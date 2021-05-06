import Foundation
import ArgumentParser

struct AcknowledgementGenerator: ParsableCommand {
  static var configuration = CommandConfiguration(
      abstract: "A utility for generating acknowledgement SwiftUI View.",
      version: "1.0.0"
  )

  @Argument(help: "Resolved package path")
  var resolvedPackagePath: String

  @Argument(help: "Path for the default template file")
  var templatePath: String
  
  @Option(help: "Output directory path where the SwiftUI will be written")
  var outputDirectoryPath: String = "."

  @Option(help: "Output file name")
  var outputFileName: String = "AcknowledgementView.swift"
}
