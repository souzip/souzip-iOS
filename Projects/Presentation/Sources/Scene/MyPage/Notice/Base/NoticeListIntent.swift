import Domain

struct NoticeListState {
    var notices: [Notice] = []
}

enum NoticeListAction {
    case viewDidLoad
    case back
    case tapNotice(id: Int)
}

enum NoticeListEvent {
    case loading(Bool)
    case showAlert(message: String)
}
