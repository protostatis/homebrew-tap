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
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.12/unbrowser-aarch64-apple-darwin.tar.gz"
      sha256 "788385c169cf5adaca3948db0806730811bc20112e281e28aff7056fe9debdcb"
    end
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.12/unbrowser-x86_64-apple-darwin.tar.gz"
      sha256 "d2d28f9bc977873b42756a410856aa269c2ad16bff51ff25c026f9914cc69b24"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.12/unbrowser-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1acbfc63d1a2997cdf6893d3d0418d0c0a9137115938bd0f88443aac292fecad"
    end
    on_arm do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.12/unbrowser-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9835794eb6c45de0c2dde123449c7139755ec77ae274164f2f1b95aa34bac72c"
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
