import Domain
import Foundation

/// 발견·추천·지도 시트 그리드 등 동일 카드 UI에서 쓰는 행 모델.
public struct SouvenirFeedCardItem: Hashable {
    public let id: Int
    public let imageURL: String
    public let title: String
    public let categoryTitle: String
    public let isWishlisted: Bool?
    public let listSlotID: String

    public init(
        id: Int,
        imageURL: String,
        title: String,
        categoryTitle: String,
        isWishlisted: Bool?,
        listSlotID: String
    ) {
        self.id = id
        self.imageURL = imageURL
        self.title = title
        self.categoryTitle = categoryTitle
        self.isWishlisted = isWishlisted
        self.listSlotID = listSlotID
    }

    /// Intent에서 `listSlotID`를 붙이기 전 ViewModel이 채우는 자리 표시 값.
    public static let pendingListSlotID = ""

    public static let globeListSlotID = "globe-sheet-grid"

    public init(catalogSouvenir: CatalogSouvenir, listSlotID: String = Self.pendingListSlotID) {
        self.init(
            id: catalogSouvenir.id,
            imageURL: catalogSouvenir.thumbnailUrl,
            title: catalogSouvenir.name,
            categoryTitle: catalogSouvenir.category.title,
            isWishlisted: catalogSouvenir.isWishlisted,
            listSlotID: listSlotID
        )
    }

    public init(listItem: SouvenirListItem) {
        self.init(
            id: listItem.id,
            imageURL: listItem.thumbnail,
            title: listItem.name,
            categoryTitle: listItem.category.title,
            isWishlisted: listItem.isWishlisted,
            listSlotID: Self.globeListSlotID
        )
    }

    public func withListSlotID(_ listSlotID: String) -> SouvenirFeedCardItem {
        SouvenirFeedCardItem(
            id: id,
            imageURL: imageURL,
            title: title,
            categoryTitle: categoryTitle,
            isWishlisted: isWishlisted,
            listSlotID: listSlotID
        )
    }
}

public enum SouvenirFeedCardListSlot: String {
    case discoveryCountry = "discovery-country"
    case discoveryCategory = "discovery-category"
    case recommendPreferred = "recommend-preferred"
    case recommendUpload = "recommend-upload"
}
