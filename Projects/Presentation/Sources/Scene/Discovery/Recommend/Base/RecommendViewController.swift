final class RecommendViewController: BaseViewController<
    RecommendViewModel,
    RecommendView
> {
    // MARK: - LIfe Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action.accept(.viewDidLoad)
    }

    // MARK: - Bind

    override func bindState() {
        observe(\.sectionModels)
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
