import Domain

struct NoticeDetailState {
    var detail: NoticeDetail?
}

enum NoticeDetailAction {
    case viewDidLoad
    case back
}

enum NoticeDetailEvent {
    case loading(Bool)
    case showAlert(message: String)
}
