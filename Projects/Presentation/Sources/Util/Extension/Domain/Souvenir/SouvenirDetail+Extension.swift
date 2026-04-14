import Domain

extension SouvenirDetail {
    var formattedLocalPrice: String? {
        guard let local = price.localAmount, let symbol = price.localCurrencySymbol else { return nil }
        return "\(local.formatted())\(symbol)"
    }

    var formattedKrwPrice: String? {
        guard let krw = price.krwAmount else { return nil }
        return "\(krw.formatted())원"
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
