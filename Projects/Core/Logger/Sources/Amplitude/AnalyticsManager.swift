import AmplitudeSwift
import Foundation

public final class AnalyticsManager {
    public static let shared = AnalyticsManager()

    private var amplitude: Amplitude?

    private init() {}

    // MARK: - Configuration

    public func configure(apiKey: String) {
        // Amplitude autocapture 설정
        let configuration = Configuration(
            apiKey: apiKey,
            autocapture: [.sessions, .appLifecycles, .screenViews]
        )

        #if DEBUG
            configuration.logLevel = LogLevelEnum.DEBUG
            configuration.optOut = true // 디버그에서는 서버 전송 안함
        #else
            configuration.logLevel = LogLevelEnum.ERROR
            configuration.optOut = false
        #endif

        amplitude = Amplitude(configuration: configuration)
    }

    // MARK: - User Identity

    /// 로그인/자동로그인 완료 시점에 호출하여 user_id를 설정
    public func setUserId(_ userId: String) {
        amplitude?.setUserId(userId: userId)
    }

    // MARK: - Tracking

    public func track(event: AnalyticsEvent) {
        amplitude?.track(
            eventType: event.eventType,
            eventProperties: event.properties
        )
    }
}
