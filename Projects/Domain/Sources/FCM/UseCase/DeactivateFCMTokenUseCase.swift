public protocol DeactivateFCMTokenUseCase {
    func execute() async throws
}

public final class DefaultDeactivateFCMTokenUseCase: DeactivateFCMTokenUseCase {
    private let fcmRepository: FCMRepository

    public init(fcmRepository: FCMRepository) {
        self.fcmRepository = fcmRepository
    }

    public func execute() async throws {
        try await fcmRepository.deactivate()
    }
}
