import XCTest
@testable import Domain

final class SaveCategoriesUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockOnboardingRepository, DefaultSaveCategoriesUseCase) {
        let mockRepository = MockOnboardingRepository()
        let sut = DefaultSaveCategoriesUseCase(onboardingRepo: mockRepository)
        return (mockRepository, sut)
    }

    func test_카테고리전달_저장호출() {
        let (mockRepository, sut) = makeSUT()
        let categories: [SouvenirCategory] = [.snack, .fashion, .travel]

        sut.execute(categories: categories)

        XCTAssertEqual(mockRepository.saveCategoriesCallCount, 1)
        XCTAssertEqual(mockRepository.lastCategories, categories)
    }

    func test_빈카테고리_저장호출() {
        let (mockRepository, sut) = makeSUT()

        sut.execute(categories: [])

        XCTAssertEqual(mockRepository.saveCategoriesCallCount, 1)
        XCTAssertEqual(mockRepository.lastCategories, [])
    }
}
