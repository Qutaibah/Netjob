import Foundation

public enum WareResult<T, E> {
    case next(T)
    case abort(E)
}
