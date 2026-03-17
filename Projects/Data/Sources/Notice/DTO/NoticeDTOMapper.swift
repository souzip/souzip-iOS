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
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        // 서버가 UTC 시간을 timezone suffix 없이 반환 → "Z" 추가
        let utcString = isoString.hasSuffix("Z") ? isoString : isoString + "Z"
        return formatter.date(from: utcString) ?? Date()
    }
}
