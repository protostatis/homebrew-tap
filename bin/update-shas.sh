#!/usr/bin/env bash
# update-shas.sh — fill SHA-256 placeholders in Formula/unbrowser.rb after
# a release tarball ships. Run once per release tag.
#
# Usage:
#   ./bin/update-shas.sh v0.0.2
#
# What it does:
#   1. Fetches the three platform tarballs from the GitHub Release for the
#      given tag.
#   2. Computes sha256 for each.
#   3. Updates `version "X.Y.Z"` line in Formula/unbrowser.rb.
#   4. sed-replaces the REPLACE_ME_<TARGET> placeholders with real shas.
#   5. Prints a diff for human review before commit.
#
# Requires: curl, shasum (macOS) or sha256sum (Linux), sed, gh (optional —
# uses gh when available so private releases work, falls back to plain curl
# for public ones).

set -euo pipefail

REPO="protostatis/unbrowser"
TAG="${1:-}"
if [[ -z "$TAG" ]]; then
  echo "usage: $0 <tag>   (e.g. $0 v0.0.2)" >&2
  exit 1
fi
VERSION="${TAG#v}"

FORMULA="$(cd "$(dirname "$0")/.." && pwd)/Formula/unbrowser.rb"
if [[ ! -f "$FORMULA" ]]; then
  echo "Formula not found at $FORMULA" >&2
  exit 1
fi

# Cross-platform sha256: macOS has shasum, Linux has sha256sum.
sha256_of() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    sha256sum "$1" | awk '{print $1}'
  fi
}

declare -A TARGETS=(
  [aarch64-apple-darwin]=REPLACE_ME_AARCH64_APPLE_DARWIN
  [x86_64-apple-darwin]=REPLACE_ME_X86_64_APPLE_DARWIN
  [x86_64-unknown-linux-gnu]=REPLACE_ME_X86_64_UNKNOWN_LINUX_GNU
)

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "Fetching tarballs for $TAG into $TMPDIR ..."
for target in "${!TARGETS[@]}"; do
  url="https://github.com/$REPO/releases/download/$TAG/unbrowser-$target.tar.gz"
  out="$TMPDIR/unbrowser-$target.tar.gz"
  if command -v gh >/dev/null 2>&1; then
    gh release download "$TAG" --repo "$REPO" --pattern "unbrowser-$target.tar.gz" --output "$out"
  else
    curl -fsSL --output "$out" "$url"
  fi
  echo "  fetched: $target"
done

echo
echo "Computing sha256s ..."
declare -A SHAS
for target in "${!TARGETS[@]}"; do
  SHAS[$target]="$(sha256_of "$TMPDIR/unbrowser-$target.tar.gz")"
  echo "  $target  ${SHAS[$target]}"
done

# In-place edit using Python so we can match per-target sha lines reliably
# regardless of whether the formula currently has a REPLACE_ME_* placeholder
# (first run after scaffolding) or a real sha from the previous version
# (every subsequent release). The sed-only approach silently leaves stale
# shas in place on re-runs, which produces a formula that brew refuses to
# install.
echo
echo "Patching $FORMULA ..."
python3 - "$FORMULA" "$VERSION" "${!TARGETS[@]}" <<'PY' \
  "${SHAS[@]}"
import re, sys, os
formula = sys.argv[1]
version = sys.argv[2]
n = (len(sys.argv) - 3) // 2
targets = sys.argv[3:3+n]
shas = sys.argv[3+n:]
mapping = dict(zip(targets, shas))
src = open(formula).read()
# Update version line.
src = re.sub(r'^(\s*version\s+")[^"]*(")', lambda m: m.group(1) + version + m.group(2), src, flags=re.M)
# For each target, find the URL line that mentions the target, then replace
# the sha256 line that immediately follows. Tolerates either a real sha or
# a REPLACE_ME_* placeholder.
for target, sha in mapping.items():
    pat = re.compile(
        r'(url\s+"[^"]*-' + re.escape(target) + r'\.tar\.gz"\s*\n\s*sha256\s+")'
        r'[^"]*'
        r'(")',
        re.M,
    )
    src, count = pat.subn(lambda m: m.group(1) + sha + m.group(2), src)
    if count != 1:
        print(f"  WARNING: {count} substitutions for {target} (expected 1)", file=sys.stderr)
open(formula, 'w').write(src)
PY
echo "  patched (Python-based)."

echo
echo "Done. Diff:"
echo "----"
git -C "$(dirname "$FORMULA")/.." diff -- Formula/unbrowser.rb
echo "----"
echo "Review, then: git -C $(dirname "$FORMULA")/.. commit -am \"unbrowser $VERSION\" && git push"
