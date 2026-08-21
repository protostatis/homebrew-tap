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
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.20/unbrowser-aarch64-apple-darwin.tar.gz"
      sha256 "e0d4d11a2c7bb0b75fddeb37820af855e62b68a27eec2705e8cea5d47f1689de"
    end
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.20/unbrowser-x86_64-apple-darwin.tar.gz"
      sha256 "03469171390c9e7493582450cf63070a337a78527598c954ba93d8785fb7366a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.20/unbrowser-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0b407c5e6e9d05ae10cd935fea4c385c33c2c86ed5acbed6e2f5407476e35a0f"
    end
    on_arm do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.20/unbrowser-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6ad5ff426b3b0f10fe4c08e5c3a5ea48f194546bf5455accdc2d64101e0a900c"
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
