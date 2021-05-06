import Foundation
import Mustache

extension AcknowledgementGenerator {
  func githubInfo(_ repoURL: URL) throws -> (username: String, project: String) {
    if repoURL.pathComponents.count < 3 { throw("Invalide URL") }
    guard let projetPathWithExtension = repoURL.pathComponents.last else { throw("Not a valid URL") }
    let projet = projetPathWithExtension.replacingOccurrences(of: ".git", with: "")
    
    let usernameIndex = repoURL.pathComponents.index(before: repoURL.pathComponents.endIndex)
    let username = repoURL.pathComponents[usernameIndex - 1]
    return (username, projet)
  }
  
  func convertPins(_ pins: [PKGPin]) -> [PackageInfo] {
    return pins.compactMap { pin -> PackageInfo? in
      if let name = pin.package, let repo = pin.repositoryURL, let repoURL = URL(string: repo) {
        do {
          let info = try githubInfo(repoURL)
          guard let licenseURL = URL(string: "https://api.github.com/repos/\(info.username)/\(info.project)/license") else { return nil }
          var request = URLRequest(url: licenseURL)
          request.allHTTPHeaderFields = [:]
          request.addValue("application/vnd.github.VERSION.raw", forHTTPHeaderField: "Accept")
          let res = URLSession.shared.synchronousDataTask(with: request)
          if let licenseData = res.0, let license = String(data: licenseData, encoding: .utf8) {
            return PackageInfo(name: name, license: license)
          }
        } catch {
          print(error.localizedDescription)
          return nil
        }
      }
      return nil
    }
    
  }
  
  func loadPackageInfo(_ resolvedPackagePath: String) throws -> [PackageInfo] {
    let package = try JSONDecoder().decode(PKGPackageResolved.self, from: Data(contentsOf: URL(fileURLWithPath: resolvedPackagePath)))
    guard let pins = package.object?.pins, pins.isEmpty == false else { throw("No pins found") }
    let packageInfos = convertPins(pins)
    guard packageInfos.isEmpty == false else { throw("No packageinfo found") }
    return packageInfos
  }
  
  
  
  func renderTemplate(_ templatePath: String, _ packageInfos: [PackageInfo]) throws -> String {
    let template = try Template(path: templatePath)
    let functionFormatter = FunctionFormatter()
    template.register(functionFormatter, forKey: "functionFormatter")

    let data: [String: Any] = [
      "pkg": packageInfos
    ]
    
    return try template.render(data)
  }
  
  func render(_ resolvedPackagePath: String, _ templatePath: String, _ outputPath : URL) throws {
    let packageInfos = try loadPackageInfo(resolvedPackagePath)
    let rendering = try renderTemplate(templatePath, packageInfos)
    
    try rendering.write(
      to: outputPath,
      atomically: true,
      encoding: .utf8
    )
  }
  
  mutating func run() throws {
    if FileManager.default.fileExists(atPath: resolvedPackagePath) == false {
      throw("Resolved package file \"\(resolvedPackagePath)\" don't exist")
    }
    if FileManager.default.fileExists(atPath: templatePath) == false {
      throw("Template file \"\(templatePath)\" don't exist")
    }
    
    let outputPath = URL(fileURLWithPath: outputDirectoryPath)
      .appendingPathComponent(outputFileName)
    
    try render(resolvedPackagePath, templatePath, outputPath)
  }
}
