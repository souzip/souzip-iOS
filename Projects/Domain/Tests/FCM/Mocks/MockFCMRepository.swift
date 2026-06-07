import Foundation
@testable import Domain

final class MockFCMRepository: FCMRepository {
    var registerError: Error?
    var deactivateError: Error?

    private(set) var registerCallCount = 0
    private(set) var lastRegistration: FCMRegistration?
    private(set) var deactivateCallCount = 0

    func register(_ registration: FCMRegistration) async throws {
        registerCallCount += 1
        lastRegistration = registration

        if let registerError {
            throw registerError
        }
    }

    func deactivate() async throws {
        deactivateCallCount += 1

        if let deactivateError {
            throw deactivateError
        }
    }
}

enum MockFCMError: Error {
    case failed
}
