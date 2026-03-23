# Tuist 모듈 구조 일관성 리서치

## 현재 구조 및 문제점

### Tuist 레벨: 상위 그래프는 비교적 단순하나 “레이어”와 “실제 소스 트리”가 1:1이 아님

- **모듈 열거**: `Module` enum이 App, Presentation, Domain, Data + Core 5종(Networking, Logger, Keychain, UserDefaults, AdMob) + Shared 2종(DesignSystem, Utils)만 정의됨 (`Tuist/ProjectDescriptionHelpers/Core/Module.swift`).
- **의존성 방향**: 문서화된 클린 아키텍처(App → Presentation → Domain ← Data, Core는 인프라)와 대체로 맞음. `ModuleDependencies`에서 Presentation은 Domain만 직접 두고 Data는 참조하지 않음.
- **문제**: **피처 단위 Tuist 타깃이 아니라** Domain/Data/Presentation이 각각 **단일 거대 프레임워크**다. “모듈화”는 폴더(피처 디렉터리) 수준이고, 빌드 단위·경계 강제는 최소화된 상태.

### 프로젝트 정의의 들쭉날쭉함

각 `Projects/*/Project.swift`에서 `Project.framework` 옵션이 제각각이다.

| 모듈 | hasResources | hasTests |
|------|--------------|----------|
| Presentation | ❌ | ✅ |
| Domain | ❌ | ✅ |
| Data | ✅ | ✅ |
| Networking, Logger, AdMob, Utils | ❌ | ❌ |
| Keychain, UserDefaults | ❌ | ✅ |
| DesignSystem | ✅ | ❌ |

- **테스트**: Core 일부만 단위 테스트 타깃이 있어, “인프라 모듈 = 테스트 없음” 같은 일관 규칙이 없음.
- **리소스**: Data·DesignSystem만 `Resources/**`를 쓰는 구조로 정의됨(다른 모듈은 리소스가 없거나 소스에 포함).

### 소스 트리 네이밍·스펠링 불일치 (MVP 누적 흔적)

- **`Utill`**: Domain, Data, Presentation, Networking, Keychain, UserDefaults 등 광범위에 `Utill` 폴더명 사용(표준 영어 `Util`/`Utilities`와 불일치).
- **Presentation `Scene/Souvernir`**: `Souvenir` 도메인/데이터와 철자 불일치.
- **Data `Onboarding/DTO/Netwrok`**: `Network` 오타.

### Domain 피처별 하위 폴더 패턴이 통일되지 않음

`Projects/Domain/Sources` 기준:

- `Auth`, `Location`, `Onboarding`, `User`: `Model` / `Repository` / `UseCase` / `Error`
- `Country`, `Discovery`, `Notice`, `Souvenir`: `Model` / `Repository` / `Error` — **UseCase 폴더 없음**
- `Utill`: `Factory`만 존재 (도메인 “피처”가 아닌 공통 성격)

문서(`docs/claude/architecture.md`)의 “Model / UseCase / Repository / Error” 가이드와 실제 폴더가 **피처마다 다름**.

### Data vs Domain 피처 대응

- Domain에 **`Location`** 폴더(`Model`/`Repository`/`UseCase`/`Error`)가 있으나 **현재 Swift 소스 파일이 없음**(빈 플레이스홀더). 지도·좌표 선택은 Presentation의 `LocationPicker` 등으로 처리되고, 검색/지오코딩은 **Country** Data가 담당하는 형태로 경계가 폴더 이름과 어긋남.
- Onboarding은 Domain·Data 모두에 존재하나 Data 쪽 DTO 경로에 `Netwrok` 등 정리 미비.

### Presentation 내부 구조

- 상위로 `Coordinator/`, `Scene/`, `Common/`, `Utill/` 로 구분 — 피처는 주로 `Scene`·`Coordinator` 하위에 중복 배치.
- **Tabbar** vs 문서의 **TabBar** 등 네이밍 케이스 혼재 가능성.

### SPM / 외부 라이브러리 선언

