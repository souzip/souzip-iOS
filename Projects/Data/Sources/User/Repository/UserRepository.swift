import Domain
import Networking

public final class DefaultUserRepository: UserRepository {
    private let userRemote: UserRemoteDataSource
    private let userLocal: UserLocalDataSource

    public init(
        userRemote: UserRemoteDataSource,
        userLocal: UserLocalDataSource
    ) {
        self.userRemote = userRemote
        self.userLocal = userLocal
    }

    // MARK: - Remote (API)

    public func getUserProfile() async throws -> UserProfile {
        do {
            let dto = try await userRemote.getUserProfile()
            return UserDTOMapper.toDomain(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func getUserSouvenirs() async throws -> [SouvenirThumbnail] {
        do {
            let request = SouvenirListRequest()
            let dto = try await userRemote.getUserSouvenirs(request: request)
            return UserDTOMapper.toDomain(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }

    // MARK: - Local (UserDefaults)

    public func getLocalUser() -> LoginUser? {
        guard let userDTO = userLocal.getUser() else {
            return nil
        }
        return UserDTOMapper.toDomain(userDTO)
    }

    public func saveLocalUser(userId: String, nickname: String, needsOnboarding: Bool) {
        userLocal.saveUserId(userId)
        userLocal.saveUserNickname(nickname)
        userLocal.saveNeedsOnboarding(needsOnboarding)
    }

    public func deleteLocalUser() {
        userLocal.deleteUser()
    }
}

// MARK: - Mapper

private extension DefaultUserRepository {
    func mapToDomainError(_ error: Error) -> UserError {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .unauthorized:
                return .unauthorized

            case .noData:
                return .noData

            case .invalidURL, .invalidResponse, .invalidEndpointType,
                 .unknown, .serverError, .encodingError, .decodingError:
                return .fetchFailed
            }
        }

        return .fetchFailed
    }
}
