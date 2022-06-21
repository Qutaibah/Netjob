import Foundation

extension Data {
    
    var lineBreak: String {
        return "\r\n"
    }
    
    func start(_ boundary: String) -> Data {
        return self.add(boundary)
    }
    
    func finish(_ boundary: String) -> Data {
        return self.add(boundary).add("--").breakLine()
    }
    
    func breakLine() -> Data {
        return self.add(lineBreak)
    }
    
    func contentDisposition(_ name: String) -> Data {
        return self.add("Content-Disposition: form-data; name=\"\(name)\";")
    }
    
    func fileName(_ name: String) -> Data {
        return self.add("filename=\"\(name)\"")
    }
    
    func contentType(_ type: String) -> Data {
        return self.add("Content-Type: \(type)")
    }

    func add(_ string: String) -> Data {
        if let data = string.data(using: .utf8) {
            var new = self
            new.append(data)
            return new
        }
        return Data()
    }
    
    func add(_ data: Data) -> Data {
        var new = self
        new.append(data)
        return new
    }

    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
    
    func string(encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }
    
    var prettyJSONString: String {
        do {
            let object = try JSONSerialization.jsonObject(with: self, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            return prettyData.string(encoding: .utf8) ?? ""
        } catch {
            return String(data: self, encoding: .utf8) ?? ""
        }
    }
}
