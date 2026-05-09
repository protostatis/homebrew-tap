class Unbrowser < Formula
  desc "Web access for LLM agents. One static binary. No Chrome"
  homepage "https://github.com/protostatis/unbrowser"
  version "0.0.8"
  license "Apache-2.0"

  # Per-arch native binaries pulled from the GitHub Release. The shas are
  # filled in by ./bin/update-shas.sh after each release tag is pushed and
  # CI has finished publishing tarballs. Until then this formula won't
  # install — that's intentional, brew will refuse rather than silently
  # downloading something that doesn't match.
  on_macos do
    on_arm do
      url "https://github.com/protostatis/unbrowser/releases/download/v#{version}/unbrowser-aarch64-apple-darwin.tar.gz"
      sha256 "cbed12b76544fe209dcd61acaeaa2a9c34a7f11bd6d04363e591031acd709bac"
    end
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v#{version}/unbrowser-x86_64-apple-darwin.tar.gz"
      sha256 "315a10cbbc81c2c0ca7ab9c62d2c83d9ba1b954ca3526b3aac2550f4a0e02138"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/protostatis/unbrowser/releases/download/v#{version}/unbrowser-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7ea4679f2daf406910db6a9027a874c42ae734c8ea42187d03eac593aebb76f3"
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
