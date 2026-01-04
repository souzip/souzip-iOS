import DesignSystem
import SnapKit
import UIKit

final class EmptyStateCell: UICollectionViewCell {
    private let label: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey300
        label.setTypography(.body2M)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func render(_ text: String) {
        label.text = text
    }
}
