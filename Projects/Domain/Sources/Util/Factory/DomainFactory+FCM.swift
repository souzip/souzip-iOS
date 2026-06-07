public protocol DomainFCMFactory: AnyObject {
    func makeFCMRepository() -> FCMRepository
    func makeRegisterFCMTokenUseCase() -> RegisterFCMTokenUseCase
    func makeDeactivateFCMTokenUseCase() -> DeactivateFCMTokenUseCase
}

public extension DefaultDomainFactory {
    func makeFCMRepository() -> FCMRepository {
        factory.makeFCMRepository()
    }

    func makeRegisterFCMTokenUseCase() -> RegisterFCMTokenUseCase {
        DefaultRegisterFCMTokenUseCase(fcmRepository: makeFCMRepository())
    }

    func makeDeactivateFCMTokenUseCase() -> DeactivateFCMTokenUseCase {
        DefaultDeactivateFCMTokenUseCase(fcmRepository: makeFCMRepository())
    }
}
