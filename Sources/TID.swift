import Foundation

public struct TID: ID, CustomStringConvertible {
    // This date is the 5th of November 2016
    public static var referenceDate = Date(timeIntervalSinceReferenceDate: 5e8)
    static let chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!$"
                        .characters.map{"\($0)"}

    // this enables us to make 16 unique
    // instances of this struct every microsecond
    public static var maxUniqifier = 16
    static var uniqifier = maxUniqifier - 1
    
    static var nextUniq: Int {
        uniqifier = (uniqifier + 1) % maxUniqifier
        
        return uniqifier
    }
    
    public let hashValue: Int
    public let description: String

    public init() {
        let timeInterval = Date().timeIntervalSince(TID.referenceDate)
        self = TID(Int(timeInterval * 1e6) * TID.maxUniqifier + TID.nextUniq)
    }
    
    public init(_ id: Int) {
        hashValue = id
        
        let bits = String(hashValue, radix: 2)
        let c = bits.characters.count
        
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
            .characters.map { TID.chars.index(of: "\($0)") ?? -1 }
        
        guard !indices.contains(-1) else { return nil }
        
        hashValue = indices.reversed().enumerated()
            .reduce(0) { $0 + $1.element * 64 ^ $1.offset }
        
        description = string
    }
}

extension TID: Comparable {
    public static func <(left: TID, right: TID) -> Bool {
        return left.hashValue < right.hashValue
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
        let toPad = length - self.characters.count
        if toPad < 1 { return self }
        return String(repeating: pad, count: toPad) + self
    }
    
    func split(every length: Int) -> [String] {
        return Array(self.characters)
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

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^ : PowerPrecedence
func ^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
