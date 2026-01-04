import Domain

final class RecommendViewModel: BaseViewModel<
    RecommendState,
    RecommendAction,
    RecommendEvent,
    DiscoveryRoute
> {
    // MARK: - Repository

    private let discoveryRepo: DiscoveryRepository
    private let countryRepo: CountryRepository

    private var preferredAll: [DiscoverySouvenir] = []
    private var uploadAll: [DiscoverySouvenir] = []

    // MARK: - Init

    init(
        discoveryRepo: DiscoveryRepository,
        countryRepo: CountryRepository
    ) {
        self.discoveryRepo = discoveryRepo
        self.countryRepo = countryRepo
        super.init(initialState: State())
    }

    // MARK: - Action

    override func handleAction(_ action: Action) {
        switch action {
        case .viewDidLoad:
            Task { await loadInitialData() }

        case .back:
            navigate(to: .pop)

        case let .countryChipTap(item):
            Task { await handleCountryChipTap(item) }

        case let .souvenirCardTap(item):
            navigate(to: .souvenirRoute(.detail(id: item.id)))

        case .uploadButtonTap:
            navigate(to: .souvenirRoute(.create))

        case .preferredMoreTap:
            mutate { $0.isPreferredExpanded.toggle() }

        case .uploadMoreTap:
            mutate { $0.isUploadExpanded.toggle() }
        }
    }
}

// MARK: - Load

private extension RecommendViewModel {
    func loadInitialData() async {
        do {
            let (preferred, upload) = try await fetchAIRecommendations()

            preferredAll = preferred
            uploadAll = upload

            let countries = await makeCountryChips(from: preferredAll)
            let initialSelectedCode = countries.first?.countryCode

            let selectedCountries = setSelectedCountry(
                countries,
                selectedCode: initialSelectedCode
            )

            let preferredCardsAll = makePreferredCardsAll(selectedCode: initialSelectedCode)
            let uploadCardsAll = mapToCards(uploadAll)
            let uploadCountryName = await resolveUploadCountryName(from: uploadAll)

            mutate { state in
                state.countries = selectedCountries
                state.preferredSouvenirs = preferredCardsAll

                state.uploadSouvenirs = uploadCardsAll
                state.uploadCountryName = uploadCountryName

                state.isPreferredExpanded = false
                state.isUploadExpanded = false
            }
        } catch {
            emit(.showErrorAlert(message: error.localizedDescription))
        }
    }

    func fetchAIRecommendations() async throws -> (
        preferred: [DiscoverySouvenir],
        upload: [DiscoverySouvenir]
    ) {
        async let preferredTask = discoveryRepo.getAIRecommendationByPreferenceCategory()
        async let uploadTask = discoveryRepo.getAIRecommendationByPreferenceUpload()

        let preferred = try await preferredTask
        let upload = try await uploadTask

        return (preferred, upload)
    }
}

// MARK: - Tap Handling

private extension RecommendViewModel {
    func handleCountryChipTap(_ item: CountryChipItem) async {
        // 이미 선택된 칩이면 무시
        guard state.value.countries.contains(where: {
            $0.countryCode == item.countryCode && $0.isSelected
        }) == false else { return }

        mutate { state in
            state.countries = self.setSelectedCountry(
                state.countries,
                selectedCode: item.countryCode
            )
            state.isPreferredExpanded = false
        }

        let preferredCardsAll = makePreferredCardsAll(selectedCode: item.countryCode)
        mutate { $0.preferredSouvenirs = preferredCardsAll }
    }
}

// MARK: - Builders

private extension RecommendViewModel {
    func makeCountryChips(from preferred: [DiscoverySouvenir]) async -> [CountryChipItem] {
        let codes = orderedUnique(preferred.map(\.countryCode))

        var result: [CountryChipItem] = []

        for code in codes {
            guard let country = try? countryRepo.fetchCountry(countryCode: code) else {
                continue
            }

            result.append(
                CountryChipItem(
                    countryCode: country.code,
                    title: country.nameKorean,
                    flagImage: country.flagImageURL,
                    isSelected: false
                )
            )
        }

        return result
    }

    func setSelectedCountry(
        _ countries: [CountryChipItem],
        selectedCode: String?
    ) -> [CountryChipItem] {
        guard let selectedCode, !selectedCode.isEmpty else { return countries }

        return countries.map { chip in
            CountryChipItem(
                countryCode: chip.countryCode,
                title: chip.title,
                flagImage: chip.flagImage,
                isSelected: chip.countryCode.caseInsensitiveCompare(selectedCode) == .orderedSame
            )
        }
    }

    func makePreferredCardsAll(selectedCode: String?) -> [SouvenirCardItem] {
        let filtered = filterByCountry(preferredAll, countryCode: selectedCode)
        return mapToCards(filtered)
    }

    func resolveUploadCountryName(from upload: [DiscoverySouvenir]) async -> String? {
        guard let code = upload.first?.countryCode else { return nil }
        guard let country = try? countryRepo.fetchCountry(countryCode: code) else { return nil }
        return country.nameKorean
    }
}

// MARK: - Helpers

private extension RecommendViewModel {
    func mapToCards(_ souvenirs: [DiscoverySouvenir]) -> [SouvenirCardItem] {
        souvenirs.map {
            let category = koreanTitle(from: $0.category)

            return SouvenirCardItem(
                id: $0.id,
                imageURL: $0.thumbnailUrl,
                title: $0.name,
                category: category
            )
        }
    }

    func filterByCountry(
        _ souvenirs: [DiscoverySouvenir],
        countryCode: String?
    ) -> [DiscoverySouvenir] {
        guard let code = countryCode, code.isEmpty == false else { return souvenirs }
        return souvenirs.filter { $0.countryCode.caseInsensitiveCompare(code) == .orderedSame }
    }

    func orderedUnique(_ codes: [String]) -> [String] {
        var set = Set<String>()
        var result: [String] = []
        result.reserveCapacity(codes.count)

        for code in codes {
            let upper = code.uppercased()
            if set.insert(upper).inserted {
                result.append(upper)
            }
        }
        return result
    }

    private func koreanTitle(from serverCode: String) -> String {
        switch serverCode {
        case "FOOD_SNACK": "먹거리·간식"
        case "BEAUTY_HEALTH": "뷰티·헬스"
        case "FASHION_ACCESSORY": "패션·악세서리"
        case "CULTURE_TRADITION": "문화·전통"
        case "TOY_KIDS": "장난감·키즈"
        case "SOUVENIR_BASIC": "기념품 기본템"
        case "HOME_LIFESTYLE": "홈·라이프스타일"
        case "STATIONERY_ART": "문구·아트"
        case "TRAVEL_PRACTICAL": "여행·실용템"
        case "TECH_GADGET": "테크·전자제품"
        default:
            serverCode
        }
    }
}
