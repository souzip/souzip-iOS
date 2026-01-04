final class DiscoveryViewController: BaseViewController<
    DiscoveryViewModel,
    DiscoveryView
> {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action.accept(.viewDidLoad)
    }

    // MARK: - Bind

    override func bindState() {
        observeState()
            .map(\.sectionModels)
            .onNext(contentView.render)
    }

    // MARK: - Event

    override func handleEvent(_ event: Event) {
        switch event {
        case let .showErrorAlert(message):
            showDSAlert(message: message)
        }
    }
}
