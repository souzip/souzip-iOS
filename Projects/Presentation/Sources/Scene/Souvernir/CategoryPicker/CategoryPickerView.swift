import DesignSystem
import Domain
import SnapKit
import UIKit

final class CategoryPickerView: BaseView<CategoryPickerAction> {
    // MARK: - UI

    private let naviBar = DSNavigationBar(
        title: "카테고리 선택",
        style: .back
    )

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
            categoryGridView,
            completeButton,
        ].forEach(addSubview)
    }

    override func setConstraints() {
        naviBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        categoryGridView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(24)
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
            .map { .select(item: $0) }
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
