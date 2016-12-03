public struct IID: ID {
    public static var seed = 0
    public let hashValue: Int

    public init() {
        IID.seed += 1
        self = IID(IID.seed)
    }

    public init(_ id: Int) {
        hashValue = id
    }
}

extension IID: Comparable {    
    public static func <(left: IID, right: IID) -> Bool {
        return left.hashValue < right.hashValue
    }
}
