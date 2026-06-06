import Foundation
@testable import Domain

final class MockUserRepository: UserRepository {
    var stubUserProfile = UserProfile(
        userId: "user-1",
        nickname: "tester",
        email: "tester@example.com",
        profileImageUrl: "https://example.com/profile.png"
    )
    var stubUserSouvenirListPage = UserSouvenirListPage(
        items: [],
        currentPage: 0,
        totalPages: 1,
        totalItems: 0,
        pageSize: 20,
        hasNext: false,
        hasPrevious: false
    )
    var stubLocalUser: LoginUser?
    var stubHasVisitedMyPage = false

    var getUserProfileError: Error?
    var getUserSouvenirsError: Error?

    private(set) var getUserProfileCallCount = 0
    private(set) var getUserSouvenirsCallCount = 0
    private(set) var lastGetUserSouvenirsPage: Int?
    private(set) var lastGetUserSouvenirsSize: Int?
    private(set) var getLocalUserCallCount = 0
    private(set) var saveLocalUserCallCount = 0
    private(set) var lastSavedUserId: String?
    private(set) var lastSavedNickname: String?
    private(set) var lastSavedNeedsOnboarding: Bool?
    private(set) var deleteLocalUserCallCount = 0
    private(set) var getHasVisitedMyPageCallCount = 0
    private(set) var markMyPageVisitedCallCount = 0

    func getUserProfile() async throws -> UserProfile {
        getUserProfileCallCount += 1

        if let getUserProfileError {
            throw getUserProfileError
        }

        return stubUserProfile
    }

    func getUserSouvenirs(page: Int, size: Int) async throws -> UserSouvenirListPage {
        getUserSouvenirsCallCount += 1
        lastGetUserSouvenirsPage = page
        lastGetUserSouvenirsSize = size

        if let getUserSouvenirsError {
            throw getUserSouvenirsError
        }

        return stubUserSouvenirListPage
    }

    func getLocalUser() -> LoginUser? {
        getLocalUserCallCount += 1
        return stubLocalUser
    }

    func saveLocalUser(userId: String, nickname: String, needsOnboarding: Bool) {
        saveLocalUserCallCount += 1
        lastSavedUserId = userId
        lastSavedNickname = nickname
        lastSavedNeedsOnboarding = needsOnboarding
    }

    func deleteLocalUser() {
        deleteLocalUserCallCount += 1
    }

    func getHasVisitedMyPage() -> Bool {
        getHasVisitedMyPageCallCount += 1
        return stubHasVisitedMyPage
    }

    func markMyPageVisited() {
        markMyPageVisitedCallCount += 1
    }
}

enum MockUserError: Error {
    case failed
}
