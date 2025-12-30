import UIKit

public final class CommonNavigationController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
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

extension CommonNavigationController: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        // 부모 뷰 계층에서 CommonTabbarController 찾기
        var parent = navigationController.parent
        while parent != nil {
            if let tabBarController = parent as? CommonTabbarController {
                // hidesBottomBarWhenPushed 값에 따라 탭바 숨김/표시
                let shouldHideTabBar = viewController.hidesBottomBarWhenPushed
                tabBarController.setTabBarHidden(shouldHideTabBar, animated: animated)
                break
            }
            parent = parent?.parent
        }
    }
}
