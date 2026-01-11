import Foundation
import Kingfisher
import Logger
import UIKit

public final class ImageCacheConfiguration {
    public static let shared = ImageCacheConfiguration()

    private init() {}

    public func setup() {
        let cache = ImageCache.default

        // 메모리: 100MB
        cache.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024

        // 디스크: 500MB
        cache.diskStorage.config.sizeLimit = 500 * 1024 * 1024

        // 기본 만료: 7일
        cache.diskStorage.config.expiration = .days(7)

        // 앱 시작 시 만료된 캐시 정리
        cleanExpiredCache()

        // 초기 캐시 크기 확인
        logCacheSize()

        // 백그라운드 전환 시 만료된 캐시 정리
        setupBackgroundCleanup()

        // 메모리 경고 시 메모리 캐시 비우기
        setupMemoryWarning()
    }

    private func cleanExpiredCache() {
        ImageCache.default.cleanExpiredDiskCache {
            Logger.shared.debug("만료된 디스크 캐시 정리 완료", category: .cache)
        }
    }

    private func logCacheSize() {
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case let .success(size):
                let mb = Double(size) / 1024 / 1024
                Logger.shared.info(
                    "현재 디스크 캐시 크기: \(String(format: "%.2f", mb))MB",
                    category: .cache
                )
            case let .failure(error):
                Logger.shared.error(
                    "캐시 크기 확인 실패: \(error.localizedDescription)",
                    category: .cache
                )
            }
        }
    }

    private func setupMemoryWarning() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            ImageCache.default.clearMemoryCache()
            Logger.shared.warning("메모리 경고 - 메모리 캐시 전체 삭제", category: .cache)
            self?.logCacheSize()
        }
    }

    private func setupBackgroundCleanup() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Logger.shared.debug("백그라운드 전환 - 만료된 캐시 정리 시작", category: .cache)
            self?.cleanExpiredCache()
        }
    }
}
