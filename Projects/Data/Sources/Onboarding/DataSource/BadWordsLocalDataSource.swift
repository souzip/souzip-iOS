public protocol BadWordsLocalDataSource {
    func fetchBadWords() -> Set<String>
}

public final class DefaultBadWordsLocalDataSource: BadWordsLocalDataSource {
    private let cachedBadWords: Set<String>

    public init() {
        do {
            cachedBadWords = try JSONLoader.load(filename: "bad_words")
        } catch {
            fatalError("Failed to load bad_words.json from bundle: \(error)")
        }
    }

    public func fetchBadWords() -> Set<String> {
        cachedBadWords
    }
}
