import DesignSystem
import SnapKit
import UIKit

final class MyPageView: BaseView<MyPageAction> {
    // MARK: - UI Components

    private let navigationBar = DSNavigationBar(
        title: "마이컬렉션",
        style: .Settings
    )

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()

    private let contentView = UIView()

    private let headerView = MyPageHeaderView()

    private let segmentView = MyPageSegmentView()

    private let collectionView = MyCollectionView()

    private let collectionEmptyView: MyPageCollectionEmptyView = {
        let view = MyPageCollectionEmptyView()
        view.isHidden = true
        return view
    }()

    private let likedEmptyView: MyPageLikedEmptyView = {
        let view = MyPageLikedEmptyView()
        view.isHidden = true
        return view
    }()

    private let faButton = DSFAButton(image: .dsIconEditContained)

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .dsBackground
    }

    override func setHierarchy() {
        [
            navigationBar,
            scrollView,
            collectionEmptyView,
            likedEmptyView,
            faButton,
        ].forEach(addSubview)

        scrollView.addSubview(contentView)

        [
            headerView,
            segmentView,
            collectionView,
        ].forEach(contentView.addSubview)
    }

    override func setConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        segmentView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }

        collectionEmptyView.snp.makeConstraints { make in
            make.top.equalTo(segmentView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        likedEmptyView.snp.makeConstraints { make in
            make.top.equalTo(segmentView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        faButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
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

        bind(segmentView.action)
            .map { .tapSegmentTab($0) }

        bind(collectionView.action)
            .map { item in
                switch item {
                case let .country(countryItem):
                    .tapCountry(countryItem)
                case let .souvenir(souvenir):
                    .tapSouvenir(souvenir)
                }
            }

        bind(collectionEmptyView.action)
            .map { .tapCreateSouvenir }

        bind(faButton.rx.tap).to(.tapCreateSouvenir)
    }

    // MARK: - Public

    func renderProfile(_ profile: ProfileData) {
        headerView.render(profile)
    }

    func renderSeagment(_ tab: CollectionTab) {
        segmentView.updateUI(for: tab)
    }

    func renderVisibleContent(_ content: MyPageVisibleContent) {
        let allViews = [
            collectionView,
            collectionEmptyView,
            likedEmptyView,
        ]
        allViews.forEach { $0.isHidden = true }

        switch content {
        case .collection:
            collectionView.isHidden = false
        case .collectionEmpty:
            collectionEmptyView.isHidden = false
        case .likedEmpty:
            likedEmptyView.isHidden = false
        }
    }

    func renderCollection(_ data: MyCollectionData) {
        collectionView.render(data: data)
    }
}
