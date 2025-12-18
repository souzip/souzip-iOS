import DesignSystem
import UIKit

extension UIViewController {
    func showDSAlert(
        title: String? = nil,
        message: String,
        confirmTitle: String = "확인",
        confirmHandler: (() -> Void)? = nil
    ) {
        let alertView = DSAlertView()
        alertView.render(
            title: title,
            message: message,
            confirmTitle: confirmTitle,
            confirmHandler: confirmHandler
        )
        alertView.show(on: self)
    }

    func showDSConfirmAlert(
        title: String? = nil,
        message: String,
        confirmTitle: String = "확인",
        cancelTitle: String = "취소",
        confirmHandler: (() -> Void)? = nil,
        cancelHandler: (() -> Void)? = nil
    ) {
        let alertView = DSAlertView()
        alertView.render(
            title: title,
            message: message,
            confirmTitle: confirmTitle,
            cancelTitle: cancelTitle,
            confirmHandler: confirmHandler,
            cancelHandler: cancelHandler
        )
        alertView.show(on: self)
    }
}
