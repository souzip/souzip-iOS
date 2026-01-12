import UIKit

final class GlobeViewController: BaseViewController<
    GlobeViewModel,
    GlobeView
> {
    // MARK: - Bind State

    override func bindState() {
        // CountryBadges만 State에서 observe
        observe(\.countryBadges)
            .distinct()
            .onNext(contentView.renderCountryBadges)
    }

    // MARK: - Event

    override func handleEvent(_ event: Event) {
        switch event {
        case let .renderScene(scene):
            contentView.render(scene: scene, animated: true)

        case let .transitionToSheetWithoutCamera(context):
            contentView.transitionToSheetWithoutCamera(context)

        case let .scrollCarouselToItem(item):
            contentView.scrollCarouselToItem(item)

        case let .moveCameraAndSelectPin(item):
            contentView.moveCameraAndSelectPin(item)

        case let .updateSouvenirsAndPinsOnly(souvenirs):
            contentView.updateSouvenirsAndPinsOnly(souvenirs)

        case let .showSearchButton(show):
            contentView.showSearchButton(show)

        case .showLocationPermissionAlert:
            showLocationPermissionAlert()

        case let .showError(message):
            showDSAlert(message: message)
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
