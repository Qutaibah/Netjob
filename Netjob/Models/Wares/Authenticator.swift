import Foundation

final class AuthMiddleware: Middleware {
    var middlewareOrder: WareOrder = .middle
    
    func handle(request: Request, result: (WareResult<Request, Error>) -> Void) {
        let request = request.setAuth(token: "")
        result(.next(request))
    }
}
