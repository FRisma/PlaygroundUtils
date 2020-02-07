/*:
 # Codable
 
 - Author:
 [Franco Risma](emilio.risma@gmail.com)
 For more information, see [this Medium post.](https://medium.com/swiftly-swift/swift-4-decodable-beyond-the-basics-990cc48b7375)
 */

import Foundation

/*:
 
 - The Decoder:
 Transforms something in something else (from JSON to memory representation)
 Fuctions:
 1. container<Key>(keyedBy: Key.Type) -> Returns a keyed container
 2. singleValueContainer() -> Data
 
 - The Containers
 
 
 */


public struct CodableDictionary: Codable {
    private var value: [String: Any]

    public init(value: [String: Any]) {
        self.value = value
    }

    public var rawValue: [String: Any] {
        return value
    }

    // MARK: - subscripts

    public subscript(key: String) -> Any? {
        get {
            return value[key]
        }
        set {
            value[key] = newValue
        }
    }

    // MARK: - Dictionary implementations

    public var isEmpty: Bool {
        return value.isEmpty
    }

    public var count: Int {
        return value.count
    }

    public var capacity: Int {
        return value.capacity
    }

    public func index(forKey key: String) -> Dictionary<String, Any>.Index? {
        return value.index(forKey: key)
    }

    public var first: (key: String, value: Any)? {
        return value.first
    }

    public var keys: Dictionary<String, Any>.Keys {
        return value.keys
    }

    public var values: Dictionary<String, Any>.Values {
        return value.values
    }

    // MARK: - Codable

    public struct DynamicCodingKeys: CodingKey {
        public var stringValue: String
        public var intValue: Int?

        public init?(stringValue: String) { self.stringValue = stringValue }
        public init?(intValue: Int) { self.intValue = intValue; stringValue = "\(intValue)" }

        init?(key: CodingKey) {
            if let intValue = key.intValue {
                self.init(intValue: intValue)
            } else {
                self.init(stringValue: key.stringValue)
            }
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        var dict: [String: Any] = [:]

        for key in container.allKeys {
            guard let codingKey = DynamicCodingKeys(key: key) else { continue }

            if let string: String = try? container.decode(String.self, forKey: codingKey) {
                dict[key.stringValue] = string
            } else if let bool: Bool = try? container.decode(Bool.self, forKey: codingKey) {
                dict[key.stringValue] = bool
            } else if let int: Int = try? container.decode(Int.self, forKey: codingKey) {
                dict[key.stringValue] = int
            } else if let double: Double = try? container.decode(Double.self, forKey: codingKey) {
                dict[key.stringValue] = double
            } else if let array: [String] = try? container.decode([String].self, forKey: codingKey) {
                dict[key.stringValue] = array
            } else if let array: [Bool] = try? container.decode([Bool].self, forKey: codingKey) {
                dict[key.stringValue] = array
            } else if let array: [Int] = try? container.decode([Int].self, forKey: codingKey) {
                dict[key.stringValue] = array
            } else if let array: [Double] = try? container.decode([Double].self, forKey: codingKey) {
                dict[key.stringValue] = array
            } else if let nestedDict: CodableDictionary = try? container.decode(CodableDictionary.self, forKey: codingKey) {
                dict[key.stringValue] = nestedDict.value
            } else if let nestedArrayDict: [CodableDictionary] = try? container.decode([CodableDictionary].self, forKey: codingKey) {
                dict[key.stringValue] = nestedArrayDict.map { $0.value }
            } else {
                let context = DecodingError.Context(codingPath: [], debugDescription: "Could not find Type of value in key: \(key.stringValue)")
                throw DecodingError.dataCorrupted(context)
            }
        }

        value = dict
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)

        for (key, value) in value {
            guard let codingKey = DynamicCodingKeys(stringValue: key) else { continue }

            switch value {
            case let value as String:
                try container.encode(value, forKey: codingKey)
            case let value as Int:
                try container.encode(value, forKey: codingKey)
            case let value as Double:
                try container.encode(value, forKey: codingKey)
            case let value as Bool:
                try container.encode(value, forKey: codingKey)
            case let value as [String]:
                try container.encode(value, forKey: codingKey)
            case let value as [Int]:
                try container.encode(value, forKey: codingKey)
            case let value as [Double]:
                try container.encode(value, forKey: codingKey)
            case let value as [Bool]:
                try container.encode(value, forKey: codingKey)
            default:
                if let additionalEncoding = self.additionalEncoding {
                    try additionalEncoding(&container, codingKey, value)
                } else {
                    let context = EncodingError.Context(codingPath: [codingKey], debugDescription: "Could not encode value (\(value)) for unknwon type.")
                    throw EncodingError.invalidValue(value, context)
                }
            }
        }
    }

