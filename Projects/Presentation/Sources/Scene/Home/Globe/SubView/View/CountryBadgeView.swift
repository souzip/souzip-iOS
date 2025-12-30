import DesignSystem
import Kingfisher
import SnapKit
import UIKit

final class CountryBadgeView: UIView {
    // MARK: - UI

    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()

    private let countryLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.setTypography(.body3M)
        return label
    }()

    // MARK: - Init

    init(
        countryName: String,
        color: UIColor,
        imageURL: String
    ) {
        super.init(frame: .zero)
        configure()
        render(name: countryName, color: color)
        render(urlString: imageURL)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func render(name: String, color: UIColor) {
        countryLabel.text = name

        backgroundColor = color.withAlphaComponent(0.47)
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 18
    }

    private func render(urlString: String) {
        flagImageView.setStaticAsset(urlString)
    }
}

// MARK: - UI Configuration

private extension CountryBadgeView {
    func configure() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        [
            countryLabel,
            flagImageView,
        ].forEach(addSubview)
    }

    func setConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(36)
        }

        flagImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        countryLabel.snp.makeConstraints {
            $0.leading.equalTo(flagImageView.snp.trailing).offset(7)
            $0.trailing.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
        }
    }
}
