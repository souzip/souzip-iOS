import Domain

final class TermsViewModel: BaseViewModel<
    TermsState,
    TermsAction,
    TermsEvent,
    AuthRoute
> {
    // MARK: - UseCase

    private let saveMarketingConsent: SaveMarketingConsentUseCase

    // MARK: - Life Cycle

    init(
        saveMarketingConsent: SaveMarketingConsentUseCase
    ) {
        self.saveMarketingConsent = saveMarketingConsent
        super.init(initialState: State())
    }

    // MARK: - Action Handling

    override func handleAction(_ action: Action) {
        switch action {
        case .viewWillAppear:
            break

        case .tapback:
            navigate(to: .login)

        case .tapAllAgree:
            handleAllAgree()

        case let .tapTerm(type):
            handleAgreeTerm(type)

        case let .tapTermDetail(type):
            handleTermDetail(type)

        case .tapAgreeButton:
            handleAgreeButton()

        case let .confirmMarketing(agree):
            handleMarketingConfirm(agree)
        }
    }

    // MARK: - Private

    private func handleAllAgree() {
        let isAllAgreed = state.value.items.isAllAgreed

        mutate { state in
            state.age14.isAgreed = !isAllAgreed
            state.service.isAgreed = !isAllAgreed
            state.privacy.isAgreed = !isAllAgreed
            state.location.isAgreed = !isAllAgreed
            state.marketing.isAgreed = !isAllAgreed
        }
    }

    private func handleAgreeTerm(_ type: TermsType) {
        mutate { state in
            switch type {
            case .age14:
                state.age14.isAgreed.toggle()
            case .service:
                state.service.isAgreed.toggle()
            case .privacy:
                state.privacy.isAgreed.toggle()
            case .location:
                state.location.isAgreed.toggle()
            case .marketing:
                state.marketing.isAgreed.toggle()
            }
        }
    }

    private func handleTermDetail(_ type: TermsType) {
        guard let url = type.detailURL else { return }
    }

    private func handleAgreeButton() {
        guard state.value.items.isRequiredAllAgreed else { return }

        if state.value.marketing.isAgreed {
            navigate(to: .profile)
        } else {
            let message = "마케팅 수신에 미동의 시,\n이벤트/혜택 알림을 받을 수 없어요."
            emit(.showMarketingConfirm(message))
        }
    }

    private func handleMarketingConfirm(_ isAgreed: Bool) {
        if isAgreed {
            mutate { state in
                state.marketing.isAgreed = true
            }
        }

        saveMarketingConsent.execute(isAgreed: isAgreed)
        navigate(to: .profile)
    }
}
