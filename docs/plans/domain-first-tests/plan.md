# domain-first-tests — Domain 첫 단위 테스트 (닉네임 로컬 검증)

> **민감 정보 금지**: API 키·토큰·실계정·미공개 사업/수치·장문 내부 전략은 이 파일에 쓰지 않는다.  
> 초안·가설·장문 메모 → `draft-*` / `notes-*` (gitignore) 또는 `docs/harness/scratch/`.

## intake 요약 (2026-05)

| 항목 | 내용 |
|------|------|
| **목표** | 테스트 코드 **실습 우선** — 하네스 TDD 게이트는 다음 단계 |
| **레이어** | **Domain** |
| **파일럿** | `DefaultValidateNicknameUseCase` **로컬 검증** (길이·문자·비속어·정상·중복 분기) |
| **비목표** | preflight/verify TDD 강제, Presentation·Data 테스트, Domain 전체 커버, CI 자동화 |

---

## 목표

Domain 모듈에 **의미 있는 XCTest**를 처음 도입한다. `ValidateNicknameUseCase`의 로컬 검증 규칙을 Mock `OnboardingRepository`와 함께 검증하고, 팀이 반복할 수 있는 **테스트 파일·실행 절차**를 남긴다.

---

## 비목표

- `docs/harness/scripts/preflight.sh`에 `xcodebuild test` 추가 (후속 plan)
- `plan.md` / verify 스킬에 「테스트 필수」 게이트
- `validateLocally`를 public으로 노출하거나 별도 타입으로 **대규모 리팩터** (1차는 `execute` 경로만)
- `checkNickname` 네트워크·Data 레이어 통합 테스트
- Presentation / Data / Storage 테스트 타깃 작업

---

## 파악한 구조

### 테스트 인프라 (이미 있음)

| 항목 | 상태 |
|------|------|
| Tuist | `Project.framework(.domain, hasTests: true)` → `DomainTests` 타깃 |
| 소스 | `Projects/Domain/Tests/Base.swift` — `testExample()` (`XCTAssertTrue(true)`) 플레이스홀더만 존재 |
| Mock/Stub | 저장소 전역 **없음** (이번에 Domain Tests에 최초 도입) |
| preflight | `tuist install` + `tuist generate`만 — 테스트 실행 없음 |

### 검증 대상 UseCase

`ValidateNicknameUseCase` — 로컬 검증은 `private extension`의 `validateLocally`에 있음.

```swift
// Projects/Domain/Sources/Onboarding/UseCase/ValidateNicknameUseCase.swift (요약)
public func execute(_ nickname: String) async throws -> NicknameValidationResult {
    let validationResult = validateLocally(nickname)
    switch validationResult {
    case let .valid(validNickname):
        let isAvailable = try await onboardingRepo.checkNickname(validNickname)
        return isAvailable ? .valid(nickname: validNickname) : .invalid(..., .duplicated)
    case .invalid:
        return validationResult  // 원격 호출 없음
    }
}
```

**테스트 전략 (1차)**: `@testable import Domain`으로도 **private** 메서드는 접근 불가 → **`execute(_:)` async**만 호출한다.

- 로컬 실패 케이스: `checkNickname` **호출되지 않음** (Mock에서 call count 0으로 검증 가능)
- 로컬 성공 + 중복: Mock `checkNickname` → `false`
- 로컬 성공 + 사용 가능: Mock `checkNickname` → `true` (선택 1건)

### 정책 상수 (`NicknameValidationPolicy`)

| 규칙 | 값 |
|------|-----|
| 최소 길이 | 2 |
| 최대 길이 | 11 (초과분은 `prefix`로 잘림 후 검증) |
| 허용 문자 | 영문·숫자·완성형 한글 (`\u{AC00}`…`\u{D7A3}`) |

### Repository 의존

`OnboardingRepository` — 로컬 검증에 쓰는 메서드: `fetchBadWords()`, `execute` 성공 시 `checkNickname(_:)`.  
나머지 메서드는 Mock에서 no-op 또는 `XCTFail` (미호출 가정).

---

## 변경 계획

### `Projects/Domain/Tests/Mocks/MockOnboardingRepository.swift` (신규)

- **이유**: Domain에 테스트 더블이 없음. UseCase 단위 테스트의 최소 Mock.
- **Before**: 없음
- **After** (발췌):

