import Foundation

struct ResponseRepresentation: Codable {
    var id: String
    var statusCode: Int?
    var method: String?
    var absolute_url: String?
    var startedAt: Date?
    var endedAt: Date? {
        didSet {
            let end = endedAt ?? Date()
            duration = end.timeIntervalSince(startedAt ?? end)
        }
    }
    var request: Combined?
    var response: Combined?
    var error: String?
    private(set) var status: Status?
    private(set) var duration: Double?

    init() {
        id = UUID().uuidString
        startedAt = Date()
    }
    
    mutating func set(status: Status) {
        self.status = status
        switch status {
        case .started:
            if NetjobConfiguration.logLevel == .verbose {
                Logger.verbose(json?.prettyJSONString.decorated ?? "")
            }
        case .canceled:
            if NetjobConfiguration.logLevel == .verbose {
                Logger.verbose(json?.prettyJSONString.decorated ?? "")
            }
        case .finished:
            if [.verbose, .info].contains(NetjobConfiguration.logLevel) {
                Logger.any(json?.prettyJSONString.decorated ?? "")
            }
        case .custom:
            if NetjobConfiguration.logLevel == .verbose {
                Logger.verbose("Cached: \(id)")
                Logger.verbose(json?.prettyJSONString.decorated ?? "")
            }
        }
    }

    var json: Data? {
        let dic = dictionary
        let data = dic.asRequestBody
        return data
    }
    
    enum Status: Codable {
        init(from decoder: Decoder) throws {
            let raw = try decoder.singleValueContainer().decode(String.self)
            self.init(rawValue: raw)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        }
        
        case started
        case canceled
        case finished
        case custom(String)
        
        var rawValue: String {
            switch self {
            case .started:
                return "started".uppercased()
            case .canceled:
                return "canceled".uppercased()
            case .finished:
                return "finished".uppercased()
            case .custom(let status):
                return status.uppercased()
            }
        }
        
        init(rawValue: String) {
            switch rawValue.lowercased() {
            case "started":
                self = .started
            case "canceled":
                self = .canceled
            case "finished":
                self = .finished
            default:
                self = .custom(rawValue)
            }
        }
    }
    
    struct Combined: Codable, DictionaryConvertable {
        var headers: [String: String]?
        var body: Any?
        
        init(headers: [String : String]? = nil, body: Data? = nil) {
            self.headers = headers
            guard let body = body else { return }
            var value = try? JSONSerialization.jsonObject(with: body, options: [.allowFragments])
            value = value ?? body.string(encoding:.utf8)
            self.body = body
        }
        
        enum CodingKeys: String, CodingKey {
            case headers
            case body
        }
        
        init (from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let container =  try decoder.container (keyedBy: CodingKeys.self)
            headers = try container.decode ([String: String].self, forKey: .headers)
            let data = try values.decode(Data.self, forKey: .body)
            body = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
        }
        
        func encode (to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(headers, forKey: .headers)
            if let body = self.body {
                let data = try JSONSerialization.data(withJSONObject: body, options: [.fragmentsAllowed])
                try container.encode(data, forKey: .body)
            }
        }
    }
}

extension ResponseRepresentation {
    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = ResponseRepresentation.dateEncodingStrategy
        return encoder
    }
    
    static var decoder: JSONDecoder {
        let encoder = JSONDecoder()
        encoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder.dateDecodingStrategy = ResponseRepresentation.dateDecodingStrategy
        return encoder
    }
        
    static var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        .formatted(NetjobConfiguration.formatter)
    }
    
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        .formatted(NetjobConfiguration.formatter)
    }
}

extension ResponseRepresentation: DictionaryConvertable {}
