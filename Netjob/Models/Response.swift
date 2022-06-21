import Foundation

public struct Response {
    public private(set) var request: Request
    public private(set) var data: Data?
    public private(set) var response: URLResponse?
    public var error: Error?
    private var object: ResponseRepresentation
    
    init(request: Request) {
        self.request = request
        let headers = request.request.allHTTPHeaderFields
        object = ResponseRepresentation()
        object.request = ResponseRepresentation.Combined(headers: headers?.isEmpty == true
                                                    ? nil
                                                    : headers,
                                                 body: request.request.httpBody)
        object.method = request.request.httpMethod
        object.absolute_url = request.request.url?.absoluteString
        object.set(status: .started)
    }
    
    mutating func set(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response

        if let urlResponse = response as? HTTPURLResponse {
            object.statusCode = urlResponse.statusCode
            object.response = ResponseRepresentation.Combined(headers: urlResponse.allHeaderFields as? [String: String],
                                                     body: data)
        }
        self.error = error ?? NetjobError(code: object.statusCode)
        object.endedAt = Date()
        object.error = self.error?.localizedDescription
        object.set(status: .finished)
    }
    
    public mutating func set(status: String) {
        object.set(status: ResponseRepresentation.Status(rawValue: status))
    }
}

extension Response: Equatable {
    
    public static func == (lhs: Response, rhs: Response) -> Bool {
        lhs.object.id == rhs.object.id
    }
}
