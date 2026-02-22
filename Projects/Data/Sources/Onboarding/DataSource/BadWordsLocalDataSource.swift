public protocol BadWordsLocalDataSource {
    func fetchBadWords() throws -> Set<String>
}

public final class DefaultBadWordsLocalDataSource: BadWordsLocalDataSource {
    private var cachedBadWords: Set<String>?

    public init() {}

    public func fetchBadWords() throws -> Set<String> {
        if let cached = cachedBadWords { return cached }

        let words: Set<String> = try JSONLoader.load(filename: "bad_words")
        cachedBadWords = words
        return words
    }
}
