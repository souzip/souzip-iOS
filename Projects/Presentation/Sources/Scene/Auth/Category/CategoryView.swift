import DesignSystem
import Domain
import SnapKit
import UIKit

final class CategoryView: BaseView<CategoryAction> {
    // MARK: - UI

    private let naviBar = DSNavigationBar(
        title: "카테고리 선택",
        style: .back
    )

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "관심 있는 카테고리를\n선택해주세요"
        label.textColor = .dsGreyWhite
        label.numberOfLines = 2
        label.setTypography(.subhead24SB)
        return label
    }()

    private let subTitleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "5개까지 선택 가능하며, 맞춤 기념품을 추천해드려요"
        label.textColor = .dsGrey300
        label.numberOfLines = 1
        label.setTypography(.body3M)
        return label
    }()

    private let categoryGridView = CategoryGridView()

    private let completeButton: DSButton = {
        let button = DSButton()
        button.setTitle("완료")
        button.setEnabled(false)
        return button
    }()

    // MARK: - Override

    override func setAttributes() {
        backgroundColor = .dsBackground
    }

    override func setHierarchy() {
        [
            naviBar,
            titleLabel,
            subTitleLabel,
            categoryGridView,
            completeButton,
        ].forEach(addSubview)
    }

    override func setConstraints() {
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(21)
        }

        categoryGridView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(33)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        completeButton.snp.makeConstraints { make in
            make.top.equalTo(categoryGridView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }

    override func setBindings() {
        bind(naviBar.onLeftTap).to(.back)
        bind(categoryGridView.toggle.asObservable())
            .map { .toggle(item: $0) }
        bind(completeButton.rx.tap).to(.complete)
    }

    // MARK: - Public

    func render(items: [CategoryItem]) {
        categoryGridView.render(items: items)
    }

    func render(canComplete: Bool) {
        completeButton.setEnabled(canComplete)
    }
}
