import DesignSystem
import SnapKit
import UIKit

final class TermsAllAgreeCell: UICollectionViewCell {
    private typealias Metric = TermsConstants
    private typealias Strings = TermsConstants.Strings

    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = Strings.allAgree
        label.textColor = .dsGreyWhite
        label.setTypography(.body2SB)
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

    func render(_ isAgreed: Bool) {
        checkImageView.image = isAgreed ? .dsIconCheckSelected : .dsIconCheck
    }
}

// MARK: - UI Configuration

private extension TermsAllAgreeCell {
    func configure() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        [
            checkImageView,
            titleLabel,
        ].forEach(contentView.addSubview)
    }

    func setConstraints() {
        checkImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Metric.checkboxLeadingOffset)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Metric.checkboxSize)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkImageView.snp.trailing).offset(Metric.titleLeadingOffset)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }
}
