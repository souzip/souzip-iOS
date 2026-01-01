import Domain

extension SouvenirListItem {
    var formattedLocalPrice: String? {
        guard let localPrice, let currencySymbol else { return nil }
        return "\(localPrice.formatted())\(currencySymbol)"
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
}
