final class AppContainer {
    private static var stored: AppContainer?

    static var shared: AppContainer {
        guard let stored else {
            fatalError("AppContainer.bootstrap(config:)를 먼저 호출해야 합니다.")
        }
        return stored
    }

    let factory: AppFactory

    private lazy var pushTokenSyncerInstance: PushTokenSyncing = factory.makePushTokenSyncer()

    var pushTokenSyncer: PushTokenSyncing {
        pushTokenSyncerInstance
    }

    private init(config: AppConfiguration) {
        factory = AppFactory(config: config)
    }

    static func bootstrap(config: AppConfiguration) {
        guard stored == nil else { return }

        stored = AppContainer(config: config)
    }
}
