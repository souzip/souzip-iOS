import Domain
import Foundation

public enum NoticeDTOMapper {
    public static func toNoticeDomain(_ dto: NoticeResponse) -> Notice {
        Notice(
            id: dto.id,
            title: dto.title,
            createdAt: parseDate(dto.createdAt)
        )
    }

    public static func toNoticeDetailDomain(_ dto: NoticeResponse) -> NoticeDetail {
        NoticeDetail(
            id: dto.id,
            title: dto.title,
            content: dto.content,
            createdAt: parseDate(dto.createdAt),
            imageURLs: dto.files
                .sorted { $0.displayOrder < $1.displayOrder }
                .map(\.url)
        )
    }
}

// MARK: - Private

private extension NoticeDTOMapper {
    static func parseDate(_ isoString: String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: String(isoString.prefix(19))) ?? Date()
    }
}
