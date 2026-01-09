import Domain

enum ProfileAction {
    case viewDidLoad
    case tapBack
    case tapProfileImage
    case selectProfileImage(ProfileImageType)
    case updateNickname(String)
    case tapCompleteButton
}

struct ProfileState {
    var nickname: String = ""
    var isNicknameValid: Bool = false
    var nicknameErrorMessage: String?
    var nicknameMaxLength: Int = 0
    var selectedImageType: ProfileImageType?
    var isCompleteButtonEnabled: Bool = false

    var nicknameCountText: String {
        "\(nickname.count)/\(nicknameMaxLength)"
    }
}

enum ProfileEvent {
    case showImagePicker
    case showAlert(String)
}
