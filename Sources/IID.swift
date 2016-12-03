public struct IID: ID, CustomStringConvertible {
    public static var seed = 0
    public let hashValue: Int
    public let description: String

    public init() {
        IID.seed += 1
        self = IID(IID.seed)
    }

    public init(_ id: Int) {
        hashValue = id
        description = "\(id)"
    }
}

extension IID: Comparable {    
    public static func <(left: IID, right: IID) -> Bool {
        return left.hashValue < right.hashValue
    }
}
