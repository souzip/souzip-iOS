import Foundation

public struct NicknameValidationPolicy {
    public let minLength: Int = 2
    public let maxLength: Int = 11

    public let allowedCharacterSet: CharacterSet = {
        var set = CharacterSet()

        // 영문
        set.formUnion(CharacterSet(charactersIn: "a" ... "z"))
        set.formUnion(CharacterSet(charactersIn: "A" ... "Z"))

        // 숫자
        set.formUnion(.decimalDigits)

        // 완성형 한글만
        set.formUnion(CharacterSet(charactersIn: "\u{AC00}" ... "\u{D7A3}"))

        return set
    }()
}
