import SnapKit
import UIKit

final class DSTabBarItemView: UIView {
    // MARK: - Event

    var onTap: (() -> Void)?

    // MARK: - UI

    private let control = UIControl()

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textAlignment = .center
        label.textColor = .dsGreyWhite
        label.setTypography(.body4M)
        return label
    }()

    // MARK: - State

    private let item: DSTabBarItem

    // MARK: - Init

    init(item: DSTabBarItem) {
        self.item = item
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Render

    func setSelected(_ selected: Bool) {
        iconView.image = selected ? item.selectedImage : item.image
        titleLabel.textColor = selected ? .dsMain : .dsGreyWhite
    }

    // MARK: - Private

    @objc private func tapped() {
        onTap?()
    }
}

// MARK: - UI Configuration

private extension DSTabBarItemView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setAttributes() {
        titleLabel.text = item.title
    }

    func setHierarchy() {
        addSubview(control)
        control.addSubview(iconView)
        control.addSubview(titleLabel)
    }

    func setConstraints() {
        control.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }

    func setBindings() {
        control.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
}
