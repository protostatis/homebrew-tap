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
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.15/unbrowser-aarch64-apple-darwin.tar.gz"
      sha256 "9cc8111c883fa5474478b701c32894856abd13c5528e5b934e2560144d3e020b"
    end
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.15/unbrowser-x86_64-apple-darwin.tar.gz"
      sha256 "3585066af4fc37d7fe5d6cb58dcfa989b40c909512102cbc193fb649f037f328"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.15/unbrowser-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "91bec3179b76db9a136907e7f8d2f59ff0bf745d312614b81aedf737e2849c4c"
    end
    on_arm do
      url "https://github.com/protostatis/unbrowser/releases/download/v0.0.15/unbrowser-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "071261a179c25d818e01539c5e68c79ed57b0558dbb228fde5c73bab73092ef3"
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
