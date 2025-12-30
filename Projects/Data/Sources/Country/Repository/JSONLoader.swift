import Foundation

enum JSONLoader {
    static func load<T: Decodable>(
        filename: String,
        as type: T.Type
    ) throws -> T {
        guard let url = Bundle.module.url(
            forResource: filename,
            withExtension: "json"
        ) else {
            throw NSError(domain: "JSONNotFound", code: 0)
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
