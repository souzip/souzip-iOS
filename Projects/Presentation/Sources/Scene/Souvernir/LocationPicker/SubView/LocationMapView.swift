import CoreLocation
import DesignSystem
import MapboxMaps
import RxCocoa
import RxSwift
import SnapKit
import UIKit

enum LocationMapMode {
    case readonly
    case editable
    case search
}

final class LocationMapView: UIView {
    // MARK: - Properties

    private let mode: LocationMapMode
    private var mapboxMapView: MapView

    private let centerPinView: UIImageView = {
        let iv = UIImageView(image: .dsLocationPinSelected)
        iv.contentMode = .scaleAspectFit
        iv.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        iv.layer.shadowOpacity = 1
        iv.layer.shadowOffset = .zero
        iv.layer.shadowRadius = 2
        return iv
    }()

    private var searchPinAnnotations: [ViewAnnotation] = []
    private var selectedIndex: Int?

    let tapSearchPinRelay = PublishRelay<Int>()

    // MARK: - Init

    init(mode: LocationMapMode, initialCoordinate: CLLocationCoordinate2D) {
        self.mode = mode

        let mapInitOptions = MapInitOptions(
            mapStyle: .standard(
                theme: .default,
                lightPreset: .night,
                showPlaceLabels: false
            ),
            cameraOptions: CameraOptions(
                center: initialCoordinate,
                zoom: 15.0
            )
        )
        mapboxMapView = MapView(frame: .zero, mapInitOptions: mapInitOptions)

        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func getCurrentCenter() -> CLLocationCoordinate2D {
        mapboxMapView.mapboxMap.cameraState.center
    }

    func updateCameraPadding(bottom: CGFloat) {
        let currentCenter = mapboxMapView.mapboxMap.cameraState.center

        let padding = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: bottom,
            right: 0
        )

        let cameraOptions = CameraOptions(
            center: currentCenter,
            padding: padding
        )

        mapboxMapView.mapboxMap.setCamera(to: cameraOptions)
    }

    func setSearchPins(_ items: [SearchResultItem]) {
        removeSearchPins()

        for (index, item) in items.enumerated() {
            let pinView = LocationSearchPinView()
            pinView.tag = index

            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(handleSearchPinTap(_:))
            )
            pinView.addGestureRecognizer(tapGesture)
            pinView.isUserInteractionEnabled = true

            let annotation = ViewAnnotation(
                coordinate: item.coordinate,
                view: pinView
            )
            annotation.allowOverlap = true
            annotation.variableAnchors = [
                ViewAnnotationAnchorConfig(anchor: .bottom),
            ]

            searchPinAnnotations.append(annotation)
            mapboxMapView.viewAnnotations.add(annotation)
        }
    }

    func removeSearchPins() {
        searchPinAnnotations.forEach { $0.remove() }
        searchPinAnnotations = []
        selectedIndex = nil
    }

    func selectSearchPin(at index: Int?) {
        guard searchPinAnnotations.indices.contains(index ?? -1) || index == nil else { return }

        // 이전 선택 해제
        if let prev = selectedIndex,
           let prevView = searchPinAnnotations[safe: prev]?.view as? LocationSearchPinView {
            prevView.state = .normal
        }

        // 새 선택
        if let index,
           let view = searchPinAnnotations[safe: index]?.view as? LocationSearchPinView {
            view.state = .selected
            selectedIndex = index
        } else {
            selectedIndex = nil
        }
    }

    func moveCamera(to coordinate: CLLocationCoordinate2D) {
        let cameraOptions = CameraOptions(
            center: coordinate,
            zoom: 15.0
        )
        mapboxMapView.camera.fly(to: cameraOptions, duration: 0.3)
    }

    @objc private func handleSearchPinTap(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        guard let index = searchPinAnnotations.firstIndex(where: { $0.view === view }) else { return }
        tapSearchPinRelay.accept(index)
    }

    // MARK: - Private

    private func configure() {
        setMapView()
        setupMode()
    }

    private func setMapView() {
        // Ornaments 설정
        mapboxMapView.ornaments.options.scaleBar.visibility = .hidden
        mapboxMapView.ornaments.options.compass.visibility = .hidden

        mapboxMapView.layer.cornerRadius = 10
        mapboxMapView.clipsToBounds = true

        addSubview(mapboxMapView)

        mapboxMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(centerPinView)
        // 카메라 center(좌표)는 뷰포트 정중앙. Globe 기념품 핀과 동일하게 핀 하단이 그 지점에 오도록 앵커.
        centerPinView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }

        try? mapboxMapView.mapboxMap.setProjection(StyleProjection(name: .mercator))
        try? mapboxMapView.mapboxMap.setCameraBounds(
            with: CameraBoundsOptions(maxZoom: 20.0, minZoom: 5.0)
        )
    }

    private func setupMode() {
        switch mode {
        case .readonly:
            // 제스처 비활성화
            mapboxMapView.gestures.options.panEnabled = false
            mapboxMapView.gestures.options.pinchEnabled = false
            mapboxMapView.gestures.options.rotateEnabled = false
            mapboxMapView.gestures.options.pitchEnabled = false

        case .editable:
            // 제스처 활성화
            mapboxMapView.gestures.options.panEnabled = true
            mapboxMapView.gestures.options.pinchEnabled = true
            mapboxMapView.gestures.options.rotateEnabled = false
            mapboxMapView.gestures.options.pitchEnabled = false

        case .search:
            // 제스처 활성화 + 센터핀 숨김
            mapboxMapView.gestures.options.panEnabled = true
            mapboxMapView.gestures.options.pinchEnabled = true
            mapboxMapView.gestures.options.rotateEnabled = false
            mapboxMapView.gestures.options.pitchEnabled = false
            centerPinView.isHidden = true
        }
    }
}

// MARK: - Helper

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
