import Analytics
import Domain
import UIKit

extension SouvenirFormViewModel {
    /// 옵션 B: `countryCode`가 있으면 국가 메타 `currency.symbol`로 `localCurrencySymbol`을 갱신한다. 실패 시 `SouvenirFormState` 초기값 유지(편집: `detail.price.localCurrencySymbol` → `$`, 생성: `$`).
    func applyLocalCurrencySymbolFromCountryIfAvailable(countryCode: String) {
        guard !countryCode.isEmpty else { return }
        do {
            let country = try loadCountryDetail.execute(countryCode: countryCode)
            mutate { $0.localCurrencySymbol = country.currency.symbol }
        } catch {
            // 국가 조회 실패 — 폴백은 `SouvenirFormState` 편집 초기화에 위임. 로그는 네트워크/번들 계층 정책에 따름.
        }
    }

    func handleAddLocalPhotos(_ photos: [LocalPhoto]) {
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

    func handleRemoveLocalPhoto(_ id: UUID) {
        mutate { state in
            guard case .create = state.mode else { return }
            state.localPhotos.removeAll { $0.id == id }
        }
    }

    func resolveAddressIfLatest(coordinate: Coordinate, generation: UInt64) async {
        do {
            let locationAddress = try await loadLocationAddress.execute(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )

            let country = try loadCountryDetail.execute(countryCode: locationAddress.countryCode)
            await MainActor.run { [weak self] in
                guard let self else { return }
                guard generation == addressLookupGeneration else { return }
                guard state.value.coordinate == coordinate else { return }
                mutate {
                    $0.address = locationAddress.address
                    $0.currencySymbol = country.currency.symbol
                    $0.localCurrencySymbol = country.currency.symbol
                    $0.countryCode = locationAddress.countryCode
                }
            }
        } catch {
            await MainActor.run { [weak self] in
                guard let self else { return }
                guard generation == addressLookupGeneration else { return }
                guard state.value.coordinate == coordinate else { return }
                emit(.showError(error.localizedDescription))
            }
        }
    }

    func handleUpdatePrice(_ text: String) {
        let wasEmpty = state.value.price.isEmpty
        let filtered = text.filter(\.isNumber)
        mutate { state in
            state.price = filtered
        }
        if wasEmpty, !filtered.isEmpty {
            trackUploadOnce(.upload(.priceAdded))
        }
    }

    func handleUpdateDescription(_ text: String) {
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

    /// 업로드 퍼널 이벤트를 폼 세션 당 1회만 발송
    func trackUploadOnce(_ event: AnalyticsEvent) {
        guard case .create = state.value.mode else { return }
        guard !firedUploadEvents.contains(event.eventType) else { return }
        firedUploadEvents.insert(event.eventType)
        AnalyticsManager.shared.track(event: event)
    }
}

// MARK: - 위치 검색 결과 순서

extension SouvenirFormViewModel {
    /// 탭한 항목만 맨 앞으로, 나머지는 기존 상대 순서 유지
    static func searchResultsPlacingSelectedFirst(
        _ items: [SearchResultItem],
        selected: SearchResultItem
    ) -> [SearchResultItem] {
        guard let index = items.firstIndex(where: { $0.id == selected.id }) else {
            return items
        }
        var rest = items
        let chosen = rest.remove(at: index)
        return [chosen] + rest
    }
}
