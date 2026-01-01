import UIKit

final class CategoryPickerViewController: BaseViewController<
    CategoryPickerViewModel,
    CategoryPickerView
> {
    // MARK: - Bind

    override func bindState() {
        observe(\.items)
            .distinct()
            .onNext(contentView.render(items:))

        observe(\.canComplete)
            .distinct()
            .onNext(contentView.render(canComplete:))
    }
}
