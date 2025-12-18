import Foundation

public final class AppleOAuthService: OAuthService {
    private let serviceID: String

    public init(serviceID: String) {
        self.serviceID = serviceID
    }

    public func login() async throws -> String {
        // TODO: AuthenticationServices 사용
        // 1. ASAuthorizationAppleIDProvider() 생성
        // 2. ASAuthorizationAppleIDRequest 설정
        // 3. ASAuthorizationController 실행
        // 4. ID Token 반환

        fatalError("Sign in with Apple 구현 필요")
    }
}
