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
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.18/unbrowser-aarch64-apple-darwin.tar.gz"
      sha256 "5022d64d1f049baaf0c9bdd59d8de8b553922961c3cf37f3545fe3d2a487e6f7"
    end
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.18/unbrowser-x86_64-apple-darwin.tar.gz"
      sha256 "d397f9603216cfaa5db2fd28b0547467471782faf092a435c62e457316fb3741"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.18/unbrowser-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6e4482d0d8e96a317fc3ec5cbe70525d067cf3db827d5476b42f3f521cbff35a"
    end
    on_arm do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.18/unbrowser-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1edc14fa6925a1233d23861b61cfcdac43400d1266206ea522a27b306c80a311"
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
