import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SearchTextFieldView: UIView {
    // MARK: - Events

    let textChanged = PublishRelay<String>()
    let clearButtonTapped = PublishRelay<Void>()

    // MARK: - UI

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey800
        view.layer.cornerRadius = 8
        return view
    }()

    private let searchIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsIconSearch
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let textField: TypographyTextField = {
        let textField = TypographyTextField()
        textField.setTypography(.body1R)
        textField.setPlaceholderTypography(
            .body1R,
            text: "어디로 떠나시나요?",
            color: .dsGrey500
        )
        textField.textColor = .dsGreyWhite
        textField.returnKeyType = .search
        return textField
    }()

    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.dsIconCancel, for: .normal)
        button.isHidden = true
        return button
    }()

    // MARK: - Properties

    private let disposeBag = DisposeBag()

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
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    private func setAttributes() {
        backgroundColor = .clear
    }

    private func setHierarchy() {
        addSubview(containerView)

        [
            searchIconView,
            textField,
            clearButton,
        ].forEach {
            containerView.addSubview($0)
        }
    }

    private func setConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(51)
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        searchIconView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }

        clearButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(clearButton.snp.height)
        }

        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalTo(clearButton.snp.leading).offset(-8)
            make.top.bottom.equalToSuperview().inset(12)
        }
    }

    private func setBindings() {
        textField.rx.text.orEmpty
            .distinctUntilChanged()
            .do { [weak self] text in
                self?.clearButton.isHidden = text.isEmpty
                self?.searchIconView.isHidden = !text.isEmpty
            }
            .bind(to: textChanged)
            .disposed(by: disposeBag)

        clearButton.rx.tap
            .do(onNext: { [weak self] in
                self?.textField.text = ""
                self?.textField.becomeFirstResponder()
                self?.clearButton.isHidden = true
            })
            .bind(to: clearButtonTapped)
            .disposed(by: disposeBag)
    }
}
