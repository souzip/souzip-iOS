import UIKit

public final class CommonNavigationController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        isNavigationBarHidden = true
        interactivePopGestureRecognizer?.delegate = self
    }
}

extension CommonNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
