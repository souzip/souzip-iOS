import Domain
import Foundation

enum SouvenirFormAction {
    // Navigation
    case tapClose
    case confirmClose

    case tapPhotoAdd
    case addLocalPhotos([LocalPhoto])
    case removeLocalPhoto(UUID)

    // Basic Info
    case updateName(String)
    case tapAddress
    /// 검색·결과로 좌표가 잡힌 뒤, 지도에서 핀을 다시 조정할 때
    case tapPreciseLocation
    /// 두 번째 인자는 **상세 주소**(피커 `detailText`). 메인 주소 줄은 역지오코딩으로 `state.address`에 채움.
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
    var price: String = ""
    var currencySymbol: String = "₩"
    var localCurrencySymbol: String = "$"

    // 분류
    var purpose: SouvenirPurpose = .personal
    var category: SouvenirCategory?

    // 설명
    var description: String = ""

    // MARK: - Init

    init(mode: SouvenirFormMode) {
        self.mode = mode
        guard case let .edit(detail) = mode else { return }
        existingFiles = detail.files
        name = detail.name
        coordinate = detail.location.coordinate
        address = detail.location.address
        countryCode = detail.countryCode
        locationDetail = detail.location.locationDetail ?? ""
        let symbol = detail.price.localCurrencySymbol ?? "₩"
        currencySymbol = symbol
        if symbol == "₩" {
            price = detail.price.krwAmount.map { String($0) } ?? ""
        } else {
            price = detail.price.localAmount.map { String($0) } ?? ""
        }
        purpose = detail.purpose
        category = detail.category
        description = detail.description
    }

    // MARK: - Computed properties

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
    case showConfirmClose
}
