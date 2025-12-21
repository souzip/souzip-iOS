import AuthenticationServices
import UIKit

public final class AppleOAuthService: NSObject, OAuthService {
    private var continuation: CheckedContinuation<String, Error>?

    override public init() {}

    @MainActor
    public func login() async throws -> String {
        guard continuation == nil else {
            throw OAuthServiceError.cancelled
        }

        return try await withCheckedThrowingContinuation { cont in
            continuation = cont

            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleOAuthService: ASAuthorizationControllerDelegate {
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            finish(.failure(OAuthServiceError.unknown(NSError(domain: "InvalidCredential", code: -1))))
            return
        }

        guard let tokenData = credential.identityToken,
              let idToken = String(data: tokenData, encoding: .utf8),
              !idToken.isEmpty else {
            finish(.failure(OAuthServiceError.unknown(NSError(domain: "MissingIdentityToken", code: -2))))
            return
        }

        finish(.success(idToken))
    }

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        if let authError = error as? ASAuthorizationError, authError.code == .canceled {
            finish(.failure(OAuthServiceError.cancelled))
            return
        }

        if error is ASAuthorizationError {
            finish(.failure(OAuthServiceError.sdkError(error)))
        } else {
            finish(.failure(OAuthServiceError.unknown(error)))
        }
    }

    private func finish(_ result: Result<String, Error>) {
        guard let cont = continuation else { return }
        continuation = nil

        switch result {
        case let .success(code):
            cont.resume(returning: code)
        case let .failure(error):
            cont.resume(throwing: error)
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AppleOAuthService: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}
