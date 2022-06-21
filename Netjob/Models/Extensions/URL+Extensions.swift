import Foundation

extension URL {
    
    init(string: String, query: [String: Any]?) {
        guard let baseUrl = URL(string: string) else {
            fatalError("The URL provided is not valid")
        }
        self.init(url: baseUrl, query: query)
    }
    
    init(string: String, query: Data?) {
        guard let baseUrl = URL(string: string) else {
            fatalError("The URL provided is not valid")
        }
        guard let query = query,
              let dictionary: Dictionary = NSKeyedUnarchiver.unarchiveObject(with: query) as? [String: Any] else {
            self = baseUrl
            return
        }
        self.init(url: baseUrl, query: dictionary)
    }

    init(url: URL, query: [String: Any]?) {
        guard let query = query else {
            self = url
            return
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = query.map { element in
            URLQueryItem(name: element.key,
                         value: String(describing: element.value))
        }
        guard let newUrl = components?.url else {
            self = url
            return
        }
        self = newUrl
    }
    
    private func percentEscapeString(_ string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
}
