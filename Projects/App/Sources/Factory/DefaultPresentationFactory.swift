import Domain
import Presentation

final class DefaultPresentationFactory: PresentationFactory {
    private let factory: DomainFactory

    init(factory: DomainFactory) {
        self.factory = factory
    }
}
