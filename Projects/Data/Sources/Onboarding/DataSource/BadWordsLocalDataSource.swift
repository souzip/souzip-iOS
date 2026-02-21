import Foundation

public protocol BadWordsLocalDataSource {
    func fetchBadWords() -> Set<String>
}

public final class DefaultBadWordsLocalDataSource: BadWordsLocalDataSource {
    private var cachedBadWords: Set<String>?

    public init() {}

    public func fetchBadWords() -> Set<String> {
        if let cached = cachedBadWords { return cached }

        let words = loadFromBundle()
        cachedBadWords = words
        return words
    }

    // MARK: - Private

    private func loadFromBundle() -> Set<String> {
        guard let url = Bundle.module.url(forResource: "bad_words", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let words = try? JSONDecoder().decode([String].self, from: data)
        else { return [] }

        return Set(words.map { $0.lowercased() })
    }
}
