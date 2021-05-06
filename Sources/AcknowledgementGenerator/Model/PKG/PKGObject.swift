import Foundation

// MARK: - PKGObject
public struct PKGObject: Equatable, Codable {
    public var pins: [PKGPin]?

    public init(pins: [PKGPin]?) {
        self.pins = pins
    }
}
