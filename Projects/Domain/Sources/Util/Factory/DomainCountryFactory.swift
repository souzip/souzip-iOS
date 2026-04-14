public protocol DomainSouvenirFactory: AnyObject {
    func makeSouvenirRepository() -> SouvenirRepository

    func makeLoadSouvenirDetailUseCase() -> LoadSouvenirDetailUseCase
    func makeCreateSouvenirUseCase() -> CreateSouvenirUseCase
    func makeUpdateSouvenirUseCase() -> UpdateSouvenirUseCase
    func makeDeleteSouvenirUseCase() -> DeleteSouvenirUseCase
    func makeLoadNearbySouvenirsUseCase() -> LoadNearbySouvenirsUseCase
    func makeConsumeSouvenirMyPageRefreshUseCase() -> ConsumeSouvenirMyPageRefreshUseCase
}
