import Domain
import MapboxMaps
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class MapboxView: UIView {
    // MARK: - Properties

    private var mapboxMapView: MapView

    private var countryBadges: [CountryBadge] = []
    private var countryAnnotations: [ViewAnnotation] = []

    // 기념품 핀 관련
    private var souvenirs: [SouvenirListItem] = []
    private var souvenirAnnotations: [ViewAnnotation] = []
    private var selectedSouvenirIndex: Int?

    // MARK: - Observables

    let mapReady = PublishRelay<Void>()
    let cameraDidMove = PublishRelay<CLLocationCoordinate2D>()

    let tapCountrybadge = PublishRelay<CountryBadge>()
    let tapSouvenirPin = PublishRelay<SouvenirListItem>()

    private let disposeBag = DisposeBag()

    // MARK: - Initializers

    override init(frame: CGRect) {
        let mapInitOptions = MapInitOptions(
            mapStyle: .standard(theme: .default, lightPreset: .night)
        )
        mapboxMapView = MapView(frame: frame, mapInitOptions: mapInitOptions)
        super.init(frame: frame)
        setMapView()
        setLocationPuck()
        setbinding()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setMapView() {
        mapboxMapView.ornaments.options.scaleBar.visibility = .hidden

        mapboxMapView.ornaments.options.logo.position = .bottomLeft
        mapboxMapView.ornaments.options.logo.margins = CGPoint(x: 0, y: 0)

        mapboxMapView.ornaments.options.attributionButton.position = .bottomLeft
        mapboxMapView.ornaments.options.attributionButton.margins = CGPoint(x: 76, y: 0)

        addSubview(mapboxMapView)

        mapboxMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setLocationPuck() {
        let puckConfiguration = Puck2DConfiguration(
            topImage: .dsCurrentLocation,
            scale: .constant(1.0)
        )

        mapboxMapView.location.options.puckType = .puck2D(puckConfiguration)
    }

    private func setbinding() {
        mapboxMapView.rx.mapLoaded
            .bind(to: mapReady)
            .disposed(by: disposeBag)

        mapboxMapView.rx.cameraChanged
            .map { [weak self] _ in
                self?.mapboxMapView.mapboxMap.cameraState.center ?? CLLocationCoordinate2D()
            }
            .bind(to: cameraDidMove)
            .disposed(by: disposeBag)
    }
}

// MARK: - Public Methods (기존)

extension MapboxView {
    func configureAsGlobe() {
        try? mapboxMapView.mapboxMap.setProjection(StyleProjection(name: .globe))
        try? mapboxMapView.mapboxMap.setCameraBounds(
            with: CameraBoundsOptions(maxZoom: 4.0, minZoom: 1.5)
        )
    }

    func configureAsMap() {
        try? mapboxMapView.mapboxMap.setProjection(StyleProjection(name: .mercator))
        try? mapboxMapView.mapboxMap.setCameraBounds(
            with: CameraBoundsOptions(maxZoom: 20.0, minZoom: 5.0)
        )
    }

    func moveCamera(
        to center: CLLocationCoordinate2D? = nil,
        zoom: CGFloat? = nil,
        animated: Bool,
        duration: TimeInterval,
        extraLift: CGFloat = 0
    ) {
        let screenCenter = UIScreen.main.bounds.height / 2
        let mapViewCenter = mapboxMapView.bounds.height / 2
        let offset = screenCenter - mapViewCenter

        let padding = UIEdgeInsets(
            top: offset - extraLift,
            left: 0,
            bottom: -offset + extraLift,
            right: 0
        )

        let cameraOptions = CameraOptions(
            center: center,
            padding: padding,
            zoom: zoom
        )

        if animated {
            mapboxMapView.camera.fly(to: cameraOptions, duration: duration)
        } else {
            mapboxMapView.camera.ease(to: cameraOptions, duration: duration)
        }
    }

    func updateCameraPadding(extraLift: CGFloat) {
        let currentState = mapboxMapView.mapboxMap.cameraState
        let currentPadding = currentState.padding

        let screenCenter = UIScreen.main.bounds.height / 2
        let mapViewCenter = mapboxMapView.bounds.height / 2
        let offset = screenCenter - mapViewCenter

        // ✅ top/left/right은 현재값 유지, bottom만 새로 계산
        let newPadding = UIEdgeInsets(
            top: offset - extraLift,
            left: currentPadding.left,
            bottom: -offset + extraLift,
            right: currentPadding.right
        )

        let cameraOptions = CameraOptions(padding: newPadding)
        mapboxMapView.mapboxMap.setCamera(to: cameraOptions)
    }

    func setCountryBadges(_ badges: [CountryBadge]) {
        countryBadges = badges

        countryAnnotations = []

        for (index, badge) in badges.enumerated() {
            let badgeView = CountryBadgeView(
                countryName: badge.countryName,
                color: badge.color,
                imageURL: badge.imageURL
            )

            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(handleBadgeViewTap(_:))
            )
            badgeView.addGestureRecognizer(tapGesture)
            badgeView.isUserInteractionEnabled = true
            badgeView.tag = index

            let annotation = ViewAnnotation(
                coordinate: badge.coordinate,
                view: badgeView
            )
            annotation.allowOverlap = false
            annotation.variableAnchors = [
                ViewAnnotationAnchorConfig(anchor: .bottom),
            ]

            countryAnnotations.append(annotation)
        }

        showCountryBadges(isHidden: false)
    }

    func showCountryBadges(isHidden: Bool) {
        if isHidden {
            countryAnnotations.forEach { $0.remove() }
        } else {
            countryAnnotations.forEach { mapboxMapView.viewAnnotations.add($0) }
        }
    }

    func showUserLocation(isHidden: Bool) {
        if isHidden {
            mapboxMapView.location.options.puckType = nil
        } else {
            setLocationPuck()
        }
    }

    func moveCameraToUserLocation() {
        guard let location = mapboxMapView.location.latestLocation?.coordinate else { return }

        let currentZoom = mapboxMapView.mapboxMap.cameraState.zoom
        moveCamera(to: location, zoom: currentZoom, animated: true, duration: 0.3)
    }
}

// MARK: - Souvenir Pin Methods

extension MapboxView {
    func setSouvenirPins(_ items: [SouvenirListItem]) {
        souvenirs = items
        souvenirAnnotations.forEach { $0.remove() }
        souvenirAnnotations = []
        selectedSouvenirIndex = nil

        for (index, souvenir) in items.enumerated() {
            let testView = SouvenirPinView(category: souvenir.category)

            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(handleSouvenirPinTap(_:))
            )
            testView.addGestureRecognizer(tapGesture)
            testView.isUserInteractionEnabled = true
            testView.tag = index

            let annotation = ViewAnnotation(
                coordinate: souvenir.coordinate.toCLLocationCoordinate2D,
                view: testView
            )
            annotation.allowOverlap = true
            annotation.visible = true
            annotation.variableAnchors = [
                ViewAnnotationAnchorConfig(anchor: .bottom),
            ]

            souvenirAnnotations.append(annotation)
        }

        showSouvenirPins(isHidden: false)
    }

    func showSouvenirPins(isHidden: Bool) {
        if isHidden {
            souvenirAnnotations.forEach { $0.remove() }
        } else {
            for annotation in souvenirAnnotations {
                mapboxMapView.viewAnnotations.add(annotation)
            }
        }
    }

    func selectSouvenirPin(item: SouvenirListItem) {
        guard let index = souvenirs.firstIndex(where: { $0.id == item.id }) else { return }
        selectSouvenirPin(at: index)
    }

    /// 모든 핀 선택 해제
    func deselectAllSouvenirPins() {
        selectSouvenirPin(at: nil)
    }
}

// MARK: - Private Methods

private extension MapboxView {
    @objc func handleBadgeViewTap(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        let index = view.tag

        guard index < countryBadges.count else { return }
        tapCountrybadge.accept(countryBadges[index])
    }

    @objc func handleSouvenirPinTap(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        let index = view.tag

        guard index < souvenirs.count else { return }

        if selectedSouvenirIndex != index {
            selectSouvenirPin(at: index)
            tapSouvenirPin.accept(souvenirs[index])
        }
    }

    /// 선택된 핀 업데이트
    func selectSouvenirPin(at index: Int?) {
        // 이전 선택 해제
        if let previousIndex = selectedSouvenirIndex,
           let previousView = souvenirAnnotations[safe: previousIndex]?.view as? SouvenirPinView {
            previousView.state = .normal
        }

        // 새로운 선택
        if let index,
           let view = souvenirAnnotations[safe: index]?.view as? SouvenirPinView {
            view.state = .selected
            selectedSouvenirIndex = index
        } else {
            selectedSouvenirIndex = nil
        }
    }
}

// MARK: - Helper Extension

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
