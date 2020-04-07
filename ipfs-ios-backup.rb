class IpfsIosBackup < Formula
    desc "Command line utility to backup iOS devices to an embedded and private IPFS node"
    homepage "https://github.com/codynhat/ipfs-ios-backup"
  
    # Source code archive. Each tagged release will have one
    url "https://github.com/codynhat/ipfs-ios-backup/archive/v0.1.0.tar.gz"
    sha256 "8d6ad1118bdd5c053d132cb6ead962ea42c9b5bc1a96e28dbe3030123024f982"
    head "https://github.com/codynhat/ipfs-ios-backup"
  
    depends_on "go" => :build
  
    def install
      ENV["GOPATH"] = buildpath
  
      bin_path = buildpath/"src/github.com/codynhat/ipfs-ios-backup"

      bin_path.install Dir["*"]
      cd bin_path do
        # Install the compiled binary into Homebrew's `bin` - a pre-existing
        # global variable
        system "go", "build", "-o", bin/"ipfs-ios-backup", "."
      end
    end
  
    test do
      system bin/"ipfs-ios-backup", "--help"
    end
  end