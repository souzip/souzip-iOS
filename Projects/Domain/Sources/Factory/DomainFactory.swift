public protocol DomainFactory: AnyObject {}

public final class DefaultDomainFactory: DomainFactory {
    private let factory: DataFactory

    public init(factory: DataFactory) {
        self.factory = factory
    }
}
