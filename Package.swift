import PackageDescription

let package = Package(
    name: "TidyLog",
    dependencies: [
      .Package(url: "https://github.com/ng28/TidyJSON.git", majorVersion: 2, minor: 0)
    ]
)
