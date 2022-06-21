import Foundation

extension Dictionary where Key == String {
    var asUrlQuery: Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }

    var asRequestBody: Data {
        return try! JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted, .sortedKeys])
    }
}

extension Dictionary where Key == String, Value: Encodable {
    
    var prettyJSONString: String {
        guard !keys.isEmpty else { return "<empty>"}
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

