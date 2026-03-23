public protocol DomainDiscoveryFactory: AnyObject {
    func makeDiscoveryRepository() -> DiscoveryRepository
}

public extension DefaultDomainFactory {
    func makeDiscoveryRepository() -> DiscoveryRepository {
        factory.makeDiscoveryRepository()
    }
}
