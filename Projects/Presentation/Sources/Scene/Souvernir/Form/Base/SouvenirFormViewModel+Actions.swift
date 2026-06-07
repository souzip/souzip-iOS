import Domain
import UIKit

extension SouvenirFormViewModel {
    func markDirtyIfNeeded(for action: Action) {
        switch action {
        case .tapClose, .confirmClose, .tapSubmit,
             .tapPhotoAdd, .tapAddress, .tapPreciseLocation, .tapCategory:
            break
        default:
            isDirty = true
        }
    }

    func handleCloseAction(_ action: Action) {
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

        default:
            break
        }
    }

    func handlePhotoAction(_ action: Action) {
        switch action {
        case .tapPhotoAdd:
            guard case .create = state.value.mode else { return }
            emit(.showImagePicker)

        case let .addLocalPhotos(photos):
            handleAddLocalPhotos(photos)

        case let .removeLocalPhoto(id):
            handleRemoveLocalPhoto(id)

        default:
            break
        }
    }

    func handleUpdateName(_ text: String) {
        let wasEmpty = state.value.name.isEmpty
        mutate { state in
            if text.count <= 30 {
                state.name = text
            }
        }
        if wasEmpty, !text.isEmpty {
            trackUploadOnce(.upload(.titleAdded))
        }
    }

    func handleTapPreciseLocation() {
        guard let coordinate = state.value.coordinate else { return }
        navigate(to: .locationPicker(
            initialCoordinate: coordinate.toCLLocationCoordinate2D,
            onComplete: { [weak self] clCoordinate, detail in
                self?.handleAction(.updateAddress(
                    clCoordinate.toCoordinate,
                    detail
                ))
            }
        ))
    }

    func handleTapAddress() {
        navigate(to: .search(.init(
            initialQuery: locationSearchQuery,
            mode: .store,
            onResult: { [weak self] items, selectedItem, searchText in
                self?.locationSearchQuery = searchText
                let orderedItems = Self.searchResultsPlacingSelectedFirst(
                    items,
                    selected: selectedItem
                )
                self?.navigate(
                    to: .locationSearchResult(
                        items: orderedItems,
                        searchText: searchText,
                        centerCoordinate: selectedItem.coordinate,
                        onConfirm: { [weak self] confirmedItem in
                            // 상세주소는 피커에서만 입력; 검색 결과 이름은 locationDetail에 넣지 않음
                            self?.handleAction(.updateAddress(
                                confirmedItem.coordinate.toCoordinate,
                                ""
                            ))
                        }
                    )
                )
            }
        )))
    }

    func handleUpdateAddress(coordinate: Coordinate, detail: String) {
        mutate { state in
            state.coordinate = coordinate
            state.locationDetail = detail
        }
        trackUploadOnce(.upload(.locationSet))

        addressLookupGeneration += 1
        let generation = addressLookupGeneration
        let lookupCoordinate = coordinate
        Task { [weak self] in
            await self?.resolveAddressIfLatest(
                coordinate: lookupCoordinate,
                generation: generation
            )
        }
    }

    func handleUpdateCurrencySymbol(_ symbol: String) {
        mutate { state in
            state.currencySymbol = symbol
        }
    }

    func handleSelectPurpose(_ purpose: SouvenirPurpose) {
        mutate { state in
            state.purpose = purpose
        }
        trackUploadOnce(.upload(.targetAdded))
    }

    func handleTapCategory() {
        let category = state.value.category

        navigate(to: .categoryPicker(
            initailCategory: category
        ) { [weak self] selected in
            self?.handleAction(.selectCategory(selected))
        })
    }

    func handleSelectCategory(_ category: SouvenirCategory) {
        mutate { state in
            state.category = category
        }
        trackUploadOnce(.upload(.categoryAdded))
    }
}
