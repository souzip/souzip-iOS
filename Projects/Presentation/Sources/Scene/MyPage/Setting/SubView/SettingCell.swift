import DesignSystem
import SnapKit
import UIKit

final class SettingCell: UITableViewCell {

    enum Position {
        case single, top, middle, bottom
    }

    // MARK: - UI

    private let cardView = UIView()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.setTypography(.body2R)
        return label
    }()

    private let trailingLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey80
        label.setTypography(.body2R)
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()

    private let chevronImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = .dsIconChevronRight.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .dsGrey300
        return iv
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardView.backgroundColor = .dsGrey900
        cardView.clipsToBounds = true

        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(trailingLabel)
        cardView.addSubview(chevronImageView)

        cardView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }

        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }

        trailingLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(12)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        trailingLabel.isHidden = true
        chevronImageView.isHidden = false
    }

    private func applyCorner(position: Position) {
        cardView.layer.cornerRadius = 16

        switch position {
        case .single:
            cardView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner,
            ]
        case .top:
            cardView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
            ]
        case .middle:
            cardView.layer.maskedCorners = []
        case .bottom:
            cardView.layer.maskedCorners = [
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner,
            ]
        }
    }
}

extension SettingCell {
    func configureTitle(_ title: String, position: Position) {
        titleLabel.text = title
        titleLabel.setTypography(.body2SB)

        trailingLabel.isHidden = true
        chevronImageView.isHidden = true
        applyCorner(position: position)
    }

    func configureItem(_ item: SettingItem, position: Position, isLast: Bool) {
        titleLabel.text = item.title
        titleLabel.setTypography(.body2R)

        if let trailing = item.trailingText {
            trailingLabel.text = trailing
            trailingLabel.isHidden = false
        } else {
            trailingLabel.isHidden = true
        }

        chevronImageView.isHidden = !item.showsChevron
        applyCorner(position: position)
    }

    func configureSpacer(position: Position) {
        titleLabel.text = nil
        trailingLabel.isHidden = true
        chevronImageView.isHidden = true

        applyCorner(position: position)
    }
}
