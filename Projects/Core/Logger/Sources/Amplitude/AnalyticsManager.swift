import AmplitudeSwift
import Foundation

public final class AnalyticsManager {
    public static let shared = AnalyticsManager()

    private var amplitude: Amplitude?

    private init() {}

    // MARK: - Configuration

    public func configure(apiKey: String) {
        // screenViews를 제외한 autocapture 설정
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

    public func track(event: AnalyticsEvent) {
        amplitude?.track(
            eventType: event.eventType,
            eventProperties: event.properties
        )
    }
}