- `Tuist/Package.swift`에 **SwiftSVG** 패키지가 있으나 `ExternalLibrary`에는 없고, `Projects` 전역에서 `import` 사용도 검색되지 않음 — **미사용 또는 미정리 의존성** 후보.
- 광고·지도·분석 등 **무거운 SDK가 Presentation(Data)에 집중**되어 있어, 향후 피처 모듈로 쪼갤 때 **링크/번들 크기·빌드 캐시** 이슈가 될 수 있음.

### 워크스페이스

- `Workspace.swift`는 `"Projects/**"`로 모든 하위 `Project.swift`를 끌어옴 — 구조 변경 시 **새 폴더에 Project.swift만 두면 자동 포함**됨(명시적 나열이 아님).

---

## 영향받는 파일

- `Workspace.swift` — 워크스페이스에 포함되는 프로젝트 glob
- `Tuist/ProjectDescriptionHelpers/Core/Module.swift` — 모듈 경로·이름 단일 진실
- `Tuist/ProjectDescriptionHelpers/Dependencies/ModuleDependencies.swift` — 타깃 간 의존성 그래프
- `Tuist/ProjectDescriptionHelpers/Templates/Project+Framework.swift`, `Project+App.swift`, `Project+Testing.swift` — 타깃 생성 규칙
- `Tuist/Package.swift`, `Tuist/ProjectDescriptionHelpers/Dependencies/ExternalLibrary.swift` — SPM 제품과 모듈 연결
- `Projects/*/Project.swift` (11개) — 각 모듈의 resources/tests 플래그
- `Projects/{Presentation,Domain,Data,Core,Shared,App}/Sources/**` — 실제 물리 폴더 구조 및 `import` 경계
- `Projects/App/Sources/Factory/**` — 모듈 쪼개기 시 Factory/DI 수정 범위가 가장 큼
- `docs/claude/architecture.md`, 루트 `CLAUDE.md` — 구조 변경 후 문서 동기화 필요

---

## 기존 패턴 및 의존성

- **Tuist 헬퍼 중심**: `Project.framework(module, …)` / `Project.app()`로 중복을 줄이고, 의존성은 `ModuleDependencies.dependencies(for:)` 한곳에서 스위치 분기.
- **번들 ID 규칙**: 프레임워크는 `Environment.bundlePrefix + "." + module.rawValue.lowercased()` (`Project+Framework.swift`).
- **레이어 의존성 (의도)**:
  - App: Presentation, Domain, Data
  - Presentation: Domain + Logger, DesignSystem, Utils, AdMob + Rx/Kingfisher/Mapbox
  - Domain: Utils, Logger
  - Data: Domain + Networking, Logger, Keychain, UserDefaults, Utils + Kakao/Google Sign-In
  - Core 모듈: 대부분 Logger( 및 Utils)에 기대는 얇은 스택
- **피처 폴더**: Domain/Data는 `Souvenir`, `Auth`, `Country` 등 동일한 피처 이름으로 대칭을 이루려 하지만, Location·UseCase 유무 등으로 **대칭이 깨져 있음**.

---

## 각 모듈의 역할 (코드 기준)

Tuist 타깃 하나가 앱에서 맡는 **실질 책임**을 요약한다. (경로는 모두 `Projects/…/Sources` 이하.)

### App (`Projects/App`)

- **iOS 진입점**: `AppDelegate`, `SceneDelegate`, 윈도우/루트 네비게이션 설정.
- **구성·조립**: `AppConfiguration`(API base URL, Kakao/Google 키 등) + `AppFactory`에서 `KeychainFactory`, `NetworkFactory`, `DefaultDataFactory`, `DefaultDomainFactory`를 생성해 **Data/Domain 그래프를 한 번에 만든다**.
- **화면 시작**: `RootCoordinator`에 `DomainFactory`만 넘김 — Presentation 쪽 `DefaultPresentationFactory`는 `RootCoordinator` 내부에서 `DomainFactory`로부터 생성됨.
- **예외 의존성**: `SceneDelegate`가 OAuth URL 처리를 위해 `import Data` 후 `AuthRedirect.handle(url:)` 호출 — 엄밀한 레이어링 관점에서는 **App → Data 직접 의존**(Presentation/Domain을 거치지 않음).

### Presentation (`Projects/Presentation`)

