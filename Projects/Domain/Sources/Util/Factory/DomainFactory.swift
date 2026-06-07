public protocol DomainFactory:
    AnyObject,
    DomainAuthFactory,
    DomainOnboardingFactory,
    DomainCountryFactory,
    DomainSouvenirFactory,
    DomainDiscoveryFactory,
    DomainUserFactory,
    DomainNoticeFactory,
    DomainWishlistFactory,
    DomainFCMFactory {}

public final class DefaultDomainFactory: DomainFactory {
    let factory: DataFactory

    public init(factory: DataFactory) {
        self.factory = factory
    }
}
