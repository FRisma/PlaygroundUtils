import UIKit

var str = """
{
"status": "success",
"retry_time": 1000,
"congrats": {
"payment_id": "71052233",
"collector_name": "Test Test",
"header_title": "¡Listo! Ya le pagaste a Test Test",
"header_subtitle": "",
"header_image": "https://mla-s2-p.mlstatic.com/600619-MLA32239048138_092019-O.jpg",
"body_title": "Operación",
"body_message": "Usalo como comprobante de pago, siempre que lo necesites.",
"payment_date": "27 de septiembre de 2019 a las 12:47hs",
"payment_image": "https://http2.mlstatic.com/storage/logos-api-admin/f4fec170-571b-11e8-9a2d-4b2bd7b1bf77-xl@2x.png",
"payment_method_name": "Cuenta de Mercado Pago",
"payment_paid_amount": "$ 40",
"buttons": [
{
"title": "Continuar",
"type": "PrimaryOption"
}
]
},
"track_data": {
"payment_id": "71052233",
"collector_name": "Test Test",
"collector_id": null,
"paid_amount": "40.0",
"currency_id": "ARS",
"payment_date": "2019-09-27T12:47:02.020-04:00",
"payment_method_id": "account_money",
"payment_method_name": "Dinero en mi cuenta de MercadoPago"
}
}
""".data(using: .utf8)!

public enum ISBuyerQRPaymentStatus: String, Codable {
    case newPayment = "success"
    case failedPayment = "failure"
    case noPayment = "other"
}

public struct ISBuyerQRPayment: Decodable {
    public var status: ISBuyerQRPaymentStatus
    public var retryTime: Int
    public var congrats: ISBuyerQRCongratsViewData?
    public var trackData: Tracks?
}

public struct ISBuyerQRCongratsViewData: Decodable {
    public var paymentId: String?
    public var headerTitle: String
    public var headerSubtitle: String?
    public var headerImage: String
    public var bodyTitle: String?
    public var bodyMessage: String?
    public var paymentDate: String?
    public var paymentImage: String?
    public var paymentMethodName: String?
    public var paymentItemAmount: String?
    public var paymentPaidAmount: String?
    public var buttons: [ISBuyerQRCongratsButtons]
}

public struct ISBuyerQRCongratsButtons: Decodable {
    public var title: String
    public var type: String
    public var action: String?
}

public struct TrackData: Codable {
    let trackData: Tracks
}

public struct Tracks: Codable {
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
        if let value = try? container.decodeIfPresent(Double.self) {
            self = .double(value)
            return
        }
        if let value = try? container.decode(Bool.self) {
            self = .bool(value)
            return
        }
        if let value = try? container.decode(NSNull().self) {
            
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
    let respuest = try decoder.decode(ISBuyerQRPayment.self, from: str)
    print(respuest)
} catch {
    print(error)
}

