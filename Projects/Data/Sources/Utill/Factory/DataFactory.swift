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

    // MARK: - Token Refresher

    private lazy var cachedTokenRefresher: TokenRefresher = {
        let localDataSource = DefaultAuthLocalDataSource(
            keychainStorage: keychainFactory.makeKeychainStorage(),
            userDefaultsStorage: userDefaultsFactory.makeUDStorage()
        )

        let plainClient = networkFactory.makePlainClient()

        let remoteDataSource = DefaultAuthRemoteDataSource(
            plain: plainClient,
            authed: nil,
            oauthServices: [:]
        )

        let userLocalDataSource = DefaultUserLocalDataSource(
            storage: userDefaultsFactory.makeUDStorage()
        )

        return DefaultTokenRefresher(
            authLocal: localDataSource,
            authRemote: remoteDataSource,
            userLocal: userLocalDataSource
        )
    }()

    // MARK: - Auth

    private lazy var cachedAuthRepository: AuthRepository = {
        let oauthServices = oauthServiceFactory.makeOAuthServices()

        let plainClient = networkFactory.makePlainClient()
        let authedClient = networkFactory.makeAuthedClient(cachedTokenRefresher)

        let authRemoteDataSource = DefaultAuthRemoteDataSource(
            plain: plainClient,
            authed: authedClient,
            oauthServices: oauthServices
        )

        let authLocalDataSource = DefaultAuthLocalDataSource(
            keychainStorage: keychainFactory.makeKeychainStorage(),
            userDefaultsStorage: userDefaultsFactory.makeUDStorage()
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

    // MARK: - Onboarding

    private lazy var cachedOnboardingRepository: OnboardingRepository = {
        let networkClient = networkFactory.makeAuthedClient(cachedTokenRefresher)

        let onboardingRemoteDataSource = DefaultOnboardingRemoteDataSource(
            networkClient: networkClient
        )

        let onboardingLocalDataSource = DefaultOnboardingLocalDataSource(
            storage: userDefaultsFactory.makeUDStorage()
        )

        let userLocalDataSource = DefaultUserLocalDataSource(
            storage: userDefaultsFactory.makeUDStorage()
        )

        let badWordsLocalDataSource = DefaultBadWordsLocalDataSource()

        return DefaultOnboardingRepository(
            onboardingRemote: onboardingRemoteDataSource,
            onboardingLocal: onboardingLocalDataSource,
            userLocal: userLocalDataSource,
            badWordsLocal: badWordsLocalDataSource
        )
    }()

    // MARK: - Country

    private lazy var cachedCountryLocalDataSource: CountryLocalDataSource = DefaultCountryLocalDataSource()

    private lazy var cachedCountryRepository: CountryRepository = {
        let plainClient = networkFactory.makePlainClient()
        let authedClient = networkFactory.makeAuthedClient(cachedTokenRefresher)

        let countryRemoteDataSource = DefaultCountryRemoteDataSource(
            plain: plainClient,
            authed: authedClient
        )

        return DefaultCountryRepository(
            countryRemote: countryRemoteDataSource,
            countryLocal: cachedCountryLocalDataSource
        )
    }()

    // MARK: - Souvenir

    private lazy var cachedSouvenirRepository: SouvenirRepository = {
        let plainClient = networkFactory.makePlainClient()
        let authedClient = networkFactory.makeAuthedClient(cachedTokenRefresher)

        let souvenirRemoteDataSource = DefaultSouvenirRemoteDataSource(
            plain: plainClient,
            authed: authedClient
        )

        return DefaultSouvenirRepository(
            souvenirRemote: souvenirRemoteDataSource
        )
    }()

    private lazy var cachedDiscoveryRepository: DiscoveryRepository = {
        let plainClient = networkFactory.makePlainClient()
        let authedClient = networkFactory.makeAuthedClient(cachedTokenRefresher)

        let discoveryRemoteDataSource = DefaultDiscoveryRemoteDataSource(
            plain: plainClient,
            authed: authedClient
        )

        return DefaultDiscoveryRepository(
            discoveryRemote: discoveryRemoteDataSource,
            countryLocal: cachedCountryLocalDataSource
        )
    }()

    // MARK: - User

    private lazy var cachedUserRepository: UserRepository = {
        let authedClient = networkFactory.makeAuthedClient(cachedTokenRefresher)

        let userRemoteDataSource = DefaultUserRemoteDataSource(
            networkClient: authedClient
        )

        let userLocalRemoteDataSource = DefaultUserLocalDataSource(
            storage: userDefaultsFactory.makeUDStorage()
        )

        return DefaultUserRepository(
            userRemote: userRemoteDataSource,
            userLocal: userLocalRemoteDataSource
        )
    }()

    // MARK: - Public

    public func makeAuthRepository() -> AuthRepository {
        cachedAuthRepository
    }

    public func makeOnboardingRepository() -> OnboardingRepository {
        cachedOnboardingRepository
    }

    public func makeCountryRepository() -> CountryRepository {
        cachedCountryRepository
    }

    public func makeSouvenirRepository() -> SouvenirRepository {
        cachedSouvenirRepository
    }

    public func makeDiscoveryRepository() -> DiscoveryRepository {
        cachedDiscoveryRepository
    }

    public func makeUserRepository() -> UserRepository {
        cachedUserRepository
    }
}
