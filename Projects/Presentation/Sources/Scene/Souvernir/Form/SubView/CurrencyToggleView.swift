import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import UIKit

// MARK: - Action

enum CurrencyToggleAction {
    case selected(String)
}

// MARK: - View

final class CurrencyToggleView: BaseView<CurrencyToggleAction> {
    // MARK: - Properties

    private enum CurrencySelection {
        case krw
        case local
    }

    private var currentSelection: CurrencySelection = .local
    private var localCurrencySymbol: String = "$"
    private var isEnabled: Bool = true

    // MARK: - UI

    private let selectionBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey700
        view.layer.cornerRadius = 4
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var krwButton: UIButton = makeCurrencyButton(title: "원")
    private lazy var localButton: UIButton = makeCurrencyButton(title: localCurrencySymbol)

    private var selectionLeadingConstraint: Constraint?

    // MARK: - Init

    init() {
        super.init(frame: .zero)
    }

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .dsGrey800
        layer.cornerRadius = 8
        clipsToBounds = true
    }

    override func setHierarchy() {
        addSubview(selectionBackgroundView)
        [krwButton, localButton].forEach { addSubview($0) }
    }

    override func setConstraints() {
        krwButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(4)
            make.top.bottom.equalToSuperview().inset(4)
            make.width.equalTo(32)
        }

        localButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(4)
            make.top.bottom.equalToSuperview().inset(4)
            make.width.equalTo(32)
        }

        selectionBackgroundView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.width.equalTo(32)
            selectionLeadingConstraint = make.leading.equalToSuperview().inset(4).constraint
        }
    }

    override func setBindings() {
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
    }

    // MARK: - Public

    /// render 시 호출 - 현재 선택 기호 반영 (emit 없음)
    func configure(currencySymbol: String, animated: Bool) {
        if currencySymbol == "₩" {
            setSelection(.krw, animated: animated, emit: false)
        } else {
            localCurrencySymbol = currencySymbol
            updateButtonTitle(localButton, title: currencySymbol)
            setSelection(.local, animated: animated, emit: false)
        }
    }

    /// 현지 통화 기호 변경 (위치 변경 시)
    func updateLocalSymbol(_ symbol: String) {
        localCurrencySymbol = symbol
        updateButtonTitle(localButton, title: symbol)
        if isEnabled {
            applyCurrencyButtonStyle(selected: currentSelection)
        }
    }

    /// 가격 모름 토글 - 인터랙션 차단 + 선택 버튼 색상 변경
    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
        isUserInteractionEnabled = enabled
        if enabled {
            applyCurrencyButtonStyle(selected: currentSelection)
        } else {
            let selectedButton = currentSelection == .krw ? krwButton : localButton
            setCurrencyButtonColor(selectedButton, color: .dsGrey800)
        }
    }

    // MARK: - Toggle

    private func setSelection(_ selection: CurrencySelection, animated: Bool, emit: Bool) {
        currentSelection = selection

        if isEnabled {
            applyCurrencyButtonStyle(selected: selection)
        }

        let inset: CGFloat = 4
        let buttonWidth: CGFloat = 32
        let gap: CGFloat = 2

        let targetLeading: CGFloat = switch selection {
        case .krw: inset
        case .local: inset + buttonWidth + gap
        }

        layoutIfNeeded()
        selectionLeadingConstraint?.update(offset: targetLeading)

        let animations = { [weak self] in
            self?.layoutIfNeeded()
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
            case .krw: action.accept(.selected("₩"))
            case .local: action.accept(.selected(localCurrencySymbol))
            }
        }
    }

    // MARK: - Button Helpers

    private func makeCurrencyButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.dsGrey500, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .clear
        return button
    }

    private func updateButtonTitle(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
    }

    private func applyCurrencyButtonStyle(selected: CurrencySelection) {
        setButton(krwButton, isSelected: selected == .krw)
        setButton(localButton, isSelected: selected == .local)
    }

    private func setButton(_ button: UIButton, isSelected: Bool) {
        button.setTitleColor(isSelected ? .dsGreyWhite : .dsGrey500, for: .normal)
    }

    private func setCurrencyButtonColor(_ button: UIButton, color: UIColor) {
        button.setTitleColor(color, for: .normal)
    }
}
