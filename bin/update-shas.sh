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

# In-place edit. -i '' is BSD sed (macOS); -i'' is GNU sed (Linux). Use -i.bak
# then delete the .bak — works on both.
echo
echo "Patching $FORMULA ..."
sed -i.bak \
  -e "s/^  version \".*\"/  version \"$VERSION\"/" \
  "$FORMULA"
for target in "${!TARGETS[@]}"; do
  placeholder="${TARGETS[$target]}"
  sha="${SHAS[$target]}"
  sed -i.bak -e "s/$placeholder/$sha/" "$FORMULA"
done
rm -f "$FORMULA.bak"

echo
echo "Done. Diff:"
echo "----"
git -C "$(dirname "$FORMULA")/.." diff -- Formula/unbrowser.rb
echo "----"
echo "Review, then: git -C $(dirname "$FORMULA")/.. commit -am \"unbrowser $VERSION\" && git push"
