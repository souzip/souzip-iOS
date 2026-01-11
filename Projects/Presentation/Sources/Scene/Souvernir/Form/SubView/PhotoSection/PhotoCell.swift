import DesignSystem
import Domain
import SnapKit
import UIKit

final class PhotoCell: UICollectionViewCell {
    // MARK: - Public

    var onTapDelete: (() -> Void)?

    // MARK: - UI

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.8
        imageView.clipsToBounds = true
        imageView.backgroundColor = .dsGrey700
        return imageView
    }()

    private let mainBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.isHidden = true
        return view
    }()

    private let mainBadgeLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "대표 사진"
        label.textColor = .dsGreyWhite
        label.setTypography(.body4R)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    private let deleteButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .dsGrey900
        config.cornerStyle = .capsule
        config.image = .dsIconCancel.resized(to: CGSize(width: 10, height: 10))
        let button = UIButton(configuration: config)
        button.isHidden = true
        return button
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

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        setMain(false)
        setDeleteVisible(false)
        onTapDelete = nil
    }

    // MARK: - Render

    func renderLocal(url: URL, isMain: Bool, showDelete: Bool) {
        setMain(isMain)
        setDeleteVisible(showDelete)

        imageView.image = UIImage(contentsOfFile: url.path)
    }

    func renderRemote(file: SouvenirFile, isMain: Bool, showDelete: Bool) {
        setMain(isMain)
        setDeleteVisible(showDelete)

        imageView.setMyFeedImage(file.url)
    }
}

// MARK: - Private

private extension PhotoCell {
    func configure() {
        contentView.addSubview(imageView)
        contentView.addSubview(mainBackgroundView)
        contentView.addSubview(mainBadgeLabel)
        contentView.addSubview(deleteButton)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        mainBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(24)
        }

        mainBadgeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(6)
            make.height.equalTo(18)
            make.horizontalEdges.equalToSuperview().inset(4)
        }

        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.trailing.equalToSuperview().inset(4)
            make.width.height.equalTo(14)
        }

        deleteButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
    }

    func setMain(_ isMain: Bool) {
        mainBackgroundView.isHidden = !isMain
        mainBadgeLabel.isHidden = !isMain
    }

    func setDeleteVisible(_ isVisible: Bool) {
        deleteButton.isHidden = !isVisible
    }

    @objc func didTapDelete() {
        onTapDelete?()
    }
}
