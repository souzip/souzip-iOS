import Domain
import FCM
import Logger
import Storage

protocol PushTokenSyncing: AnyObject {
    func sync(fcmToken: String) async
    func syncCurrentTokenIfAuthenticated() async
}

actor DefaultPushTokenSyncer: PushTokenSyncing {
    private let registerFCMToken: RegisterFCMTokenUseCase
    private let checkFullAuthentication: CheckFullAuthenticationUseCase
    private let fcmTokenProvider: FCMTokenProviding
    private let deviceIdStore: DeviceIdProviding

    private struct RegistrationKey: Hashable {
        let token: String
        let deviceId: String
    }

    private var inFlightRegistrations = Set<RegistrationKey>()

    init(
        registerFCMToken: RegisterFCMTokenUseCase,
        checkFullAuthentication: CheckFullAuthenticationUseCase,
        fcmTokenProvider: FCMTokenProviding,
        deviceIdStore: DeviceIdProviding
    ) {
        self.registerFCMToken = registerFCMToken
        self.checkFullAuthentication = checkFullAuthentication
        self.fcmTokenProvider = fcmTokenProvider
        self.deviceIdStore = deviceIdStore
    }

    func sync(fcmToken: String) async {
        await registerIfNeeded(fcmToken: fcmToken)
    }

    func syncCurrentTokenIfAuthenticated() async {
        guard let fcmToken = await fcmTokenProvider.currentToken() else { return }

        await registerIfNeeded(fcmToken: fcmToken)
    }

    private func registerIfNeeded(fcmToken: String) async {
        guard await checkFullAuthentication.execute() else { return }

        let deviceId: String
        do {
            deviceId = try await deviceIdStore.deviceId()
        } catch {
            Logger.shared.error(
                "FCM 토큰 등록용 기기 ID 준비 실패: \(error.localizedDescription)",
                category: .general
            )
            return
        }

        let registrationKey = RegistrationKey(token: fcmToken, deviceId: deviceId)
        guard !inFlightRegistrations.contains(registrationKey) else { return }
        inFlightRegistrations.insert(registrationKey)
        defer { inFlightRegistrations.remove(registrationKey) }

        let deviceInfo = DeviceInfoProvider.current()
        let registration = FCMRegistration(
            token: fcmToken,
            deviceId: deviceId,
            deviceType: .ios,
            deviceModel: deviceInfo.deviceModel,
            osVersion: deviceInfo.osVersion,
            appVersion: deviceInfo.appVersion
        )

        do {
            try await registerFCMToken.execute(registration: registration)
            Logger.shared.info("FCM 토큰 서버 등록 완료", category: .general)
        } catch {
            Logger.shared.error(
                "FCM 토큰 서버 등록 실패: \(error.localizedDescription)",
                category: .general
            )
        }
    }
}
