import UIKit

final class GlobeViewController: BaseViewController<
    GlobeViewModel,
    GlobeView
> {
    // MARK: - Properties

    private var guideToastTask: Task<Void, Never>?

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
            if scene != .globe { dismissGuideToast() }
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

        case .showGlobeGuideToast:
            showGuideToast()
        }
    }

    // MARK: - Private

    private func showGuideToast() {
        showToast("지구본을 돌려보세요!", bottomInset: 28, duration: 3.0)

        guideToastTask = Task {
            try? await Task.sleep(for: .seconds(3))
            guard !Task.isCancelled else { return }
            showToast("나라를 누르시면 대표 여행지로 이동해요", bottomInset: 28, duration: 999)
        }
    }

    private func dismissGuideToast() {
        guideToastTask?.cancel()
        guideToastTask = nil
        hideToast()
    }

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
