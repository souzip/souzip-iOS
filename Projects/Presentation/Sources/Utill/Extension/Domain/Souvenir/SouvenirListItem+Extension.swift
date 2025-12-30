import Domain

extension SouvenirListItem {
    var formattedLocalPrice: String {
        "\(localPrice.formatted())\(currencySymbol)"
    }

    var formattedKrwPrice: String {
        "\(krwPrice.formatted())원"
    }
}
