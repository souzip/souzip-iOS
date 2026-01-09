import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class UploadPromptCell: UICollectionViewCell {
    // MARK: - Action

    let action = PublishRelay<Void>()
    var disposeBag = DisposeBag()

    // MARK: - UI

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "업로드 기반으로\n 맞춤 기념품을 추천해드릴게요"
        label.textColor = .dsGreyWhite
        label.numberOfLines = 2
        label.textAlignment = .center
        label.setTypography(.body1SB)
        return label
    }()

    private let subtitleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "기념품을 업로드하러 가보세요"
        label.textColor = .dsGrey300
        label.textAlignment = .center
        label.setTypography(.body3M)
        return label
    }()

    private let uploadButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .dsGrey800
        config.baseForegroundColor = .dsGreyWhite
        config.background.cornerRadius = 8
        config.setTypography(.body2M, title: "업로드하기")
        let button = UIButton(configuration: config)
        return button
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        return stack
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

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        setBindings()
    }
}

// MARK: - UI Configuration

private extension UploadPromptCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setAttributes() {
        contentView.backgroundColor = .clear
    }

    func setHierarchy() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(uploadButton)
    }

    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints { make in
            make.height.equalTo(21)
        }

        uploadButton.snp.makeConstraints { make in
            make.width.equalTo(117)
            make.height.equalTo(42)
        }
    }

    func setBindings() {
        uploadButton.rx.tap
            .bind(to: action)
            .disposed(by: disposeBag)
    }
}
