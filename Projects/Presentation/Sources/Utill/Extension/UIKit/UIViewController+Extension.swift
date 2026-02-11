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

// MARK: - BottomSheet

extension UIViewController {
    @discardableResult
    func presentBottomSheet(
        contentView: UIView,
        onDismiss: (() -> Void)? = nil
    ) -> DSBottomSheetViewController {
        let vc = DSBottomSheetViewController(contentView: contentView)

        if let onDismiss {
            _ = vc.onDismiss(onDismiss)
        }

        present(vc, animated: false)
        return vc
    }
}

// MARK: - Toast

extension UIViewController {
    func showToast(
        _ message: String,
        bottomInset: CGFloat = 104,
        duration: TimeInterval = 1.2
    ) {
        let toast = DSToastView(text: message)
        toast.alpha = 0
        toast.isUserInteractionEnabled = false

        view.addSubview(toast)

        toast.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(bottomInset)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.85)
        }

        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction]
        ) {
            toast.alpha = 1
        } completion: { _ in
            UIView.animate(
                withDuration: 0.2,
                delay: duration,
                options: [.curveEaseIn, .allowUserInteraction]
            ) {
                toast.alpha = 0
            } completion: { _ in
                toast.removeFromSuperview()
            }
        }
    }
}
