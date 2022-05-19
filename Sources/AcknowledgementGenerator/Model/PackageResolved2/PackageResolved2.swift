// PackageResolved2.swift

import Foundation

// MARK: - PackageResolved2
public struct PackageResolved2: Equatable, Codable {
  public var pins: [Pin]?
  public var version: Int?
  
  public init(pins: [Pin]?, version: Int?) {
    self.pins = pins
    self.version = version
  }
  
  public struct Pin: Equatable, Codable {
    public var identity: String?
    public var kind: String?
    public var location: String?
    public var state: State?
    
    public init(identity: String?, kind: String?, location: String?, state: State?) {
      self.identity = identity
      self.kind = kind
      self.location = location
      self.state = state
    }
    
    public struct State: Equatable, Codable {
      public var revision: String?
      public var version: String?
      
      public init(revision: String?, version: String?) {
        self.revision = revision
        self.version = version
      }
    }
  }
}
