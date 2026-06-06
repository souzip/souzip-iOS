import DesignSystem
import SnapKit
import UIKit

final class MyPageView: BaseView<MyPageAction> {
    // MARK: - UI Components

    private let navigationBar = DSNavigationBar(
        title: "마이컬렉션",
        style: .trailingSettings
    )

    private let myPageRootListView = MyPageRootListView()

    private let faButton = DSFAButton(image: .dsIconEditContained)

    private let guestLoginView = GuestLoginView()

    private var didApplyRootListSnapshotOnce = false

    /// 스냅샷 반영 뒤 VC 쪽 후속 작업(페이저 높이 등)을 연결한다.
    var onRootListSnapshotRendered: (() -> Void)?

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .dsBackground
    }

    override func setHierarchy() {
        [
            navigationBar,
            myPageRootListView,
            faButton,
            guestLoginView,
        ].forEach(addSubview)
    }

    override func setConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        myPageRootListView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }

        faButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }

        guestLoginView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    override func setBindings() {
        bind(navigationBar.onRightTap)
            .map { button in
                switch button {
                case .settings: .tapSetting
                default: .tapSetting
                }
            }

        bind(faButton.rx.tap).to(.tapCreateSouvenir)

        bind(guestLoginView.action).to(.tapLogin)
    }

    // MARK: - Public

    func rootListView() -> MyPageRootListView {
        myPageRootListView
    }

    func renderRootList(_ input: (isGuest: Bool, profile: ProfileData?)) {
        renderIsGuest(input.isGuest)
        let animatingDifferences = didApplyRootListSnapshotOnce
        didApplyRootListSnapshotOnce = true
        myPageRootListView.applySnapshot(input, animatingDifferences: animatingDifferences)
        onRootListSnapshotRendered?()
    }

    func renderIsGuest(_ isGuest: Bool) {
        guestLoginView.isHidden = !isGuest

        myPageRootListView.isHidden = isGuest
        faButton.isHidden = isGuest
    }
}
