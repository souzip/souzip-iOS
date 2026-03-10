import Networking

public protocol NoticeRemoteDataSource {
    func getNotices() async throws -> [NoticeResponse]
    func getNotice(id: Int) async throws -> NoticeResponse
}

public final class DefaultNoticeRemoteDataSource: NoticeRemoteDataSource {
    private let plain: NetworkClient

    public init(plain: NetworkClient) {
        self.plain = plain
    }

    public func getNotices() async throws -> [NoticeResponse] {
        let endpoint = NoticeEndpoint.getNotices
        let response: APIResponse<[NoticeResponse]> = try await plain.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }

        return data
    }

    public func getNotice(id: Int) async throws -> NoticeResponse {
        let endpoint = NoticeEndpoint.getNotice(id: id)
        let response: APIResponse<NoticeResponse> = try await plain.request(endpoint)

        guard let data = response.data else {
            throw NetworkError.noData
        }

        return data
    }
}
