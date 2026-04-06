import Foundation

public protocol GooglePlaceTypeLocalDataSource {
    func koreanLabel(forAPIValue raw: String?) -> String
}

public final class DefaultGooglePlaceTypeLocalDataSource: GooglePlaceTypeLocalDataSource {
    private let placeTypeToCategoryLabel: [String: String]

    public init() {
        do {
            let groups: [CategoryGroupDTO] = try JSONLoader.load(
                filename: "google_place_type_categories"
            )
            placeTypeToCategoryLabel = Dictionary(
                groups.flatMap { group in
                    group.placeTypes.map { ($0, group.categoryLabel) }
                },
                uniquingKeysWith: { first, _ in first }
            )
        } catch {
            fatalError("Failed to load google_place_type_categories.json from bundle: \(error)")
        }
    }

    public func koreanLabel(forAPIValue raw: String?) -> String {
        let trimmed = raw?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !trimmed.isEmpty else { return "" }
        return placeTypeToCategoryLabel[trimmed.lowercased()] ?? ""
    }
}

private struct CategoryGroupDTO: Decodable {
    let categoryLabel: String
    let placeTypes: [String]
}
