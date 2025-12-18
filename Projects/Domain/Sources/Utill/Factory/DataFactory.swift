public protocol DataFactory: AnyObject {
    func makeAuthRepository() -> AuthRepository
}
