import XCTest
@testable import Domain

final class LoadLocationAddressUseCaseTests: XCTestCase {
    private func makeSUT() -> (MockCountryRepository, DefaultLoadLocationAddressUseCase) {
        let mockRepository = MockCountryRepository()
        let sut = DefaultLoadLocationAddressUseCase(countryRepo: mockRepository)
        return (mockRepository, sut)
    }

    private func makeLocationAddress() -> LocationAddress {
        LocationAddress(
            address: "서울특별시 중구 세종대로",
            city: "서울",
            countryCode: "KR"
        )
    }

    func test_좌표정상_주소반환() async throws {
        let (mockRepository, sut) = makeSUT()
        let expected = makeLocationAddress()
        mockRepository.stubLocationAddress = expected

        let result = try await sut.execute(latitude: 37.5665, longitude: 126.9780)

        XCTAssertEqual(result.address, expected.address)
        XCTAssertEqual(result.city, expected.city)
        XCTAssertEqual(result.countryCode, expected.countryCode)
        XCTAssertEqual(mockRepository.loadAddressCallCount, 1)
        XCTAssertEqual(mockRepository.lastLoadAddressLatitude, 37.5665)
        XCTAssertEqual(mockRepository.lastLoadAddressLongitude, 126.9780)
    }

    func test_주소조회실패_에러전파() async {
        let (mockRepository, sut) = makeSUT()
        mockRepository.loadAddressError = CountryError.serverError

        do {
            _ = try await sut.execute(latitude: 0, longitude: 0)
            XCTFail("에러가 발생해야 합니다")
        } catch {
            XCTAssertEqual(error as? CountryError, .serverError)
        }

        XCTAssertEqual(mockRepository.loadAddressCallCount, 1)
        XCTAssertEqual(mockRepository.lastLoadAddressLatitude, 0)
        XCTAssertEqual(mockRepository.lastLoadAddressLongitude, 0)
    }

    func test_다른좌표_저장소전달() async throws {
        let (mockRepository, sut) = makeSUT()
        mockRepository.stubLocationAddress = makeLocationAddress()

        _ = try await sut.execute(latitude: 35.6762, longitude: 139.6503)

        XCTAssertEqual(mockRepository.lastLoadAddressLatitude, 35.6762)
        XCTAssertEqual(mockRepository.lastLoadAddressLongitude, 139.6503)
    }
}
