import Foundation

struct ErrorCatcher: Postware {
    var postwareOrder: WareOrder = .custom(1)
    
    func handle(response: Response, result: WareCallback<Response>) {
        if let error = response.error {
            result(.abort(error))
        } else {
            result(.next(response))
        }
    }
}
