import Data
import Domain
import Foundation
import Keychain
import Logger
import Networking
import Presentation
import UserDefaults
import Utils

final class AppFactory {
    let keychainFactory: KeychainFactory
    let networkFactory: NetworkFactory
    let dataFactory: DataFactory
    let domainFactory: DomainFactory
    let presentationFactory: PresentationFactory

    init() {
        // Configuration
        let config = AppConfiguration()

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
            googleClientID: config.googleClientID,
            appleServiceID: config.appleServiceID
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

        // Presentation
        let presentationFactory = DefaultPresentationFactory(factory: domainFactory)

        self.keychainFactory = keychainFactory
        self.networkFactory = networkFactory
        self.dataFactory = dataFactory
        self.domainFactory = domainFactory
        self.presentationFactory = presentationFactory
    }
}
