import XCTest
@testable import Domain

final class ValidateNicknameUseCaseTests: XCTestCase {
    func test_최소길이미만_너무짧음반환() async throws {
        let mockRepo = MockOnboardingRepository()
        let sut = DefaultValidateNicknameUseCase(onboardingRepo: mockRepo)
        let result = try await sut.execute("a")

        guard case let .invalid(nickname, .tooShort(min)) = result else {
            XCTFail("expected tooShort, got \(result)")
            return
        }
        XCTAssertEqual(min, 2)
        XCTAssertEqual(nickname, "a")
        XCTAssertEqual(mockRepo.checkNicknameCallCount, 0)
    }

    func test_허용되지않은문자_잘못된문자반환() async throws {
        let mockRepo = MockOnboardingRepository()
        mockRepo.badWords = []
        let sut = DefaultValidateNicknameUseCase(onboardingRepo: mockRepo)
        let result = try await sut.execute("ab@")

        guard case .invalid(_, .invalidCharacters) = result else {
            XCTFail("expected invalidCharacters, got \(result)")
            return
        }
        XCTAssertEqual(mockRepo.checkNicknameCallCount, 0)
    }

    func test_비속어포함_비속어에러반환() async throws {
        let mockRepo = MockOnboardingRepository()
        mockRepo.badWords = ["bad"]
        let sut = DefaultValidateNicknameUseCase(onboardingRepo: mockRepo)
        let result = try await sut.execute("bad")

        guard case .invalid(_, .profanity) = result else {
            XCTFail("expected profanity, got \(result)")
            return
        }
        XCTAssertEqual(mockRepo.checkNicknameCallCount, 0)
    }

    func test_유효닉네임_사용가능성공반환() async throws {
        let mockRepo = MockOnboardingRepository()
        mockRepo.checkNicknameResult = true
        let sut = DefaultValidateNicknameUseCase(onboardingRepo: mockRepo)
        let result = try await sut.execute("ab")

        guard case let .valid(nickname) = result else {
            XCTFail("expected valid, got \(result)")
            return
        }
        XCTAssertEqual(nickname, "ab")
        XCTAssertEqual(mockRepo.checkNicknameCallCount, 1)
    }

    func test_유효닉네임_중복에러반환() async throws {
        let mockRepo = MockOnboardingRepository()
        mockRepo.checkNicknameResult = false
        let sut = DefaultValidateNicknameUseCase(onboardingRepo: mockRepo)
        let result = try await sut.execute("validnick")

        guard case .invalid(_, .duplicated) = result else {
            XCTFail("expected duplicated, got \(result)")
            return
        }
        XCTAssertEqual(mockRepo.checkNicknameCallCount, 1)
    }

    func test_최대길이초과_잘린뒤성공반환() async throws {
        let mockRepo = MockOnboardingRepository()
        mockRepo.checkNicknameResult = true
        let sut = DefaultValidateNicknameUseCase(onboardingRepo: mockRepo)
        let long = String(repeating: "a", count: 15)
        let result = try await sut.execute(long)

        guard case let .valid(nickname) = result else {
            XCTFail("expected valid after truncate, got \(result)")
            return
        }
        XCTAssertEqual(nickname.count, 11)
        XCTAssertEqual(mockRepo.checkNicknameCallCount, 1)
    }

    func test_한글숫자혼합_성공반환() async throws {
        let mockRepo = MockOnboardingRepository()
        mockRepo.checkNicknameResult = true
        let sut = DefaultValidateNicknameUseCase(onboardingRepo: mockRepo)
        let result = try await sut.execute("한글12")

        guard case let .valid(nickname) = result else {
            XCTFail("expected valid, got \(result)")
            return
        }
        XCTAssertEqual(nickname, "한글12")
        XCTAssertEqual(mockRepo.checkNicknameCallCount, 1)
    }
}
