import KakaoSDKCommon

public struct OAuthConfiguration {
    public let kakaoAppKey: String
    public let googleClientID: String

    public init(
        kakaoAppKey: String,
        googleClientID: String,
    ) {
        self.kakaoAppKey = kakaoAppKey
        self.googleClientID = googleClientID

        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }
}
