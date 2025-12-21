import KakaoSDKUser

public final class KakaoOAuthService: OAuthService {
    private let appKey: String

    public init(appKey: String) {
        self.appKey = appKey
    }

    @MainActor
    public func login() async throws -> String {
        try await withCheckedThrowingContinuation { cont in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { token, error in
                    if let error {
                        cont.resume(throwing: OAuthServiceError.sdkError(error))
                        return
                    }

                    cont.resume(returning: token?.accessToken ?? "")
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { token, error in
                    if let error {
                        cont.resume(throwing: OAuthServiceError.sdkError(error))
                        return
                    }

                    cont.resume(returning: token?.accessToken ?? "")
                }
            }
        }
    }
}
