// swift-tools-version:5.0
import PackageDescription

let package = Package(
	name: "FolioReaderKit",
	dependencies: [
        .package(url: "https://github.com/ZipArchive/ZipArchive.git", from: "2.1.0"),
        .package(url: "https://github.com/cxa/MenuItemKit.git", from: "3.0.0"),
        .package(url: "https://github.com/zoonooz/ZFDragableModalTransition.git", from: "0.6.0"),
        .package(url: "https://github.com/tadija/AEXML.git", from: "4.2.0"),
        .package(url: "https://github.com/ArtSabintsev/FontBlaster.git", from: "4.0.0"),
		.package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.12.0"),
	]
)
