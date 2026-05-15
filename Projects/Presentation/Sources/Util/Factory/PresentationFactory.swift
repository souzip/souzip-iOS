import Domain
import UIKit

protocol PresentationFactory:
    AnyObject,
    PresentationAuthFactory,
    PresentationHomeFactory,
    PresentationSouvenirFactory,
    PresentationMyPageFactory,
    PresentationDiscoveryFactory,
    PresentationTabBarFactory {}

final class DefaultPresentationFactory: PresentationFactory {
    let domainFactory: DomainFactory

    lazy var authSessionStore: AuthSessionStore = .init(
        checkFullAuthentication: domainFactory.makeCheckFullAuthenticationUseCase()
    )

    lazy var userSouvenirInvalidationStore: UserSouvenirInvalidationStore = .init()

    init(domainFactory: DomainFactory) {
        self.domainFactory = domainFactory
    }
}
