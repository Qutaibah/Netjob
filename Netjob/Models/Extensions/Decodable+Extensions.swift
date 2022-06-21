import Foundation

extension Decodable {
    static func decode(from data: Data, using decoder: JSONDecoder) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}
