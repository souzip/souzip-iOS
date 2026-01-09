import DesignSystem
import SnapKit
import UIKit

final class MyPageSegmentView: BaseView<CollectionTab> {
    // MARK: - UI Components

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var collectionButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.setTypography(.body2SB, title: "컬렉션")
        let button = UIButton(configuration: config)
        return button
    }()

    private lazy var likedButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.setTypography(.body2SB, title: "찜")
        let button = UIButton(configuration: config)
        return button
    }()

    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGreyWhite
        return view
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey500
        return view
    }()

    // MARK: - Override

    override func setHierarchy() {
        [
            buttonStackView,
            separatorView,
            underlineView,
        ].forEach(addSubview)

        [
            collectionButton,
            likedButton,
        ].forEach(buttonStackView.addArrangedSubview)
    }

    override func setConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(40)
        }

        separatorView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }

        underlineView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(collectionButton)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    override func setBindings() {
        bind(collectionButton.rx.tap).to(.collection)
        bind(likedButton.rx.tap).to(.liked)
    }

    // MARK: - Update UI

    func updateUI(for tab: CollectionTab) {
        let isCollection = tab == .collection

        // 컬렉션 버튼 업데이트
        updateButton(
            collectionButton,
            isSelected: isCollection
        )

        // 찜 버튼 업데이트
        updateButton(
            likedButton,
            isSelected: !isCollection
        )

        // 언더라인 애니메이션
        UIView.animate(withDuration: 0.3) {
            self.underlineView.snp.remakeConstraints { make in
                make.horizontalEdges.equalTo(isCollection ? self.collectionButton : self.likedButton)
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            self.layoutIfNeeded()
        }
    }

    private func updateButton(_ button: UIButton, isSelected: Bool) {
        var config = button.configuration ?? UIButton.Configuration.plain()
        config.baseForegroundColor = isSelected ? .dsGreyWhite : .dsGrey700
        button.configuration = config
    }
}
