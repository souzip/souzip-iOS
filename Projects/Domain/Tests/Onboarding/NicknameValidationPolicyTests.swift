import XCTest
@testable import Domain

/// `NicknameValidationPolicy` 상수·허용 문자 집합 계약 검증 (Model 단독 테스트 없음).
final class NicknameValidationPolicyTests: XCTestCase {
    private let policy = NicknameValidationPolicy()

    // MARK: - 길이 상수

    func test_기본값_최소2최대11() {
        XCTAssertEqual(policy.minLength, 2)
        XCTAssertEqual(policy.maxLength, 11)
    }

    func test_새인스턴스_길이상수동일() {
        let other = NicknameValidationPolicy()
        XCTAssertEqual(other.minLength, policy.minLength)
        XCTAssertEqual(other.maxLength, policy.maxLength)
    }

    func test_최소최대_양의정수() {
        XCTAssertGreaterThan(policy.minLength, 0)
        XCTAssertGreaterThan(policy.maxLength, policy.minLength)
    }

    // MARK: - 허용 문자 (영문·숫자·완성형 한글)

    func test_영문소문자_전부허용() throws {
        for scalar in UnicodeScalar("a").value ... UnicodeScalar("z").value {
            let character = try Character(XCTUnwrap(UnicodeScalar(scalar)))
            XCTAssertTrue(isAllowed(character), "expected allowed: \(character)")
        }
    }

    func test_영문대문자_전부허용() throws {
        for scalar in UnicodeScalar("A").value ... UnicodeScalar("Z").value {
            let character = try Character(XCTUnwrap(UnicodeScalar(scalar)))
            XCTAssertTrue(isAllowed(character), "expected allowed: \(character)")
        }
    }

    func test_아라비아숫자_전부허용() {
        for digit in "0123456789" {
            XCTAssertTrue(isAllowed(digit), "expected allowed: \(digit)")
        }
    }

    func test_완성형한글경계_허용문자포함() {
        XCTAssertTrue(isAllowed(Character("\u{AC00}"))) // 가
        XCTAssertTrue(isAllowed(Character("\u{D7A3}"))) // 힣
    }

    func test_혼합허용닉네임_전부허용() {
        let samples = ["ab", "AB", "12", "가나", "Test12가", "Z9힣"]
        for sample in samples {
            XCTAssertTrue(
                containsOnlyAllowed(sample),
                "expected allowed: \(sample)"
            )
        }
    }

    func test_최대길이11자_문자검사통과() {
        let eleven = String(repeating: "a", count: policy.maxLength)
        XCTAssertEqual(eleven.count, 11)
        XCTAssertTrue(containsOnlyAllowed(eleven))
    }

    func test_빈문자열_문자검사통과() {
        // 길이 검증은 UseCase — 문자 집합만 보면 빈 문자열은 통과
        XCTAssertTrue(containsOnlyAllowed(""))
    }

    // MARK: - 비허용 문자

    func test_한글자모_허용문자제외() {
        let jamo = ["ㄱ", "ㄴ", "ㅏ", "ㅑ", "ㅎ", "ㆍ"]
        for sample in jamo {
            XCTAssertFalse(isAllowed(Character(sample)), "expected disallowed: \(sample)")
        }
    }

    func test_완성형범위직전_허용문자제외() {
        XCTAssertFalse(isAllowed(Character("\u{ABFF}")))
    }

    func test_완성형범위직후_허용문자제외() {
        XCTAssertFalse(isAllowed(Character("\u{D7A4}")))
    }

    func test_공백류_허용문자제외() {
        let samples = [" ", "\t", "\n", "\r"]
        for sample in samples {
            XCTAssertFalse(
                containsOnlyAllowed(sample),
                "expected disallowed: \(sample.debugDescription)"
            )
        }
    }

    func test_특수문자_허용문자제외() {
        let samples = ["@", ".", ",", "!", "?", "-", "_", "/", "\\", "(", ")", "#", "&", "*"]
        for sample in samples {
            XCTAssertFalse(
                isAllowed(Character(sample)),
                "expected disallowed: \(sample)"
            )
        }
    }

    func test_이모지_허용문자제외() {
        XCTAssertFalse(containsOnlyAllowed("😀"))
        XCTAssertFalse(containsOnlyAllowed("👍"))
    }

    func test_전각영문_허용문자제외() {
        XCTAssertFalse(containsOnlyAllowed("Ａ"))
        XCTAssertFalse(containsOnlyAllowed("ａ"))
    }

    func test_전각숫자_decimalDigits포함_허용문자포함() {
        // Policy가 `.decimalDigits`를 쓰므로 전각 숫자도 허용됨 — 제품에서 막으려면 Policy 정의 변경 필요
        XCTAssertTrue(containsOnlyAllowed("１"))
        XCTAssertTrue(containsOnlyAllowed("９"))
    }

    func test_라틴확장문자_허용문자제외() {
        XCTAssertFalse(isAllowed("é"))
        XCTAssertFalse(isAllowed("ñ"))
    }

    func test_키릴문자_허용문자제외() {
        XCTAssertFalse(isAllowed("а"))
        XCTAssertFalse(isAllowed("Я"))
    }

    func test_일본어_허용문자제외() {
        XCTAssertFalse(containsOnlyAllowed("あ"))
        XCTAssertFalse(containsOnlyAllowed("ア"))
    }

    func test_한자_허용문자제외() {
        XCTAssertFalse(containsOnlyAllowed("漢"))
        XCTAssertFalse(containsOnlyAllowed("字"))
    }

    func test_혼합문자열_불허한글자포함_전체불허() {
        let samples = ["ab@c", "가나@", "12 34", "valid😀", "a\u{200B}b"]
        for sample in samples {
            XCTAssertFalse(
                containsOnlyAllowed(sample),
                "expected disallowed: \(sample)"
            )
        }
    }

    // MARK: - Helpers

    private func isAllowed(_ character: Character) -> Bool {
        NicknamePolicyTestSupport.isAllowed(character, policy: policy)
    }

    private func containsOnlyAllowed(_ string: String) -> Bool {
        NicknamePolicyTestSupport.containsOnlyAllowedCharacters(string, policy: policy)
    }
}
