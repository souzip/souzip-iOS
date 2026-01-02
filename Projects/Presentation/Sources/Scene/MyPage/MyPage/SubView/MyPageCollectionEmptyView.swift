import DesignSystem
import SnapKit
import UIKit

final class MyPageCollectionEmptyView: BaseView<Void> {
    // MARK: - UI Components

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = .dsCharacterTraveling
        return imageView
    }()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "소중한 여행의 추억이 담긴\n기념품 컬렉션을 만들어보세요"
        label.textColor = .dsGreyWhite
        label.textAlignment = .center
        label.numberOfLines = 2
        label.setTypography(.body2R)
        return label
    }()

    private let uploadButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .dsGrey800
        config.baseForegroundColor = .dsGreyWhite
        config.setTypography(.body2M, title: "기념품 업로드하기")
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
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

    override func setAttributes() {
        backgroundColor = .clear
    }

    override func setHierarchy() {
        addSubview(stackView)

        [
            iconImageView,
            titleLabel,
            uploadButton,
        ].forEach(stackView.addArrangedSubview)
    }

    override func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(136)
            make.height.equalTo(125)
        }

        uploadButton.snp.makeConstraints { make in
            make.width.equalTo(161)
            make.height.equalTo(42)
        }
    }

    override func setBindings() {
        bind(uploadButton.rx.tap).to(())
    }
}
