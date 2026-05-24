import XCTest
@testable import Domain

final class MockUserRepository: UserRepository {
    var getUserProfileResult: UserProfile = DomainTestFixtures.userProfile
    var getUserSouvenirsResult: UserSouvenirListPage = DomainTestFixtures.emptyUserSouvenirListPage
    var getLocalUserResult: LoginUser?
    var getHasVisitedMyPageResult = false

    private(set) var getUserProfileCallCount = 0
    private(set) var getUserSouvenirsCallCount = 0
    private(set) var lastSouvenirsPage: Int?
    private(set) var lastSouvenirsSize: Int?
    private(set) var markMyPageVisitedCallCount = 0

    func getUserProfile() async throws -> UserProfile {
        getUserProfileCallCount += 1
        return getUserProfileResult
    }

    func getUserSouvenirs(page: Int, size: Int) async throws -> UserSouvenirListPage {
        getUserSouvenirsCallCount += 1
        lastSouvenirsPage = page
        lastSouvenirsSize = size
        return getUserSouvenirsResult
    }

    func getLocalUser() -> LoginUser? {
        getLocalUserResult
    }

    func saveLocalUser(userId: String, nickname: String, needsOnboarding: Bool) {
        XCTFail("unexpected saveLocalUser")
    }

    func deleteLocalUser() {
        XCTFail("unexpected deleteLocalUser")
    }

    func getHasVisitedMyPage() -> Bool {
        getHasVisitedMyPageResult
    }

    func markMyPageVisited() {
        markMyPageVisitedCallCount += 1
    }
}
