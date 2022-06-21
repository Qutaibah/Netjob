import Foundation

public typealias WareCallback<T> = (WareResult<T, Error>) -> Void

public protocol Ware {}

public protocol Middleware: Ware {
    var middlewareOrder: WareOrder { get }
    func handle(request: Request, result: @escaping WareCallback<Request>)
}

public protocol Postware: Ware {
    var postwareOrder: WareOrder { get }
    func handle(response: Response, result: @escaping WareCallback<Response>)
}
