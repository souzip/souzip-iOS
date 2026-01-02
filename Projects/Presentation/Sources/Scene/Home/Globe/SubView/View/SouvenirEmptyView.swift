import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SouvenirEmptyView: UIView {
    // MARK: - UI

    var tapUpload: Observable<Void> { uploadButton.rx.tap.asObservable() }

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = .dsCharacterPrepareTrip
        return view
    }()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "앗, 아직 정보가 없어요!\n최초의 발견자가 되어주세요"
        label.textColor = .dsGreyWhite
        label.numberOfLines = 2
        label.textAlignment = .center
        label.setTypography(.body2R)
        return label
    }()

    private let uploadButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .dsGrey800
        config.baseForegroundColor = .dsGreyWhite
        config.setTypography(.body2M, title: "업로드하기")
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - UI Configuration

private extension SouvenirEmptyView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .clear
    }

    func setHierarchy() {
        [
            imageView,
            titleLabel,
            uploadButton,
        ].forEach(addSubview)
    }

    func setConstraints() {
        snp.makeConstraints { make in
            make.width.equalTo(215)
        }

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(105)
            make.height.equalTo(77)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }

        uploadButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(117)
            make.height.equalTo(42)
            make.bottom.equalToSuperview()
        }
    }
}
