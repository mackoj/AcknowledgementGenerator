import Foundation

// MARK: - GHGithubLicense
public struct GHGithubLicense: Equatable, Codable {
  public var name: String?
  public var path: String?
  public var sha: String?
  public var size: Int?
  public var url: String?
  public var htmlURL: String?
  public var gitURL: String?
  public var downloadURL: String?
  public var type: String?
  public var content: String?
  public var encoding: String?
  public var _links: GHLinks?
  public var license: GHLicense?
  
  enum CodingKeys: String, CodingKey {
    case name
    case path
    case sha
    case size
    case url
    case htmlURL = "html_url"
    case gitURL = "git_url"
    case downloadURL = "download_url"
    case type
    case content
    case encoding
    case _links = "_links"
    case license
  }
  
  public init(name: String?, path: String?, sha: String?, size: Int?, url: String?, htmlURL: String?, gitURL: String?, downloadURL: String?, type: String?, content: String?, encoding: String?, links: GHLinks?, license: GHLicense?) {
    self.name = name
    self.path = path
    self.sha = sha
    self.size = size
    self.url = url
    self.htmlURL = htmlURL
    self.gitURL = gitURL
    self.downloadURL = downloadURL
    self.type = type
    self.content = content
    self.encoding = encoding
    self._links = links
    self.license = license
  }
}
