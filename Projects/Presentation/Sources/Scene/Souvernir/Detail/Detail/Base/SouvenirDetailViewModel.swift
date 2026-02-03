import Domain
import Foundation

final class SouvenirDetailViewModel: BaseViewModel<
    SouvenirDetailState,
    SouvenirDetailAction,
    SouvenirDetailEvent,
    SouvenirRoute
> {
    // MARK: - Properties

    private let souvenirRepo: SouvenirRepository

    // MARK: - Init

    init(
        souvenirId: Int,
        souvenirRepo: SouvenirRepository
    ) {
        self.souvenirRepo = souvenirRepo
        super.init(initialState: State())

        Task {
            await fetchDetail(id: souvenirId)
        }
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .back:
            navigate(to: .pop)

        case .edit:
            guard let detail = state.value.detail else { return }

            navigate(
                to: .edit(detail: detail) { [weak self] editedDetail in
                    let newDetail = SouvenirDetail(
                        id: editedDetail.id,
                        name: editedDetail.name,
                        localPrice: editedDetail.localPrice,
                        currencySymbol: editedDetail.currencySymbol,
                        krwPrice: editedDetail.krwPrice,
                        description: editedDetail.description,
                        address: editedDetail.address,
                        locationDetail: editedDetail.locationDetail,
                        coordinate: editedDetail.coordinate,
                        category: editedDetail.category,
                        purpose: editedDetail.purpose,
                        countryCode: editedDetail.countryCode,
                        isOwned: editedDetail.isOwned,
                        owner: editedDetail.owner,
                        files: detail.files
                    )

                    self?.mutate { $0.detail = newDetail }
                }
            )

        case .delete:
            emit(.showDeleteAlert)

        case .etc:
            emit(.showReport)

        case .tapCopy:
            guard let address = state.value.detail?.address else { return }
            emit(.copy(address))

        case .confirmDelete:
            Task { await handleConfirmDelete() }
        }
    }

    // MARK: - Private

    private func fetchDetail(id: Int) async {
        emit(.loading(true))

        do {
            let detail = try await souvenirRepo.getSouvenir(id: id)
            mutate {
                $0.detail = detail
                $0.souvenirId = id
            }
        } catch {
            emit(.showAlert(message: error.localizedDescription))
        }

        emit(.loading(false))
    }

    private func handleConfirmDelete() async {
        guard let detail = state.value.detail else { return }

        emit(.loading(true))

        do {
            try await souvenirRepo.deleteSouvenir(id: detail.id)
            handleAction(.back)
        } catch {
            emit(.showAlert(message: error.localizedDescription))
        }

        emit(.loading(false))
    }
}
