import Foundation
import Mustache
import HTMLString

extension AcknowledgementGenerator {
  func githubInfo(_ repoURL: URL) throws -> (username: String, project: String) {
    if repoURL.pathComponents.count < 3 { throw("URL pathComponents count is < 3") }
    guard let projetPathWithExtension = repoURL.pathComponents.last else { throw("Last pathComponents is nil") }
    let projet = projetPathWithExtension.replacingOccurrences(of: ".git", with: "")
    
    let usernameIndex = repoURL.pathComponents.index(before: repoURL.pathComponents.endIndex)
    let username = repoURL.pathComponents[usernameIndex - 1]
    return (username, projet)
  }
  
  func loadURL(_ repoURL: URL, _ name: String? = nil) throws -> PackageInfo? {
    let info = try githubInfo(repoURL)
    print("Loading license for \(info.project) by \(info.username)")
    guard let licenseURL = URL(string: "https://api.github.com/repos/\(info.username)/\(info.project)/license") else { return nil }
    var request = URLRequest(url: licenseURL)
    request.allHTTPHeaderFields = [:]
    request.addValue("application/vnd.github.VERSION.raw", forHTTPHeaderField: "Accept")
    let res = URLSession.shared.synchronousDataTask(with: request)
    if let licenseData = res.0 {
      if let licenseString = String(data: licenseData, encoding: .utf8),
         let decodedData = licenseString.removingHTMLEntities().data(using: .utf8),
         let ghError = try? JSONDecoder().decode(GithubError.self, from: decodedData) {
        print("\(name ?? info.project) failed to get license reason: \(ghError.message)")
      } else if let license = String(data: licenseData, encoding: .utf8) {
        return PackageInfo(name: name ?? info.project, author: info.username, license: license)
      }
    }
    return nil
  }
  
  func convertPins(_ pins: [PKGPin]) -> [PackageInfo] {
    return pins.compactMap { pin -> PackageInfo? in
      if let name = pin.package, let repo = pin.repositoryURL, let repoURL = URL(string: repo) {
        do {
          return try loadURL(repoURL, name)
        } catch {
          print(error.localizedDescription)
          return nil
        }
      }
      return nil
    }
    
  }
  
  
  func handlePackageVersion1(_ resolvedPackagePath: String) throws -> [PackageInfo] {
    let package = try JSONDecoder().decode(PKGPackageResolved.self, from: Data(contentsOf: URL(fileURLWithPath: resolvedPackagePath)))
    guard let pins = package.object?.pins, pins.isEmpty == false else { throw("No pins found") }
    
    print("Loading license from Github")
    var packageInfos = convertPins(pins)
    guard packageInfos.isEmpty == false else { throw("No packageinfo found") }
    packageInfos.sort()
    return packageInfos
  }

  func convertPins(_ pins: [PackageResolved2.Pin]) -> [PackageInfo] {
    return pins.compactMap { pin -> PackageInfo? in
      if let name = pin.identity, let repo = pin.location, let repoURL = URL(string: repo) {
        do {
          return try loadURL(repoURL, name)
        } catch {
          print(error.localizedDescription)
          return nil
        }
      }
      return nil
    }
    
  }

  func handlePackageVersion2(_ resolvedPackagePath: String) throws -> [PackageInfo] {
    let package = try JSONDecoder().decode(PackageResolved2.self, from: Data(contentsOf: URL(fileURLWithPath: resolvedPackagePath)))
    guard let pins = package.pins, pins.isEmpty == false else { throw("No pins found") }
    
    print("Loading license from Github")
    var packageInfos = convertPins(pins)
    guard packageInfos.isEmpty == false else { throw("No packageinfo found") }
    packageInfos.sort()
    return packageInfos
  }

  func loadPackageInfo(_ resolvedPackagePath: String) throws -> [PackageInfo] {
    print("Loading resolved package file(\(resolvedPackagePath))")
    let packageVersion = try JSONDecoder().decode(PackageResolvedVersion.self, from: Data(contentsOf: URL(fileURLWithPath: resolvedPackagePath)))
    guard let version = packageVersion.version else { fatalError("No version no decoding") }
    print("PackageResolvedVersion: \(version)")
    switch version {
      case 1: return try handlePackageVersion1(resolvedPackagePath)
      case 2: return try handlePackageVersion2(resolvedPackagePath)
      default: return try handlePackageVersion2(resolvedPackagePath)
    }
  }
  
  func renderTemplate(_ templatePath: String, _ packageInfos: [PackageInfo]) throws -> String {
    print("Loading template file(\(templatePath))")
    let template = try Template(path: templatePath)
    let functionFormatter = FunctionFormatter()
    template.register(functionFormatter, forKey: "functionFormatter")

    var groupPKGS: [GroupPackageInfo] = []
    var group: GroupPackageInfo = GroupPackageInfo(pkg: [])
    for pkg in packageInfos {
      if group.pkg.count < 10 {
        group.pkg.append(pkg)
      }
      if group.pkg.count == 10 {
        groupPKGS.append(group)
        group = GroupPackageInfo(pkg: [])
      }
    }
    if group.pkg.isEmpty == false {
      groupPKGS.append(group)
    }

    let data: [String: Any] = [
      "grouppkg": groupPKGS,
      "header": header,
      "footer": footer
    ]
    
    print("Rendering template file")
    return try template.render(data).removingHTMLEntities()
  }
  
  func render(_ resolvedPackagePath: String, _ templatePath: String, _ outputPath : URL, _ otherURLS: [URL]) throws {
    var packageInfos: [PackageInfo] = []
    if debugMode {
      packageInfos = [PackageInfo(name: "toto", author: "jeff", license: "mit\nTHE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR")]
    } else {
      packageInfos = try loadPackageInfo(resolvedPackagePath)
    }
    
    let otherPkg = otherURLS.compactMap { pkgUrl -> PackageInfo? in
      return try? loadURL(pkgUrl)
    }
    packageInfos.append(contentsOf: otherPkg)
    
    let rendering = try renderTemplate(templatePath, packageInfos)
    
    if deleteOriginal {
      print("Delete output file(\(outputPath))")
      try FileManager.default.removeItem(at: outputPath)
    }

    print("Write output file(\(outputPath))")
    try rendering.write(
      to: outputPath,
      atomically: true,
      encoding: .utf8
    )
  }
  
  mutating func run() throws {
    print("Start")
    if FileManager.default.fileExists(atPath: resolvedPackagePath) == false {
      throw("Resolved package file \"\(resolvedPackagePath)\" don't exist")
    }
    if FileManager.default.fileExists(atPath: templatePath) == false {
      throw("Template file \"\(templatePath)\" don't exist")
    }
    
    let outputPath = URL(fileURLWithPath: outputDirectoryPath)
      .appendingPathComponent(outputFileName)
    
    let validURLS = urls.compactMap { $0 }
    try render(resolvedPackagePath, templatePath, outputPath, validURLS)
    print("Finished")
  }
}
