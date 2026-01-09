public struct SouvenirFile: Hashable {
    public let id: Int
    public let url: String
    public let originalName: String
    public let displayOrder: Int

    public init(
        id: Int,
        url: String,
        originalName: String,
        displayOrder: Int
    ) {
        self.id = id
        self.url = url
        self.originalName = originalName
        self.displayOrder = displayOrder
    }
}
