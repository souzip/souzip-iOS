import Domain
import UIKit

public protocol PresentationFactory: AnyObject {
    func makeLoginVC() -> UIViewController
}

public final class DefaultPresentationFactory: PresentationFactory {
    private let factory: DomainFactory

    public init(factory: DomainFactory) {
        self.factory = factory
    }

    public func makeLoginVC() -> UIViewController {
        UIViewController()
    }
}
