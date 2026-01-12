import Domain
import Foundation

enum SouvenirFormAction {
    // Navigation
    case tapClose

    case tapPhotoAdd
    case addLocalPhotos([LocalPhoto])
    case removeLocalPhoto(UUID)

    // Basic Info
    case updateName(String)
    case tapAddress
    case updateAddress(Coordinate, String)

    // Price
    case updateLocalPrice(String)
    case updateCurrencySymbol(String)

    // Classification
    case selectPurpose(SouvenirPurpose)
    case tapCategory
    case selectCategory(SouvenirCategory)

    // Description
    case updateDescription(String)

    // Submit
    case tapSubmit
}

struct SouvenirFormState {
    let mode: SouvenirFormMode

    // 사진
    var localPhotos: [LocalPhoto] = []
    var existingFiles: [SouvenirFile] = []

    // 기본 정보
    var name: String = ""

    // 좌표
    var coordinate: Coordinate?
    var address: String = ""
    var locationDetail: String = ""
    var countryCode: String = ""

    // 가격
    var localPrice: String = ""
    var currencySymbol: String = "₩"

    // 분류
    var purpose: SouvenirPurpose = .personal
    var category: SouvenirCategory?

    // 설명
    var description: String = ""

    // Computed properties
    var isEditMode: Bool {
        if case .edit = mode {
            return true
        }
        return false
    }

    var navigationTitle: String {
        switch mode {
        case .create: "업로드하기"
        case .edit: "수정하기"
        }
    }

    var submitButtonTitle: String {
        switch mode {
        case .create: "저장하기"
        case .edit: "수정 완료"
        }
    }

    var descriptionCountText: String {
        "\(description.count)/2,000"
    }

    var isSubmitEnabled: Bool {
        let hasImages: Bool = switch mode {
        case .create:
            !localPhotos.isEmpty
        case .edit:
            !existingFiles.isEmpty
        }

        return hasImages &&
            !name.isEmpty &&
            !address.isEmpty &&
            category != nil &&
            !description.isEmpty
    }
}

enum SouvenirFormMode {
    case create
    case edit(SouvenirDetail)
}

struct LocalPhoto: Hashable {
    let id: UUID
    let url: URL
}

enum SouvenirFormEvent {
    case loading(Bool)
    case showImagePicker
    case showError(String)
}
