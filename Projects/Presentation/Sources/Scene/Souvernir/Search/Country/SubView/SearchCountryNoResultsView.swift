import DesignSystem
import UIKit

/// 검색어는 있으나 API 결과가 0건일 때 표시 (`SearchCountryOnboardingView`와 구분)
/// `UIStackView`로 두어 intrinsic 크기가 콘텐츠에 맞춰짐.
final class SearchCountryNoResultsView: UIStackView {
    // MARK: - UI

    private let primaryLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "검색 결과가 없습니다."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .dsGreyWhite
        label.setTypography(.body2R)
        return label
    }()

    private let secondaryLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "도시, 국가 이름을 입력해보세요.\n단어가 정확한지 확인해보세요."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .dsGrey500
        label.setTypography(.body3M)
        return label
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        axis = .vertical
        spacing = 10
        alignment = .fill
        distribution = .fill
        backgroundColor = .clear
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32)
        isLayoutMarginsRelativeArrangement = true
        insetsLayoutMarginsFromSafeArea = false

        addArrangedSubview(primaryLabel)
        addArrangedSubview(secondaryLabel)

        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        let w = bounds.width - layoutMargins.left - layoutMargins.right
        guard w > 0 else { return }
        primaryLabel.preferredMaxLayoutWidth = w
        secondaryLabel.preferredMaxLayoutWidth = w
    }
}
