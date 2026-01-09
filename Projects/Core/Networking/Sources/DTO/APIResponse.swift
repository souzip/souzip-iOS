public struct APIResponse<T: Decodable>: Decodable {
    public let data: T?
    public let message: String
}
