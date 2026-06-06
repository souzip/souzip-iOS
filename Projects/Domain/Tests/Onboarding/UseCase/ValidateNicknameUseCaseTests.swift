import XCTest
@testable import Domain

final class ValidateNicknameUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockOnboardingRepository, DefaultValidateNicknameUseCase) {
        let mockRepository = MockOnboardingRepository()
        let sut = DefaultValidateNicknameUseCase(onboardingRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_허용되지않은문자_유효하지않음결과() async throws {
        let (mockRepository, sut) = makeSUT()

        let result = try await sut.execute("test!")

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.nickname, "test!")
        guard case let .invalid(_, error) = result else {
            XCTFail("invalid 결과가 예상됩니다")
            return
        }
        guard case .invalidCharacters = error else {
            XCTFail("invalidCharacters 에러가 예상됩니다")
            return
        }
        XCTAssertEqual(mockRepository.checkNicknameCallCount, 0)
    }

    func test_비속어포함_유효하지않음결과() async throws {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubBadWords = ["badword"]

        let result = try await sut.execute("BadWord")

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.nickname, "BadWord")
        guard case let .invalid(_, error) = result else {
            XCTFail("invalid 결과가 예상됩니다")
            return
        }
        guard case .profanity = error else {
            XCTFail("profanity 에러가 예상됩니다")
            return
        }
        XCTAssertEqual(mockRepository.fetchBadWordsCallCount, 1)
        XCTAssertEqual(mockRepository.checkNicknameCallCount, 0)
    }

    func test_최소길이미만_유효하지않음결과() async throws {
        let (mockRepository, sut) = makeSUT()

        let result = try await sut.execute("a")

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.nickname, "a")
        guard case let .invalid(_, error) = result else {
            XCTFail("invalid 결과가 예상됩니다")
            return
        }
        guard case let .tooShort(min) = error else {
            XCTFail("tooShort 에러가 예상됩니다")
            return
        }
        XCTAssertEqual(min, sut.policy.minLength)
        XCTAssertEqual(mockRepository.checkNicknameCallCount, 0)
    }

    func test_최대길이초과_절단후유효결과() async throws {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubCheckNicknameResult = true

        let result = try await sut.execute("abcdefghijkl")

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.nickname, "abcdefghijk")
        XCTAssertEqual(mockRepository.checkNicknameCallCount, 1)
        XCTAssertEqual(mockRepository.lastCheckedNickname, "abcdefghijk")
    }

    func test_유효한닉네임중복_유효하지않음결과() async throws {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubCheckNicknameResult = false

        let result = try await sut.execute("tester")

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.nickname, "tester")
        guard case let .invalid(_, error) = result else {
            XCTFail("invalid 결과가 예상됩니다")
            return
        }
        guard case .duplicated = error else {
            XCTFail("duplicated 에러가 예상됩니다")
            return
        }
        XCTAssertEqual(mockRepository.checkNicknameCallCount, 1)
        XCTAssertEqual(mockRepository.lastCheckedNickname, "tester")
    }

    func test_유효한닉네임사용가능_유효결과() async throws {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubCheckNicknameResult = true

        let result = try await sut.execute("수집러")

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(result.nickname, "수집러")
        XCTAssertNil(result.nicknameErrorMessage)
        XCTAssertEqual(mockRepository.checkNicknameCallCount, 1)
        XCTAssertEqual(mockRepository.lastCheckedNickname, "수집러")
    }

    func test_닉네임확인실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.checkNicknameError = MockOnboardingError.failed

        do {
            _ = try await sut.execute("tester")
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockOnboardingError, .failed)
        }

        XCTAssertEqual(mockRepository.checkNicknameCallCount, 1)
        XCTAssertEqual(mockRepository.lastCheckedNickname, "tester")
    }
}
