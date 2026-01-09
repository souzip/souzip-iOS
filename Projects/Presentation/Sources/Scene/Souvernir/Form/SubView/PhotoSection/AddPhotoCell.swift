import DesignSystem
import SnapKit
import UIKit

final class AddPhotoCell: UICollectionViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey700
        view.layer.cornerRadius = 4.8
        view.clipsToBounds = true
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsIconCamera
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .dsGrey80
        label.font = .pretendard(size: 9.6, weight: .regular)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(currentCount: Int) {
        countLabel.text = "\(currentCount) / 5"
    }
}

// MARK: - UI Configuration

private extension AddPhotoCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        contentView.backgroundColor = .clear
    }

    func setHierarchy() {
        addSubview(containerView)

        [
            iconImageView,
            countLabel,
        ].forEach(containerView.addSubview)
    }

    func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.centerX.equalToSuperview()
            make.size.equalTo(24)
        }

        countLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
}
