import Foundation

public struct IID: ID, CustomStringConvertible {
    public static var seeds = [String:UInt]()
    public let value: UInt
    public let description: String

    static let queue = DispatchQueue(label: "nl.devign.iid")

    public init() {
        self.init(for: "")
    }

    public init(for name: String) {
        IID.queue.sync {
            IID.seeds[name, default: 0] += 1
        }
        
        self.init(IID.seeds[name, default: 0])
    }

    public init(_ id: UInt) {
        value = id
        description = "\(id)"
    }
}

extension IID: Comparable {    
    public static func <(left: IID, right: IID) -> Bool {
        return left.hashValue < right.hashValue
    }
}
