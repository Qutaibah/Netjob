import Foundation

public protocol Endpoint {

    var url: String { get }

    var body: [String: Any?]? { get }
    
    var query: [String: Any]? { get }

    var method: HTTPMethod { get }
            
    var decoder: JSONDecoder { get }
        
    var serverTrustPolicy: ServerTrustPolicy? { get }
    
    var middlewares: [Middleware] { get }
    
    var postwares: [Postware] { get }

    var files: [Media]? { get }
}

public extension Endpoint {
    
    var serverTrustPolicy: ServerTrustPolicy? {
        nil
    }
    
    var decoder: JSONDecoder {
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return formatter
        }()
        let keyDecodingStrategy = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
        let dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.formatted(formatter)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return decoder
    }
}

public extension Endpoint {
        
    @discardableResult
    func request<T>(result: @escaping NetResult<T>) -> Cancellable {
        let cancellable = Netjob(endpoint: self)
        cancellable.request(result: result)
        return cancellable
    }
}
