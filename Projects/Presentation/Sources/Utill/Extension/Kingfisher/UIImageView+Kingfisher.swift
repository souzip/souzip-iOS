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
                .cacheSerializer(FormatIndicatedCacheSerializer.png),
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
                .diskCacheExpiration(.days(30)),
                .transition(.fade(0.2)),
            ]
        )
    }

    // 상세 이미지
    func setDetailImage(_ urlString: String?) {
        guard let url = urlString, let imageURL = URL(string: url) else { return }

        kf.setImage(
            with: imageURL,
            options: [
                .processor(DownsamplingImageProcessor(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))),
                .scaleFactor(UIScreen.main.scale),
                .diskCacheExpiration(.days(3)),
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
                .memoryCacheExpiration(.seconds(300)),
                .diskCacheExpiration(.seconds(3600)),
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
                .processor(DownsamplingImageProcessor(size: bounds.size)),
                .diskCacheExpiration(.never),
                .transition(.fade(0.2)),
            ]
        )
    }
}
