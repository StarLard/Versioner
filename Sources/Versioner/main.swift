//
//  main.swift
//  Versioner
//
//  Created by Friden, Caleb on 2/19/22.
//  Copyright © 2022 Friden, Caleb. All rights reserved.
//
import Foundation
import ArgumentParser

struct Versioner: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A command line tool to generate version numbers from timestamps.",
        version: "1.0.0",
        subcommands: [Version.self, Unversion.self],
        defaultSubcommand: Version.self)
    
    struct Version: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Creates a version number.")
        
        @Argument(help: "Unix timestamp to generate version number from.")
        var timestamp: Int = Int(Date().timeIntervalSince1970)
        
        mutating func run() throws {
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            let versionString = Self.dateFormatter.string(from: date)
            guard let versionNumber = Int(versionString) else {
                throw ValidationError("Cannot make version number from invalid version string: \(versionString)")
            }
            print(versionNumber)
        }
        
        static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            return formatter
        }()
    }
    
    struct Unversion: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Decodes a version number into the date that was used to create it.")
        
        @Argument(help: "Version number created by versioner version command.")
        var version: Int
        
        @Option(help: "The date format to output in. Defaults to \"EEEE, MMM d, yyyy, h:m:s a zzzz\"")
        var dateFormat: String = "EEEE, MMM d, yyyy, h:m:s a zzzz"
        
        @Option(help: "The time zone to output in. Defaults to current.")
        var timeZoneAbbreviation: String?
        
        @Flag(help: "Whether or not the Unix timestamp should should be output instead of the date.")
        var timestamp: Bool = false
        
        mutating func run() throws {
            guard let versionDate = Version.dateFormatter.date(from: String(version)) else {
                throw ValidationError("\(version) was not a valid version number")
            }
            
            guard !timestamp else {
                print(Int(versionDate.timeIntervalSince1970))
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = dateFormat
            formatter.timeZone = timeZoneAbbreviation.map(TimeZone.init(abbreviation:)) ?? .current
            
            let dateString = formatter.string(from: versionDate)
            print(dateString)
        }
    }
    
    
    struct ValidationError: Error, CustomStringConvertible {
        var message: String
        
        /// Creates a new validation error with the given message.
        init(_ message: String) {
            self.message = message
        }
        
        var description: String { message }
    }
}

Versioner.main()
