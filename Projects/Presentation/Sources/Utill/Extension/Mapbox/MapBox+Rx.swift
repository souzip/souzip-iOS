import MapboxMaps
import RxCocoa
import RxSwift

extension Reactive where Base: MapView {
    var mapTap: Observable<InteractionContext> {
        Observable.create { observer in
            let interaction = TapInteraction { context in
                observer.onNext(context)
                return false
            }

            let cancelable = self.base.mapboxMap.addInteraction(interaction)

            return Disposables.create {
                cancelable.cancel()
            }
        }
    }

    var mapLoaded: Observable<Void> {
        Observable.create { observer in
            let cancelable = self.base.mapboxMap.onMapLoaded.observe { _ in
                observer.onNext(())
            }

            return Disposables.create {
                cancelable.cancel()
            }
        }
    }

    var cameraChanged: Observable<CameraChanged> {
        Observable.create { observer in
            let cancelable = self.base.mapboxMap.onCameraChanged.observe { event in
                observer.onNext(event)
            }

            return Disposables.create {
                cancelable.cancel()
            }
        }
    }
}
