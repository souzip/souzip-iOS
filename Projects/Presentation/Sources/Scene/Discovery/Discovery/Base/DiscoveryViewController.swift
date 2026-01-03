final class DiscoveryViewController: BaseViewController<
    DiscoveryViewModel,
    DiscoveryView
> {
    // MARK: - Bind

    override func bindState() {
        observeState()
            .map { ($0.data, $0.isCategoryExpanded) }
            .onNext(contentView.render)
    }

    // MARK: - Event

    override func handleEvent(_ event: Event) {}
}
