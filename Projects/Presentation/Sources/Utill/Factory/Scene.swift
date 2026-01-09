import RxRelay
import RxSwift
import UIKit

public struct RoutedScene<Route> {
    public let vc: UIViewController
    public let route: PublishRelay<Route>
    public let disposeBag: DisposeBag
}
