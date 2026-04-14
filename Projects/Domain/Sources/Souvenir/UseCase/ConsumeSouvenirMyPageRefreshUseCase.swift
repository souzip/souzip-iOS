import Foundation

public protocol ConsumeSouvenirMyPageRefreshUseCase {
    func execute() async -> Bool
}

public final class DefaultConsumeSouvenirMyPageRefreshUseCase: ConsumeSouvenirMyPageRefreshUseCase {
    private let souvenirRepo: SouvenirRepository

    public init(souvenirRepo: SouvenirRepository) {
        self.souvenirRepo = souvenirRepo
    }

    public func execute() async -> Bool {
        await souvenirRepo.consumeMyPageRefresh()
    }
}
