import KakaoSDKCommon

public struct OAuthConfiguration {
    public let kakaoAppKey: String
    public let googleClientID: String
    public let appleServiceID: String

    public init(
        kakaoAppKey: String,
        googleClientID: String,
        appleServiceID: String
    ) {
        self.kakaoAppKey = kakaoAppKey
        self.googleClientID = googleClientID
        self.appleServiceID = appleServiceID
        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }
}
