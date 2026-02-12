import DesignSystem
import UIKit

final class MyPageViewController: BaseViewController<
    MyPageViewModel,
    MyPageView
> {
    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action.accept(.viewWillAppear)
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

        observe(\.isGuest)
            .distinct()
            .onNext(contentView.renderIsGuest)
    }

    override func handleEvent(_ event: Event) {
        switch event {
        case let .showErrorAlert(message):
            showDSAlert(message: message)
        }
    }
}
