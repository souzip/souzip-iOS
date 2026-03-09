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
    // MARK: - Repository

    private let countryRepo: CountryRepository
    private let souvenirRepo: SouvenirRepository

    private let onResult: ((SouvenirDetail) -> Void)?

    /// 검색화면 재진입 시 유지할 마지막 검색어
    private var locationSearchQuery: String = ""

    /// 업로드 퍼널 이벤트 중복 발송 방지
    private var firedUploadEvents: Set<String> = []

    /// 폼에 입력 이벤트가 한 번이라도 발생했는지 여부
    private var isDirty: Bool = false

    // MARK: - Life Cycle

    init(
        mode: SouvenirFormMode,
        onResult: ((SouvenirDetail) -> Void)? = nil,
        countryRepo: CountryRepository,
        souvenirRepo: SouvenirRepository
    ) {
        self.onResult = onResult
        self.countryRepo = countryRepo
        self.souvenirRepo = souvenirRepo

        let initialState = SouvenirFormState(mode: mode)
        super.init(initialState: initialState)

        if !initialState.countryCode.isEmpty,
           let country = try? countryRepo.fetchCountry(countryCode: initialState.countryCode) {
            mutate { $0.localCurrencySymbol = country.currency.symbol }
        }

        if case .create = mode {
            trackUploadOnce(.upload(.start))
        }
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .tapClose, .confirmClose, .tapSubmit:
            break
        default:
            isDirty = true
        }

        switch action {
        case .tapClose:
            if isDirty {
                emit(.showConfirmClose)
            } else {
                navigate(to: .dismiss)
                navigate(to: .finish)
            }

        case .confirmClose:
            navigate(to: .dismiss)
            navigate(to: .finish)

        case .tapPhotoAdd:
            guard case .create = state.value.mode else { return }
            emit(.showImagePicker)

        case let .addLocalPhotos(photos):
            handleAddLocalPhotos(photos)

        case let .removeLocalPhoto(id):
            handleRemoveLocalPhoto(id)

        case let .updateName(text):
            let wasEmpty = state.value.name.isEmpty
            mutate { state in
                state.name = text
            }
            if wasEmpty, !text.isEmpty {
                trackUploadOnce(.upload(.titleAdded))
            }

        // 주소 입력 탭 처리
        case .tapAddress:
            navigate(to: .search(.init(
                initialQuery: locationSearchQuery,
                mode: .store,
                onResult: { [weak self] searchResult in
                    self?.locationSearchQuery = searchResult.name
                    self?.navigate(
                        to: .locationPicker(
                            initialCoordinate: searchResult.coordinate
                        ) { [weak self] coordinate, detail in
                            self?.handleAction(.updateAddress(
                                coordinate.toCoordinate,
                                detail
                            ))
                        }
                    )
                }
            )))

        case let .updateAddress(coordinate, detail):
            mutate { state in
                state.coordinate = coordinate
                state.locationDetail = detail
            }
            trackUploadOnce(.upload(.locationSet))

            Task { await updateAddress(coordinate) }

        case let .updateLocalPrice(text):
            handleUpdatePrice(text)

        case let .updateCurrencySymbol(symbol):
            mutate { state in
                state.currencySymbol = symbol
            }

        case let .selectPurpose(purpose):
            mutate { state in
                state.purpose = purpose
            }
            trackUploadOnce(.upload(.targetAdded))

        case .tapCategory:
            let category = state.value.category

            navigate(to: .categoryPicker(
                initailCategory: category
            ) { [weak self] selected in
                self?.handleAction(.selectCategory(selected))
            })

        case let .selectCategory(category):
            mutate { state in
                state.category = category
            }
            trackUploadOnce(.upload(.categoryAdded))

        case let .updateDescription(text):
            handleUpdateDescription(text)

        case .tapSubmit:
            handleSubmit()
        }
    }

    // MARK: - Private

    private func handleAddLocalPhotos(_ photos: [LocalPhoto]) {
        let wasEmpty = state.value.localPhotos.isEmpty
        mutate { state in
            guard case .create = state.mode else { return }
            let remaining = max(0, 5 - state.localPhotos.count)
            state.localPhotos.append(contentsOf: photos.prefix(remaining))
        }
        if wasEmpty, !state.value.localPhotos.isEmpty {
            trackUploadOnce(.upload(.photoAdded))
        }
    }

    private func handleRemoveLocalPhoto(_ id: UUID) {
        mutate { state in
            guard case .create = state.mode else { return }
            state.localPhotos.removeAll { $0.id == id }
        }
    }

    private func updateAddress(_ coordinate: Coordinate) async {
        do {
            let address = try await countryRepo.getAddress(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )

            let country = try countryRepo.fetchCountry(countryCode: address.countryCode)
            mutate {
                $0.address = address.formattedAddress
                $0.currencySymbol = country.currency.symbol
                $0.localCurrencySymbol = country.currency.symbol
                $0.countryCode = address.countryCode
            }
        } catch {
            emit(.showError(error.localizedDescription))
        }
    }

    private func handleUpdatePrice(_ text: String) {
        let wasEmpty = state.value.price.isEmpty
        let filtered = text.filter(\.isNumber)
        mutate { state in
            state.price = filtered
        }
        if wasEmpty, !filtered.isEmpty {
            trackUploadOnce(.upload(.priceAdded))
        }
    }

    private func handleUpdateDescription(_ text: String) {
        let wasEmpty = state.value.description.isEmpty
        mutate { state in
            if text.count <= 2000 {
                state.description = text
            }
        }
        if wasEmpty, !text.isEmpty {
            trackUploadOnce(.upload(.introduceAdded))
        }
    }

    private func handleSubmit() {
        guard let input = makeSubmitInput() else {
            emit(.showError("필수 정보를 모두 입력해주세요."))
            return
        }

        switch state.value.mode {
        case .create:
            trackUploadOnce(.upload(.complete))
            handleCreate(input: input)
        case let .edit(original):
            handleUpdate(id: original.id, input: input)
        }
    }

    // MARK: - Analytics

    /// 업로드 퍼널 이벤트를 폼 세션 당 1회만 발송
    private func trackUploadOnce(_ event: AnalyticsEvent) {
        guard case .create = state.value.mode else { return }
        guard !firedUploadEvents.contains(event.eventType) else { return }
        firedUploadEvents.insert(event.eventType)
        AnalyticsManager.shared.track(event: event)
    }

    // MARK: - Private Helpers

    private func makeSubmitInput() -> SouvenirInput? {
        let currentState = state.value

        guard let coordinate = currentState.coordinate,
              let category = currentState.category
        else { return nil }

        let price: Int? = currentState.price.isEmpty ? nil : Int(currentState.price)
        let currencyCode: String? = if currentState.currencySymbol == "₩" {
            "KRW"
        } else {
            try? countryRepo
                .fetchCountry(countryCode: currentState.countryCode)
                .currency
                .code
        }

        return SouvenirInput(
            name: currentState.name,
            price: price,
            currencyCode: currencyCode,
            description: currentState.description,
            address: currentState.address,
            locationDetail: currentState.locationDetail.isEmpty ? nil : currentState.locationDetail,
            coordinate: coordinate,
            category: category,
            purpose: currentState.purpose,
            countryCode: currentState.countryCode
        )
    }

    private func handleCreate(input: SouvenirInput) {
        Task {
            do {
                emit(.loading(true))
                let imageData = try convertPhotosToData(state.value.localPhotos)
                _ = try await souvenirRepo.createSouvenir(
                    input: input,
                    images: imageData
                )
                emit(.loading(false))
                navigate(to: .dismiss)
            } catch {
                emit(.loading(false))
                emit(.showError(error.localizedDescription))
            }
        }
    }

    private func handleUpdate(id: Int, input: SouvenirInput) {
        Task {
            do {
                emit(.loading(true))
                let souvenirDetail = try await souvenirRepo.updateSouvenir(id: id, input: input)
                onResult?(souvenirDetail)
                emit(.loading(false))
                navigate(to: .dismiss)
            } catch {
                emit(.loading(false))
                emit(.showError(error.localizedDescription))
            }
        }
    }

    private func convertPhotosToData(_ photos: [LocalPhoto]) throws -> [Data] {
        var results: [Data] = []
        results.reserveCapacity(photos.count)

        for photo in photos {
            try autoreleasepool {
                guard FileManager.default.fileExists(atPath: photo.url.path) else {
                    throw ImageProcessingError.invalidSource
                }

                guard let jpegData = resizeImageFromFile(at: photo.url, maxDimension: 3000, compressionQuality: 0.75) else {
                    throw ImageProcessingError.jpegConversionFailed
                }

                results.append(jpegData)
            }
        }

        return results
    }

    private func resizeImageFromFile(
        at url: URL,
        maxDimension: CGFloat,
        compressionQuality: CGFloat
    ) -> Data? {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }

        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
              let pixelWidth = properties[kCGImagePropertyPixelWidth] as? Int,
              let pixelHeight = properties[kCGImagePropertyPixelHeight] as? Int else {
            return nil
        }

        let needsResize = pixelWidth > Int(maxDimension) || pixelHeight > Int(maxDimension)

        let cgImage: CGImage?

        if needsResize {
            let options: [CFString: Any] = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: maxDimension,
                kCGImageSourceShouldCacheImmediately: true,
            ]
            cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary)
        } else {
            let options: [CFString: Any] = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: max(pixelWidth, pixelHeight),
                kCGImageSourceShouldCacheImmediately: true,
            ]
            cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary)
        }

        guard let finalCGImage = cgImage else {
            return nil
        }

        let uiImage = UIImage(cgImage: finalCGImage)
        return uiImage.jpegData(compressionQuality: compressionQuality)
    }
}

enum ImageProcessingError: LocalizedError {
    case invalidSource
    case thumbnailCreationFailed
    case jpegConversionFailed

    var errorDescription: String? {
        switch self {
        case .invalidSource:
            "사진을 불러오는 데 실패했어요."
        case .thumbnailCreationFailed:
            "사진을 처리하는 중 문제가 발생했어요."
        case .jpegConversionFailed:
            "사진을 저장 형식으로 변환하지 못했어요."
        }
    }
}
