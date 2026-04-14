import Foundation

public protocol UpdateSouvenirUseCase {
    func execute(id: Int, input: SouvenirInput) async throws -> SouvenirDetail
}

public final class DefaultUpdateSouvenirUseCase: UpdateSouvenirUseCase {
    private let souvenirRepo: SouvenirRepository

    public init(souvenirRepo: SouvenirRepository) {
        self.souvenirRepo = souvenirRepo
    }

    public func execute(id: Int, input: SouvenirInput) async throws -> SouvenirDetail {
        try await souvenirRepo.updateSouvenir(id: id, input: input)
    }
}
