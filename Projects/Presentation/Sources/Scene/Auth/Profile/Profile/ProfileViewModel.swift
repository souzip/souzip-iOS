import Domain

final class ProfileViewModel: BaseViewModel<
    ProfileState,
    ProfileAction,
    ProfileEvent,
    AuthRoute
> {
    // MARK: - UseCase

    private let validateNickname: ValidateNicknameUseCase
    private let saveNickname: SaveNicknameUseCase
    private let saveProfileImageColor: SaveProfileImageColorUseCase

    // MARK: - Init

    init(
        validateNickname: ValidateNicknameUseCase,
        saveNickname: SaveNicknameUseCase,
        saveProfileImageColor: SaveProfileImageColorUseCase
    ) {
        self.validateNickname = validateNickname
        self.saveNickname = saveNickname
        self.saveProfileImageColor = saveProfileImageColor
        super.init(initialState: State())
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .viewDidLoad:
            let maxLength = validateNickname.policy.maxLength
            mutate { $0.nicknameMaxLength = maxLength }

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
            Task { await validateAndProceed() }
        }
    }

    // MARK: - Private Logic

    private func validateAndProceed() async {
        guard let profileColor = state.value.selectedImageType else {
            return
        }

        let nickname = state.value.nickname

        do {
            let result = try await validateNickname.execute(nickname)

            mutate {
                $0.nickname = result.nickname
                $0.nicknameErrorMessage = result.nicknameErrorMessage
                $0.isNicknameValid = result.isValid
            }

            if result.isValid {
                saveNickname.execute(nickname: nickname)
                saveProfileImageColor.execute(color: profileColor)
                navigate(to: .category)
            }
        } catch {
            emit(.showAlert(error.localizedDescription))
        }
    }
}
