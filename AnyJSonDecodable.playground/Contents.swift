import Foundation

let response = """
{
    "track_data": {
        "payment_id": "71052233",
        "collector_name": "Test Test",
        "collector_id": 377185072,
        "paid_amount": "40.0",
        "currency_id": "ARS",
        "payment_date": "2019-09-27T12:47:02.020-04:00",
        "payment_method_id": "account_money",
        "payment_method_name": "Dinero en mi cuenta de MercadoPago"
    }
}
""".data(using: .utf8)!


struct TrackData: Codable {
    let trackData: Tracks
}

struct Tracks: Codable {
    var array: [String: TrackValue]
    
    public struct DynamicCodingKey: CodingKey {
        public var stringValue: String
        public init?(stringValue: String) { self.stringValue = stringValue }
        
        public var intValue: Int? { return nil }
        public init?(intValue: Int) { return nil }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        self.array = [String: TrackValue]()
        
        for key in container.allKeys {
            let value = try container.decode(TrackValue.self, forKey: DynamicCodingKey(stringValue: key.stringValue)!)
            self.array[key.stringValue] = value
        }
    }
}


enum TrackValue: Codable {
    case string(String?)
    case int(Int?)
    case double(Double?)
    case bool(Bool?)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .string(value)
            return
        }
        if let value = try? container.decode(Int.self) {
            self = .int(value)
            return
        }
        if let value = try? container.decode(Double.self) {
            self = .double(value)
            return
        }
        if let value = try? container.decode(Bool.self) {
            self = .bool(value)
            return
        }
        throw DecodingError.typeMismatch(TrackValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Track"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        }
    }
}


do {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let resultado = try decoder.decode(TrackData.self, from: response)
    print(resultado.trackData)
} catch {
    print(error)
}
