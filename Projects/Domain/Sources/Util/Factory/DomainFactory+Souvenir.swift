public extension DefaultDomainFactory {
    func makeSouvenirRepository() -> SouvenirRepository {
        factory.makeSouvenirRepository()
    }

    func makeLoadSouvenirDetailUseCase() -> LoadSouvenirDetailUseCase {
        DefaultLoadSouvenirDetailUseCase(souvenirRepo: makeSouvenirRepository())
    }

    func makeCreateSouvenirUseCase() -> CreateSouvenirUseCase {
        DefaultCreateSouvenirUseCase(souvenirRepo: makeSouvenirRepository())
    }

    func makeUpdateSouvenirUseCase() -> UpdateSouvenirUseCase {
        DefaultUpdateSouvenirUseCase(souvenirRepo: makeSouvenirRepository())
    }

    func makeDeleteSouvenirUseCase() -> DeleteSouvenirUseCase {
        DefaultDeleteSouvenirUseCase(souvenirRepo: makeSouvenirRepository())
    }

    func makeLoadNearbySouvenirsUseCase() -> LoadNearbySouvenirsUseCase {
        DefaultLoadNearbySouvenirsUseCase(souvenirRepo: makeSouvenirRepository())
    }

    func makeConsumeSouvenirMyPageRefreshUseCase() -> ConsumeSouvenirMyPageRefreshUseCase {
        DefaultConsumeSouvenirMyPageRefreshUseCase(souvenirRepo: makeSouvenirRepository())
    }
}