    public var additionalEncoding: ((_ container: inout KeyedEncodingContainer<CodableDictionary.DynamicCodingKeys>, _ codingKey: CodableDictionary.DynamicCodingKeys, _ value: Any) throws -> Void)?
}

struct CustomDecodingStrategy {
    /// This array represents the root key of the
    /// entities in json that wants to be decoded
    /// with the strategy useDefaultKeys.
    /// `jsonTrackingKeys = ["tracking_info"]`:
    ///
    ///     {
    ///         "testing_key" : "Hi",
    ///         "tracking_info" : {
    ///             "first_key" : "Greetings",
    ///             "second_key" : "Say Goodbye",
    ///         }
    ///     }
    ///
    ///     // Keys will be "testingKey", "trackingInfo", "first_key", "second_key"
    ///
    /// The conversion of `p` to a string in the assignment to `s` uses the
    /// `Point` type's `debugDescription` property.
    static let jsonTrackingKeys = [
        "twitter",
        "track_info",
    ]

    func convertFromSnakeCaseExceptTrackingInfo() -> JSONDecoder.KeyDecodingStrategy {
        return .custom(convertFromSnakeCase(exceptWithin: CustomDecodingStrategy.jsonTrackingKeys.map(convertFromSnakeCase)))
    }

    /// Custom convertion from snake case unless the key's parent key (already decoded in camelCase)
    /// is present in the exceptWithin parameter
    private func convertFromSnakeCase(exceptWithin exceptions: [String]) -> ([CodingKey]) -> CodingKey {
        return { keys in
            guard let lastKey = keys.last else { return AnyKey(stringValue: "undefined")! }
            let parents = keys.dropLast().compactMap { $0.stringValue }
            if parents.contains(where: { exceptions.contains($0) }) {
                print("FRISMA native key: \(lastKey)")
                return lastKey
            } else {
                return AnyKey(stringValue: self.convertFromSnakeCase(lastKey.stringValue))!
            }
        }
    }

    // Apple's convert from snake case source code
    private func convertFromSnakeCase(_ stringKey: String) -> String {
        guard !stringKey.isEmpty else { return stringKey }

        // Find the first non-underscore character
        guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "_" }) else {
            // Reached the end without finding an _
            return stringKey
        }

        // Find the last non-underscore character
        var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
        while lastNonUnderscore > firstNonUnderscore, stringKey[lastNonUnderscore] == "_" {
            stringKey.formIndex(before: &lastNonUnderscore)
        }

        let keyRange = firstNonUnderscore ... lastNonUnderscore
        let leadingUnderscoreRange = stringKey.startIndex ..< firstNonUnderscore
        let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore) ..< stringKey.endIndex

        let components = stringKey[keyRange].split(separator: "_")
        let joinedString: String
        if components.count == 1 {
            // No underscores in key, leave the word as is - maybe already camel cased
            joinedString = String(stringKey[keyRange])
        } else {
            joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
        }

        // Do a cheap isEmpty check before creating and appending potentially empty strings
        let result: String
        if leadingUnderscoreRange.isEmpty, trailingUnderscoreRange.isEmpty {
            result = joinedString
        } else if !leadingUnderscoreRange.isEmpty, !trailingUnderscoreRange.isEmpty {
            // Both leading and trailing underscores
            result = String(stringKey[leadingUnderscoreRange]) + joinedString + String(stringKey[trailingUnderscoreRange])
        } else if !leadingUnderscoreRange.isEmpty {
            // Just leading
            result = String(stringKey[leadingUnderscoreRange]) + joinedString
        } else {
            // Just trailing
            result = joinedString + String(stringKey[trailingUnderscoreRange])
        }
        return result
    }
}

struct AnyKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
        intValue = nil
    }

    init?(intValue: Int) {
        stringValue = String(intValue)
        self.intValue = intValue
    }
}



struct Swifter: Decodable {
    let fullName: String
    let id: Int
    let twitter: CodableDictionary
    let trackingInfo: CodableDictionary
}

let json = """
{
    "fullName": "Federico Zanetello",
    "id": 123456,
    "twitter": {
        "first_key" : "Hello",
        "second_key" : "Goodbly",
    },
    "tracking_info": {
        "local_time" : "I dont know",
        "best_friend" : "CFK",
    }
}
""".data(using: .utf8)! // our data in native (JSON) format
let decoder = JSONDecoder()
decoder.keyDecodingStrategy = CustomDecodingStrategy().convertFromSnakeCaseExceptTrackingInfo()
let myStruct = try decoder.decode(Swifter.self, from: json) // Decoding our data
print(myStruct) // decoded!!!!!
