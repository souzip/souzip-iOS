public protocol DomainSouvenirFactory: AnyObject {
    func makeSouvenirRepository() -> SouvenirRepository
}

public extension DefaultDomainFactory {
    func makeSouvenirRepository() -> SouvenirRepository {
        factory.makeSouvenirRepository()
    }
}
