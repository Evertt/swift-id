import Foundation

public struct TID: ID, CustomStringConvertible {
    // This date is the 5th of November 2016
    public static var referenceDate = Date(timeIntervalSinceReferenceDate: 5e8)
    static let chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!$".map{"\($0)"}

    // this enables us to make 16 unique
    // instances of this struct every microsecond
    public static var maxUniqifier: UInt = 16
    static var uniqifier: UInt = maxUniqifier - 1
    
    static let queue = DispatchQueue(label: "nl.devign.tid")
    
    static var nextUniq: UInt {
        IID.queue.sync {
            uniqifier = (uniqifier + 1) % maxUniqifier
        }
        
        return uniqifier
    }
    
    public let value: UInt
    public let description: String

    public init() {
        let timeInterval = Date().timeIntervalSince(TID.referenceDate)
        self = TID(UInt(timeInterval * 1e6) * TID.maxUniqifier + TID.nextUniq)
    }
    
    public init(_ id: UInt) {
        value = id
        
        let bits = String(value, radix: 2)
        let c = bits.count
        
        let base64Chars = bits
            .padLeft(toLength: (c - 1) + (6 - (c - 1) % 6), withPad: "0")
            .split(every: 6)
            .reduce([String]()) { $0 + [TID.chars[Int($1, radix: 2)!]] }
        
        let chunkSize = 1...2 ~= base64Chars.count % 4 ? 3 : 4
        
        description = base64Chars
            .chunk(per: chunkSize)
            .map{ $0.joined() }
            .joined(separator: "-")
    }
    
    public init?(_ string: String) {
        let indices = string.replacingOccurrences(of: "-", with: "")
            .map { TID.chars.index(of: "\($0)") ?? -1 }
        
        guard !indices.contains(-1) else { return nil }
        
        value = indices.reversed().enumerated()
            .reduce(0) { $0 + UInt($1.element) * UInt(64 ^ $1.offset) }
        
        description = string
    }
}

extension TID: Comparable {
    public static func <(left: TID, right: TID) -> Bool {
        return left.value < right.value
    }
}

extension TID: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = TID(value)!
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self = TID(value)!
    }
    
    public init(unicodeScalarLiteral value: String) {
        self = TID(value)!
    }
}

extension String {
    func padLeft(toLength length: Int, withPad pad: String) -> String {
        let toPad = length - self.count
        if toPad < 1 { return self }
        return String(repeating: pad, count: toPad) + self
    }
    
    func split(every length: Int) -> [String] {
        return Array(self)
            .chunk(per: length)
            .map{ $0.reduce("") { "\($0)\($1)" } }
    }
}

extension Array {
    func chunk(per chunkSize: Int) -> [[Element]] {
        return stride(from: count, to: 0, by: -chunkSize).map { endIndex in
            let chunkStart = self.index(endIndex, offsetBy: -chunkSize, limitedBy: startIndex) ?? startIndex
            return Array(self[chunkStart..<endIndex])
        }.reversed()
    }
}
