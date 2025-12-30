import Kingfisher

public final class ImageCacheConfiguration {
    public static let shared = ImageCacheConfiguration()

    private init() {}

    public func setup() {
        let cache = ImageCache.default

        // 메모리: 100MB
        cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024

        // 디스크: 500MB
        cache.diskStorage.config.sizeLimit = 500 * 1024 * 1024

        // 만료: 7일
        cache.diskStorage.config.expiration = .days(7)

        // 앱 시작 시 오래된 캐시 정리
        cache.cleanExpiredDiskCache()
    }
}