- **UI + MVVM-C**: `Scene/`(화면별 View·ViewController·ViewModel), `Coordinator/`(피처·탭·루트 흐름), `Common/`(공통 VC/뷰), `Utill/Base`( `BaseViewModel`, `BaseView`, `BaseViewController`, `BaseCoordinator`, `Coordinator` 프로토콜 등).
- **도메인 사용**: ViewModel에서 `DomainFactory`로부터 Repository(또는 추후 UseCase)를 받아 사용. Data 모듈은 import하지 않음.
- **외부 UI/플랫폼**: RxSwift 계열, SnapKit(DesignSystem 경유), Kingfisher, **MapboxMaps**(지도/글로브 등), **AdMob 모듈**의 배너 삽입.
- **팩토리**: `PresentationFactory` 프로토콜 + `DefaultPresentationFactory`를 extension으로 피처별 분할(`PresentationFactory+Souvenir.swift` 등) — 화면 조립의 단일 진입점 역할.

### Domain (`Projects/Domain`)

- **순수 도메인 규칙의 선언부**: 피처별 `Model`, `Repository` **프로토콜**, 일부 피처에 `UseCase`, `Error`.
- **Data 경계 타입**: `Utill/Factory/DataFactory` 프로토콜이 “Repository 구현체를 누가 만드는가”를 정의 (`makeAuthRepository()` 등 7종 — Location 미포함).
- **Presentation 경계 타입**: `DomainFactory`가 피처별 팩토리 프로토콜(`DomainAuthFactory` 등)을 합성 — `DefaultDomainFactory`는 내부 `DataFactory`에 위임해 Repository를 꺼내 UseCase를 구성.
- **의존성**: `Utils`(키 타입 등), `Logger`만 Tuist 그래프상 연결 — 외부 SDK 없음.

### Data (`Projects/Data`)

- **Repository 구현체**: Domain 프로토콜을 만족하는 `Default*Repository`, Remote/Local `DataSource`, `DTO` + Mapper, `Endpoint`.
- **인증 인프라**: Kakao/Google/Apple OAuth 서비스, `TokenRefresher`, `AuthRedirect`(URL 콜백 처리) 등 — **앱 레이어에서 직접 참조되는 공개 타입**도 포함.
- **팩토리**: `DefaultDataFactory`가 Networking + Keychain + UserDefaults + OAuth를 묶어 lazy 캐시로 Repository를 생성(`Projects/Data/Sources/Utill/Factory/DataFactory.swift`).
- **의존성**: Domain(계약), Networking, Keychain, UserDefaults, Utils, Logger, Kakao/Google SPM.

### Networking (`Projects/Core/Networking`)

- **HTTP 클라이언트**: `APIEndpoint` 프로토콜, `DefaultNetworkClient`(async/await, 401 시 `TokenRefresher`로 재시도 가능한 authed/plain 팩토리 메서드), `APIResponse` 등 공통 DTO.
- **설정**: `NetworkConfiguration`, `NetworkFactory` / `DefaultNetworkFactory`.
- **역할 범위**: “어떤 API인지”는 Data의 Endpoint가 정의하고, Networking은 **전송·디코딩·토큰 갱신 훅**에 집중.

### Logger (`Projects/Core/Logger`)

- **개발 로그**: `Logger.shared` — OSLog 기반, DEBUG에서 레벨/카테고리/파일·라인 출력 (`#if DEBUG` 가드).
- **제품 분석**: `AnalyticsManager` — Amplitude 초기화, userId 설정/해제, `AnalyticsEvent` enum으로 이벤트 전송(앱/업로드 퍼널 등).
- **모듈명과 실제 역할**: 이름은 Logger이지만 **운영 분석(Amplitude)**까지 포함하는 “관측/로깅” 모듈.

### Keychain (`Projects/Core/Keychain`)

- **보안 저장소**: `KeychainStorage` 프로토콜, `DefaultKeychainStorage`(actor) — Codable 저장/조회/삭제, `KeychainError`.
- **조립**: `KeychainFactory` / `DefaultKeychainFactory`(번들 ID를 service로 사용).
- **횡단**: `Utils.KeychainKey`와 키 이름 계약을 맞춰 Data의 Auth 로컬 데이터소스 등이 사용.

### UserDefaults (`Projects/Core/UserDefaults`)

