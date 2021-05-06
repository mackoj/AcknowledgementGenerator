import Foundation

// MARK: - GHLinks
public struct GHLinks: Equatable, Codable {
    public var _self: String?
    public var git: String?
    public var html: String?

  enum CodingKeys: String, CodingKey {
    case _self = "self"
    case git
    case html
  }

    public init(linksSelf: String?, git: String?, html: String?) {
        self._self = linksSelf
        self.git = git
        self.html = html
    }
}
