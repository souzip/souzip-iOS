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
    private var isTabBarHidden = false

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

    func setTabBarHidden(_ hidden: Bool, animated: Bool = true) {
        guard isTabBarHidden != hidden else { return }
        isTabBarHidden = hidden

        if animated {
            animateTabBar(hidden: hidden)
        } else {
            applyTabBarState(hidden: hidden)
        }
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

        // ✅ 제약조건 수정: tabBarView.snp.top 기준으로 설정
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

    // MARK: - Private Animation

    private func animateTabBar(hidden: Bool) {
        if hidden {
            // 아래로 슬라이드하며 사라지기
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: [.curveEaseInOut],
                animations: {
                    let tabBarHeight = self.tabBarView.frame.height
                    self.tabBarView.transform = CGAffineTransform(
                        translationX: 0,
                        y: tabBarHeight
                    )
                    self.tabBarView.alpha = 0

                    // ✅ 컨텐츠 뷰도 함께 확장
                    self.updateContentConstraints(tabBarHidden: hidden)
                    self.view.layoutIfNeeded()
                },
                completion: { _ in
                    self.tabBarView.isHidden = true
                }
            )
        } else {
            // 위로 슬라이드하며 나타나기
            tabBarView.isHidden = false

            // ✅ 컨텐츠 뷰 제약조건 먼저 업데이트
            updateContentConstraints(tabBarHidden: hidden)

            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: [.curveEaseInOut],
                animations: {
                    self.tabBarView.transform = .identity
                    self.tabBarView.alpha = 1
                    self.view.layoutIfNeeded()
                }
            )
        }
    }

    private func applyTabBarState(hidden: Bool) {
        tabBarView.isHidden = hidden
        tabBarView.alpha = hidden ? 0 : 1

        if hidden {
            let tabBarHeight = tabBarView.frame.height
            tabBarView.transform = CGAffineTransform(translationX: 0, y: tabBarHeight)
        } else {
            tabBarView.transform = .identity
        }

        updateContentConstraints(tabBarHidden: hidden)
    }

    // ✅ 컨텐츠 제약조건 업데이트 메서드 추가
    private func updateContentConstraints(tabBarHidden: Bool) {
        guard let currentVC else { return }

        currentVC.view.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()

            if tabBarHidden {
                // 탭바 숨김: 화면 끝까지 확장
                make.bottom.equalToSuperview()
            } else {
                // 탭바 표시: 탭바 위까지
                make.bottom.equalTo(tabBarView.snp.top)
            }
        }
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
