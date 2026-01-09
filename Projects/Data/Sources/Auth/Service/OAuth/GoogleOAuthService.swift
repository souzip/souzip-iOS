import Foundation

public final class GoogleOAuthService: OAuthService {
    private let clientID: String

    public init(clientID: String) {
        self.clientID = clientID
    }

    public func login() async throws -> String {
        // TODO: GoogleSignIn SDK 사용
        // 1. GIDConfiguration(clientID: clientID) 생성
        // 2. GIDSignIn.sharedInstance.signIn() 호출
        // 3. Access Token 반환

        fatalError("GoogleSignIn SDK 구현 필요")
    }
}
