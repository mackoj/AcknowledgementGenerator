import Foundation

// MARK: - PKGPackageResolved
public struct PKGPackageResolved: Equatable, Codable {
    public var object: PKGObject?
    public var version: Int?

    public init(object: PKGObject?, version: Int?) {
        self.object = object
        self.version = version
    }
}
