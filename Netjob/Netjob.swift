import Foundation

typealias Failure = (Error) -> Void
typealias Success<T> = (T) -> Void
public typealias NetResult<T> = (Result<T, Error>) -> Void

public class Netjob {
    
    private let session: URLSession?
    private let endpoint: Endpoint
    private var task: Cancellable?
    private let sslChallenger: SSLChallenger?
    private var hasBeenCanceled: Bool = false
    
    var postwares: [Postware] {
        var wares = Array(endpoint.postwares)
        wares.append(StatusCodeValidator())
        wares.sort(by: { $0.postwareOrder < $1.postwareOrder })
        // Appended after sorting the wares to make sure it's the last one
        wares.append(ErrorCatcher())
        return wares
    }
    
    var middlewares: [Middleware] {
        let wares = Array(endpoint.middlewares)
        return wares.sorted(by: { $0.middlewareOrder < $1.middlewareOrder })
    }

    public init(endpoint: Endpoint, session: URLSession? = nil) {
        self.endpoint = endpoint
        if let session = session {
            sslChallenger = nil
            self.session = session
        } else if let ssl = endpoint.serverTrustPolicy {
            let config: URLSessionConfiguration = .ephemeral
            sslChallenger = SSLChallenger(serverTrustPolicy: ssl)
            self.session = URLSession(configuration: config, delegate: sslChallenger, delegateQueue: nil)
        } else {
            sslChallenger = nil
            self.session = URLSession.shared
        }
    }
    
    private func handle(middlewares: [Middleware],
                        request: Request,
                        result: @escaping WareCallback<Request>) {
        
        guard let ware = middlewares.first else {
            return result(.next(request))
        }
        
        ware.handle(request: request) { (handled: WareResult<Request, Error>) in
            switch handled {
            case .next(let request):
                let middlewares = Array(middlewares[1...])
                self.handle(middlewares: middlewares, request: request, result: result)
            case .abort(let error):
                result(.abort(error))
            }
        }
    }
    
    private func handle(postwares: [Postware],
                        response: Response,
                        result: @escaping WareCallback<Response>) {
        
        guard let ware = postwares.first else {
            return result(.next(response))
        }
        
        ware.handle(response: response) { (handled: WareResult<Response, Error>) in
            switch handled {
            case .next(let response):
                let postwares = Array(postwares[1...])
                self.handle(postwares: postwares, response: response, result: result)
                
            case .abort(let error):
                result(.abort(error))
            }
        }
    }
    
    private func handle<T>(response: Response, result: @escaping NetResult<T>) {
        self.handle(postwares: self.postwares, response: response) { (handled: WareResult<Response, Error>) in
            switch handled {
            case .next(let response):
                do {
                    let object: T = try self.convertData(response: response)
                    DispatchQueue.main.async {
                        result(.success(object))
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        result(.failure(error))
                    }
                }
            case .abort(let error):
                DispatchQueue.main.async {
                    result(.failure(error))
                }
            }
        }
    }
    
    private func convertData<T>(response: Response) throws -> T {
        if T.self is Void.Type { return () as! T }
        guard let data = T.self == Empty.self ? Empty.fakeData : response.data else {
            throw NetjobError.decoderFailed(error: nil)
        }
        guard let object = try ResponseWrapper<T>().output(data: data, decoder: self.endpoint.decoder) else {
            throw NetjobError.decoderFailed(error: nil)
        }
        return object
    }
    
    private func prepareClient(client: @escaping WareCallback<NetworkClient>) {
        let request = Request(endpoint: endpoint)
        handle(middlewares: middlewares, request: request) { (handled: WareResult<Request, Error>) in
            switch handled {
            case .next(let request):
                let network = NetworkClient(request: request, session: self.session)
                client(.next(network))
            case .abort(let error):
                client(.abort(error))
            }
        }
    }
    
    public func cancel() {
        hasBeenCanceled = true
        task?.cancel()
    }
}

extension Netjob: Cancellable {}

extension Netjob: Network {
    public func request<T>(result: @escaping NetResult<T>) {
        prepareClient { (client: WareResult<NetworkClient, Error>) in
            guard self.hasBeenCanceled == false else { return }
            switch client {
            case .next(let networkClient):
                self.task = networkClient.request { (response: Response) in
                    self.handle(response: response, result: result)
                }
            case .abort(let error):
                if case let NetjobError.errorAsSuccess(response) = error {
                    self.handle(response: response, result: result)
                } else if case NetjobError.retry = error {
                    self.request(result: result)
                } else {
                    DispatchQueue.main.async {
                        result(.failure(error))
                    }
                }
            }
        }
    }
}
