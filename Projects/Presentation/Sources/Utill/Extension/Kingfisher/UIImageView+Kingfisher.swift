import Kingfisher
import UIKit

extension UIImageView {
    // 피드/목록 이미지
    func setFeedImage(_ urlString: String?) {
        guard let url = urlString, let imageURL = URL(string: url) else { return }

        kf.setImage(
            with: imageURL,
            options: [
                .processor(DownsamplingImageProcessor(size: bounds.size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage, // 여러 크기로 재사용
                .transition(.fade(0.2)),
            ]
        )
    }

    // 프로필 이미지
    func setProfileImage(_ urlString: String?) {
        guard let url = urlString, let imageURL = URL(string: url) else { return }

        kf.setImage(
            with: imageURL,
            options: [
                .processor(
                    DownsamplingImageProcessor(size: bounds.size)
                        |> RoundCornerImageProcessor(cornerRadius: bounds.width / 2)
                ),
                .cacheOriginalImage,
                .diskCacheExpiration(.days(30)), // 오래 캐싱
                .transition(.fade(0.2)),
            ]
        )
    }

    // 상세 이미지 (큰 용량, 자주 안 봄)
    func setDetailImage(_ urlString: String?) {
        guard let url = urlString, let imageURL = URL(string: url) else { return }

        kf.setImage(
            with: imageURL,
            options: [
                .cacheOriginalImage,
                .diskCacheExpiration(.days(3)), // 짧게 캐싱
                .transition(.fade(0.2)),
            ]
        )
    }

    // 임시/일회성 이미지
    func setTemporaryImage(_ urlString: String?) {
        guard let url = urlString, let imageURL = URL(string: url) else { return }

        kf.setImage(
            with: imageURL,
            options: [
                .processor(DownsamplingImageProcessor(size: bounds.size)),
                .memoryCacheExpiration(.seconds(300)), // 메모리만 5분
                .diskCacheExpiration(.seconds(3600)), // 디스크 1시간
                .transition(.fade(0.2)),
            ]
        )
    }

    // 정적 에셋
    func setStaticAsset(_ urlString: String?) {
        guard let url = urlString, let imageURL = URL(string: url) else { return }

        kf.setImage(
            with: imageURL,
            options: [
                .cacheOriginalImage,
                .diskCacheExpiration(.never), // 영구 보관
                .transition(.fade(0.2)),
            ]
        )
    }
}
