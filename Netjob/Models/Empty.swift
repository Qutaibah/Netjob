import Foundation

public struct Empty: Codable {
    public init() {}
    
    public static var new: Empty = Empty()
    static var fakeData: Data {
        "{}".data(using: .utf8)!
    }
}
