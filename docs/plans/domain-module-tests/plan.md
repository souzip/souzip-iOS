# domain-module-tests — Domain UseCase 전수 단위 테스트

> **Jira**: [SOU-639](https://souzip.atlassian.net/browse/SOU-639)  
> **브랜치**: `feat/SOU-639/domain-module-tests`

> **민감 정보 금지**: API 키·토큰·실계정·미공개 사업/수치·장문 내부 전략은 이 파일에 쓰지 않는다.  
> 초안·가설·장문 메모 → `draft-*` / `notes-*` (gitignore) 또는 `docs/harness/scratch/`.

## intake 요약 (2026-05-24)

| 항목 | 내용 |
|------|------|
| **완료 정의** | Domain **`Default*UseCase` 32개**(현재 `develop`) 각각 최소 1개 테스트 **또는** §검토 필요에 사유·필요 리팩터 명시 |
| **범위 밖** | Model·Error·Factory **단독** 테스트, 모델 **모든 경우수** 전수 — §「테스트 범위」 |
| **진행 방식** | Mock만으로 가능한 것은 바로 테스트 작성 · 막히거나 Sources 수정이 필요하면 문서화 → 사용자 검토 후 진행 |
| **프로덕션 코드** | **`Projects/Domain/Sources/**` 변경 금지** (승인·별도 지시 전). Tests·Mocks만 |
| **선행 작업** | [`domain-first-tests`](../domain-first-tests/plan.md) — DomainTests·Mock 패턴·⌘U 스킴 |
| **플랜 경로** | `docs/plans/domain-module-tests/plan.md` (본 파일) |

---

## 목표

`domain-first-tests`로 만든 **DomainTests** 환경 위에, Domain 레이어 **모든 Default*UseCase**에 대해 테스트 커버리지를 채운다. 비즈니스 분기가 있는 UseCase는 의미 있는 assertion을, Repository 위임만 하는 UseCase는 **Mock 호출·인자·반환** 검증으로 최소 1건을 남긴다.

---

## 비목표

- `Projects/Domain/Sources/**` 리팩터·가시성 변경 (`internal` 노출, `validateLocally` 분리 등) — §검토 필요에만 기록, **승인 전 미적용**
- Presentation / Data / Storage / Core 테스트
- `preflight.sh`에 `xcodebuild test` 추가, CI 게이트, 하네스 TDD 강제
- Domain **Model·Error·Factory** 단독 테스트 — `NicknameValidationPolicy`·`SouvenirInput` 등 **모든 필드·enum 조합** 전수 커버 **아님**
- UseCase **분기·엣지 전수** (위임형은 1건으로 충족, 분기형도 plan 완료 수준만 — 추가 시나리오는 별도 플랜)
- 기존 `ValidateNicknameUseCaseTests` 시나리오 대량 추가 (이미 파일럿 완료)
- `domain-first-tests` plan 본문 수정 (역사 기록으로 유지)

---

## 파악한 구조

### 인프라 (이미 있음)

| 항목 | 상태 |
|------|------|
| Tuist | `Project.framework(.domain, hasTests: true)` → `DomainTests` |
| 실행 | **`Domain`** 스킴( DomainTests만 ) 또는 Workspace **`수집-Tests`** · Run은 App `수집-Debug` |
| 기존 테스트 | `ValidateNicknameUseCaseTests` (7건) · `MockOnboardingRepository` |
| Repository 프로토콜 | 8개 — Auth, Country, Discovery, Notice, Onboarding, Souvenir, User, Wishlist |

## 테스트 범위 (UseCase vs Model)

| 대상 | 이 플랜 | 설명 |
|------|---------|------|
| **`Default*UseCase.execute`** | ✅ UseCase당 **≥1** test | 비즈니스 분기·Repository 위임 검증 |
| **Model** (`SouvenirDetail`, `UserProfile`, …) | ❌ 단독 테스트 없음 | Tests에서 **fixture·stub** 로만 사용 |
| **Error** (`AuthError`, `NicknameValidationError`, …) | ❌ 단독 없음 | UseCase assertion으로 **간접** 검증 (예: 닉네임 7건) |
| **Factory** (`DomainFactory` 등) | ❌ | App/Data DI 범위 |
| **Repository 프로토콜** | ❌ | **Mock** 구현체만 (`Tests/Mocks/`) |

Domain `Sources`에는 Model·Error·UseCase 외 다수 파일이 있으나, **「도메인 모델 모든 경우수」를 테스트하는 것은 이 플랜의 완료 정의가 아니다.**  
모델 로직이 UseCase 안에 있으면(예: `ValidateNickname`) 그 UseCase 테스트로 커버하고, 순수 데이터 홀더·Mapper 없는 struct는 테스트하지 않는다.

**다음 단계(별도 플랜·승인 시에만)**: 특정 Model/Policy 단독 테스트, UseCase 분기 추가, Data Mapper 테스트 등.

---

### UseCase 인벤토리 (32 — `develop` 2026-05-25)

파일명이 `*UseCase.swift`가 아닌 **`LoadRecentAuthProvider.swift`** 포함.  
**제외**: `DefaultLoadUserWishlistsUseCase` — 플랜 작성 시점에는 있었으나 현재 브랜치에 **없음** (삭제·미머지).

| # | UseCase | 유형 | 1차 테스트 방향 | 상태 |
|---|---------|------|-----------------|------|
| **Auth** |
| 1 | `DefaultAutoLoginUseCase` | 분기 | 미로그인→`.shouldLogin` / refresh 실패→`.shouldLogin` / onboarding→`.shouldOnboarding` / 성공→`.ready` | ✅ |
| 2 | `DefaultCheckFullAuthenticationUseCase` | 위임 | `isFullyAuthenticated` 결과 전달 | ✅ |
| 3 | `DefaultLoginUseCase` | 분기 | `provider == nil`→guest·`deleteAllTokens` / onboarding·ready | ✅ |
| 4 | `DefaultLogoutUseCase` | 위임 | `logout` 호출 1회 | ✅ |
| 5 | `DefaultWithdrawUseCase` | 위임 | `withdraw` 호출 1회 | ✅ |
| 6 | `DefaultLoadRecentAuthProviderUseCase` | 위임 | `loadRecentLoginProvider` 반환 전달 | ✅ |
| **Country** |
| 7 | `DefaultLoadCountryDetailUseCase` | 위임 | `loadCountry(countryCode:)` 인자·반환 | ✅ |
| 8 | `DefaultLoadLocationAddressUseCase` | 위임 | `loadAddress(latitude:longitude:)` | ✅ |
| 9 | `DefaultLoadPopularCountriesUseCase` | 위임 | `loadPopularCountries()` | ✅ |
| 10 | `DefaultSearchLocationsUseCase` | 위임 | `searchLocations(keyword:)` | ✅ |
| **Discovery** |
| 11 | `DefaultLoadAIRecommendationsForCategoryUseCase` | 위임 | repo 메서드 1회 | ✅ |
| 12 | `DefaultLoadAIRecommendationsForUploadUseCase` | 위임 | repo 메서드 1회 | ✅ |
| 13 | `DefaultLoadCountryTopSouvenirsUseCase` | 위임 | repo 메서드 1회 | ✅ |
| 14 | `DefaultLoadTopSouvenirsByCategoryUseCase` | 위임 | `category` 인자 전달 | ✅ |
| **Notice** |
| 15 | `DefaultLoadNoticeDetailUseCase` | 위임 | `getNotice(id:)` | ✅ |
| 16 | `DefaultLoadNoticesUseCase` | 위임 | `getNotices()` | ✅ |
| **Onboarding** |
| 17 | `DefaultCompleteOnboardingUseCase` | 위임 | `completeOnboarding` 반환 | ✅ |
| 18 | `DefaultSaveCategoriesUseCase` | 위임 | `saveCategories` 인자 | ✅ |
| 19 | `DefaultSaveMarketingConsentUseCase` | 위임 | `saveMarketingConsent` | ✅ |
| 20 | `DefaultSaveNicknameUseCase` | 위임 | `saveNickname` | ✅ |
| 21 | `DefaultSaveProfileImageColorUseCase` | 위임 | `saveProfileImageColor` | ✅ |
| 22 | `DefaultValidateNicknameUseCase` | 분기 | **완료** (`ValidateNicknameUseCaseTests`) | ✅ |
| **Souvenir** |
| 23 | `DefaultCreateSouvenirUseCase` | 위임 | `createSouvenir(input:images:)` | ✅ |
| 24 | `DefaultDeleteSouvenirUseCase` | 위임 | `deleteSouvenir(id:)` | ✅ |
| 25 | `DefaultLoadNearbySouvenirsUseCase` | 위임 | `loadNearbySouvenirs` 인자 3개 | ✅ |
| 26 | `DefaultLoadSouvenirDetailUseCase` | 위임 | `loadSouvenir(id:)` | ✅ |
| 27 | `DefaultUpdateSouvenirUseCase` | 위임 | `updateSouvenir(id:input:)` | ✅ |
| **User** |
| 28 | `DefaultLoadUserProfileUseCase` | 위임 | `getUserProfile()` | ✅ |
| 29 | `DefaultLoadUserSouvenirsUseCase` | 위임 | `page`·`size` 전달 | ✅ |
| 30 | `DefaultUploadPromptBubbleUseCase` | 분기 | `shouldShowBubble` / `markViewed` 각 1건 이상 | ✅ |
| **Wishlist** |
| 31 | `DefaultAddToWishlistUseCase` | 위임 | `addToWishlist(souvenirId:)` | ✅ |
| 32 | `DefaultRemoveFromWishlistUseCase` | 위임 | `removeFromWishlist(souvenirId:)` | ✅ |

**유형 설명**

- **분기**: `guard`·`if`·enum 반환 등 Mock 상태 조합으로 검증 가치 큼
- **위임**: `execute`가 Repository 한 줄 호출 — Mock **callCount·전달 인자·stub 반환**으로 1건

---

## 검토 필요 (Sources 변경·블로커)

implement 중 막히면 **행 추가**. 승인 전 Sources 수정 금지.

| UseCase | 이슈 | 제안 (승인 후) | 상태 |
|---------|------|----------------|------|
| _(없음 — 리서치 시점)_ | — | — | — |

**리서치 시 예상**

- 32개 모두 `public execute` 경로로 Mock 테스트 **가능** (private 메서드 직접 테스트 불필요).
- `LoginUser`·`CountryDetail` 등 반환 타입은 Tests에서 **최소 fixture** 또는 기존 Domain initializer로 stub (Sources 변경 없이).
- 위임형만으로는 회귀 방지 가치가 낮음 → 완료 정의상 **1건은 작성**하되, §검토 필요에 “가치 낮음”을 적지 않음 (옵션 1 충족).

---

## 변경 계획

### 공통 규칙 (Tests)

- **함수명**: `test_{조건}_{기대결과}` — 세그먼트 **한글 2개** (`domain-first-tests`와 동일)
- **constitution**: `force_unwrapping`·**IUO(`Type!`) 금지** — `setUp`에서 일반 Optional 할당 후 `guard let` / `XCTUnwrap`, 또는 테스트 메서드 내 지역 `let sut = Default…(...)`
- **파일 배치**: `Projects/Domain/Tests/{Feature}/{Name}UseCaseTests.swift` (기존 Onboarding과 동일)
- **Mock 배치**: `Projects/Domain/Tests/Mocks/Mock{Repository}.swift` — 미호출 메서드는 `XCTFail("unexpected …")` 또는 no-op (파일럿 MockOnboarding 패턴)

### `Projects/Domain/Tests/Mocks/` (신규 7 + 기존 1)

| 파일 | 이유 |
|------|------|
| `MockAuthRepository.swift` | Auth 6 UseCase |
| `MockCountryRepository.swift` | Country 4 |
| `MockDiscoveryRepository.swift` | Discovery 4 |
| `MockNoticeRepository.swift` | Notice 2 |
| `MockSouvenirRepository.swift` | Souvenir 5 |
| `MockUserRepository.swift` | User 3 |
| `MockWishlistRepository.swift` | Wishlist 2 |
| `MockOnboardingRepository.swift` | **기존** — Onboarding Save*·Complete용 stub 확장만 |

- **Before**: Onboarding Mock 1개만
- **After** (발췌 — 위임 검증 패턴):

```swift
final class MockAuthRepository: AuthRepository {
    var logoutCallCount = 0

    func logout() async throws {
        logoutCallCount += 1
    }

    // 나머지 protocol 요구사항: 미사용 시 XCTFail 또는 기본 stub
}
```

```swift
func test_로그아웃호출_한번위임() async throws {
    let mock = MockAuthRepository()
    let sut = DefaultLogoutUseCase(authRepo: mock)
    try await sut.execute()
    XCTAssertEqual(mock.logoutCallCount, 1)
}
```

### `Projects/Domain/Tests/Auth/AutoLoginUseCaseTests.swift` (신규 — 분기 예시)

- **이유**: Auth 중 분기 최다 — 패턴 SSOT
- **After** (대표):

```swift
func test_미로그인_로그인유도반환() async {
    let mock = MockAuthRepository()
    mock.checkLoginStatusResult = false
    let sut = DefaultAutoLoginUseCase(authRepo: mock)
    let result = await sut.execute()
    XCTAssertEqual(result, .shouldLogin)
}
```

### 나머지 `*UseCaseTests.swift` (신규 ~25)

- **이유**: 인벤토리 ⬜ → ✅
- **Before**: `ValidateNicknameUseCaseTests`만 존재
- **After**: Feature 폴더별 1 UseCase ≈ 1 테스트 파일 (소형 Save*는 한 파일에 묶어도 됨 — **UseCase당 최소 1 test method** 유지)

**구현 순서 (권장)**

1. Mocks 7종 (컴파일 가능한 전체 protocol 구현)
2. **Auth** → **User** (`UploadPromptBubble`) → **Onboarding** (Save*·Complete)
3. **Country** · **Discovery** · **Notice** · **Souvenir** · **Wishlist**

### `Projects/Domain/Sources/**`

- **변경 없음** (intake 옵션 1)

---

## 완료 기준

- [x] 인벤토리 **32** UseCase (`develop`) — 각각 ✅ 테스트 파일에 1건 이상 **또는** §검토 필요 표에 사유·리팩터 제안
- [x] `DomainTests` — IUO·force unwrap 없음 ([`constitution.md`](../../harness/constitution.md)) · `ValidateNicknameUseCaseTests` IUO 제거
- [x] (기계) `tuist generate` 성공
- [x] (기계) `xcodebuild test -workspace Souzip.xcworkspace -scheme Domain -destination 'platform=iOS Simulator,name=iPhone 13 mini' -only-testing:DomainTests` — **45 tests, 0 failures** (2026-05-25, `LoadUserWishlists` 제외 반영)
- [x] (증거) verify 2026-05-24~25 — `Domain` 스킴 45 tests 0 failures

## 구현 메모 (2026-05-24, plan 정합 2026-05-25)

| 항목 | 내용 |
|------|------|
| **테스트 수** | **45** (`DomainTests`) — UseCase 32개 + 닉네임 분기 7건 등 |
| **UseCase 수** | **32** (`develop`; 구 플랜 33은 `LoadUserWishlists` 포함 기준) |
| **신규** | Mocks 7 · `DomainTestFixtures` · Feature별 Tests 10파일 |
| **Sources** | 변경 없음 |
| **§검토 필요** | 추가 항목 없음 |

---

## 참고

- 파일럿: [`docs/plans/domain-first-tests/plan.md`](../domain-first-tests/plan.md)
- 레이어 규칙: [`docs/harness/context/README.md`](../../harness/context/README.md)
- 승인 후 implement: 「**구현해**」
