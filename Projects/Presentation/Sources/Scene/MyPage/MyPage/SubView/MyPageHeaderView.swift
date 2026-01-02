import DesignSystem
import SnapKit
import UIKit

final class MyPageHeaderView: UIView {
    // MARK: - UI Components

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .dsGreyWhite
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        return imageView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private let nicknameLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.setTypography(.body1R)
        return label
    }()

    private let emailLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey300
        label.setTypography(.body4R)
        return label
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

    // MARK: - Setup

    private func setupUI() {}

    // MARK: - Configure

    func render(_ data: ProfileData) {
        profileImageView.setProfileImage(data.profileImageUrl)
        nicknameLabel.text = data.nickname

        if data.email.isEmpty {
            emailLabel.isHidden = true
        } else {
            emailLabel.isHidden = false
            emailLabel.text = data.email
        }
    }
}

// MARK: - UI Configuration

private extension MyPageHeaderView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .clear
    }

    func setHierarchy() {
        [
            profileImageView,
            stackView,
        ].forEach(addSubview)

        [
            nicknameLabel,
            emailLabel,
        ].forEach(stackView.addArrangedSubview)
    }

    func setConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(70)
        }

        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(70)
        }

        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8.5)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
        }

        nicknameLabel.snp.makeConstraints { make in
            make.height.equalTo(27)
        }

        emailLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
    }
}
