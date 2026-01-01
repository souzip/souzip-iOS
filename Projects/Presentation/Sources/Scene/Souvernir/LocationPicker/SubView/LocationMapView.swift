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
}

final class LocationMapView: UIView {
    // MARK: - Properties

    private let mode: LocationMapMode
    private var mapboxMapView: MapView

    private let centerPinView: UIImageView = {
        let iv = UIImageView(image: .dsLocationPin)
        iv.contentMode = .scaleAspectFit
        return iv
    }()

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

    // MARK: - Private

    private func configure() {
        setMapView()
        setupMode()
    }

    private func setMapView() {
        // Ornaments 설정
        mapboxMapView.ornaments.options.scaleBar.visibility = .hidden
        mapboxMapView.ornaments.options.compass.visibility = .hidden

        addSubview(mapboxMapView)

        mapboxMapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(centerPinView)
        centerPinView.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
        }
    }
}
