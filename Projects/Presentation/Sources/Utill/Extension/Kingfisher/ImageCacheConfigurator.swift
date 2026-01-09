import Foundation
import Kingfisher
import UIKit

public final class ImageCacheConfiguration {
    public static let shared = ImageCacheConfiguration()

    private init() {}

    public func setup() {
        let cache = ImageCache.default

        // 메모리: 100MB
        cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024

        // 디스크: 500MB
        cache.diskStorage.config.sizeLimit = 300 * 1024 * 1024

        // 만료: 7일
        cache.diskStorage.config.expiration = .days(7)

        // 앱 시작 시 오래된 캐시 정리
        cache.cleanExpiredDiskCache()
        setupMemoryWarning()
    }

    private func setupMemoryWarning() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { _ in
            ImageCache.default.clearMemoryCache()
        }
    }
}
