import DesignSystem
import Domain
import RxRelay
import RxSwift
import SnapKit
import UIKit

final class TermsCell: UICollectionViewCell, ActionBindable {
    enum Action {
        case tapDetail
    }

    let action = PublishRelay<Action>()
    var disposeBag = DisposeBag()

    private typealias Metric = TermsConstants

    // MARK: - UI

    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.numberOfLines = 1
        label.setTypography(.body3M)
        return label
    }()

    private let detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.dsIconChevronRight, for: .normal)
        button.tintColor = .dsGreyWhite
        return button
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        setBindings()
    }

    // MARK: - Configuration

    func render(_ item: TermsItem) {
        titleLabel.text = item.displayTitle
        checkImageView.image = item.checkboxImage
        detailButton.isHidden = !item.hasDetailPage
    }
}

// MARK: - UI Configuration

private extension TermsCell {
    func configure() {
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setHierarchy() {
        [
            checkImageView,
            titleLabel,
            detailButton,
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
            $0.trailing.equalTo(detailButton.snp.leading)
            $0.centerY.equalToSuperview()
        }

        detailButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-Metric.detailButtonTrailingOffset)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Metric.detailButtonSize)
        }
    }

    func setBindings() {
        bind(detailButton.rx.tap).to(.tapDetail)
    }
}
