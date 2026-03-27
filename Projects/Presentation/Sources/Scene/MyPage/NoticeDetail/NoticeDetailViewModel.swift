import Domain

final class NoticeDetailViewModel: BaseViewModel<
    NoticeDetailState,
    NoticeDetailAction,
    NoticeDetailEvent,
    MyPageRoute
> {
    private let noticeRepo: NoticeRepository
    private let noticeID: Int

    init(noticeRepo: NoticeRepository, noticeID: Int) {
        self.noticeRepo = noticeRepo
        self.noticeID = noticeID
        super.init(initialState: State())
    }

    override func handleAction(_ action: Action) {
        switch action {
        case .viewDidLoad:
            Task {
                emit(.loading(true))
                await fetchDetail()
                emit(.loading(false))
            }

        case .back:
            navigate(to: .pop)
        }
    }
}

// MARK: - Private

private extension NoticeDetailViewModel {
    func fetchDetail() async {
        do {
            let detail = try await noticeRepo.getNotice(id: noticeID)
            mutate { $0.detail = detail }
        } catch {
            emit(.showAlert(message: error.localizedDescription))
        }
    }
}
