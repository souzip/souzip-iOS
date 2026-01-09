import CoreLocation
import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class LocationPickerView: BaseView<LocationPickerAction> {
    // MARK: - UI

    private let naviBar = DSNavigationBar(
        title: "위치 추가",
        style: .back
    )

    private var mapView: LocationMapView

    private let detailInputView = LocationDetailInputView()

    private let completeButton: DSButton = {
        let button = DSButton()
        button.setTitle("완료")
        button.setEnabled(true)
        return button
    }()

    private var detailBottomConstraint: Constraint?

    // MARK: - Init

    init(initialCoordinate: CLLocationCoordinate2D) {
        mapView = LocationMapView(mode: .editable, initialCoordinate: initialCoordinate)
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func setAttributes() {
        backgroundColor = .dsBackground
        setupKeyboardObservers()
        hideKeyboardWhenTappedAround()
    }

    override func setHierarchy() {
        [
            mapView,
            detailInputView,
            completeButton,
            naviBar,
        ].forEach(addSubview)
    }

    override func setConstraints() {
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        mapView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        detailInputView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            self.detailBottomConstraint = make.bottom
                .equalTo(completeButton.snp.top)
                .offset(-12.5)
                .constraint
        }

        completeButton.snp.makeConstraints { make in make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }

    override func setBindings() {
        bind(naviBar.onLeftTap).to(.tapBack)

        detailInputView.action
            .map { .detailTextChanged($0) }
            .bind(to: action)
            .disposed(by: disposeBag)

        bind(completeButton.rx.tap)
            .map { [weak self] in
                let coordinate = self?.mapView.getCurrentCenter() ?? CLLocationCoordinate2D()
                return .tapComplete(coordinate)
            }
    }

    // MARK: - Private

    private func setupKeyboardObservers() {
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .compactMap(\.userInfo)
            .bind { [weak self] userInfo in
                guard let self else { return }

                let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) ?? .zero
                let keyboardHeight = max(0, frame.height - safeAreaInsets.bottom)

                // 애니메이션 정보 추출
                let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.25
                let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt) ?? 0

                let completeButtonBottom: CGFloat = 20 + 50

                let offset = -(keyboardHeight - completeButtonBottom + 12.5)

                detailBottomConstraint?.update(offset: offset)

                UIView.animate(
                    withDuration: duration,
                    delay: 0,
                    options: UIView.AnimationOptions(rawValue: curve << 16),
                    animations: {
                        self.layoutIfNeeded()
                    }
                )
            }
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .compactMap(\.userInfo)
            .bind { [weak self] userInfo in
                guard let self else { return }

                let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.25
                let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt) ?? 0

                detailBottomConstraint?.update(offset: -12.5)

                UIView.animate(
                    withDuration: duration,
                    delay: 0,
                    options: UIView.AnimationOptions(rawValue: curve << 16),
                    animations: {
                        self.layoutIfNeeded()
                    }
                )
            }
            .disposed(by: disposeBag)
    }
}
