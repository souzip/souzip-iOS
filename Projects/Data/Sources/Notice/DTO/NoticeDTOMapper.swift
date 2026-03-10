import Domain

public enum NoticeDTOMapper {
    public static func toNoticeDomain(_ dto: NoticeResponse) -> Notice {
        Notice(
            id: dto.id,
            title: dto.title,
            createdAt: dto.createdAt
        )
    }

    public static func toNoticeDetailDomain(_ dto: NoticeResponse) -> NoticeDetail {
        NoticeDetail(
            id: dto.id,
            title: dto.title,
            content: dto.content,
            createdAt: dto.createdAt,
            imageURLs: dto.files
                .sorted { $0.displayOrder < $1.displayOrder }
                .map(\.url)
        )
    }
}
