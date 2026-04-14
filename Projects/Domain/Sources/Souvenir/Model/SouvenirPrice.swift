/// 기념품 상세의 가격 표현(현지 금액·통화·원화 환산). Mapper에서 API `price` 블록을 해석해 조립한다.
public struct SouvenirPrice: Equatable {
    public let localAmount: Int?
    public let localCurrencySymbol: String?
    public let krwAmount: Int?

    public init(
        localAmount: Int?,
        localCurrencySymbol: String?,
        krwAmount: Int?
    ) {
        self.localAmount = localAmount
        self.localCurrencySymbol = localCurrencySymbol
        self.krwAmount = krwAmount
    }
}
