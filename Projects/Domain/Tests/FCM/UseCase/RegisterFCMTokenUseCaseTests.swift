import XCTest
@testable import Domain

final class RegisterFCMTokenUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockFCMRepository, DefaultRegisterFCMTokenUseCase) {
        let mockRepository = MockFCMRepository()
        let sut = DefaultRegisterFCMTokenUseCase(fcmRepository: mockRepository)
        return (mockRepository, sut)
    }

    private func makeRegistration() -> FCMRegistration {
        FCMRegistration(
            token: "fcm-token",
            deviceId: "device-id",
            deviceType: .ios,
            deviceModel: "iPhone15,2",
            osVersion: "17.0",
            appVersion: "1.2.0"
        )
    }

    func test_정상호출_토큰등록() async throws {
        let (mockRepository, sut) = makeSUT()
        let registration = makeRegistration()

        try await sut.execute(registration: registration)

        XCTAssertEqual(mockRepository.registerCallCount, 1)
        XCTAssertEqual(mockRepository.lastRegistration?.token, registration.token)
        XCTAssertEqual(mockRepository.lastRegistration?.deviceId, registration.deviceId)
    }

    func test_등록실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.registerError = MockFCMError.failed

        do {
            try await sut.execute(registration: makeRegistration())
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockFCMError, .failed)
        }

        XCTAssertEqual(mockRepository.registerCallCount, 1)
    }
}
