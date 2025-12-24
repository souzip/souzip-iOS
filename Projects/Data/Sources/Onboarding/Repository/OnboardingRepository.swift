import Domain
import Networking

public final class DefaultOnboardingRepository: OnboardingRepository {
    private let onboardingRemote: OnboardingRemoteDataSource
    private let onboardingLocal: OnboardingLocalDataSource
    private let userLocal: UserLocalDataSource

    public init(
        onboardingRemote: OnboardingRemoteDataSource,
        onboardingLocal: OnboardingLocalDataSource,
        userLocal: UserLocalDataSource
    ) {
        self.onboardingRemote = onboardingRemote
        self.onboardingLocal = onboardingLocal
        self.userLocal = userLocal
    }

    // MARK: - Save

    public func saveMarketingConsent(_ isAgreed: Bool) {
        onboardingLocal.saveMarketingConsent(isAgreed)
    }

    public func saveNickname(_ nickname: String) {
        onboardingLocal.saveNickname(nickname)
    }

    public func saveProfileImageColor(_ color: ProfileImageType) {
        let colorString = OnboardingDTOMapper.toDTO(color)
        onboardingLocal.saveProfileImageColor(colorString)
    }

    public func saveCategories(_ categories: [SouvenirCategory]) {
        let dtos = categories.map { category in
            let categoryString = OnboardingDTOMapper.toDTO(category)
            return OnboardingCategoryDTO(value: categoryString)
        }
        onboardingLocal.saveCategories(dtos)
    }

    // MARK: - Complete Onboarding

    public func completeOnboarding() async throws -> LoginUser {
        do {
            guard let temporaryData = onboardingLocal.getTemporaryData() else {
                throw OnboardingError.incompleteData
            }

            let dto = try await onboardingRemote.completeOnboarding(temporaryData)

            userLocal.saveUserId(dto.userId)
            userLocal.saveUserNickname(dto.nickname)
            userLocal.saveNeedsOnboarding(false)

            onboardingLocal.clearTemporaryData()

            return OnboardingDTOMapper.toDomain(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }

    // MARK: - Check Nickname

    public func checkNickname(_ nickname: String) async throws -> Bool {
        do {
            let dto = try await onboardingRemote.checkNickname(nickname)
            return dto.available
        } catch {
            throw mapToDomainError(error)
        }
    }
}

// MARK: - Error Mapper

private extension DefaultOnboardingRepository {
    func mapToDomainError(_ error: Error) -> OnboardingError {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .noData, .invalidURL, .unknown,
                 .serverError, .unauthorized,
                 .encodingError, .decodingError:
                return .networkFailed
            }
        }

        return .networkFailed
    }
}
