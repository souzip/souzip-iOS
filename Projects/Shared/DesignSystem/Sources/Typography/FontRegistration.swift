import CoreText
import Logger
import UIKit

public final class FontRegistration {
    private static var isRegistered = false
    private static let logger = Logger.shared

    public static func register() {
        guard !isRegistered else {
            logger.warning("Fonts already registered", category: .general)
            return
        }

        let bundle = Bundle(for: FontRegistration.self)

        let fontNames = [
            "Pretendard-Black",
            "Pretendard-Bold",
            "Pretendard-ExtraBold",
            "Pretendard-ExtraLight",
            "Pretendard-Light",
            "Pretendard-Medium",
            "Pretendard-Regular",
            "Pretendard-SemiBold",
            "Pretendard-Thin",
        ]

        var successCount = 0
        for fontName in fontNames
            where registerFont(named: fontName, withExtension: "otf", in: bundle) {
            successCount += 1
        }

        isRegistered = true
        logger.info("Font registration completed: \(successCount)/\(fontNames.count) fonts registered", category: .general)
    }

    @discardableResult
    private static func registerFont(
        named name: String,
        withExtension ext: String,
        in bundle: Bundle
    ) -> Bool {
        guard let fontURL = bundle.url(forResource: name, withExtension: ext) else {
            logger.error("Font file not found: \(name).\(ext)", category: .general)
            return false
        }

        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)

        if !success,
           let error = error?.takeRetainedValue() {
            logger.error("Failed to register font \(name): \(error)", category: .general)
            return false
        }

        return true
    }
}
