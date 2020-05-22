class IpfsIosBackup < Formula
    desc "Command line utility to backup iOS devices to an embedded and private IPFS node"
    homepage "https://github.com/codynhat/ipfs-ios-backup"
  
    # Source code archive. Each tagged release will have one
    url "https://github.com/codynhat/ipfs-ios-backup/archive/v0.2.0.tar.gz"
    sha256 "a82dc8f7543e4eda4b1bf2f614d445258ef61b8551e51267d964173ff503b021"
    head "https://github.com/codynhat/ipfs-ios-backup"
  
    depends_on "go" => :build
    depends_on "codynhat/libimobiledevice/libimobiledevice"
  
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

    plist_options :manual => "ipfs-ios-backup"

    def plist; <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>ThrottleInterval</key>
          <integer>300</integer>
          <key>ProgramArguments</key>
          <array>
            <string>#{prefix}/bin/ipfs-ios-backup</string>
            <string>daemon</string>
          </array>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
        </dict>
      </plist>
      EOS
    end
  end