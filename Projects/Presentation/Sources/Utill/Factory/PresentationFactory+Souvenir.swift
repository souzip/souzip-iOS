import CoreLocation
import Domain

protocol PresentationSouvenirFactory: AnyObject {
    func makeSouvenirDetailScene(id: Int) -> RoutedScene<SouvenirRoute>
    func makeSouvenirFormScene(
        mode: SouvenirFormMode,
        onResult: ((SouvenirDetail) -> Void)?
    ) -> RoutedScene<SouvenirRoute>
    func makeSearchScene(
        onResult: @escaping (SearchResultItem) -> Void
    ) -> RoutedScene<SouvenirRoute>
    func makeLocationPicker(
        initialCoordinate: CLLocationCoordinate2D,
        onComplete: @escaping (CLLocationCoordinate2D, String) -> Void
    ) -> RoutedScene<SouvenirRoute>
    func makeCategoryPicker(
        initailCategory: SouvenirCategory?,
        onComplete: @escaping (SouvenirCategory) -> Void
    ) -> RoutedScene<SouvenirRoute>
}

extension DefaultPresentationFactory {
    func makeSouvenirDetailScene(id: Int) -> RoutedScene<SouvenirRoute> {
        let vm = SouvenirDetailViewModel(
            souvenirId: id,
            souvenirRepo: domainFactory.makeSouvenirRepository()
        )
        let view = SouvenirDetailView()
        let vc = SouvenirDetailViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }

    func makeSouvenirFormScene(
        mode: SouvenirFormMode,
        onResult: ((SouvenirDetail) -> Void)? = nil
    ) -> RoutedScene<SouvenirRoute> {
        let vm = SouvenirFormViewModel(
            mode: mode,
            onResult: onResult,
            countryRepo: domainFactory.makeCountryRepository(),
            souvenirRepo: domainFactory.makeSouvenirRepository()
        )

        let view = SouvenirFormView()
        let vc = SouvenirFormViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }

    func makeSearchScene(
        onResult: @escaping (SearchResultItem) -> Void
    ) -> RoutedScene<SouvenirRoute> {
        let vm = SearchCountryViewModel(
            onResult: onResult,
            countryRepo: domainFactory.makeCountryRepository()
        )
        let view = SearchCountryView()
        let vc = SearchCountryViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }

    func makeLocationPicker(
        initialCoordinate: CLLocationCoordinate2D,
        onComplete: @escaping (CLLocationCoordinate2D, String) -> Void
    ) -> RoutedScene<SouvenirRoute> {
        let vm = LocationPickerViewModel(onComplete: onComplete)
        let view = LocationPickerView(initialCoordinate: initialCoordinate)
        let vc = LocationPickerViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }

    func makeCategoryPicker(
        initailCategory: SouvenirCategory?,
        onComplete: @escaping (SouvenirCategory) -> Void
    ) -> RoutedScene<SouvenirRoute> {
        let vm = CategoryPickerViewModel(
            initialCategory: initailCategory,
            onCompleted: onComplete
        )
        let view = CategoryPickerView()
        let vc = CategoryPickerViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }
}
