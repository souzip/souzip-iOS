import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class ReportBottomSheetView: BaseView<ReportBottomSheetView.Action> {
    // MARK: - Action

    enum Action {
        case report
        case close
    }

    // MARK: - UI

    private let reportButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .dsGreyWhite
        config.setTypography(.body1SB, title: "신고하기")
        return UIButton(configuration: config)
    }()

    private let closeButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "닫기"
        config.baseForegroundColor = .dsGreyWhite
        config.baseBackgroundColor = .dsGrey700
        config.background.cornerRadius = LayoutConstants.CornerRadius.small

        var titleAttr = AttributedString("닫기")
        titleAttr.font = .pretendard(size: 17, weight: .medium)
        config.attributedTitle = titleAttr
        let button = UIButton(configuration: config)
        return button
    }()

    // MARK: - Setup

    override func setHierarchy() {
        addSubview(reportButton)
        addSubview(closeButton)
    }

    override func setConstraints() {
        reportButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(27)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(reportButton.snp.bottom).offset(LayoutConstants.Spacing.small)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(LayoutConstants.Size.Button.medium)
            make.bottom.equalToSuperview().inset(24)
        }
    }

    override func setBindings() {
        bind(reportButton.rx.tap).to(.report)
        bind(closeButton.rx.tap).to(.close)
    }
}
