import DesignSystem
import SnapKit
import UIKit

/// 검색어가 비어 있을 때 표시 — 캐릭터 일러스트 + 모드별 안내 (`SearchCountryNoResultsView`와 구분)
/// `UIStackView`로 두어 intrinsic 크기가 콘텐츠에 맞춰짐.
final class SearchCountryOnboardingView: UIStackView {
    // MARK: - UI

    private let illustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsCharacterSearch
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let messageLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "나라 · 도시 이름으로 검색해보세요"
        label.textColor = .dsGreyWhite
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setTypography(.body2R)
        return label
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        axis = .vertical
        alignment = .center
        spacing = 8
        backgroundColor = .clear
        addArrangedSubview(illustrationImageView)
        addArrangedSubview(messageLabel)

        illustrationImageView.snp.makeConstraints { make in
            make.width.equalTo(141)
            make.height.equalTo(129)
        }

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
        let w = bounds.width
        guard w > 0 else { return }
        messageLabel.preferredMaxLayoutWidth = w
    }

    // MARK: - Public

    func render(mode: SearchCountryMode) {
        switch mode {
        case .country:
            messageLabel.text = "나라 · 도시 이름으로 검색해보세요"
        case .store:
            messageLabel.text = "구매하신 상점을 검색해보세요"
        }
    }
}
