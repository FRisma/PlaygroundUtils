import Foundation

public enum DVYFilterState: Int, Codable {
    case selected
    case unselected
}

public enum DVYFilterType: String, Codable {
    case action
    case quick
    case quickHighlighted
}

public struct DVYQuickFilter {
    private let title: String
    private let priority: Int
    private let criteria: DVYFilterCriteria
    private var state: DVYFilterState = .unselected
    private var type: DVYFilterType = .quick

    public init(title: String, criteria: DVYFilterCriteria, priority: Int = 1, state: DVYFilterState = .unselected, type: DVYFilterType = .quick) {
        self.title = title
        self.criteria = criteria
        self.priority = priority
        self.state = state
        self.type = type
    }
}

extension DVYQuickFilter: Codable {
    public enum CodingKeys: String, CodingKey {
        case title = "title"
        case priority = "priority"
        case criteria = "tag"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        priority = try container.decode(Int.self, forKey: .priority)
        let criteriaString: String = try container.decode(String.self, forKey: .criteria)
        let criteriaArray = criteriaString.split(separator: ",").map { String($0) }
        criteria = DVYFilterCriteria(with: criteriaArray)
    }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            do {
                let stringCrit = criteria.filters().joined(separator: ",")
                try container.encode(stringCrit, forKey: .criteria)
                try container.encode(title, forKey: .title)
                try container.encode(priority, forKey: .priority)
            } catch {
                print(error)
            }
        }
}

public struct DVYFilterCriteria {
    private let criteria: Set<String>

    public init(with filter: String) {
        criteria = Set([filter])
    }

    public init(with filters: [String]) {
        criteria = Set(filters)
    }

    public init(with filters: Set<String>) {
        criteria = filters
    }

    public func filters() -> [String] {
        return Array(criteria)
    }
}
extension DVYFilterCriteria: Codable {}

extension Array where Iterator.Element == DVYQuickFilter {
    public func asData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}

let array = [
    DVYQuickFilter(title: "Uno", criteria: DVYFilterCriteria(with: ["franco","emilio","risma"]), priority: 1, state: .unselected, type: .quick),
    DVYQuickFilter(title: "dos", criteria: DVYFilterCriteria(with: "dos"), priority: 1, state: .unselected, type: .quick),
    DVYQuickFilter(title: "tres", criteria: DVYFilterCriteria(with: "tres"), priority: 1, state: .unselected, type: .quick),
    DVYQuickFilter(title: "cuatro", criteria: DVYFilterCriteria(with: "cuatro"), priority: 1, state: .unselected, type: .quick),
]

extension Data {
    public func decodeArray<Element>(of element: Element.Type) -> [Element]? where Element : Decodable {
        do {
            return try JSONDecoder().decode(Array<Element>.self, from: self)
        } catch {
            print(error)
            return nil
        }
    }
}

let encoded = array.asData()
let encodedString = String(data:encoded!, encoding: .utf8)!
let decoded = encoded!.decodeArray(of: DVYQuickFilter.self)
print(decoded)



