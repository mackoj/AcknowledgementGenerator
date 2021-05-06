import Foundation

// MARK: - PKGPin
public struct PKGPin: Equatable, Codable {
    public var package: String?
    public var repositoryURL: String?
    public var state: PKGState?

    public init(package: String?, repositoryURL: String?, state: PKGState?) {
        self.package = package
        self.repositoryURL = repositoryURL
        self.state = state
    }
}
