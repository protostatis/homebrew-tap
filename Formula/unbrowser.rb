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
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.19/unbrowser-aarch64-apple-darwin.tar.gz"
      sha256 "56c4a13eeb82267faab55bbba0e69d7decc1ee3cb030357c925b3d58e83aef19"
    end
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.19/unbrowser-x86_64-apple-darwin.tar.gz"
      sha256 "1c0f82b967c9bb2e1f82d7433589c35917971abbb39d022c4191dc826d6c6177"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.19/unbrowser-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ad1bf96eaf413a10490adb64aa3f81deeac928c54a19e057efe4e6369a977242"
    end
    on_arm do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.19/unbrowser-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f353284434656aacbe957db34fb9de28a50eb7dd02cc8effd64edb4bfcbfc133"
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
