public struct ErrorResponse: Decodable {
    public let message: String
    public let traceId: String?

    public init(message: String, traceId: String? = nil) {
        self.message = message
        self.traceId = traceId
    }
}
