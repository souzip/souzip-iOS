public struct SouvenirDetail {
    public let id: Int
    public let name: String
    public let price: SouvenirPrice
    public let description: String
    public let location: SouvenirLocation
    public let category: SouvenirCategory
    public let purpose: SouvenirPurpose
    public let countryCode: String
    /// 로그인 사용자 기준 이 기념품 소유 여부(API `isOwned`).
    public let isOwned: Bool
    /// 닉네임·프로필 등 **표시용** 작성자 정보. `isOwned`와의 비즈니스 규칙은 UseCase·도메인 서비스에서 조합한다.
    public let owner: SouvenirOwner
    public let files: [SouvenirFile]

    public init(
        id: Int,
        name: String,
        price: SouvenirPrice,
        description: String,
        location: SouvenirLocation,
        category: SouvenirCategory,
        purpose: SouvenirPurpose,
        countryCode: String,
        isOwned: Bool,
        owner: SouvenirOwner,
        files: [SouvenirFile]
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.description = description
        self.location = location
        self.category = category
        self.purpose = purpose
        self.countryCode = countryCode
        self.isOwned = isOwned
        self.owner = owner
        self.files = files
    }

    /// 대표 이미지 URL. **진실 소스는 첨부 `files` 순서**이며, 본 값은 첫 파일 URL에 대한 파생이다.
    public var thumbnailUrl: String? {
        files.first?.url
    }

    public var imageUrls: [String] {
        files.map(\.url)
    }
}
