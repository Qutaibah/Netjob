import Foundation

public protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable {}
