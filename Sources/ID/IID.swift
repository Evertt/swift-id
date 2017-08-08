import Foundation

public struct IID: ID, CustomStringConvertible {
    public static var seeds = [String:Int]()
    public let hashValue: Int
    public let description: String

    static let queue = DispatchQueue(label: "nl.devign.id")

    public init() {
        self.init(for: "")
    }

    public init(for name: String) {
        IID.queue.sync {
            IID.seeds[name] = (IID.seeds[name] ?? 0) + 1
        }
        
        self.init(IID.seeds[name] ?? 0)
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
