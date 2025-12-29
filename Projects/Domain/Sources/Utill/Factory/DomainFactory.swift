public protocol DomainFactory:
    AnyObject,
    DomainAuthFactory,
    DomainOnboardingFactory,
    DomainCountryFactory {}

public final class DefaultDomainFactory: DomainFactory {
    let factory: DataFactory

    public init(factory: DataFactory) {
        self.factory = factory
    }
}
