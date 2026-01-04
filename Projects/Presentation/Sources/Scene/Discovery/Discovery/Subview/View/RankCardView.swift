import DesignSystem
import SnapKit
import UIKit

final class RankCardView: UIView {
    enum Style {
        case first
        case normal

        var containerColor: UIColor {
            switch self {
            case .first: .dsGrey800
            case .normal: .dsGrey700
            }
        }

        var badgeColor: UIColor {
            switch self {
            case .first: .dsMain
            case .normal: .dsMainR50
            }
        }

        var badgeLabelColor: UIColor {
            switch self {
            case .first: .dsGreyWhite
            case .normal: .dsMain
            }
        }

        var titleColor: UIColor {
            switch self {
            case .first: .dsMain
            case .normal: .dsGreyWhite
            }
        }

        var countBackgroundColor: UIColor {
            switch self {
            case .first: .dsGrey900
            case .normal: .dsGrey800
            }
        }
    }

    // MARK: - UI Components

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    private let rankBadgeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()

    private let rankLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textAlignment = .center
        label.setTypography(.body4M)
        return label
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 7
        return stackView
    }()

    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textAlignment = .center
        label.setTypography(.body2SB)
        return label
    }()

    private let countContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let countLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textAlignment = .center
        label.setTypography(.caption2R)
        label.textColor = .dsGrey80
        return label
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        clipsToBounds = false

        addSubview(containerView)
        addSubview(rankBadgeView)

        containerView.addSubview(contentStackView)

        contentStackView.addArrangedSubview(flagImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(countContainerView)

        countContainerView.addSubview(countLabel)
        rankBadgeView.addSubview(rankLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        rankBadgeView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-9)
            make.leading.equalToSuperview().offset(-5)
            make.size.equalTo(30)
        }

        rankLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        contentStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        flagImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
        }

        countLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(2)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.height.equalTo(12)
        }
    }

    // MARK: - Render

    func render(
        style: Style,
        rank: Int,
        imageURLString: String,
        title: String,
        count: String
    ) {
        // 스타일 적용
        containerView.backgroundColor = style.containerColor
        rankBadgeView.backgroundColor = style.badgeColor
        rankLabel.textColor = style.badgeLabelColor
        titleLabel.textColor = style.titleColor
        countContainerView.backgroundColor = style.countBackgroundColor

        // 데이터 설정
        flagImageView.setStaticAsset(imageURLString)
        rankLabel.text = "\(rank)위"
        titleLabel.text = title
        countLabel.text = "\(count)개 기념품"
    }
}
