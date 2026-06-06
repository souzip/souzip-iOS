import Analytics
import CoreLocation
import Domain
import Logger
import Photos
import RxSwift
import UIKit

final class SouvenirFormViewModel: BaseViewModel<
    SouvenirFormState,
    SouvenirFormAction,
    SouvenirFormEvent,
    SouvenirRoute
> {
    // MARK: - UseCase

    let loadCountryDetail: LoadCountryDetailUseCase
    let loadLocationAddress: LoadLocationAddressUseCase
    let createSouvenir: CreateSouvenirUseCase
    let updateSouvenir: UpdateSouvenirUseCase
    let userSouvenirInvalidationStore: UserSouvenirInvalidationStore

    let onResult: ((SouvenirDetail) -> Void)?

    /// 검색화면 재진입 시 유지할 마지막 검색어
    var locationSearchQuery: String = ""

    /// 업로드 퍼널 이벤트 중복 발송 방지
    var firedUploadEvents: Set<String> = []

    /// 폼에 입력 이벤트가 한 번이라도 발생했는지 여부
    var isDirty: Bool = false

    /// 역지오코딩 요청 세대 — 늦게 도착한 응답이 최신 좌표를 덮어쓰지 않게 함
    var addressLookupGeneration: UInt64 = 0

    // MARK: - Life Cycle

    init(
        mode: SouvenirFormMode,
        onResult: ((SouvenirDetail) -> Void)? = nil,
        loadCountryDetail: LoadCountryDetailUseCase,
        loadLocationAddress: LoadLocationAddressUseCase,
        createSouvenir: CreateSouvenirUseCase,
        updateSouvenir: UpdateSouvenirUseCase,
        userSouvenirInvalidationStore: UserSouvenirInvalidationStore
    ) {
        self.onResult = onResult
        self.loadCountryDetail = loadCountryDetail
        self.loadLocationAddress = loadLocationAddress
        self.createSouvenir = createSouvenir
        self.updateSouvenir = updateSouvenir
        self.userSouvenirInvalidationStore = userSouvenirInvalidationStore

        let initialState = SouvenirFormState(mode: mode)
        super.init(initialState: initialState)

        applyLocalCurrencySymbolFromCountryIfAvailable(
            countryCode: initialState.countryCode
        )

        if case .create = mode {
            trackUploadOnce(.upload(.start))
        }
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        markDirtyIfNeeded(for: action)

        switch action {
        case .tapClose, .confirmClose:
            handleCloseAction(action)
        case .tapPhotoAdd, .addLocalPhotos, .removeLocalPhoto:
            handlePhotoAction(action)
        case let .updateName(text):
            handleUpdateName(text)
        case .tapPreciseLocation:
            handleTapPreciseLocation()
        case .tapAddress:
            handleTapAddress()
        case let .updateAddress(coordinate, detail):
            handleUpdateAddress(coordinate: coordinate, detail: detail)
        case let .updateLocalPrice(text):
            handleUpdatePrice(text)
        case let .updateCurrencySymbol(symbol):
            handleUpdateCurrencySymbol(symbol)
        case let .selectPurpose(purpose):
            handleSelectPurpose(purpose)
        case .tapCategory:
            handleTapCategory()
        case let .selectCategory(category):
            handleSelectCategory(category)
        case let .updateDescription(text):
            handleUpdateDescription(text)
        case .tapSubmit:
            handleSubmit()
        }
    }
}
