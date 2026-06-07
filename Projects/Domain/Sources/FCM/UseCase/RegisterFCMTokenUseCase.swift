public protocol RegisterFCMTokenUseCase {
    func execute(registration: FCMRegistration) async throws
}

public final class DefaultRegisterFCMTokenUseCase: RegisterFCMTokenUseCase {
    private let fcmRepository: FCMRepository

    public init(fcmRepository: FCMRepository) {
        self.fcmRepository = fcmRepository
    }

    public func execute(registration: FCMRegistration) async throws {
        try await fcmRepository.register(registration)
    }
}
