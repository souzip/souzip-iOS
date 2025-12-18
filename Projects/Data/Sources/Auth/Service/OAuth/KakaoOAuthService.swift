import Foundation

public final class KakaoOAuthService: OAuthService {
    private let appKey: String

    public init(appKey: String) {
        self.appKey = appKey
    }

    public func login() async throws -> String {
        // TODO: KakaoSDK 사용
        // 1. KakaoSDK.initSDK(appKey: appKey)
        // 2. 카카오톡 설치 여부 확인
        //    - 설치됨: 카카오톡으로 로그인
        //    - 미설치: 웹 로그인
        // 3. Access Token 반환

        fatalError("KakaoSDK 구현 필요")
    }
}
