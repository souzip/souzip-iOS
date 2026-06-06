import XCTest
@testable import Domain

final class LoadUserSouvenirsUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockUserRepository, DefaultLoadUserSouvenirsUseCase) {
        let mockRepository = MockUserRepository()
        let sut = DefaultLoadUserSouvenirsUseCase(userRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_기념품목록조회성공_페이지반환() async throws {
        let (mockRepository, sut) = makeSUT()
        let expectedPage = UserSouvenirListPage(
            items: [
                CollectedSouvenirSummary(
                    id: 1,
                    thumbnailUrl: "https://example.com/thumb.png",
                    country: "일본",
                    createdAt: "2024-01-01",
                    updatedAt: "2024-01-02",
                    wishlistCount: 3,
                    isWishlisted: true
                ),
            ],
            currentPage: 1,
            totalPages: 2,
            totalItems: 10,
            pageSize: 5,
            hasNext: true,
            hasPrevious: false
        )
        mockRepository.stubUserSouvenirListPage = expectedPage

        let result = try await sut.execute(page: 1, size: 5)

        XCTAssertEqual(result, expectedPage)
        XCTAssertEqual(mockRepository.getUserSouvenirsCallCount, 1)
    }

    func test_페이지파라미터전달_리포지토리호출() async throws {
        let (mockRepository, sut) = makeSUT()

        _ = try await sut.execute(page: 3, size: 15)

        XCTAssertEqual(mockRepository.lastGetUserSouvenirsPage, 3)
        XCTAssertEqual(mockRepository.lastGetUserSouvenirsSize, 15)
        XCTAssertEqual(mockRepository.getUserSouvenirsCallCount, 1)
    }

    func test_기념품목록조회실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.getUserSouvenirsError = MockUserError.failed

        do {
            _ = try await sut.execute(page: 0, size: 20)
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? MockUserError, .failed)
        }

        XCTAssertEqual(mockRepository.getUserSouvenirsCallCount, 1)
        XCTAssertEqual(mockRepository.lastGetUserSouvenirsPage, 0)
        XCTAssertEqual(mockRepository.lastGetUserSouvenirsSize, 20)
    }
}
