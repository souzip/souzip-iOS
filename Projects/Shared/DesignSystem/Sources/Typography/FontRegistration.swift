import CoreText
import Logger
import UIKit

public final class FontRegistration {
    private static var isRegistered = false

    public static func register() {
        guard !isRegistered else {
            Logger.shared.warning(
                "폰트가 이미 등록되어 있습니다.",
                category: .general
            )
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
        Logger.shared.info(
            "폰트 등록이 완료되었습니다. (\(successCount)/\(fontNames.count)개 등록)",
            category: .general
        )
    }

    @discardableResult
    private static func registerFont(
        named name: String,
        withExtension ext: String,
        in bundle: Bundle
    ) -> Bool {
        guard let fontURL = bundle.url(forResource: name, withExtension: ext) else {
            Logger.shared.error(
                "폰트 파일을 찾을 수 없습니다: \(name).\(ext)",
                category: .general
            )
            return false
        }

        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterFontsForURL(
            fontURL as CFURL,
            .process,
            &error
        )

        if !success,
           let error = error?.takeRetainedValue() {
            Logger.shared.error(
                "폰트 등록에 실패했습니다: \(name) (\(error.localizedDescription))",
                category: .general
            )
            return false
        }

        return true
    }
}
