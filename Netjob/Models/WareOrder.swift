import Foundation

/// The order of when this ware should be handled?
public enum WareOrder {
    /// At first, `0.1`
    case first
    /// In the middle, `0.5`
    case middle
    /// At last, `0.9`
    case last
    
    /// To have more control over priorities, pass an order double
    /// - important: The following values are already defined:
    /// * First = __0.1__
    /// * Middle = __0.5__
    /// * Last = __0.9__
    ///
    case custom(Double)
    
    public var rawValue: Double {
        switch self {
        case .first:
            return 0.1
        case .middle:
            return 0.5
        case .last:
            return 0.9
        case .custom(let value):
            return value
        }
    }
    
    public init?(rawValue: Double) {
        switch rawValue {
        case 0.1:
            self = .first
        case 0.5:
            self = .middle
        case 0.9:
            self = .last
        default:
            self = .custom(rawValue)
        }
    }
}

extension WareOrder: Comparable {
    public static func < (lhs: WareOrder, rhs: WareOrder) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    public static func > (lhs: WareOrder, rhs: WareOrder) -> Bool {
        lhs.rawValue > rhs.rawValue
    }
}
