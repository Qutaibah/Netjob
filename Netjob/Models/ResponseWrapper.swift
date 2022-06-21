import Foundation

public struct ResponseWrapper<T> {
    
    func output(data: Data, decoder: JSONDecoder? = nil) throws -> T? {
        switch T.self {
        case is Data.Type:
            return data as? T
        case is String.Type:
            return try getString(data) as? T
        case is Decodable.Type where decoder != nil:
            return try decode(data, using: decoder!)
        case is Serializable.Type:
            return try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? T
        default:
            return nil
        }
    }
    
    private func getString(_ data: Data) throws -> String? {
        guard let value = String(data: data, encoding: .utf8) else {
            throw NetjobError.decoderFailed(error: nil)
        }
        return value
    }
    
    private func decode<T>(_ data: Data, using decoder: JSONDecoder) throws -> T? {
        guard let T = T.self as? Decodable.Type else {
            throw NetjobError.decoderFailed(error: nil)
        }
        return try T.decode(from: data, using: decoder) as? T
    }
}
