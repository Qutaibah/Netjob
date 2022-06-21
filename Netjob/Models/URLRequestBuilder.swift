import Foundation

extension URLRequest {
    
    init(endpoint: Endpoint) {
        let url = URL(string: endpoint.url, query: endpoint.query)
        self.init(url: url)
        let params = endpoint.body?.compactMapValues({ $0 })
        if let body = params?.compactMapValues({ $0 as? MultipartConvertable }), let files = endpoint.files {
            self.httpBody = encodeParameters(parameters: body, media: files)
        } else if let body = params {
            self.httpBody = encodeParameters(parameters: body)
        }
        self.httpMethod = endpoint.method.name
        self.httpShouldHandleCookies = false
    }
    
    func encodeParameters(parameters: [String : Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters, options: [])
    }
        
    mutating func encodeParameters(parameters: [String: MultipartConvertable]?, media: [Media]?) -> Data {
        let boundaryHeader: String = UUID().uuidString
        let boundary: String = "--" + boundaryHeader

        var body = Data()

        if let parameters = parameters {
            for (key, value) in parameters {
                body = body
                    .start(boundary)
                    .breakLine()
                    .contentDisposition(key)
                    .breakLine()
                    .breakLine()
                    .add(value.value)
                    .breakLine()
            }
        }

        if let media = media {
            for file in media {
                body = body
                    .start(boundary)
                    .breakLine()
                    .contentDisposition(file.key)
                    .fileName(file.fileName)
                    .breakLine()
                    .contentType(file.mimeType)
                    .breakLine()
                    .breakLine()
                    .add(file.data)
                    .breakLine()
            }
        }
        body = body.finish(boundary)
        allHTTPHeaderFields?["Content-Type"] = "multipart/form-data; boundary=\(boundaryHeader)"
        return body
    }
}
