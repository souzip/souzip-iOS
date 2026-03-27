import Domain

final class NoticeListViewModel: BaseViewModel<
    NoticeListState,
    NoticeListAction,
    NoticeListEvent,
    MyPageRoute
> {
    private let noticeRepo: NoticeRepository

    init(noticeRepo: NoticeRepository) {
        self.noticeRepo = noticeRepo
        super.init(initialState: State())
    }

    override func handleAction(_ action: Action) {
        switch action {
        case .viewDidLoad:
            Task {
                emit(.loading(true))
                await fetchNotices()
                emit(.loading(false))
            }

        case .back:
            navigate(to: .pop)

        case let .tapNotice(id):
            navigate(to: .noticeDetail(id))
        }
    }
}

// MARK: - Private

private extension NoticeListViewModel {
    func fetchNotices() async {
        do {
            let notices = try await noticeRepo.getNotices()
            mutate { $0.notices = notices }
        } catch {
            emit(.showAlert(message: error.localizedDescription))
        }
    }
}
