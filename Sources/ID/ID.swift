public protocol ID: Hashable, Codable, ExpressibleByIntegerLiteral {
    var value: UInt { get }
    init()
    init(_ id: UInt)
}

extension ID {
    public init(integerLiteral value: UInt) {
        self.init(value)
    }
}

extension ID {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(UInt.self)
        self.init(value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
