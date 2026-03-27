import Foundation

public protocol OAuthServiceFactory {
    func makeOAuthServices() -> [OAuthPlatform: OAuthService]
}

public final class DefaultOAuthServiceFactory: OAuthServiceFactory {
    private let configuration: OAuthConfiguration

    public init(configuration: OAuthConfiguration) {
        self.configuration = configuration
    }

    public func makeOAuthServices() -> [OAuthPlatform: OAuthService] {
        [
            .kakao: KakaoOAuthService(appKey: configuration.kakaoAppKey),
            .google: GoogleOAuthService(clientID: configuration.googleClientID),
            .apple: AppleOAuthService(),
        ]
    }
}
