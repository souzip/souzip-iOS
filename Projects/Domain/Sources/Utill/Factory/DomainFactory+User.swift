public protocol DomainUserFactory: AnyObject {
    func makeUserRepository() -> UserRepository
}

public extension DefaultDomainFactory {
    func makeUserRepository() -> UserRepository {
        factory.makeUserRepository()
    }
}
