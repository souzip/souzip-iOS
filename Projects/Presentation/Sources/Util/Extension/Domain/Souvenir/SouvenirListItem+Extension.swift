import Domain

extension SouvenirListItem {
    /// 리스트·캐러셀도 상세와 동일: **통화 기호 왼쪽**, 공백 후 금액 (`SouvenirDetail+Extension`과 규칙 공유).
    var formattedLocalPrice: String? {
        guard let localPrice, let currencySymbol else { return nil }
        return "\(currencySymbol) \(localPrice.formatted())"
    }

    var formattedKrwPrice: String? {
        guard let krwPrice else { return nil }
        return "\(krwPrice.formatted())원"
    }

    var displayPrice: String {
        if let formatted = formattedKrwPrice {
            formatted
        } else if let formatted = formattedLocalPrice {
            formatted
        } else {
            "가격 정보 없음"
        }
    }

    func withIsWishlisted(_ isWishlisted: Bool?) -> SouvenirListItem {
        SouvenirListItem(
            id: id,
            name: name,
            category: category,
            purpose: purpose,
            localPrice: localPrice,
            krwPrice: krwPrice,
            currencySymbol: currencySymbol,
            thumbnail: thumbnail,
            coordinate: coordinate,
            address: address,
            wishlistCount: wishlistCount,
            isWishlisted: isWishlisted
        )
    }
}
