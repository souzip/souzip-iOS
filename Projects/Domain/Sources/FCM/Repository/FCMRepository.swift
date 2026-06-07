public protocol FCMRepository {
    func register(_ registration: FCMRegistration) async throws
    func deactivate() async throws
}
