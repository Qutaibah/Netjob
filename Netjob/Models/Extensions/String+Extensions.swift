import Foundation

extension String {
    
    mutating func newLine() {
        append("\n")
    }
    
    var decorated: String {
        let decoration = NetjobConfiguration.decoration.randomElement() ?? "🐞"
        switch NetjobConfiguration.decorationStyle {
        case .firstAndLastLine:
            let line = String(repeating: decoration, count: 50)
            return line + "\n" + self + "\n" + line
        case .linePrefix:
            let new = decoration + " " + self
            return new.replacingOccurrences(of: "\n", with: "\n\(decoration) ")
        }
    }
    
    var snakeCased: String {
        let acronymPattern = "([A-Z]+)([A-Z][a-z]|[0-9])"
        let fullWordsPattern = "([a-z])([A-Z]|[0-9])"
        let digitsFirstPattern = "([0-9])([A-Z])"
        return self.processCamelCaseRegex(pattern: acronymPattern)?
            .processCamelCaseRegex(pattern: fullWordsPattern)?
            .processCamelCaseRegex(pattern:digitsFirstPattern)?.lowercased() ?? self.lowercased()
    }
    
    fileprivate func processCamelCaseRegex(pattern: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")
    }
}
