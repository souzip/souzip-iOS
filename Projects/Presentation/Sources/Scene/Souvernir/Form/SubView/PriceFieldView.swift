import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import UIKit

// MARK: - Action

enum PriceFieldAction {
    case priceChanged(String)
    case currencyChanged(String)
}

// MARK: - View

final class PriceFieldView: BaseView<PriceFieldAction> {
    // MARK: - Properties

    private let placeholderText = "기념품의 가격을 입력해주세요."

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

    private let currencyToggleView = CurrencyToggleView()

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

    // MARK: - Init

    init(title: String) {
        super.init(frame: .zero)

        titleLabel.text = title
        currencyToggleView.configure(currencySymbol: "$", animated: false)
        applyUnknownPriceStyle(isOn: false)
    }

    // MARK: - Override

    override func setAttributes() {
        priceTextField.setPlaceholder(placeholderText)
    }

    override func setHierarchy() {
        [titleLabel, containerView, validationButton].forEach { addSubview($0) }
        [priceTextField, currencyToggleView].forEach { containerView.addSubview($0) }
    }

    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(48)
        }

        currencyToggleView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(74)
            make.height.equalTo(40)
        }

        priceTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(currencyToggleView.snp.leading).offset(-8)
        }

        validationButton.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.height.equalTo(24)
            make.bottom.equalToSuperview()
        }
    }

    override func setBindings() {
        priceTextField.onTextChanged { [weak self] text in
            guard let self else { return }
            if isProgrammaticTextUpdate { return }

            let raw = text
                .replacingOccurrences(of: ",", with: "")
                .filter(\.isNumber)

            // 최대 15자리로 제한 (Int 변환 안전 범위 확보 + 가격 입력 UX 제한)
            let limitedRaw = String(raw.prefix(15))

            let formatted = formatNumberWithComma(limitedRaw)

            // 외부에는 limitedRaw 전달
            action.accept(.priceChanged(limitedRaw))

            guard formatted != text else { return }

            isProgrammaticTextUpdate = true
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                priceTextField.setText(formatted)
                isProgrammaticTextUpdate = false
            }
        }

        bind(currencyToggleView.action)
            .map { action -> PriceFieldAction in
                switch action {
                case let .selected(symbol): return .currencyChanged(symbol)
                }
            }

        validationButton.rx.tap
            .bind { [weak self] in
                self?.handleUnknownPriceTapped()
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Public

    func render(price: String, currencySymbol: String) {
        if !price.isEmpty { setUnknownPrice(false) }

        isProgrammaticTextUpdate = true
        priceTextField.setText(formatNumberWithComma(price))
        isProgrammaticTextUpdate = false

        currencyToggleView.configure(currencySymbol: currencySymbol, animated: false)
    }

    func updateLocalCurrencySymbol(
        _ symbol: String,
        keepSelection: Bool = true,
        emit: Bool = false
    ) {
        currencyToggleView.updateLocalSymbol(symbol)
    }

    // MARK: - Private

    private func handleUnknownPriceTapped() {
        setUnknownPrice(!isUnknownPrice)

        if isUnknownPrice {
            // 1) 텍스트 비우기 + 2) placeholder 초기값
            isProgrammaticTextUpdate = true
            priceTextField.setText("")
            isProgrammaticTextUpdate = false
            priceTextField.setPlaceholder(placeholderText)

            // 외부에도 빈 값 전달(가격 없음 상태)
            action.accept(.priceChanged(""))
        }
    }

    private func setUnknownPrice(_ on: Bool) {
        guard isUnknownPrice != on else { return }
        isUnknownPrice = on
        applyUnknownPriceStyle(isOn: on)
    }

    private func applyUnknownPriceStyle(isOn: Bool) {
        // 1. validationButton 스타일
        var config = validationButton.configuration ?? .plain()
        config.baseForegroundColor = isOn ? .dsMain : .dsGreyWhite
        config.image = isOn ? .dsIconCheckSelected : .dsIconCheck
        validationButton.configuration = config

        // 2. priceTextField 인터랙션 차단/복구
        priceTextField.isUserInteractionEnabled = !isOn

        // 3. underlineView 색상 변경/복구
        priceTextField.setUnderlineColor(isOn ? .dsGrey700 : .dsGreyWhite)

        // 4. currencyToggleView 활성화/비활성화
        currencyToggleView.setEnabled(!isOn)
    }

    private func formatNumberWithComma(_ numberString: String) -> String {
        // Int 변환 실패 시 "" 대신 numberString 반환 — 필드 초기화 방지
        guard let number = Int(numberString) else { return numberString }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 0

        return formatter.string(from: NSNumber(value: number)) ?? numberString
    }
}
