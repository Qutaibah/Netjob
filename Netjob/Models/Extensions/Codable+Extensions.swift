import Foundation

extension Decodable {
    init?(dictionary: [String: Any?]?) {
        guard let dictionary = dictionary else { return nil }
        do {
            let serialized = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self = try decoder.decode(Self.self, from: serialized)
        } catch {
            return nil
        }
    }
}

extension Encodable {
    var asDictionary: [String: Any?]? {
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let object = try encoder.encode(self)
            let dictionary = try JSONSerialization.jsonObject(with: object, options: .allowFragments) as? [String: Any]
            return dictionary
        } catch {
            return nil
        }
    }
}

extension Encodable {

    var debugDescription: String {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(self)
            return String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch let error {
            print("error converting to json: \(error)")
            return "nil"
        }
    }
}
