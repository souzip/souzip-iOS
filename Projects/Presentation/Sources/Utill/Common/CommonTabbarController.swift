import DesignSystem
import SnapKit
import UIKit

final class CommonTabbarController: UIViewController {
    // MARK: - UI

    private let tabBarView = DSTabBarView()

    // MARK: - Callbacks

    var onTabTapped: ((TabRoute) -> Void)?

    // MARK: - State

    private var currentVC: UIViewController?

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Internal Methods

    func setTabs(_ items: [DSTabBarItem]) {
        tabBarView.items = items
    }

    func setSelectedIndex(_ index: Int) {
        tabBarView.setSelectedIndex(index)
    }

    func showContent(_ viewController: UIViewController) {
        let prev = currentVC

        addChild(viewController)

        if prev != nil {
            view.insertSubview(viewController.view, belowSubview: tabBarView)
        } else {
            view.addSubview(viewController.view)
            view.bringSubviewToFront(tabBarView)
        }

        viewController.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(tabBarView.snp.top)
        }

        viewController.didMove(toParent: self)
        prev?.willMove(toParent: nil)
        prev?.view.removeFromSuperview()
        prev?.removeFromParent()

        currentVC = viewController
    }
}

// MARK: - UI Configuration

private extension CommonTabbarController {
    func configure() {
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setHierarchy() {
        view.addSubview(tabBarView)
    }

    func setConstraints() {
        tabBarView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func setBindings() {
        tabBarView.onSelect = { [weak self] index in
            guard let route = TabRoute(rawValue: index) else { return }
            self?.onTabTapped?(route)
        }
    }
}
