import SnapKit
import UIKit

public final class DSToastView: UIView {
    // MARK: - UI

    private let label: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setTypography(.body4R)
        return label
    }()

    // MARK: - Init

    public init(text: String) {
        super.init(frame: .zero)
        label.text = text
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}

// MARK: - UI Configuration

private extension DSToastView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .dsGrey800
        clipsToBounds = true
    }

    func setHierarchy() {
        addSubview(label)
    }

    func setConstraints() {
        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(18)
        }
    }
}
