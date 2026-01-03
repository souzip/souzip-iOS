import Domain

enum SouvenirDetailAction {
    case back
    case edit
    case delete
    case etc

    case tapCopy
    case confirmDelete
}

struct SouvenirDetailState {
    var souvenirId: Int?
    var detail: SouvenirDetail?
}

enum SouvenirDetailEvent {
    case showAlert(message: String)
    case showDeleteAlert
    case showReport
    case loading(Bool)
}
