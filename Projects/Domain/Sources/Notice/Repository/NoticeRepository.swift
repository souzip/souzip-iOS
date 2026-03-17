public protocol NoticeRepository {
    func getNotices() async throws -> [Notice]
    func getNotice(id: Int) async throws -> NoticeDetail
}
