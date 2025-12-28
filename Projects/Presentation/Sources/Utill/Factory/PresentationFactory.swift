import Domain
import UIKit

protocol PresentationFactory:
    AnyObject,
    PresentationAuthFactory,
    PresentationHomeFactory {}

final class DefaultPresentationFactory: PresentationFactory {
    let domainFactory: DomainFactory

    init(domainFactory: DomainFactory) {
        self.domainFactory = domainFactory
    }
}
