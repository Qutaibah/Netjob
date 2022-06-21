import Foundation

protocol DictionaryConvertable {}

extension DictionaryConvertable {
    
    var dictionary: [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label?.snakeCased {
                if let data = child.value as? DictionaryConvertable {
                    dict[key] = data.dictionary
                } else if let data = child.value as? Data {
                    var value = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    value = value ?? data.string(encoding:.utf8)
                    dict[key] = value
                } else if let data = child.value as? Date {
                    dict[key] = NetjobConfiguration.formatter.string(from: data)
                } else if let data = child.value as? ResponseRepresentation.Status {
                    dict[key] = data.rawValue
                } else if let data = child.value as? ResponseRepresentation.Combined {
                    dict[key] = data.dictionary
                } else {
                    dict[key] = child.value
                }
            }
        }
        return dict
    }
}
