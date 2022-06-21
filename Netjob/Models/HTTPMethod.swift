import Foundation

/// Namespace for all http methods
public enum HTTPMethod {
    case get
    case post
    case put
    case delete
    case patch

    /// The method name that would be accepted by the http request
    internal var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        case .patch:
            return "PATCH"
        }
    }
}
