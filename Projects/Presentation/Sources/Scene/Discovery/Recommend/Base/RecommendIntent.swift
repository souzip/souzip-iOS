import Domain

// MARK: - Action / Event

enum RecommendAction {
    case back
    case viewDidLoad

    case countryChipTap(CountryChipItem)
    case souvenirCardTap(SouvenirCardItem)
    case uploadButtonTap

    case preferredMoreTap
    case uploadMoreTap
}

enum RecommendEvent {
    case showErrorAlert(message: String)
    case loading(Bool)
}

// MARK: - State

struct RecommendState {
    var countries: [CountryChipItem] = []
    var preferredSouvenirs: [SouvenirCardItem] = []

    var uploadSouvenirs: [SouvenirCardItem] = []
    var uploadCountryName: String?

    var isPreferredExpanded: Bool = false
    var isUploadExpanded: Bool = false
}

extension RecommendState {
    var sectionModels: [RecommendSectionModel] {
        makeSectionModels(
            countries: countries,
            preferredSouvenirs: preferredSouvenirs,
            uploadSouvenirs: uploadSouvenirs,
            uploadCountryName: uploadCountryName,
            isPreferredExpanded: isPreferredExpanded,
            isUploadExpanded: isUploadExpanded
        )
    }
}

private extension RecommendState {
    func makeSectionModels(
        countries: [CountryChipItem],
        preferredSouvenirs: [SouvenirCardItem],
        uploadSouvenirs: [SouvenirCardItem],
        uploadCountryName: String?,
        isPreferredExpanded: Bool,
        isUploadExpanded: Bool
    ) -> [RecommendSectionModel] {
        var models: [RecommendSectionModel] = []

        // 1) 선호 카테고리 기반 - chips (항상)
        models.append(.init(
            section: .preferredCategoryChips,
            items: countries.map { .countryChip($0) }
        ))

        // 2) 선호 카테고리 기반 - cards (비었으면 empty 1개)
        if preferredSouvenirs.isEmpty {
            models.append(.init(
                section: .preferredCategoryCards,
                items: [.empty(id: "preferred-empty", text: "비어있습니다")]
            ))
        } else {
            let preferredVisible = isPreferredExpanded
                ? preferredSouvenirs
                : Array(preferredSouvenirs.prefix(4))

            models.append(.init(
                section: .preferredCategoryCards,
                items: preferredVisible.map { .souvenirCard($0) }
            ))

            // 3) 더보기(4개 초과일 때만)
            if isPreferredExpanded {
                models.append(.init(
                    section: .preferredMore,
                    items: [.moreButton("더보기")]
                ))
            }
        }

        // spacer (업로드 섹션과 간격 분리)
        models.append(.init(section: .spacer, items: [.spacer]))

        // 4) 업로드 기반 (있으면 cards / 없으면 empty)
        if uploadSouvenirs.isEmpty {
            models.append(.init(
                section: .uploadEmpty,
                items: [.uploadPrompt]
            ))
        } else {
            let country = uploadCountryName ?? ""

            let uploadNeedsMore = uploadSouvenirs.count > 4
            let uploadVisible = isUploadExpanded
                ? uploadSouvenirs
                : Array(uploadSouvenirs.prefix(4))

            models.append(.init(
                section: .uploadBasedCards(country: country),
                items: uploadVisible.map { .souvenirCard($0) }
            ))

            if uploadNeedsMore {
                models.append(.init(
                    section: .uploadMore(country: country),
                    items: [.moreButton("더보기")]
                ))
            }
        }

        return models
    }
}
