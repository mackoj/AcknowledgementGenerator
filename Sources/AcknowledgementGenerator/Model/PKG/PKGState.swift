import Foundation

// MARK: - PKGState
public struct PKGState: Equatable, Codable {
//    public var branch: String?
    public var revision: String?
    public var version: String?

    public init(/*branch: String?, */revision: String?, version: String?) {
//        self.branch = branch
        self.revision = revision
        self.version = version
    }
}
