import Domain
import Keychain
import Networking
import UserDefaults

public final class DefaultDataFactory: DataFactory {
    private let networkFactory: NetworkFactory
    private let oauthServiceFactory: OAuthServiceFactory
    private let keychainFactory: KeychainFactory
    private let userDefaultsFactory: UserDefaultsFactory

    public init(
        networkFactory: NetworkFactory,
        oauthServiceFactory: OAuthServiceFactory,
        keychainFactory: KeychainFactory,
        userDefaultsFactory: UserDefaultsFactory
    ) {
        self.networkFactory = networkFactory
        self.oauthServiceFactory = oauthServiceFactory
        self.keychainFactory = keychainFactory
        self.userDefaultsFactory = userDefaultsFactory
    }

    // MARK: - Cached Instances

    private lazy var cachedTokenRefresher: TokenRefresher = {
        let localDataSource = DefaultAuthLocalDataSource(
            keycahinStorage: keychainFactory.makeKeychainStorage(),
            userDefaultsStoarge: userDefaultsFactory.makeUDStorage()
        )

        let networkClient = networkFactory.makePlainClient()

        let remoteDataSource = DefaultAuthRemoteDataSource(
            networkClient: networkClient,
            oauthServices: [:]
        )

        let userLocalDataSource = DefaultUserLocalDataSource(
            storage: userDefaultsFactory.makeUDStorage()
        )

        return DefaultTokenRefresher(
            local: localDataSource,
            remote: remoteDataSource,
            userLocal: userLocalDataSource
        )
    }()

    private lazy var cachedAuthRepository: AuthRepository = {
        let oauthServices = oauthServiceFactory.makeOAuthServices()
        let networkClient = networkFactory.makePlainClient()

        let authRemoteDataSource = DefaultAuthRemoteDataSource(
            networkClient: networkClient,
            oauthServices: oauthServices
        )

        let authLocalDataSource = DefaultAuthLocalDataSource(
            keycahinStorage: keychainFactory.makeKeychainStorage(),
            userDefaultsStoarge: userDefaultsFactory.makeUDStorage()
        )

        let userLocalDataSource = DefaultUserLocalDataSource(
            storage: userDefaultsFactory.makeUDStorage()
        )

        return DefaultAuthRepository(
            authRemote: authRemoteDataSource,
            authLocal: authLocalDataSource,
            userLocal: userLocalDataSource
        )
    }()

    // MARK: - Public

    public func makeAuthRepository() -> AuthRepository { cachedAuthRepository }
}
