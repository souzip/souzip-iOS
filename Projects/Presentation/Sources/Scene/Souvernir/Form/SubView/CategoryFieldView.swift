import DesignSystem
import Domain
import RxRelay
import SnapKit
import UIKit

final class CategoryFieldView: UIView {
    // MARK: - Output

    let tapRelay = PublishRelay<Void>()

    // MARK: - UI

    private let headerView = UIView()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.setTypography(.body1SB)
        return label
    }()

    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .dsIconChevronRight.withTintColor(.dsGreyWhite)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        return stackView
    }()

    private let placeholderLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "기념품의 카테고리를 선택해주세요."
        label.textColor = .dsGrey300
        label.setTypography(.body3M)
        label.numberOfLines = 0
        return label
    }()

    private let categoryView: DSIconTitleView = {
        let view = DSIconTitleView(
            layout: .init(
                iconSize: 16,
                spacing: 4,
                contentInsets: .init(top: 7, left: 12, bottom: 7, right: 12),
                typography: .body4R
            )
        )
        view.isHidden = true
        view.backgroundColor = .dsGrey800
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Init

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        configure()
        setContent(showCategory: false)
        setGesture()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func render(_ category: SouvenirCategory?) {
        if let category {
            categoryView.render(title: category.title, image: category.selectedImage)
            setContent(showCategory: true)
        } else {
            setContent(showCategory: false)
        }
    }

    // MARK: - Private

    private func configure() {
        setHierarchy()
        setConstraints()
    }

    private func setHierarchy() {
        addSubview(headerView)
        addSubview(contentStackView)

        headerView.addSubview(titleLabel)
        headerView.addSubview(arrowImageView)

        contentStackView.addArrangedSubview(placeholderLabel)
        contentStackView.addArrangedSubview(categoryView)
    }

    private func setConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.lessThanOrEqualTo(arrowImageView.snp.leading).offset(-8)
        }

        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview()
            make.size.equalTo(24)
        }

        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(30)
        }

        placeholderLabel.snp.makeConstraints { make in
            make.trailing.lessThanOrEqualToSuperview()
        }

        categoryView.snp.makeConstraints { make in
            make.trailing.lessThanOrEqualToSuperview()
        }
    }

    private func setContent(showCategory: Bool) {
        placeholderLabel.isHidden = showCategory
        categoryView.isHidden = !showCategory
    }

    private func setGesture() {
        headerView.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        headerView.addGestureRecognizer(tap)
    }

    @objc private func didTapHeader() {
        tapRelay.accept(())
    }
}
