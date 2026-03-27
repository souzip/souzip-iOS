import Networking

public enum NoticeEndpoint {
    case getNotices
    case getNotice(id: Int)
}

extension NoticeEndpoint: APIEndpoint {
    public var path: String {
        switch self {
        case .getNotices:
            "/api/notices"
        case let .getNotice(id):
            "/api/notices/\(id)"
        }
    }

    public var method: HTTPMethod {
        .get
    }
}
