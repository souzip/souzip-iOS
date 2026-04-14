import Domain

final class NoticeDetailViewModel: BaseViewModel<
    NoticeDetailState,
    NoticeDetailAction,
    NoticeDetailEvent,
    MyPageRoute
> {
    private let loadNoticeDetail: LoadNoticeDetailUseCase
    private let noticeID: Int

    init(loadNoticeDetail: LoadNoticeDetailUseCase, noticeID: Int) {
        self.loadNoticeDetail = loadNoticeDetail
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
            let detail = try await loadNoticeDetail.execute(id: noticeID)
            mutate { $0.detail = detail }
        } catch {
            emit(.showAlert(message: error.localizedDescription))
        }
    }
}
