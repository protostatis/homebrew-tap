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
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.21/unbrowser-aarch64-apple-darwin.tar.gz"
      sha256 "b236ba0c4cb4e85382ae55212b2f50d1c366506025ddc6ac00495fe464e473f1"
    end
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.21/unbrowser-x86_64-apple-darwin.tar.gz"
      sha256 "78e115e6b90f919af9ed0c002c906000a31e3f473725ea37ac09064146be1c6f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.21/unbrowser-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c6a36121a83f3eea36b0611e1c2fee22054869e42279ef233a9a2a9e0ad9792b"
    end
    on_arm do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.21/unbrowser-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "31d6a55698e1a389bd8b60ef389cbc60c252e6a2d703ee7c4fe0df505e2c4646"
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
