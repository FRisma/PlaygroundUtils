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

struct Swifter: Decodable {
    let fullName: String
    let id: Int
    let twitter: URL
}

let json = """
{
 "fullName": "Federico Zanetello",
 "id": 123456,
 "twitter": "http://twitter.com/zntfdr"
}
""".data(using: .utf8)! // our data in native (JSON) format

let myStruct = try JSONDecoder().decode(Swifter.self, from: json) // Decoding our data
print(myStruct) // decoded!!!!!
