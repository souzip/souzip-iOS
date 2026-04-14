import Foundation

public protocol DeleteSouvenirUseCase {
    func execute(id: Int) async throws
}

public final class DefaultDeleteSouvenirUseCase: DeleteSouvenirUseCase {
    private let souvenirRepo: SouvenirRepository

    public init(souvenirRepo: SouvenirRepository) {
        self.souvenirRepo = souvenirRepo
    }

    public func execute(id: Int) async throws {
        try await souvenirRepo.deleteSouvenir(id: id)
    }
}
