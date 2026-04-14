import Foundation

public protocol CreateSouvenirUseCase {
    func execute(input: SouvenirInput, images: [Data]) async throws -> SouvenirDetail
}

public final class DefaultCreateSouvenirUseCase: CreateSouvenirUseCase {
    private let souvenirRepo: SouvenirRepository

    public init(souvenirRepo: SouvenirRepository) {
        self.souvenirRepo = souvenirRepo
    }

    public func execute(input: SouvenirInput, images: [Data]) async throws -> SouvenirDetail {
        try await souvenirRepo.createSouvenir(input: input, images: images)
    }
}
