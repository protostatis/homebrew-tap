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
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.16/unbrowser-aarch64-apple-darwin.tar.gz"
      sha256 "29df647a3354958a20b28dcb5dd7570a2189f8888f22a1894ff40ccced53cfe3"
    end
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.16/unbrowser-x86_64-apple-darwin.tar.gz"
      sha256 "f55ebaaf418c39a2b8ebe5016ee1f85321b28cf12d7bcfe556d47cc4fd62c5cf"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.16/unbrowser-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1efe9a210c68b2982e9098c8feba6d60548fec8a22a061bcaac829d8c84d791c"
    end
    on_arm do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.16/unbrowser-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dd63fc8a6348e16677444df82f0a5e290877111ca91af7f43b52bd49f6f96ef1"
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
