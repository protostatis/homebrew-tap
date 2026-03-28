class UnchainedskyCli < Formula
  include Language::Python::Virtualenv

  desc "Browser automation CLI over local Chrome CDP"
  homepage "https://github.com/protostatis/unchainedsky-cli"
  url "https://files.pythonhosted.org/packages/e2/1c/7b97286d6345dd35b91dc3900b6e69da9550fbedf7f8323b7a1af4bd3337/unchainedsky_cli-0.1.1.tar.gz"
  sha256 "740b2de6fa19070ec0c9459126f59957f2ac735baf9b3a742da9bce2fe656128"
  license "MIT"

  depends_on "python@3.13"

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/source/w/websockets/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"unchained", "--help"
    system bin/"unchained-ddm", "--help"
    system bin/"unchained-intel", "--help"
  end
end
