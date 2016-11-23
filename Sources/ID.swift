public protocol ID: Hashable, ExpressibleByIntegerLiteral {
    init()
    init(_ id: Int)
}

extension ID {
    public static func ==(left: Self, right: Self) -> Bool {
        return left.hashValue == right.hashValue
    }
}

extension ID {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}
