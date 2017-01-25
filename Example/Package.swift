import PackageDescription

let package = Package(
    name: "Example",
    dependencies: [
      .Package(url: "https://github.com/ng28/TidyLog.git", majorVersion:1)
    ]
)
