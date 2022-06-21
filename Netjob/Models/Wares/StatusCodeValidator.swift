import Foundation

struct StatusCodeValidator: Postware {
    var postwareOrder: WareOrder = .first
    
    func handle(response: Response, result: (WareResult<Response, Error>) -> Void) {
//        response.succeeded
//            ? next(response)
//            : fail(NetjobError(statusCode: response.statusCode, error: response.error))
        result(.next(response))
    }
}
