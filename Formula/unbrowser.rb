class Unbrowser < Formula
  desc "Web access for LLM agents. One static binary. No Chrome"
  homepage "https://github.com/protostatis/unbrowser"
  license "Apache-2.0"

  # Per-arch native binaries pulled from the GitHub Release. The shas are
  # filled in by ./bin/update-shas.sh after each release tag is pushed and
  # CI has finished publishing tarballs. Until then this formula won't
  # install — that's intentional, brew will refuse rather than silently
  # downloading something that doesn't match.
  on_macos do
    on_arm do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.13/unbrowser-aarch64-apple-darwin.tar.gz"
      sha256 "d901578191b3be70b2478af4ebda4a1ff3285db9cd6daa15889cc822f8f688c0"
    end
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.13/unbrowser-x86_64-apple-darwin.tar.gz"
      sha256 "be87b23b9a2395f0f93f52b897adea4c5fafa526ea5e57af7c624d4455696851"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.13/unbrowser-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a62dbb539df6db9cb74b3b54df7cacaecdc0c573748c6278684dc91ea52431f3"
    end
    on_arm do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.13/unbrowser-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "686df5e4dd0e78331a03c5e315112171296e81f5aadd07f5f9e98c47b5566f0c"
    end
  end

  def install
    bin.install "unbrowser"
  end

  test do
    # The standard "process starts, JSON-RPC works, exits cleanly" smoke
    # test — no network, just verifies the binary loads and the loop runs.
    output = pipe_output(bin/"unbrowser", '{"id":1,"method":"close"}')
    assert_match '"result":"bye"', output
  end
end
