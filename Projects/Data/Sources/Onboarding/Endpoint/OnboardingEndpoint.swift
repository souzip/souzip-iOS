import Foundation
import Networking

public enum OnboardingEndpoint {
    case checkNickname(nickname: String)
    case completeOnboarding(request: CompleteOnboardingRequest)
}

extension OnboardingEndpoint: APIEndpoint {
    public var path: String {
        switch self {
        case .checkNickname:
            "/api/users/check-nickname"
        case .completeOnboarding:
            "/api/users/onboarding"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .checkNickname, .completeOnboarding:
            .post
        }
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    public var body: Data? {
        switch self {
        case let .checkNickname(nickname):
            let request = CheckNicknameRequest(nickname: nickname)
            return try? JSONEncoder().encode(request)

        case let .completeOnboarding(request):
            return try? JSONEncoder().encode(request)
        }
    }
}
