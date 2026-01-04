import Foundation

public struct SouvenirListRequest {
    public let page: Int
    public let size: Int

    public init(page: Int = 0, size: Int = 12) {
        self.page = page
        self.size = size
    }

    public var queryParameters: [String: String] {
        [
            "page": "\(page)",
            "size": "\(size)",
        ]
    }
}
