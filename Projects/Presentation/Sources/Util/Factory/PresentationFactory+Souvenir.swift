import CoreLocation
import Domain

protocol PresentationSouvenirFactory: AnyObject {
    func makeSouvenirDetailScene(id: Int) -> RoutedScene<SouvenirRoute>
    func makeSouvenirFormScene(
        mode: SouvenirFormMode,
        onResult: ((SouvenirDetail) -> Void)?
    ) -> RoutedScene<SouvenirRoute>
    func makeSearchScene(context: SearchCountryContext) -> RoutedScene<SouvenirRoute>
    func makeLocationSearchResultScene(
        items: [SearchResultItem],
        searchText: String,
        centerCoordinate: CLLocationCoordinate2D,
        onConfirm: @escaping (SearchResultItem) -> Void
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
            loadSouvenirDetail: domainFactory.makeLoadSouvenirDetailUseCase(),
            deleteSouvenir: domainFactory.makeDeleteSouvenirUseCase(),
            userSouvenirInvalidationStore: userSouvenirInvalidationStore
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
            loadCountryDetail: domainFactory.makeLoadCountryDetailUseCase(),
            loadLocationAddress: domainFactory.makeLoadLocationAddressUseCase(),
            createSouvenir: domainFactory.makeCreateSouvenirUseCase(),
            updateSouvenir: domainFactory.makeUpdateSouvenirUseCase(),
            userSouvenirInvalidationStore: userSouvenirInvalidationStore
        )

        let view = SouvenirFormView()
        let vc = SouvenirFormViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }

    func makeSearchScene(context: SearchCountryContext) -> RoutedScene<SouvenirRoute> {
        let vm = SearchCountryViewModel(
            initialSearchText: context.initialQuery,
            onResult: context.onResult,
            searchLocations: domainFactory.makeSearchLocationsUseCase()
        )
        let view = SearchCountryView()
        view.render(mode: context.mode)
        let vc = SearchCountryViewController(viewModel: vm, contentView: view)

        return .init(
            vc: vc,
            route: vm.route,
            disposeBag: vc.disposeBag
        )
    }

    func makeLocationSearchResultScene(
        items: [SearchResultItem],
        searchText: String,
        centerCoordinate: CLLocationCoordinate2D,
        onConfirm: @escaping (SearchResultItem) -> Void
    ) -> RoutedScene<SouvenirRoute> {
        let vm = LocationSearchResultViewModel(
            items: items,
            searchText: searchText,
            onConfirm: onConfirm
        )
        let view = LocationSearchResultView(centerCoordinate: centerCoordinate)
        let vc = LocationSearchResultViewController(viewModel: vm, contentView: view)

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
