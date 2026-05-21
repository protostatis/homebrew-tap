class Unbrowser < Formula
  desc "Web access for LLM agents. One static binary. No Chrome"
  homepage "https://github.com/protostatis/unbrowser"
  version "0.0.10"
  license "Apache-2.0"

  # Per-arch native binaries pulled from the GitHub Release. The shas are
  # filled in by ./bin/update-shas.sh after each release tag is pushed and
  # CI has finished publishing tarballs. Until then this formula won't
  # install — that's intentional, brew will refuse rather than silently
  # downloading something that doesn't match.
  on_macos do
    on_arm do
      url "https://github.com/protostatis/unbrowser/releases/download/v#{version}/unbrowser-aarch64-apple-darwin.tar.gz"
      sha256 "467da66d477e09a75d8650d147b03d907b0ad7e6b4492a4fd971ef94beda0a26"
    end
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v#{version}/unbrowser-x86_64-apple-darwin.tar.gz"
      sha256 "4dbea3d311781f9cc0ac2b9650b15b074eeb994214de84b3c1466e2844534205"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v#{version}/unbrowser-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9473a0916fa4999832724c0bfcb3b28008d62e6f4d732eb44942fc5eff611d03"
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
