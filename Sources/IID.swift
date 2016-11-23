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
        description = String(hashValue, radix: 16, uppercase: true)
    }

    public init?(_ string: String) {
        guard let id = Int(string, radix: 16) else {
            return nil
        }

        self = IID(id)
    }
}

extension IID: Comparable {    
    public static func <(left: IID, right: IID) -> Bool {
        return left.hashValue < right.hashValue
    }
}

extension IID: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = IID(value)!
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self = IID(value)!
    }
    
    public init(unicodeScalarLiteral value: String) {
        self = IID(value)!
    }
}
