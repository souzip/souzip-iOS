import Domain
import UIKit

extension SouvenirFormViewModel {
    func handleSubmit() {
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

    func makeSubmitInput() -> SouvenirInput? {
        let currentState = state.value

        guard let coordinate = currentState.coordinate,
              let category = currentState.category
        else { return nil }

        let price: Int? = currentState.price.isEmpty ? nil : Int(currentState.price)
        let currencyCode: String? = if currentState.currencySymbol == "₩" {
            "KRW"
        } else {
            try? loadCountryDetail
                .execute(countryCode: currentState.countryCode)
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

    func handleCreate(input: SouvenirInput) {
        Task {
            do {
                emit(.loading(true))
                let imageData = try convertPhotosToData(state.value.localPhotos)
                _ = try await createSouvenir.execute(
                    input: input,
                    images: imageData
                )
                userSouvenirInvalidationStore.notifyUserSouvenirsChanged()
                emit(.loading(false))
                navigate(to: .dismiss)
            } catch {
                emit(.loading(false))
                emit(.showError(error.localizedDescription))
            }
        }
    }

    func handleUpdate(id: Int, input: SouvenirInput) {
        Task {
            do {
                emit(.loading(true))
                let souvenirDetail = try await updateSouvenir.execute(id: id, input: input)
                userSouvenirInvalidationStore.notifyUserSouvenirsChanged()
                onResult?(souvenirDetail)
                emit(.loading(false))
                navigate(to: .dismiss)
            } catch {
                emit(.loading(false))
                emit(.showError(error.localizedDescription))
            }
        }
    }
}
