import Foundation

public struct NetjobConfiguration {
    public static var bundle: Bundle {
        Bundle(for: SSLChallenger.self)
    }
    public static var logLevel: LogLevel = .verbose
    public static var decorationStyle: DecorationStyle = .linePrefix
    public static var decoration: [String] = ["🐙", "🐞", "🔥", "😈", "👁", "🤡", "🏓", "🤢", "💀", "🎃", "🤖"]

    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()

    public enum LogLevel {
        case none
        case info
        case verbose
    }
    
    public enum DecorationStyle {
        case firstAndLastLine
        case linePrefix
    }
}
