import DesignSystem
import SnapKit
import UIKit

final class CountryFilterCell: UICollectionViewCell {
    // MARK: - UI Components

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        return view
    }()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body4R)
        label.textColor = .dsGreyWhite
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

    // MARK: - Public

    func render(_ item: CountryItem) {
        titleLabel.text = item.name
        updateSelectionState(isSelected: item.isSelected)
    }

    // MARK: - Private

    private func updateSelectionState(isSelected: Bool) {
        if isSelected {
            containerView.backgroundColor = .dsMain.withAlphaComponent(0.1)
            containerView.layer.borderColor = UIColor.dsMain.cgColor
            containerView.layer.borderWidth = 1
            titleLabel.textColor = .dsMain
        } else {
            containerView.backgroundColor = .dsGrey800
            containerView.layer.borderColor = nil
            containerView.layer.borderWidth = 0
            titleLabel.textColor = .dsGreyWhite
        }
    }
}

// MARK: - UI Configuration

private extension CountryFilterCell {
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
        containerView.addSubview(titleLabel)
    }

    func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