```swift
import XCTest
@testable import Domain

final class MockOnboardingRepository: OnboardingRepository {
    var badWords: Set<String> = []
    var checkNicknameResult = true
    private(set) var checkNicknameCallCount = 0

    func fetchBadWords() -> Set<String> { badWords }

    func checkNickname(_ nickname: String) async throws -> Bool {
        checkNicknameCallCount += 1
        return checkNicknameResult
    }

    // save*, completeOnboarding — 테스트에서 호출 시 XCTFail 또는 빈 구현
    func saveMarketingConsent(_ isAgreed: Bool) {}
    func saveNickname(_ nickname: String) {}
    func saveProfileImageColor(_ color: ProfileImageType) {}
    func saveCategories(_ categories: [SouvenirCategory]) {}
    func completeOnboarding() async throws -> LoginUser {
        XCTFail("unexpected completeOnboarding")
        throw NSError(domain: "test", code: 0)
    }
}
```

> `LoginUser` 등 미사용 타입은 컴파일을 위해 최소 더미 반환으로 조정 가능 (implement 시 실제 시그니처에 맞춤).

---

### `Projects/Domain/Tests/Onboarding/ValidateNicknameUseCaseTests.swift` (신규)

- **이유**: 파일럿 시나리오·assert 패턴의 SSOT
- **Before**: 없음 (`Base.swift`만 존재)
- **테스트 함수명 규칙**: `test_{조건}_{기대결과}` — 세그먼트는 **한글** 2개, 언더스코어로 구분 (예: `test_최소길이미만_너무짧음반환`). `실행`·`execute` 같은 동작 접두는 넣지 않음.
- **After** (구조·대표 케이스):

```swift
import XCTest
@testable import Domain

final class ValidateNicknameUseCaseTests: XCTestCase {
    private var mockRepo: MockOnboardingRepository!
    private var sut: DefaultValidateNicknameUseCase!

    override func setUp() {
        super.setUp()
        mockRepo = MockOnboardingRepository()
        sut = DefaultValidateNicknameUseCase(onboardingRepo: mockRepo)
    }

    func test_최소길이미만_너무짧음반환() async throws {
        let result = try await sut.execute("a")
        guard case let .invalid(nickname, .tooShort(min)) = result else {
            return XCTFail("expected tooShort, got \(result)")
        }
        XCTAssertEqual(min, 2)
        XCTAssertEqual(nickname, "a")
        XCTAssertEqual(mockRepo.checkNicknameCallCount, 0)
    }

    func test_허용되지않은문자_잘못된문자반환() async throws {
        mockRepo.badWords = []
        let result = try await sut.execute("ab@")
        guard case let .invalid(_, .invalidCharacters) = result else {
            return XCTFail("expected invalidCharacters")
        }
        XCTAssertEqual(mockRepo.checkNicknameCallCount, 0)
    }

    func test_비속어포함_비속어에러반환() async throws {
        mockRepo.badWords = ["bad"]
        let result = try await sut.execute("bad")
        guard case let .invalid(_, .profanity) = result else {
            return XCTFail("expected profanity")
        }
        XCTAssertEqual(mockRepo.checkNicknameCallCount, 0)
    }

    func test_유효닉네임_사용가능성공반환() async throws {
        mockRepo.checkNicknameResult = true
        let result = try await sut.execute("ab")
        guard case let .valid(nickname) = result else {
            return XCTFail("expected valid")
        }
        XCTAssertEqual(nickname, "ab")
        XCTAssertEqual(mockRepo.checkNicknameCallCount, 1)
    }

    func test_유효닉네임_중복에러반환() async throws {
        mockRepo.checkNicknameResult = false
        let result = try await sut.execute("validnick")
        guard case let .invalid(_, .duplicated) = result else {
            return XCTFail("expected duplicated")
        }
        XCTAssertEqual(mockRepo.checkNicknameCallCount, 1)
    }

    func test_최대길이초과_잘린뒤성공반환() async throws {
        mockRepo.checkNicknameResult = true
        let long = String(repeating: "a", count: 15)
        let result = try await sut.execute(long)
        guard case let .valid(nickname) = result else {
            return XCTFail("expected valid after truncate")
        }
        XCTAssertEqual(nickname.count, 11)
    }
}
```

**시나리오 체크리스트** (implement 시 위 테스트로 커버):

