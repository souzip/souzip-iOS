import RxSwift
import UIKit

final class ProfileViewController: BaseViewController<
    ProfileViewModel,
    ProfileView
> {
    // MARK: - Bind

    override func bindState() {
        observe(\.nickname)
            .onNext(contentView.render(nickname:))

        observe(\.nicknameErrorMessage)
            .skip(1)
            .onNext(contentView.render(errorMessage:))

        observe(\.selectedImageType)
            .unwrapped()
            .distinct()
            .onNext(contentView.render(type:))

        observe(\.isCompleteButtonEnabled)
            .distinct()
            .onNext(contentView.render(isEnabled:))

        observe(\.nicknameCountText)
            .onNext(contentView.render(countText:))
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action.accept(.viewDidLoad)
    }

    // MARK: - Event

    override func handleEvent(_ event: Event) {
        switch event {
        case .showImagePicker:
            showImagePicker()

        case let .showAlert(message):
            showDSAlert(message: message)
        }
    }

    // MARK: - Private

    private func showImagePicker() {
        let imagePickerVC = ProfileImagePickerViewController()
        imagePickerVC.onImageSelected = { [weak self] type in
            self?.viewModel.action.accept(.selectProfileImage(type))
        }

        imagePickerVC.modalPresentationStyle = .pageSheet
        if let sheet = imagePickerVC.sheetPresentationController {
            sheet.detents = [.custom { _ in 371 }]
            sheet.prefersGrabberVisible = false
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }

        present(imagePickerVC, animated: true)
    }
}
