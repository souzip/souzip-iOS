import DesignSystem
import SnapKit
import UIKit

final class MoreButtonCell: UICollectionViewCell {
    // MARK: - UI

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "더보기"
        label.textColor = .dsGreyWhite
        label.setTypography(.body4M)
        return label
    }()

    private let arrowImageView: UIImageView = {
        let view = UIImageView()
        view.image = .dsIconChevronDown
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        return stack
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey800
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func render(title: String) {
        titleLabel.text = title
    }
}

// MARK: - UI Configuration

private extension MoreButtonCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        contentView.backgroundColor = .clear
    }

    func setHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(arrowImageView)
    }

    func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(81)
            make.height.equalTo(30)
        }

        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        arrowImageView.snp.makeConstraints { make in
            make.size.equalTo(12)
        }
    }
}
