import DesignSystem
import Domain
import Photos
import RxCocoa
import SnapKit
import UIKit

final class SouvenirFormView: BaseView<SouvenirFormAction> {
    // MARK: - UI

    private enum Metric {
        static let horizontalInset: CGFloat = 20
    }

    private let naviBar = DSNavigationBar(
        title: "",
        style: .close
    )

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        return stackView
    }()

    private let photoSectionWrapperView = UIView()

    private let photoSectionView = PhotoSectionView()
    private let nameFieldView = SouvenirFieldView(title: "기념품 명")
    private let addressFieldView = AddressFieldView()
    private let priceFieldView = PriceFieldView(title: "가격")
    private let purposeToggleView = PurposeToggleView(title: "기념품 대상")
    private let categoryFieldView = CategoryFieldView(title: "카테고리")
    private let descriptionFieldView = DescriptionFieldView()

    private let submitButton = DSButton()

    private var scrollViewBottomConstraint: Constraint?

    // MARK: - Lifecycle

    override func setAttributes() {
        backgroundColor = .dsBackground
        hideKeyboardWhenTappedAround()

        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.directionalLayoutMargins = .init(
            top: 24,
            leading: Metric.horizontalInset,
            bottom: 34,
            trailing: Metric.horizontalInset
        )
    }

    override func setHierarchy() {
        addSubview(naviBar)
        addSubview(scrollView)

        scrollView.addSubview(contentStackView)

        photoSectionWrapperView.addSubview(photoSectionView)

        [
            photoSectionWrapperView,
            nameFieldView,
            addressFieldView,
            priceFieldView,
            purposeToggleView,
            categoryFieldView,
            descriptionFieldView,
            submitButton,
        ].forEach { contentStackView.addArrangedSubview($0) }
    }

    override func setConstraints() {
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            self.scrollViewBottomConstraint = make.bottom.equalToSuperview().constraint
        }

        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        photoSectionView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(-Metric.horizontalInset)
        }

        submitButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }

    override func setBindings() {
        bind(naviBar.onLeftTap).to(.tapClose)
        bind(submitButton.rx.tap).to(.tapSubmit)

        // Photo Section
        photoSectionView.action
            .bind { [weak self] action in
                switch action {
                case .tapAdd:
                    self?.action.accept(.tapPhotoAdd)
                case let .tapRemoveLocal(id):
                    self?.action.accept(.removeLocalPhoto(id))
                }
            }
            .disposed(by: disposeBag)

        bind(nameFieldView.textRelay.asObservable())
            .map { Action.updateName($0) }

        bind(addressFieldView.tapRelay.asObservable())
            .to(.tapAddress)

        // Price Field
        priceFieldView.priceChanged
            .bind { [weak self] price in
                self?.action.accept(.updateLocalPrice(price))
            }
            .disposed(by: disposeBag)

        priceFieldView.currencyChanged
            .bind { [weak self] symbol in
                self?.action.accept(.updateCurrencySymbol(symbol))
            }
            .disposed(by: disposeBag)

        bind(categoryFieldView.tapRelay.asObservable())
            .to(.tapCategory)

        // Purpose Toggle
        purposeToggleView.purposeChanged
            .bind { [weak self] purpose in
                self?.action.accept(.selectPurpose(purpose))
            }
            .disposed(by: disposeBag)

        bind(descriptionFieldView.textChanged.asObservable())
            .map { Action.updateDescription($0) }
    }

    // MARK: - Public

    func renderTitle(_ title: String) {
        naviBar.render(title: title, style: .close)
    }

    func renderPhotos(
        mode: SouvenirFormMode,
        localPhotos: [LocalPhoto],
        existingFiles: [SouvenirFile]
    ) {
        switch mode {
        case .create:
            photoSectionView.renderCreate(localPhotos: localPhotos)
        case .edit:
            photoSectionView.renderEdit(existingFiles: existingFiles)
        }
    }

    func renderName(_ text: String) {
        nameFieldView.setText(text)
    }

    func renderAddress(_ text: String, _ description: String) {
        addressFieldView.render(text: text)
        addressFieldView.renderDescription(description)
    }

    func renderPrice(
        _ price: String,
        _ currencySymbol: String
    ) {
        priceFieldView.render(price: price, currencySymbol: currencySymbol)
    }

    func renderPurpose(_ purpose: SouvenirPurpose) {
        purposeToggleView.render(purpose)
    }

    func renderCategory(_ category: SouvenirCategory?) {
        categoryFieldView.render(category)
    }

    func renderDescription(_ description: String) {
        descriptionFieldView.updateUI(text: description)
    }

    func renderSubmitButton(title: String, isEnabled: Bool) {
        submitButton.setTitle(title)
        submitButton.setEnabled(isEnabled)
    }

    func updateKeyboardHeight(_ height: CGFloat, duration: TimeInterval, curve: UIView.AnimationOptions) {
        scrollViewBottomConstraint?.update(offset: -height)

        UIView.animate(withDuration: duration, delay: 0, options: [curve, .beginFromCurrentState]) {
            self.layoutIfNeeded()
        }
    }
}
