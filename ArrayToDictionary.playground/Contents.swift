import Foundation

let data = """
[
    {
        "id": "instore_qr_map",
        "status": true
    },
    {
        "id": "instore_qr_map",
        "status": false
    },
    {
        "id": "free_navigation",
        "status": false
    }
]
""".data(using: .utf8)!

struct MPIgniteResponse: Codable {
    let id: String
    let status: Bool
}

enum ISFeature: Int, Hashable {
    case discovery
    
    init?(fromIgnite feature: ISIgniteFeature) {
        switch feature {
        case ISIgniteFeature.discovery: self = ISFeature.discovery
        }
    }
}

enum ISIgniteFeature: String {
    case discovery = "instore_qr_map"

    init?(from feature: ISFeature) {
        switch feature {
        case ISFeature.discovery: self = ISIgniteFeature.discovery
        }
    }
}

var response = [MPIgniteResponse]()
do {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    response = try decoder.decode([MPIgniteResponse].self, from: data)
} catch {
    print(error)
}

let mapa: [(ISFeature, Bool)] = response.compactMap { element in
    guard let ignite = ISIgniteFeature(rawValue: element.id) else { return nil }
    guard let feature = ISFeature(fromIgnite: ignite) else { return nil }
    return (feature, element.status)
}
let dict = Dictionary(mapa, uniquingKeysWith: { _, latest in latest})
dict.forEach {
    print($0.key)
    print($0.value)
}

//Another way
let dic2 = response.reduce(into: [:]) { $0[$1.id] = $1.status }
dic2.forEach {
    print($0.key)
    print($0.value)
}

