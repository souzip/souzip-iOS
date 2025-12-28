import CoreLocation
import UIKit

final class GlobeViewController: BaseViewController<
    GlobeViewModel,
    GlobeView
> {
    // MARK: - Bind State

    override func bindState() {
        observe(\.mapMode)
            .distinct()
            .onNext(contentView.renderMapMode)

        observe(\.countryBadges)
            .distinct()
            .onNext(contentView.renderCountryBadges)

        observe(\.sheetViewMode)
            .distinct()
            .onNext(contentView.renderSheetViewMode)

        observe(\.souvenirs)
            .distinct()
            .onNext(contentView.renderSouvenirPins)

        observe(\.isBackButtonVisible)
            .distinct()
            .onNext(contentView.render(isBackButtonVisible:))
    }

    // MARK: - Event

    override func handleEvent(_ event: Event) {
        switch event {
        case let .moveCamera(coordinate, zoom, animated, extraLift):
            contentView.moveCamera(
                coordinate: coordinate,
                zoom: zoom,
                animated: animated,
                extraLift: extraLift
            )

        case .locationPermissionDenied:
            showLocationPermissionAlert()

        case let .locationError(message):
            showDSAlert(message: message)

        case let .moveCarouselCenter(initial):
            contentView.moveCarouselCenter(initial)

        case let .moveBottomSheetHeight(level):
            contentView.moveBottomSheetHeight(level)
        }
    }

    // MARK: - Private

    private func showLocationPermissionAlert() {
        showDSConfirmAlert(
            message: "위치 서비스를 사용하려면\n설정에서 위치 권한을 허용해주세요.",
            confirmTitle: "설정으로 이동",
            cancelTitle: "취소",
            confirmHandler: {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            },
            cancelHandler: nil
        )
    }
}
