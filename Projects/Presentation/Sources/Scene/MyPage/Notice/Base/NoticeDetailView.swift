import DesignSystem
import Domain
import Kingfisher
import SnapKit
import UIKit

final class NoticeDetailView: BaseView<NoticeDetailAction> {
    // MARK: - UI

    private let naviBar = DSNavigationBar(title: "", style: .back)

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()

    private let contentView = UIView()

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body1SB)
        label.textColor = .dsGreyWhite
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body4R)
        label.textColor = .dsGrey300
        return label
    }()

    private let imageStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.alignment = .fill
        return sv
    }()

    private let bodyLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.setTypography(.body3M)
        label.textColor = .dsGreyWhite
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Constraints

    private var bodyTopToDate: Constraint?
    private var bodyTopToImages: Constraint?

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .dsBackground
    }

    override func setHierarchy() {
        [
            naviBar,
            scrollView,
        ].forEach(addSubview)

        scrollView.addSubview(contentView)

        [
            titleLabel,
            dateLabel,
            imageStackView,
            bodyLabel,
        ].forEach(contentView.addSubview)
    }

    override func setConstraints() {
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        bodyLabel.snp.makeConstraints { make in
            bodyTopToDate = make.top.equalTo(dateLabel.snp.bottom).offset(16).constraint
            bodyTopToImages = make.top.equalTo(imageStackView.snp.bottom).offset(20).constraint
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
        }

        bodyTopToDate?.deactivate()
        bodyTopToImages?.deactivate()
    }

    override func setBindings() {
        bind(naviBar.onLeftTap).to(.back)
    }

    // MARK: - Public

    func render(detail: NoticeDetail) {
        titleLabel.text = detail.title
        dateLabel.text = formatDate(detail.createdAt)
        bodyLabel.text = detail.content.strippedHTML

        imageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if detail.imageURLs.isEmpty {
            imageStackView.isHidden = true
            bodyTopToImages?.deactivate()
            bodyTopToDate?.activate()
        } else {
            imageStackView.isHidden = false
            bodyTopToDate?.deactivate()
            bodyTopToImages?.activate()

            for urlString in detail.imageURLs {
                let iv = makeNoticeImageView()
                iv.setDetailImage(urlString)
                imageStackView.addArrangedSubview(iv)
            }
        }
    }
}

// MARK: - Private

private extension NoticeDetailView {
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
        return formatter.string(from: date)
    }

    func makeNoticeImageView() -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .dsGrey800

        // 비율 336:358 고정
        iv.snp.makeConstraints { make in
            make.height.equalTo(iv.snp.width).multipliedBy(358.0 / 336.0)
        }

        return iv
    }
}
