import Foundation

// MARK: - GHLicense
public struct GHLicense: Equatable, Codable {
  public var key: String?
  public var name: String?
  public var spdxID: String?
  public var url: String?
  public var nodeID: String?
  
  enum CodingKeys: String, CodingKey {
    case key
    case name
    case spdxID = "spdx_id"
    case url
    case nodeID = "node_id"
  }
  
  public init(key: String?, name: String?, spdxID: String?, url: String?, nodeID: String?) {
    self.key = key
    self.name = name
    self.spdxID = spdxID
    self.url = url
    self.nodeID = nodeID
  }
}
