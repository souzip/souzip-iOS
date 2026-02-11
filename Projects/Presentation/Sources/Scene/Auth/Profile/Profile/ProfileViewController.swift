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
        let contentView = ProfileImagePickerView()
        let vc = presentBottomSheet(contentView: contentView)

        contentView.action
            .bind { [weak self, weak vc] (action: ProfileImagePickerView.Action) in
                switch action {
                case .close:
                    vc?.dismissSheet()

                case let .selectImage(type):
                    vc?.dismissSheet()
                    self?.viewModel.action.accept(.selectProfileImage(type))
                }
            }
            .disposed(by: disposeBag)
    }
}
