import Domain
import Networking

public final class DefaultNoticeRepository: NoticeRepository {
    private let noticeRemote: NoticeRemoteDataSource

    public init(noticeRemote: NoticeRemoteDataSource) {
        self.noticeRemote = noticeRemote
    }

    public func getNotices() async throws -> [Notice] {
        do {
            let dtos = try await noticeRemote.getNotices()
            return dtos.map { NoticeDTOMapper.toNoticeDomain($0) }
        } catch {
            throw mapToDomainError(error)
        }
    }

    public func getNotice(id: Int) async throws -> NoticeDetail {
        do {
            let dto = try await noticeRemote.getNotice(id: id)
            return NoticeDTOMapper.toNoticeDetailDomain(dto)
        } catch {
            throw mapToDomainError(error)
        }
    }
}

// MARK: - Private

private extension DefaultNoticeRepository {
    func mapToDomainError(_ error: Error) -> NoticeError {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .serverError:
                return .serverError
            case .noData:
                return .notFound
            case .unauthorized, .invalidURL, .invalidResponse,
                 .invalidEndpointType, .unknown, .encodingError, .decodingError:
                return .networkError
            }
        }
        return .unknown
    }
}
