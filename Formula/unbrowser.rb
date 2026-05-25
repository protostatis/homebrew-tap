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
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.14/unbrowser-aarch64-apple-darwin.tar.gz"
      sha256 "abeb3d3afa5e44480ff0fece8f8adf52e9812a4e430b7607f68cdc70bd99f01f"
    end
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.14/unbrowser-x86_64-apple-darwin.tar.gz"
      sha256 "3a21f539a4f444f5d008aead5bb8ef6a9d737ef14fe9bbde66ddb378903bed3f"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.14/unbrowser-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ec8ac4508158149473d0d6bf7863b3fb8e0e4081f8dadecf35afc981445e86a2"
    end
    on_arm do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.14/unbrowser-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "142ed6292328960e278fe5aaa11035dd3707a0188877ef732733159b76380492"
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
