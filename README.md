# homebrew-tap

Homebrew tap for [UnchainedSky](https://unchainedsky.com) tools.

## Usage

```bash
brew tap protostatis/tap
```

Then install any of:

| Formula | Install | What it does |
|---|---|---|
| [`unbrowser`](Formula/unbrowser.rb) | `brew install unbrowser` | Web access for LLM agents — single-binary, native, JS-capable headless browser. No Chrome. |
| [`unchainedsky-cli`](Formula/unchainedsky-cli.rb) | `brew install unchainedsky-cli` | CDP-driven Chrome automation CLI for the harder cases (SPAs, login flows, bot challenges). |

## Tradeoff between the two

`unbrowser` is the cheap path — runs anywhere a static binary runs (Lambda, Workers, edge), tens of MB RAM per session, ~500-token BlockMap output instead of raw HTML. Right tool for stateful multi-step extraction on SSR / static / lightly-hydrated pages, and bot-walled sites you have cookies for.

`unchainedsky-cli` is the escalation path — drives real Chrome via CDP. Slower, heavier, but handles full SPAs, interactive bot challenges, and anything requiring real browser fingerprint behavior.

In practice you reach for `unbrowser` first; when the page returns a `challenge` field or `density.likely_js_filled` signal, you escalate to `unchainedsky-cli`.

## Maintenance

`unbrowser` releases pull binaries from [github.com/protostatis/unbrowser/releases](https://github.com/protostatis/unbrowser/releases). After each new release tag, run:

```bash
./bin/update-shas.sh v0.0.X    # fetches tarballs, computes shas, patches the formula
git diff Formula/unbrowser.rb  # review
git commit -am "unbrowser 0.0.X" && git push
```

The placeholder shas (`REPLACE_ME_*`) in `Formula/unbrowser.rb` are intentional — `brew install unbrowser` will fail until they're filled in, which is correct: brew should refuse to install a formula whose binary it can't verify.
