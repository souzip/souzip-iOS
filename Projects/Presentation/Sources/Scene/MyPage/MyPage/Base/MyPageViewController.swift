import DesignSystem
import UIKit

final class MyPageViewController: BaseViewController<
    MyPageViewModel,
    MyPageView
> {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action.accept(.viewDidLoad)
    }

    // MARK: - Bind

    override func bindState() {
        observe(\.profile)
            .unwrapped()
            .distinct()
            .onNext(contentView.renderProfile)

        observe(\.selectedTab)
            .distinct()
            .onNext(contentView.renderSeagment)

        observe(\.visibleContent)
            .distinct()
            .onNext(contentView.renderVisibleContent)

        observe(\.collectionData)
            .distinct()
            .onNext(contentView.renderCollection)
    }
}
