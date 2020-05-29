class IpfsIosBackup < Formula
  desc "Backup iOS devices to an embedded and private IPFS node"
  homepage "https://github.com/codynhat/ipfs-ios-backup"

  # Source code archive. Each tagged release will have one
  url "https://github.com/codynhat/ipfs-ios-backup/archive/v0.3.0.tar.gz"
  sha256 "cc0746787bef59d6218cf65b0afa40685363fe421fdd37c76d73be661ebcf0df"
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

  plist_options :manual => "ipfs-ios-backup"
  def plist
    <<~EOS
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
          <key>StandardErrorPath</key>
          <string>#{var}/log/ipfs-ios-backup.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/ipfs-ios-backup.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system bin/"ipfs-ios-backup", "--help"
  end
end
