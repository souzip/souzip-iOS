import DesignSystem
import UIKit

// MARK: - Alert

extension UIViewController {
    func showDSAlert(
        message: String,
        confirmTitle: String = "확인",
        confirmHandler: (() -> Void)? = nil
    ) {
        let alertView = DSAlertView()
        alertView.render(
            message: message,
            confirmTitle: confirmTitle,
            confirmHandler: confirmHandler
        )
        alertView.show(on: self)
    }

    func showDSConfirmAlert(
        message: String,
        confirmTitle: String = "확인",
        cancelTitle: String = "취소",
        confirmHandler: (() -> Void)? = nil,
        cancelHandler: (() -> Void)? = nil
    ) {
        let alertView = DSAlertView()
        alertView.render(
            message: message,
            confirmTitle: confirmTitle,
            cancelTitle: cancelTitle,
            confirmHandler: confirmHandler,
            cancelHandler: cancelHandler
        )
        alertView.show(on: self)
    }
}
