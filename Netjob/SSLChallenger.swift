import Foundation

class SSLChallenger: NSObject {
    
    private var serverTrustPolicy: ServerTrustPolicy!
    
    init(serverTrustPolicy: ServerTrustPolicy) {
        self.serverTrustPolicy = serverTrustPolicy
        super.init()
    }
}

extension SSLChallenger: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession,
                           didReceive challenge: URLAuthenticationChallenge,
                           completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?

        defer { completionHandler(disposition, credential) }
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust else { return }
        let host = challenge.protectionSpace.host
        guard let serverTrust = challenge.protectionSpace.serverTrust else { return }

        if serverTrustPolicy.evaluate(serverTrust, forHost: host) {
            disposition = .useCredential
            credential = URLCredential(trust: serverTrust)
        } else {
            disposition = .cancelAuthenticationChallenge
        }
    }
}
