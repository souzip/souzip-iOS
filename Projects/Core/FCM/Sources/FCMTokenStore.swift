import Foundation

actor FCMTokenStore {
    private var token: String?
    private var streamContinuations: [UUID: AsyncStream<String>.Continuation] = [:]

    func currentToken() -> String? {
        token
    }

    func registerStream(
        id: UUID,
        continuation: AsyncStream<String>.Continuation
    ) {
        streamContinuations[id] = continuation

        if let token {
            continuation.yield(token)
        }
    }

    func unregisterStream(id: UUID) {
        streamContinuations.removeValue(forKey: id)
    }

    func updateToken(_ newToken: String) -> Bool {
        guard token != newToken else { return false }

        token = newToken
        streamContinuations.values.forEach { $0.yield(newToken) }

        return true
    }
}
