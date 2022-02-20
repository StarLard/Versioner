# Versioner
A command line tool to generate version numbers from timestamps. Versioner creates version numbers by converting
the current time into reverse encoded UTC dates. For example, the version `20220220033030` can be read as 
`2022-02-20 03:30:30` or `2/2/22 3:30:30 AM UTC`

## Installation

1. Clone the respository
2. `cd` into the repository directory
3. Build the binary with `swift build --configuration release`
4. Copy the binary from the build directory into your path: `cp -f .build/release/versioner /usr/local/bin/versioner`

## Usage

Create a version number for now with `versioner version` or specify a time with `versioner version <timestamp>`:
```
$ versioner 1645327830
20220220033030
```

Use the `unversion` command to decode previously generated version numbers:
```
$ versioner unversion 20220220033030
Sunday, Feb 20, 2022, 3:30:30 AM Greenwich Mean Time
```
or to get the timestamp version:
```
$ versioner unversion 20220220033030 --timestamp
1645327830
```
