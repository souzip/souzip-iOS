import CoreLocation
import Domain
import Foundation
import RxSwift

final class LocationPickerViewModel: BaseViewModel<
    LocationPickerState,
    LocationPickerAction,
    LocationPickerEvent,
    SouvenirRoute
> {
    // MARK: - Properties

    private let onComplete: (CLLocationCoordinate2D, String) -> Void

    // MARK: - Life Cycle

    init(
        onComplete: @escaping (CLLocationCoordinate2D, String) -> Void
    ) {
        self.onComplete = onComplete
        super.init(initialState: State())
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .tapBack:
            navigate(to: .pop)

        case let .detailTextChanged(text):
            mutate { state in
                state.detailText = text
            }

        case let .tapComplete(coordinate):
            handleComplete(coordinate: coordinate)
        }
    }

    // MARK: - Private

    private func handleComplete(coordinate: CLLocationCoordinate2D) {
        let detail = state.value.detailText

        onComplete(coordinate, detail)
    }
}
