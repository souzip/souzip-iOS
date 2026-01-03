import DesignSystem
import SnapKit
import UIKit

final class MyPageLikedEmptyView: UIView {
    // MARK: - UI Components

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .dsCharacterWaiting
        return imageView
    }()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "아앗...!!!!\n서비스가 아직 준비중이에요"
        label.textColor = .dsGreyWhite
        label.textAlignment = .center
        label.numberOfLines = 2
        label.setTypography(.body2R)
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Configuration

private extension MyPageLikedEmptyView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .clear
    }

    func setHierarchy() {
        addSubview(stackView)

        [
            iconImageView,
            titleLabel,
        ].forEach(stackView.addArrangedSubview)
    }

    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(180)
        }
    }
}