| # | 테스트 함수명 | 입력·조건 | 기대 `NicknameValidationResult` | `checkNickname` 호출 |
|---|---------------|-----------|--------------------------------|----------------------|
| 1 | `test_최소길이미만_너무짧음반환` | `"a"` | `.invalid` · `.tooShort(min: 2)` | 0 |
| 2 | `test_허용되지않은문자_잘못된문자반환` | `"ab@"` 또는 이모지 포함 | `.invalid` · `.invalidCharacters` | 0 |
| 3 | `test_비속어포함_비속어에러반환` | `badWords`에 포함 | `.invalid` · `.profanity` | 0 |
| 4 | `test_유효닉네임_사용가능성공반환` | `"ab"`, repo available | `.valid` | 1 |
| 5 | `test_유효닉네임_중복에러반환` | 로컬 통과, repo duplicate | `.invalid` · `.duplicated` | 1 |
| 6 | `test_최대길이초과_잘린뒤성공반환` | 15자 연속 허용 문자 | 잘린 11자로 `.valid` | 1 |

(선택) `test_한글숫자혼합_성공반환` — 회귀 방지용.

---

### `Projects/Domain/Tests/Base.swift` (삭제 또는 대체)

- **이유**: 플레이스홀더 제거, 실제 테스트만 유지
- **Before**: `testExample()` / `XCTAssertTrue(true)`
- **After**: 파일 삭제 (테스트는 `Onboarding/`·`Mocks/`로만 구성)

---

### Domain 프로덕션 코드 (`ValidateNicknameUseCase.swift` 등)

- **이유**: 1차 범위는 **테스트 추가만**
- **Before / After**: **변경 없음** (`execute` public API로 충분)

**후속(비목표·별 plan)**: 로컬 검증이 더 늘면 `NicknameLocalValidator` 등으로 추출해 private 없이 테스트.

---

## 검증 (implement · verify 시)

### 1. 기준선

```bash
docs/harness/scripts/preflight.sh
```

### 2. 테스트 실행

**Xcode (권장)**

1. `tuist generate` 후 `Souzip.xcworkspace` 열기  
2. 스킴 **Domain** 선택 → `Product` → `Test` (⌘U)  
3. `DomainTests` / `ValidateNicknameUseCaseTests` 전부 통과

**CLI (선택·로컬)**

시뮬레이터 이름은 환경에 맞게 조정.

```bash
xcodebuild test \
  -workspace Souzip.xcworkspace \
  -scheme Domain \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -only-testing:DomainTests
```

### 3. 레이어·컨벤션

- Domain `Sources/`에 XCTest·Mock 추가 **금지** — Tests 타깃만
- `import` 순서: 일반 import → `@testable import Domain` 맨 아래
- 테스트 메서드명: `test_{조건}_{기대결과}` 한글 2세그먼트 (이 plan §변경 계획 규칙)
- `force_unwrapping` 금지 유지

---

## 완료 기준

- [x] `MockOnboardingRepository` + `ValidateNicknameUseCaseTests` 추가, `Base.swift` 플레이스홀더 제거
- [x] 위 시나리오 표 **1~6** 포함 + 선택 `test_한글숫자혼합_성공반환`, 테스트 함수명 **한글 `test_…` 규칙** 준수
- [x] Xcode에서 **Domain** 스킴 테스트 전부 통과
- [x] `preflight.sh` 성공 (`tuist install` + `generate`)
- [x] (증거) `xcodebuild test -scheme Domain` → **TEST SUCCEEDED**, 7 tests, 0 failures (2026-05-24, iPhone 13 mini Simulator)

---

## 구현 순서 (「구현해」 후)

1. `MockOnboardingRepository.swift` 추가 (컴파일 통과)
2. `ValidateNicknameUseCaseTests.swift` 추가
3. `Base.swift` 삭제
4. `tuist generate` → Domain 테스트 실행
5. 실패 시 프로덕션 수정은 **버그 확인 후 최소 변경**만 (리팩터는 별도 합의)

---

## 참고

- Domain 패턴: [`docs/harness/context/domain-and-data.md`](../../harness/context/domain-and-data.md)
- 레이어 의존: [`docs/harness/context/layers.md`](../../harness/context/layers.md)
- 하네스 TDD 강화: 별도 plan (`preflight` test, verify 체크리스트) — **이 plan 범위 밖**

---

## 승인 후

플랜 내용이 괜찮으면 **「구현해」** 또는 **「구현 시작해」**로 implement(G1) 진행.
