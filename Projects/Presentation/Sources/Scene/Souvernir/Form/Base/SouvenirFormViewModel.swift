import Domain
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

    private let souvenirRepo: SouvenirRepository

    // MARK: - Life Cycle

    init(
        mode: SouvenirFormMode,
        souvenirRepo: SouvenirRepository
    ) {
        self.souvenirRepo = souvenirRepo
        var initialState = SouvenirFormState(mode: mode)

        // 수정 모드인 경우 기존 데이터 로드
        if case let .edit(detail) = mode {
            initialState.existingFiles = detail.files
            initialState.name = detail.name
            initialState.address = detail.address
            initialState.locationDetail = detail.locationDetail ?? ""
            initialState.localPrice = detail.formattedLocalPrice ?? ""
            initialState.currencySymbol = detail.currencySymbol ?? ""
            initialState.purpose = detail.purpose
            initialState.category = detail.category
            initialState.description = detail.description
            initialState.coordinate = detail.coordinate
        }

        super.init(initialState: initialState)
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .tapClose:
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
            mutate { state in
                state.name = text
            }

        // 주소 입력 탭 처리
        case .tapAddress:
            navigate(to: .search { [weak self] searchResult in
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
            })

        case let .updateAddress(coordinate, detail):
            mutate { state in
                state.coordinate = coordinate
                state.locationDetail = detail
                state.address = "test" // 임시
            }

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

        case let .updateDescription(text):
            handleUpdateDescription(text)

        case .tapSubmit:
            handleSubmit()
        }
    }

    // MARK: - Private

    private func handleAddLocalPhotos(_ photos: [LocalPhoto]) {
        mutate { state in
            guard case .create = state.mode else { return }
            let remaining = max(0, 5 - state.localPhotos.count)
            state.localPhotos.append(contentsOf: photos.prefix(remaining))
        }
    }

    private func handleRemoveLocalPhoto(_ id: UUID) {
        mutate { state in
            guard case .create = state.mode else { return }
            state.localPhotos.removeAll { $0.id == id }
        }
    }

    private func handleUpdatePrice(_ text: String) {
        let filtered = text.filter(\.isNumber)
        mutate { state in
            state.localPrice = filtered
        }
    }

    private func handleUpdateDescription(_ text: String) {
        mutate { state in
            if text.count <= 2000 {
                state.description = text
            }
        }
    }

    private func handleSubmit() {
        guard state.value.isSubmitEnabled else { return }

        guard let input = makeSubmitInput() else {
            emit(.showError("필수 정보를 모두 입력해주세요."))
            return
        }

        switch state.value.mode {
        case .create:
            handleCreate(input: input)
        case let .edit(original):
            handleUpdate(id: original.id, input: input)
        }
    }

    // MARK: - Private Helpers

    private func makeSubmitInput() -> SouvenirInput? {
        let currentState = state.value

        guard let coordinate = currentState.coordinate else { return nil }
        guard let category = currentState.category else { return nil }

        let (localPrice, currencySymbol, krwPrice) = calculatePriceFields(
            localPrice: currentState.localPrice,
            currencySymbol: currentState.currencySymbol
        )

        return SouvenirInput(
            name: currentState.name,
            localPrice: localPrice,
            currencySymbol: currencySymbol,
            krwPrice: krwPrice,
            description: currentState.description,
            address: currentState.address,
            locationDetail: currentState.locationDetail.isEmpty ? nil : currentState.locationDetail,
            coordinate: coordinate,
            category: category,
            purpose: currentState.purpose,
            countryCode: "KR"
        )
    }

    private func calculatePriceFields(
        localPrice: String,
        currencySymbol: String
    ) -> (localPrice: Int?, currencySymbol: String?, krwPrice: Int?) {
        guard !localPrice.isEmpty else {
            return (nil, nil, nil)
        }

        let parsedPrice = parsePrice(localPrice)

        if currencySymbol == "₩" {
            return (nil, currencySymbol, parsedPrice)
        } else {
            return (parsedPrice, currencySymbol, nil)
        }
    }

    private func parsePrice(_ price: String) -> Int? {
        let cleanedPrice = price.filter(\.isNumber)
        return Int(cleanedPrice)
    }

    private func handleCreate(input: SouvenirInput) {
        Task {
            do {
                let imageData = try convertPhotosToData(state.value.localPhotos)
                _ = try await souvenirRepo.createSouvenir(
                    input: input,
                    images: imageData
                )
                navigate(to: .dismiss)
            } catch {
                emit(.showError("사진을 처리하는 중 문제가 발생했어요.\n다시 선택해주세요."))
            }
        }
    }

    private func handleUpdate(id: Int, input: SouvenirInput) {
        Task {
            do {
                _ = try await souvenirRepo.updateSouvenir(id: id, input: input)
                navigate(to: .dismiss)
            } catch {
                emit(.showError("저장 중 문제가 발생했어요.\n잠시 후 다시 시도해주세요."))
            }
        }
    }

    private func convertPhotosToData(_ photos: [LocalPhoto]) throws -> [Data] {
        try photos.map { photo in
            guard let image = UIImage(contentsOfFile: photo.url.path) else {
                throw ImageProcessingError.invalidSource
            }

            let resized = resizeImage(image, maxDimension: 3000)

            guard let jpegData = resized.jpegData(compressionQuality: 0.8) else {
                throw ImageProcessingError.jpegConversionFailed
            }

            return jpegData
        }
    }

    private func resizeImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        let size = image.size

        if size.width <= maxDimension, size.height <= maxDimension {
            return image
        }

        let aspectRatio = size.width / size.height
        let newSize = if size.width > size.height {
            CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
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
