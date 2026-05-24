import Foundation
@testable import Domain

enum DomainTestFixtures {
    static let coordinate = Coordinate(latitude: 37.5, longitude: 127.0)

    static let loginUser = LoginUser(
        userId: "user-1",
        nickname: "테스트",
        needsOnboarding: false
    )

    static let loginUserNeedsOnboarding = LoginUser(
        userId: "user-2",
        nickname: "신규",
        needsOnboarding: true
    )

    static let countryDetail = CountryDetail(
        nameEnglish: "Korea",
        nameKorean: "대한민국",
        code: "KR",
        region: CountryRegion(englishName: "Asia", koreanName: "아시아"),
        capital: "Seoul",
        flagImageURL: "https://example.com/kr.png",
        coordinate: coordinate,
        currency: CurrencyInfo(code: "KRW", symbol: "₩")
    )

    static let locationAddress = LocationAddress(
        address: "서울시 중구",
        city: "서울",
        countryCode: "KR"
    )

    static let notice = Notice(id: 1, title: "공지", createdAt: Date(timeIntervalSince1970: 0))

    static let noticeDetail = NoticeDetail(
        id: 1,
        title: "공지",
        content: "본문",
        createdAt: Date(timeIntervalSince1970: 0),
        imageURLs: []
    )

    static let catalogSouvenir = CatalogSouvenir(
        id: 1,
        name: "기념품",
        category: .snack,
        countryCode: "KR",
        thumbnailUrl: "https://example.com/t.png"
    )

    static let countryTopSouvenir = CountryTopSouvenir(
        countryCode: "KR",
        countryNameKr: "대한민국",
        souvenirCount: 1,
        souvenirs: [catalogSouvenir]
    )

    static let userProfile = UserProfile(
        userId: "user-1",
        nickname: "테스트",
        email: "test@example.com",
        profileImageUrl: "https://example.com/p.png"
    )

    static let wishlistMutation = WishlistMutationResult(
        souvenirId: 10,
        isWishlisted: true
    )

    static var souvenirDetail: SouvenirDetail {
        SouvenirDetail(
            id: 1,
            name: "기념품",
            price: SouvenirPrice(localAmount: 1000, localCurrencySymbol: "₩", krwAmount: 1000),
            description: "설명",
            location: SouvenirLocation(
                address: "주소",
                locationDetail: nil,
                coordinate: coordinate
            ),
            category: .snack,
            purpose: .personal,
            countryCode: "KR",
            isOwned: true,
            owner: SouvenirOwner(nickname: "owner", profileImageUrl: nil),
            files: [
                SouvenirFile(id: 1, url: "https://example.com/f.png", originalName: "f.png", displayOrder: 0),
            ]
        )
    }

    static var souvenirListItem: SouvenirListItem {
        SouvenirListItem(
            id: 1,
            name: "기념품",
            category: .snack,
            purpose: .personal,
            localPrice: 1000,
            krwPrice: 1000,
            currencySymbol: "₩",
            thumbnail: "https://example.com/t.png",
            coordinate: coordinate,
            address: "주소"
        )
    }

    static var souvenirInput: SouvenirInput {
        SouvenirInput(
            name: "새 기념품",
            description: "설명",
            address: "주소",
            coordinate: coordinate,
            category: .snack,
            purpose: .personal,
            countryCode: "KR"
        )
    }

    static var emptyUserSouvenirListPage: UserSouvenirListPage {
        UserSouvenirListPage(
            items: [],
            currentPage: 0,
            totalPages: 0,
            totalItems: 0,
            pageSize: 20,
            hasNext: false,
            hasPrevious: false
        )
    }

    static var citySearchHit: LocationSearchHit {
        .city(
            CitySearchHit(
                id: LocationSearchHitID(rawValue: "city-1"),
                title: "서울",
                countryLine: "대한민국",
                coordinate: coordinate
            )
        )
    }
}