- **타입드 래퍼**: `UserDefaultsStorage` / `DefaultUDStorage`, `DefaultsKey` 기반 get/set 및 Codable encode/decode 헬퍼.
- **조립**: `UserDefaultsFactory` / `DefaultsUDFactory`.
- **횡단**: 키 정의는 `Utils`의 `*DefaultsKeys` 등과 연동.

### AdMob (`Projects/Core/AdMob`)

- **SDK 부트스트랩**: `AdMobManager` — ATT 요청 후 `MobileAds.shared.start`.
- **UI**: `AdBannerView` — `BannerView` 래핑, 단위 ID는 `Utils.AppInfo`/InfoPlist 키에서 로드, 클릭 시 `AnalyticsManager`로 배너 이벤트.
- **역할**: 광고 SDK와 앱 설정(플리스트) 사이의 **얇은 어댑터 + 배너 뷰 한 종류** 수준.

### DesignSystem (`Projects/Shared/DesignSystem`)

- **디자인 토큰·컴포넌트**: 색(`UIColor+DesignSystem`), 타이포(Pretendard 등록·`Typography*` 라벨/필드), 레이아웃 상수, `DS*` 접두어 컴포넌트(버튼, 탭바, 내비게이션 바, 알럿, 바텀시트, 토스트 등).
- **의존성**: SnapKit, Logger, Utils — Presentation이 UI 일관성을 위해 주로 사용.

### Utils (`Projects/Shared/Utils`)

- **앱·빌드 메타**: `AppInfo`, `InfoPlistKey` — 번들 ID, 광고 단위 ID 등 Info.plist/xcconfig와 매핑되는 읽기 전용 접근.
- **저장소 키 타입**: `KeychainKey`, `DefaultsKey`, `AuthDefaultsKeys`, `OnboardingDefaultsKeys`, `UserDefaultsKeys` 등 — **Domain/Data/Core가 이름 충돌 없이 같은 키를 쓰기 위한 공유 계약**.
- **특징**: 비즈니스 로직 거의 없음, **의존성 0**에 가깝고 다른 모듈의 최하단에 가깝게 둔 공유 유틸.

---

## 위험 요소

1. **대규모 이동/리네임**: `Utill` → `Util` 등 물리 경로 변경은 Xcode 프로젝트가 아닌 Tuist 소스 glob 기준이라 비교적 단순하지만, **Git 히스토리·팀 습관·문서 링크** 충돌 가능.
2. **단일 프레임워크 유지 채택 시**: Tuist “모듈” 수는 그대로라도 **폴더/네이밍 규약만 통일**하는 것은 리스크가 낮고, **피처별 Tuist 타깃 분리**는 Factory, `import`, CI 시간, 순환 의존 검출까지 영향 범위가 큼.
3. **Presentation의 AdMob·Mapbox**: 피처 모듈화 시 **옵션 타깃** 또는 **인터페이스 모듈 + 구현 모듈** 없이 나누면 의존성 역전 위반이나 중복 타입 문제가 생기기 쉬움.
4. **Domain UseCase 유무 불균형**: 구조 통일 시 “모든 피처에 UseCase”로 맞출지, “Coordinator/UseCase 없이 Repository 직접” 피처를 허용할지 **아키텍처 결정**이 선행되어야 함.
5. **미사용 SPM**: SwiftSVG 제거/연결 여부를 정하지 않으면 `tuist install`·해결 시간만 증가.
6. **Derived 폴더**: 일부 모듈(App, DesignSystem, Data) 아래 `Derived/Sources`가 보임 — Tuist 생성물/로컬 산출물과 소스 혼재 시 **정리 정책**(gitignore, 경로)을 재확인할 필요가 있음.

---

## 정리

현재 “Tuist 모듈”은 **레이어별 소수 프레임워크**로 잘 정리되어 있으나, **그 안의 피처 폴더·철자·UseCase 유무·Data/Domain 대칭**은 MVP 속도 우선으로 인한 **일관성 결여**가 뚜렷하다. 다음 단계(플랜)에서는 (A) **물리 구조·네이밍만 통일**할지, (B) **피처 단위 Tuist 타깃까지 분리**할지 범위를 먼저 고르는 것이 리스크와 공수를 가늠하는 데 중요하다.
