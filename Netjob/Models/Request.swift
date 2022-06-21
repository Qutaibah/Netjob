import Foundation

public struct Request: Hashable {
    var request: URLRequest
    
    init(endpoint: Endpoint) {
        self.request = URLRequest(endpoint: endpoint)
    }
    
    public func setAuth(token: String) -> Request {
        var request = self
        request.request.addValue(token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    public func setHeaders(headers: [String: String]) -> Request {
        var request = self

        let contentTypeHeader = request.request.allHTTPHeaderFields?["Content-Type"]
        request.request.allHTTPHeaderFields = headers
        
        // if the request is multipart, force the contect type header to use it
        if let multipart = contentTypeHeader, contentTypeHeader?.contains("multipart") == true {
            request.request.addValue(multipart, forHTTPHeaderField: "Content-Type")
        }
        return request
    }
    
    mutating func setCachePolicy(policy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData) {
        request.cachePolicy = policy
    }
    
    mutating func setTimeout(duration: TimeInterval) {
        request.timeoutInterval = duration
    }

    var description: String {
        request.description
    }
}

extension Request: Equatable {
    
    public static func == (lhs: Request, rhs: Request) -> Bool {
        lhs.request.url?.absoluteString == rhs.request.url?.absoluteString
    }
}
