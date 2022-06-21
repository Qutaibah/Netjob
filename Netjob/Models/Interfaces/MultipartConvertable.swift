import Foundation

protocol MultipartConvertable {
    
    var value: String { get }
}

extension String: MultipartConvertable {
    var value: String { return self }
}

extension Int: MultipartConvertable {
    var value: String { return String(self) }
}

extension Double: MultipartConvertable {
    var value: String { return String(self) }
}

extension Float: MultipartConvertable {
    var value: String { return String(self) }
}

extension Bool: MultipartConvertable {
    var value: String { return String(self) }
}
