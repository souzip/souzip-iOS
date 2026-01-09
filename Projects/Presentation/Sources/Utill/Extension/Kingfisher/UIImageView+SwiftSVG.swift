import Kingfisher
import SwiftSVG
import UIKit

extension UIImageView {
    func setSVG(
        _ urlString: String?,
        svgSize: CGSize = CGSize(width: 36, height: 40)
    ) {
        guard let urlString, let url = URL(string: urlString) else { return }

        if urlString.lowercased().hasSuffix(".svg") {
            // 기존 svg 제거
            subviews.filter { $0.tag == 987_654 }.forEach { $0.removeFromSuperview() }

            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self, let data, error == nil else { return }

                DispatchQueue.main.async {
                    // ✅ Data로 SVGView 생성 + svgSize에 맞춰 aspectFit (잘림 방지)
                    let svgView = UIView(SVGData: data) { svgLayer in
                        svgLayer.resizeToFit(CGRect(origin: .zero, size: svgSize))
                    }

                    svgView.tag = 987_654
                    svgView.backgroundColor = .clear
                    svgView.isUserInteractionEnabled = false

                    self.addSubview(svgView)
                    svgView.translatesAutoresizingMaskIntoConstraints = false

                    NSLayoutConstraint.activate([
                        svgView.widthAnchor.constraint(equalToConstant: svgSize.width),
                        svgView.heightAnchor.constraint(equalToConstant: svgSize.height),
                        svgView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                        svgView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    ])
                }
            }.resume()

            return
        }

        // svg 아니면 기존 Kingfisher 그대로
        kf.setImage(
            with: url,
            options: [
                .processor(
                    DownsamplingImageProcessor(size: bounds.size)
                        |> RoundCornerImageProcessor(cornerRadius: bounds.width / 2)
                ),
                .cacheOriginalImage,
                .diskCacheExpiration(.days(30)),
                .transition(.fade(0.2)),
            ]
        )
    }
}
