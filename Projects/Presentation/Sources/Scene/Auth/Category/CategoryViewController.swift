final class CategoryViewController: BaseViewController<
    CategoryViewModel,
    CategoryView
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

    // MARK: - Event

    override func handleEvent(_ event: Event) {
        switch event {
        case let .showToast(message):
            showToast(message)
        }
    }
}
