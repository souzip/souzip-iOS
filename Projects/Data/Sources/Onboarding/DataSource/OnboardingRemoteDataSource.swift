import Foundation
import Networking

public protocol OnboardingRemoteDataSource {
    func checkNickname(_ nickname: String) async throws -> NicknameCheckResponse
    func completeOnboarding(_ data: OnboardingTemporaryData) async throws -> CompleteOnboardingResponse
}

public final class DefaultOnboardingRemoteDataSource: OnboardingRemoteDataSource {
    private let networkClient: NetworkClient

    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    public func checkNickname(_ nickname: String) async throws -> NicknameCheckResponse {
        let endpoint = OnboardingEndpoint.checkNickname(nickname: nickname)
        let response: APIResponse<NicknameCheckResponse> = try await networkClient.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }

        return data
    }

    public func completeOnboarding(_ data: OnboardingTemporaryData) async throws -> CompleteOnboardingResponse {
        let categories = data.categories.map(\.value)

        let request = CompleteOnboardingRequest(
            ageVerified: true,
            serviceTerms: true,
            privacyRequired: true,
            locationService: true,
            marketingConsent: data.marketingConsent,
            nickname: data.nickname,
            profileImageColor: data.profileImageColor,
            categories: categories
        )

        let endpoint = OnboardingEndpoint.completeOnboarding(request: request)
        let response: APIResponse<CompleteOnboardingResponse> = try await networkClient.request(endpoint)

        guard let responseData = response.data else {
            throw NetworkError.noData
        }

        return responseData
    }
}
