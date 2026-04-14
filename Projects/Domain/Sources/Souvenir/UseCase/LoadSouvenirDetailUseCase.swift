import Foundation

public protocol LoadSouvenirDetailUseCase {
    func execute(id: Int) async throws -> SouvenirDetail
}

public final class DefaultLoadSouvenirDetailUseCase: LoadSouvenirDetailUseCase {
    private let souvenirRepo: SouvenirRepository

    public init(souvenirRepo: SouvenirRepository) {
        self.souvenirRepo = souvenirRepo
    }

    public func execute(id: Int) async throws -> SouvenirDetail {
        try await souvenirRepo.loadSouvenir(id: id)
    }
}
