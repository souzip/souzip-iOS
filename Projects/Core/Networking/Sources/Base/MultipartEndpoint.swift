import Foundation

public protocol MultipartEndpoint: APIEndpoint {
    func createMultipartBody(boundary: String) -> Data
}

extension Data {
    mutating func append(_ string: String, encoding: String.Encoding = .utf8) {
        guard let data = string.data(using: encoding) else { return }
        append(data)
    }
}
