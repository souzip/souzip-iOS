/// 탐색·랭킹·추천 등 **카탈로그** 맥락의 기념품 한 줄 요약. 수집 컨텍스트의 `SouvenirDetail`과 동일 개념이 아니다.
/// `SouvenirCategory` 등 분류는 Souvenir·Discovery가 공유한다(공유 커널).
///
/// - Note: `thumbnailUrl`은 API 응답 필드에 가깝다. **진실 소스는 첨부가 아닌 이 응답 한 줄**이므로, 수집 상세의 `SouvenirDetail.files`와 혼동하지 않는다.
public struct CatalogSouvenir: Equatable {
    public let id: Int
    public let name: String
    public let category: SouvenirCategory
    public let countryCode: String
    public let thumbnailUrl: String

    public init(
        id: Int,
        name: String,
        category: SouvenirCategory,
        countryCode: String,
        thumbnailUrl: String
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.countryCode = countryCode
        self.thumbnailUrl = thumbnailUrl
    }
}
