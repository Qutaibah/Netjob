import Foundation

public class FileSession: URLSession {

    let bundle: Bundle
    
    public init(bundle: Bundle = .main) {
        self.bundle = bundle
        super.init()
    }
    
    public override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let components = request.url?.pathComponents[1...]
        var path = components?.joined(separator: "_") ?? ""
        if request.allHTTPHeaderFields?["Accept"]?.contains("json") == true {
            // check if path already contains json
            path.append(".json")
        }
        var data: Data?
        do {
             data = try load(path)
        } catch {
            
        }
        let error: Error? = nil

        let response = HTTPURLResponse(url: request.url ?? URL(string: "")!,
                                       statusCode: data == nil ? 404 : 200,
                                       httpVersion: "HTTP/1.1",
                                       headerFields: ["X-MOCKED": "File \(path)"])
        return FileDataTask {
            completionHandler(data, response, error)
        }
    }
    
    func load(_ filename: String) throws -> Data {
        let data: Data
        guard let file = bundle.url(forResource: filename, withExtension: nil) else {
            throw NetjobError.httpError(HTTPError.notFound)
        }
        do {
            data = try Data(contentsOf: file)
        } catch {
            throw NetjobError.httpError(HTTPError.notFound)
        }
        return data
    }
}

class FileDataTask: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}
