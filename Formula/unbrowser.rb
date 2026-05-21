class Unbrowser < Formula
  desc "Web access for LLM agents. One static binary. No Chrome"
  homepage "https://github.com/protostatis/unbrowser"
  version "0.0.11"
  license "Apache-2.0"

  # Per-arch native binaries pulled from the GitHub Release. The shas are
  # filled in by ./bin/update-shas.sh after each release tag is pushed and
  # CI has finished publishing tarballs. Until then this formula won't
  # install — that's intentional, brew will refuse rather than silently
  # downloading something that doesn't match.
  on_macos do
    on_arm do
      url "https://github.com/protostatis/unbrowser/releases/download/v#{version}/unbrowser-aarch64-apple-darwin.tar.gz"
      sha256 "4b8144c1d5ec12022cb81b24550b039e6c4471ada2468dde405826afa5744432"
    end
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v#{version}/unbrowser-x86_64-apple-darwin.tar.gz"
      sha256 "d6a092edaa1b3881f79769760f306c31d1d820ab69454dc2c54f7040db553e5d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v#{version}/unbrowser-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0f077e1b4efada384dcbb0f4bd34695a61402ec8c66a4d8751c3818f42d3320c"
    end
  end

  def install
    bin.install "unbrowser"
  end

  test do
    # The standard "process starts, JSON-RPC works, exits cleanly" smoke
    # test — no network, just verifies the binary loads and the loop runs.
    output = pipe_output("#{bin}/unbrowser", '{"id":1,"method":"close"}')
    assert_match '"result":"bye"', output
  end
end
