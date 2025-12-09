import Data
import Domain

final class DefaultDomainFactory: DomainFactory {
    private let factory: DataFactory

    init(factory: DataFactory) {
        self.factory = factory
    }
}
