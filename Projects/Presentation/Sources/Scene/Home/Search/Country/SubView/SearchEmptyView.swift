import DesignSystem
import SnapKit
import UIKit

final class SearchEmptyView: UIView {
    // MARK: - UI

    private let illustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsCharacterSearch
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "나라 · 도시 이름으로 검색해보세요"
        label.font = .pretendard(size: 18, weight: .light)
        label.textColor = .dsGreyWhite
        label.textAlignment = .center
        return label
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

    // MARK: - Configure

    private func configure() {
        setHierarchy()
        setConstraints()
    }

    private func setHierarchy() {
        for item in [illustrationImageView, messageLabel] {
            addSubview(item)
        }
    }

    private func setConstraints() {
        illustrationImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(141)
            make.height.equalTo(129)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(illustrationImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}
