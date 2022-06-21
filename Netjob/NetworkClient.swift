import Foundation

class NetworkClient {
    
    private let session: URLSession
    private let request: Request?
    
    init(request: Request, session: URLSession? = nil) {
        self.session = session ?? URLSession.shared
        self.request = request
    }
            
    @discardableResult
    func request(result: @escaping Success<Response>) -> Cancellable {
        guard let request = request else { return URLSessionTask() }
        var response = Response(request: request)
        let task = session.dataTask(with: request.request) { (data, res, error) in
            response.set(data: data, response: res, error: error)
            result(response)
        }
        task.resume()
        return task
    }
}
