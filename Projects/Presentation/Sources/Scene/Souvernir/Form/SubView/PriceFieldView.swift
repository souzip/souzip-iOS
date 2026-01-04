import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class PriceFieldView: UIView {
    // MARK: - Properties

    private let disposeBag = DisposeBag()

    let priceChanged = PublishRelay<String>()
    let currencyChanged = PublishRelay<String>()

    private let placeholderText = "기념품의 가격을 입력해주세요."

    private var localCurrencySymbol: String = "$"

    private enum CurrencySelection {
        case krw
        case local
    }

    private var currentSelection: CurrencySelection = .local
    private var isProgrammaticTextUpdate = false

    private var isUnknownPrice: Bool = false

    // MARK: - UI

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.setTypography(.body1SB)
        return label
    }()

    private let containerView = UIView()
    private let priceTextField: DSTextField = {
        let view = DSTextField()
        view.setKeyboardType(.numberPad)
        return view
    }()

    private let currencyToggleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey800
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private let currencySelectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey700
        view.layer.cornerRadius = 4
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var krwButton: UIButton = makeCurrencyButton(title: "원")
    private lazy var localButton: UIButton = makeCurrencyButton(title: localCurrencySymbol)

    private let validationButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = .dsIconCheck
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.contentInsets = .zero
        config.baseForegroundColor = .dsGrey500
        config.setTypography(.body4R, title: "가격을 잘 모르겠어요.")
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        return button
    }()

    private var selectionLeadingConstraint: Constraint?

    // MARK: - Init

    init(title: String) {
        super.init(frame: .zero)

        titleLabel.text = title
        configure()
        setBindings()

        setSelection(.local, animated: false, emit: true)
        applyUnknownPriceStyle(isOn: false)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func render(price: String, currencySymbol: String) {
        if !price.isEmpty { setUnknownPrice(false) }

        isProgrammaticTextUpdate = true
        priceTextField.setText(price.comma)
        isProgrammaticTextUpdate = false

        if currencySymbol == "₩" {
            setSelection(.krw, animated: false, emit: false)
        } else {
            updateLocalCurrencySymbol(currencySymbol, keepSelection: true, emit: false)
            setSelection(.local, animated: false, emit: false)
        }
    }

    func updateLocalCurrencySymbol(
        _ symbol: String,
        keepSelection: Bool = true,
        emit: Bool = false
    ) {
        localCurrencySymbol = symbol
        updateButtonTitle(localButton, title: symbol)

        if keepSelection {
            applyCurrencyButtonStyle(selected: currentSelection)
        } else {
            setSelection(.local, animated: false, emit: emit)
        }
    }

    // MARK: - Private

    private func configure() {
        setHierarchy()
        setConstraints()
        setAttributes()
    }

    private func setHierarchy() {
        [titleLabel, containerView, validationButton].forEach { addSubview($0) }

        [priceTextField, currencyToggleContainer].forEach { containerView.addSubview($0) }

        currencyToggleContainer.addSubview(currencySelectionView)
        [krwButton, localButton].forEach { currencyToggleContainer.addSubview($0) }
    }

    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(48)
        }

        currencyToggleContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(74)
            make.height.equalTo(40)
        }

        priceTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(currencyToggleContainer.snp.leading).offset(-8)
        }

        krwButton.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.top.bottom.equalToSuperview().inset(4)
            make.width.equalTo(32)
        }

        localButton.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().inset(4)
            make.top.bottom.equalToSuperview().inset(4)
            make.width.equalTo(32)
        }

        currencySelectionView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.width.equalTo(32)
            self.selectionLeadingConstraint = make.leading.equalToSuperview().inset(4).constraint
        }

        validationButton.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.height.equalTo(24)
            make.bottom.equalToSuperview()
        }
    }

    private func setAttributes() {
        priceTextField.setPlaceholder(placeholderText)
    }

    private func setBindings() {
        priceTextField.onTextChanged { [weak self] text in
            guard let self else { return }
            if isProgrammaticTextUpdate { return }

            let raw = text
                .replacingOccurrences(of: ",", with: "")
                .filter(\.isNumber)

            let formatted = formatNumberWithComma(raw)

            // 외부에는 raw 전달
            priceChanged.accept(raw)

            guard formatted != text else { return }

            isProgrammaticTextUpdate = true
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                priceTextField.setText(formatted)
                isProgrammaticTextUpdate = false
            }
        }

        krwButton.rx.tap
            .bind { [weak self] in
                self?.setSelection(.krw, animated: true, emit: true)
            }
            .disposed(by: disposeBag)

        localButton.rx.tap
            .bind { [weak self] in
                self?.setSelection(.local, animated: true, emit: true)
            }
            .disposed(by: disposeBag)

        validationButton.rx.tap
            .bind { [weak self] in
                self?.handleUnknownPriceTapped()
            }
            .disposed(by: disposeBag)
    }

    private func handleUnknownPriceTapped() {
        setUnknownPrice(!isUnknownPrice)

        if isUnknownPrice {
            // 1) 텍스트 비우기 + 2) placeholder 초기값
            isProgrammaticTextUpdate = true
            priceTextField.setText("")
            isProgrammaticTextUpdate = false
            priceTextField.setPlaceholder(placeholderText)

            // 외부에도 빈 값 전달(가격 없음 상태)
            priceChanged.accept("")
        }
    }

    private func setUnknownPrice(_ on: Bool) {
        guard isUnknownPrice != on else { return }
        isUnknownPrice = on
        applyUnknownPriceStyle(isOn: on)
    }

    private func applyUnknownPriceStyle(isOn: Bool) {
        var config = validationButton.configuration ?? .plain()

        config.baseForegroundColor = isOn ? .dsMain : .dsGreyWhite
        config.image = isOn ? .dsIconCheckSelected : .dsIconCheck
        validationButton.configuration = config
    }

    // MARK: - Toggle

    private func setSelection(_ selection: CurrencySelection, animated: Bool, emit: Bool) {
        guard currentSelection != selection else { return }
        currentSelection = selection

        applyCurrencyButtonStyle(selected: selection)

        let inset: CGFloat = 4
        let buttonWidth: CGFloat = 32
        let gap: CGFloat = 2

        let targetLeading: CGFloat = switch selection {
        case .krw: inset
        case .local: inset + buttonWidth + gap
        }

        currencyToggleContainer.layoutIfNeeded()
        selectionLeadingConstraint?.update(offset: targetLeading)

        let animations = { [weak self] in
            self?.currencyToggleContainer.layoutIfNeeded()
        }

        if animated {
            UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseOut]) {
                animations()
            }
        } else {
            animations()
        }

        if emit {
            switch selection {
            case .krw: currencyChanged.accept("₩")
            case .local: currencyChanged.accept(localCurrencySymbol)
            }
        }
    }

    // MARK: - Button (Configuration)

    private func makeCurrencyButton(title: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.contentInsets = .zero
        config.titleAlignment = .center
        config.baseForegroundColor = .dsGrey500

        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            return outgoing
        }

        let button = UIButton(configuration: config)
        button.backgroundColor = .clear
        return button
    }

    private func updateButtonTitle(_ button: UIButton, title: String) {
        var config = button.configuration ?? .plain()
        config.title = title
        button.configuration = config
    }

    private func applyCurrencyButtonStyle(selected: CurrencySelection) {
        setButton(krwButton, isSelected: selected == .krw)
        setButton(localButton, isSelected: selected == .local)
    }

    private func setButton(_ button: UIButton, isSelected: Bool) {
        var config = button.configuration ?? .plain()
        config.baseForegroundColor = isSelected ? .dsGreyWhite : .dsGrey500
        button.configuration = config
    }

    private func formatNumberWithComma(_ numberString: String) -> String {
        guard let number = Int(numberString) else { return "" }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 0

        return formatter.string(from: NSNumber(value: number)) ?? numberString
    }
}

extension String {
    var comma: String {
        let digits = filter(\.isNumber)
        guard let number = Int(digits) else { return self }

        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = ","
        f.locale = Locale(identifier: "en_US_POSIX")
        return f.string(from: NSNumber(value: number)) ?? digits
    }
}
