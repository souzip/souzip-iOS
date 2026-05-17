final class MyPageLikedTabViewModel: BaseViewModel<
    MyPageLikedTabState,
    MyPageLikedTabAction,
    MyPageLikedTabEvent,
    MyPageRoute
> {
    init() {
        super.init(initialState: MyPageLikedTabState())
    }

    override func handleAction(_ action: Action) {
        switch action {
        case .noop:
            break
        }
    }
}
