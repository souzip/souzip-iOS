public struct SouvenirGroup {
    public let category: SouvenirCategory
    public let souvenirs: [SouvenirListItem]

    public var count: Int {
        souvenirs.count
    }
}
