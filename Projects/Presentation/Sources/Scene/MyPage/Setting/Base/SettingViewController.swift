import SafariServices
import UIKit

final class SettingViewController: BaseViewController<
    SettingViewModel,
    SettingView
> {
    override func handleEvent(_ event: Event) {
        switch event {
        case .showLogoutAlert:
            showDSConfirmAlert(
                message: "로그아웃 하시겠습니까?",
                confirmTitle: "아니요",
                cancelTitle: "로그아웃",
                cancelHandler: { [weak self] in
                    self?.viewModel.action.accept(.logout)
                }
            )

        case .showWithdrawAlert:
            showDSConfirmAlert(
                message: "탈퇴 하시겠습니까?",
                confirmTitle: "아니요",
                cancelTitle: "탈퇴하기",
                cancelHandler: { [weak self] in
                    self?.viewModel.action.accept(.withdraw)
                }
            )

        case let .showSFView(url):
            let vc = SFSafariViewController(url: url)
            vc.modalPresentationStyle = .pageSheet
            present(vc, animated: true)
        }
    }
}
