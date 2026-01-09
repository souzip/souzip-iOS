import SnapKit
import UIKit

final class SplashView: BaseView<SplashAction> {
    // MARK: - UI

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsLogoSouzip
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .dsBackground
    }

    override func setHierarchy() {
        addSubview(logoImageView)
    }

    override func setConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(108)
        }
    }
}
