import Domain

final class ProfileViewModel: BaseViewModel<
    ProfileState,
    ProfileAction,
    ProfileEvent,
    AuthRoute
> {
    // MARK: - UseCase

    private let validateNickname: ValidateNicknameUseCase

    // MARK: - Init

    init(
        validateNickname: ValidateNicknameUseCase
    ) {
        self.validateNickname = validateNickname
        super.init(initialState: State())
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .viewDidLoad:
            let maxLenght = validateNickname.policy.maxLength
            mutate { $0.nicknameMaxLength = maxLenght }

        case .tapBack:
            navigate(to: .back)

        case .tapProfileImage:
            emit(.showImagePicker)

        case let .selectProfileImage(type):
            mutate {
                $0.isCompleteButtonEnabled = true
                $0.selectedImageType = type
            }

        case let .updateNickname(nickname):
            let limited = String(nickname.prefix(state.value.nicknameMaxLength))
            mutate {
                $0.nickname = limited
                $0.nicknameErrorMessage = nil
            }

        case .tapCompleteButton:
            validateAndProceed()
        }
    }

    // MARK: - Private Logic

    private func validateAndProceed() {
        let nickname = state.value.nickname

        switch validateNickname.execute(nickname) {

        case let .valid(validNickname):
            mutate {
                $0.nickname = validNickname
                $0.nicknameErrorMessage = nil
                $0.isNicknameValid = true
            }
            navigate(to: .category)

        case let .invalid(_, error):
            mutate {
                $0.nicknameErrorMessage = error.localizedDescription
                $0.isNicknameValid = false
            }
        }
    }
}
