import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class LocationDetailInputView: BaseView<String> {
    // MARK: - Metric

    private enum Metric {
        static let iconSize: CGFloat = 20
    }

    // MARK: - UI

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey800
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    private let warningIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsIconInformationCircle
            .withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .dsMain
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let warningLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "위치가 정확하지 않으신가요?"
        label.textColor = .dsMain
        label.setTypography(.body2SB)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "다른 사용자들이 찾아갈 수 있도록 장소를 묘사해주세요!"
        label.textColor = .dsGrey80
        label.font = .pretendard(size: 12, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private let locationTextView = LocationTextView()

    // MARK: - Lifecycle

    override func setAttributes() {
        backgroundColor = .clear
    }

    override func setHierarchy() {
        addSubview(containerView)

        [
            warningIcon,
            warningLabel,
            descriptionLabel,
            locationTextView,
        ].forEach(containerView.addSubview)
    }

    override func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        warningIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(Metric.iconSize)
        }

        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(warningIcon.snp.top)
            make.leading.equalTo(warningIcon.snp.trailing).offset(6)
            make.trailing.equalToSuperview()
            make.height.equalTo(24)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(warningLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(warningLabel)
            make.height.equalTo(18)
        }

        locationTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(24)
        }
    }

    override func setBindings() {
        locationTextView.textChanged
            .bind(to: action)
            .disposed(by: disposeBag)
    }
}
