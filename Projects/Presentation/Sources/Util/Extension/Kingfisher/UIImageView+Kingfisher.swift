import Kingfisher
import Logger
import UIKit

extension UIImageView {
    // 피드/목록 이미지
    func setFeedImage(_ urlString: String?) {
        guard let url = urlString, let imageURL = URL(string: url) else {
            return
        }

        layoutIfNeeded()

        let cacheKey = extractCacheKey(from: imageURL)

        let source = Source.network(KF.ImageResource(
            downloadURL: imageURL,
            cacheKey: cacheKey
        ))

        kf.setImage(
            with: source,
            options: [
                .processor(DownsamplingImageProcessor(size: downsampleSize)),
                .scaleFactor(UIScreen.main.scale),
                .diskCacheExpiration(.days(7)),
                .transition(.fade(0.2)),
                .cacheOriginalImage,
            ]
        )
    }

    func setMyFeedImage(_ urlString: String?) {
        guard let url = urlString, let imageURL = URL(string: url) else {
            return
        }

        layoutIfNeeded()

        let cacheKey = extractCacheKey(from: imageURL)

        let source = Source.network(KF.ImageResource(
            downloadURL: imageURL,
            cacheKey: cacheKey
        ))

        kf.setImage(
            with: source,
            options: [
                .processor(DownsamplingImageProcessor(size: downsampleSize)),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2)),
                .diskCacheExpiration(.days(30)),
                .cacheOriginalImage,
            ]
        )
    }

    // 상세 이미지
    func setDetailImage(_ urlString: String?) {
        guard let url = urlString, let imageURL = URL(string: url) else {
            return
        }

        layoutIfNeeded()

        let cacheKey = extractCacheKey(from: imageURL)

        let source = Source.network(KF.ImageResource(
            downloadURL: imageURL,
            cacheKey: cacheKey
        ))

        kf.setImage(
            with: source,
            options: [
                .processor(DownsamplingImageProcessor(size: downsampleSize)),
                .scaleFactor(UIScreen.main.scale),
                .diskCacheExpiration(.days(3)),
                .transition(.fade(0.2)),
                .cacheOriginalImage,
            ]
        )
    }

    // 정적 에셋
    func setStaticAsset(_ urlString: String?) {
        guard let url = urlString, let imageURL = URL(string: url) else {
            return
        }

        layoutIfNeeded()

        kf.setImage(
            with: imageURL,
            options: [
                .processor(DownsamplingImageProcessor(size: downsampleSize)),
                .scaleFactor(UIScreen.main.scale),
                .diskCacheExpiration(.never),
                .transition(.fade(0.2)),
                .cacheOriginalImage,
            ]
        )
    }

    // MARK: - Private Helpers

    private var downsampleSize: CGSize {
        bounds.size != .zero ? bounds.size : CGSize(width: 400, height: 400)
    }

    private func extractCacheKey(from url: URL) -> String {
        url.absoluteString.components(separatedBy: "?").first ?? url.absoluteString
    }
}
