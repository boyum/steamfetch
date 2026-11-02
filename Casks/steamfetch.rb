cask "steamfetch" do
  version "0.1.0"

  on_arm do
    url "file://#{File.expand_path("../dist/steamfetch-#{version}-arm64.zip", __dir__)}"
    sha256 "46a91292d3f03ec43b512e6305519bc53807e042b16383a2d4549bf7b0a8c88e"
  end

  on_intel do
    url "file://#{File.expand_path("../dist/steamfetch-#{version}-x64.zip", __dir__)}"
    sha256 "6fc872b08d2270274e3685671f3339db9d9f2b44552ef69e09b6048c9b410c7c"
  end

  name "steamfetch"
  desc "Download Steam game files for a different platform"
  homepage "https://github.com/boyum/steamfetch"

  binary "steamfetch"
  binary "DepotDownloader", target: "steamfetch-depotdownloader"

  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{staged_path}}"]
  end
end
