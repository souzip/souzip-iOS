import Domain

extension SouvenirDetail {
    var formattedLocalPrice: String? {
        guard let localPrice, let currencySymbol else { return nil }
        return "\(localPrice.formatted())\(currencySymbol)"
    }

    var formattedKrwPrice: String? {
        guard let krwPrice else { return nil }
        return "\(krwPrice.formatted())원"
    }

    // 표시용 가격 (원화 우선)
    var displayPrice: String? {
        if let formatted = formattedKrwPrice {
            formatted
        } else if let formatted = formattedLocalPrice {
            formatted
        } else {
            nil
        }
    }
}
