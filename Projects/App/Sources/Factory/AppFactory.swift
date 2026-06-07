import Data
import Domain
import FCM
import Networking
import Storage
import Utils

final class AppFactory {
    let fcmTokenProvider: FCMTokenProviding
    let keychainFactory: KeychainFactory
    let networkFactory: NetworkFactory
    let dataFactory: DataFactory
    let domainFactory: DomainFactory

    init(
        config: AppConfiguration,
        fcmTokenProvider: FCMTokenProviding = DefaultFCMFactory.shared.makeFCMTokenProvider()
    ) {
        self.fcmTokenProvider = fcmTokenProvider
        // keyChain
        let keychainFactory = DefaultKeychainFactory(bundleID: AppInfo.bundleID)

        // UserDefaults
        let userDefualtsFactory = DefaultsUDFactory()

        // Network
        let networkConfig = NetworkConfiguration(
            baseURL: config.apiBaseURL,
            timeout: 30
        )
        let networkFactory = DefaultNetworkFactory(config: networkConfig)

        // Data
        let oauthConfig = OAuthConfiguration(
            kakaoAppKey: config.kakaoAppKey,
            googleClientID: config.googleClientID
        )

        let oauthServiceFactory = DefaultOAuthServiceFactory(configuration: oauthConfig)

        let dataFactory = DefaultDataFactory(
            networkFactory: networkFactory,
            oauthServiceFactory: oauthServiceFactory,
            keychainFactory: keychainFactory,
            userDefaultsFactory: userDefualtsFactory
        )

        // Domain
        let domainFactory = DefaultDomainFactory(factory: dataFactory)

        self.keychainFactory = keychainFactory
        self.networkFactory = networkFactory
        self.dataFactory = dataFactory
        self.domainFactory = domainFactory
    }
}
