import XCTest
@testable import Domain

final class LogoutUseCaseTests: XCTestCase {
    private struct SUT {
        let authRepository: MockAuthRepository
        let fcmRepository: MockFCMRepository
        let useCase: DefaultLogoutUseCase
    }

    private func makeSUT() -> SUT {
        let authRepository = MockAuthRepository()
        let fcmRepository = MockFCMRepository()
        let useCase = DefaultLogoutUseCase(
            authRepo: authRepository,
            deactivateFCMToken: DefaultDeactivateFCMTokenUseCase(fcmRepository: fcmRepository)
        )
        return SUT(
            authRepository: authRepository,
            fcmRepository: fcmRepository,
            useCase: useCase
        )
    }

    func test_정상호출_FCM비활성화후로그아웃() async throws {
        let sut = makeSUT()

        try await sut.useCase.execute()

        XCTAssertEqual(sut.fcmRepository.deactivateCallCount, 1)
        XCTAssertEqual(sut.authRepository.logoutCallCount, 1)
    }

    func test_FCM비활성화실패_로그아웃은진행() async throws {
        let sut = makeSUT()
        sut.fcmRepository.deactivateError = MockFCMError.failed

        try await sut.useCase.execute()

        XCTAssertEqual(sut.fcmRepository.deactivateCallCount, 1)
        XCTAssertEqual(sut.authRepository.logoutCallCount, 1)
    }

    func test_로그아웃실패_에러전파() async {
        let sut = makeSUT()
        sut.authRepository.logoutError = MockAuthError.failed

        do {
            try await sut.useCase.execute()
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockAuthError, .failed)
        }

        XCTAssertEqual(sut.fcmRepository.deactivateCallCount, 1)
        XCTAssertEqual(sut.authRepository.logoutCallCount, 1)
    }
}
