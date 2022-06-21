import os.log
import Foundation

struct Logger {
    
    static func verbose(_ message: Any) {
        if NetjobConfiguration.logLevel == .verbose {
            output(message)
        }
    }
    
    static func info(_ message: Any) {
        if NetjobConfiguration.logLevel == .info {
            output(message)
        }
    }
    
    static func any(_ message: Any) {
        if [.verbose, .info].contains(NetjobConfiguration.logLevel) {
            output(message)
        }
    }

    static func output(_ message: Any..., separator: String = " ", terminator: String = "\n") {
        print(message)
    }
    
    static func output(_ message: Any, separator: String = " ", terminator: String = "\n") {
        print(message)
    }
}
