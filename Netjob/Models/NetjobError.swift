import Foundation

public enum NetjobError: Error {
    case errorAsSuccess(response: Response)
    case httpError(Error)
    case decoderFailed(error: Error?)
    case retry
    case unknown
    
    var embeddedError: Error? {
        switch self {
        case .decoderFailed(let error):
            return error
        default:
            return nil
        }
    }

    init?(code: Int?) {
        if let code = code, let error = HTTPError(rawValue: code) {
            self = .httpError(error)
        } else {
            return nil
        }
    }
    
    public var code: Int {
        switch self {
        case .errorAsSuccess: return 0
        case .httpError(let error):
            guard let er = error as? HTTPError else { return 1 }
            return er.rawValue
        default: return 1000
        }
    }
}
