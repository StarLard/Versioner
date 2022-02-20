import XCTest
import class Foundation.Bundle

final class VersionerTests: XCTestCase {
    func testVersion() throws {
        let timestamp: TimeInterval = 1645327830 // Sunday, February 20, 2022 3:30:30 AM
        let output = try runVersioner(withArguments: ["version", "\(timestamp)"])
        XCTAssertEqual(output, "20220220033030\n")
    }
    
    func testUnversionTimestamp() throws {
        let version: Int = 20220220033030 // Sunday, February 20, 2022 3:30:30 AM
        let output = try runVersioner(withArguments: ["unversion", "\(version)", "--timestamp"])
        XCTAssertEqual(output, "1645327830\n")
    }
    
    func testUnversionDate() throws {
        let version: Int = 20220220033030 // Sunday, February 20, 2022 3:30:30 AM
        let output = try runVersioner(withArguments: ["unversion", "\(version)", "--time-zone-abbreviation", "UTC"])
        XCTAssertEqual(output, "Sunday, Feb 20, 2022, 3:30:30 AM Greenwich Mean Time\n")
    }
    
    private func runVersioner(withArguments arguments: [String]) throws -> String? {
        guard #available(macOS 10.13, *) else {
            throw XCTSkip("Test requires macOS 10.13 or later")
        }
        // Mac Catalyst won't have `Process`, but it is supported for executables.
        #if !targetEnvironment(macCatalyst)
        let versionerBinary = productsDirectory.appendingPathComponent("Versioner")

        let process = Process()
        process.executableURL = versionerBinary

        let pipe = Pipe()
        process.standardOutput = pipe
        process.arguments = arguments

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)
        #else
        return nil
        #endif
    }

    /// Returns path to the built products directory.
    private var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }
}
