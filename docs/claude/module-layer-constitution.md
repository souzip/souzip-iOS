# 모듈·레이어 헌장

수집(Souzip)의 **Tuist 모듈 경계**, **레이어·import 규칙**, **DI/부트스트랩**을 한 문서로 정의한다.

**단일 진실**: 모듈 enum·의존 그래프는 `Tuist/ProjectDescriptionHelpers/Core/Module.swift`, `Tuist/ProjectDescriptionHelpers/Dependencies/ModuleDependencies.swift`가 우선이다. 구조를 바꾸면 Tuist와 본 문서를 함께 갱신한다.

---

## Tuist·프로젝트 생성

| 항목 | 경로 |
|------|------|
| 모듈 정의 | `Tuist/ProjectDescriptionHelpers/Core/Module.swift` |
| 의존성 그래프 | `Tuist/ProjectDescriptionHelpers/Dependencies/ModuleDependencies.swift` |
| 앱·프레임워크 템플릿 | `Tuist/ProjectDescriptionHelpers/Templates/Project+App.swift`, `Project+Framework.swift` |
| 외부 라이브러리 매핑 | `Tuist/ProjectDescriptionHelpers/Dependencies/ExternalLibrary.swift` |
| 환경 | `Tuist/ProjectDescriptionHelpers/Core/Environment.swift` (번들: `com.swyp.souzip`, 앱 이름: "수집") |
| 앱 빌드 설정 | `Config/Debug.xcconfig`, `Config/Release.xcconfig` (저장소에 커밋하지 않는 경우 `.gitignore` 따름) |

---

## 레이어 의존성 원칙

1. **방향**: `App` → `Presentation` → `Domain` ← `Data` ← Core / Shared 인프라.
2. **`Presentation`은 `Data`를 import하지 않는다.** Repository·UseCase는 `Domain` 프로토콜과 `DomainFactory`로만 접근한다.
3. **`Domain`은 외부 SDK에 의존하지 않는다.** (Foundation 등 표준 라이브러리 수준. Tuist에 네트워킹·UI·분석 SDK를 붙이지 않는다.)
4. **`Utils`는 다른 내부 모듈에 의존하지 않는다.**
5. **조립**은 `App`의 Factory 계열에서 수행한다.

---

## 레이어와 위치

| 레이어 | 책임 | 위치 |
|--------|------|------|
| Application | 진입점, 객체 그래프 조립, 기동 설정 | `Projects/App` |
| Presentation | UIKit, Coordinator, ViewModel | `Projects/Presentation` |
| Domain | 엔티티, UseCase, Repository **프로토콜**, Factory **계약** | `Projects/Domain` |
| Data | Endpoint, Remote/Local, DTO, Repository 구현, `DefaultDataFactory` | `Projects/Data` |
| Core | HTTP, Storage, Logger, Analytics, Ads 등 기술 어댑터 | `Projects/Core/*` |
| Shared | DesignSystem, Utils | `Projects/Shared/*` |

**기동**: `SceneDelegate` → `AppConfiguration` → 이후 `AppFactory`로 조립. `AppConfiguration`에서는 `FontRegistration` → `ImageCacheConfiguration` → `AnalyticsManager.configure` 순으로 호출한다. Kingfisher는 **Presentation**에만 링크해 정적 링크 중복을 피한다.

---

## 모듈 카탈로그

| 모듈 | 경로 | 역할 |
|------|------|------|
| App | `Projects/App` | `AppFactory`, `AppConfiguration`, `SceneDelegate` |
| Presentation | `Projects/Presentation` | 화면, Coordinator, `PresentationFactory`, `ImageCacheConfiguration` |
| Domain | `Projects/Domain` | 도메인 모델, `DomainFactory` / `DataFactory` 프로토콜 |
| Data | `Projects/Data` | Endpoint, DTO, Remote/Local, Repository, `DefaultDataFactory` (Auth·OAuth 등) |
| Networking | `Projects/Core/Networking` | `APIEndpoint`, `NetworkClient`, `NetworkFactory` |
| Logger | `Projects/Core/Logger` | OSLog `Logger` |
| Analytics | `Projects/Core/Analytics` | Amplitude `AnalyticsManager`, `AnalyticsEvent` |
| Storage | `Projects/Core/Storage` | Keychain·UserDefaults 스토리지 및 Factory |
| Ads | `Projects/Core/Ads` | `AdMobManager`, `AdBannerView` |
| DesignSystem | `Projects/Shared/DesignSystem` | DS, `FontRegistration` |
| Utils | `Projects/Shared/Utils` | `AppInfo`, `KeychainKey`, `DefaultsKey` |

---

## Tuist 타깃 의존성

`ModuleDependencies.dependencies(for:)` 요약.

| 타깃 | 내부 모듈 | 외부 SPM(예) |
|------|-----------|---------------|
| App | Presentation, Domain, Data, DesignSystem, Analytics, Storage, Networking, Utils | — |
| Presentation | Domain, Logger, Analytics, DesignSystem, Utils, Ads | RxSwift, RxRelay, RxCocoa, Kingfisher, MapboxMaps |
| Domain | — | — |
| Data | Domain, Networking, Logger, Storage, Utils, Analytics | Kakao SDK, Google Sign-In |
| Networking | Logger | — |
| Logger | — | — |
| Analytics | — | AmplitudeSwift |
| Storage | Logger, Utils | — |
| Ads | Logger, Analytics, Utils | GoogleMobileAds |
| DesignSystem | Logger, Utils | SnapKit |
| Utils | — | — |

---

## DI · Factory 체인

부트스트랩 흐름: **`SceneDelegate` → `AppConfiguration` → `AppFactory`**.

```
AppFactory
├── KeychainFactory        (Storage)
├── NetworkFactory         (plain + authed clients)
├── DataFactory            (lazy-cached repositories)
├── DomainFactory          (프로토콜 컴포지션: DomainAuthFactory & DomainSouvenirFactory & …)
└── PresentationFactory    (화면·Coordinator 생성)
```

- Factory는 **프로토콜 컴포지션**을 쓴다.
- Repository는 DataFactory에서 **lazy**로 캐시해 단일 인스턴스로 쓴다.
- 핵심 진입: `Projects/App/Sources/Factory/AppFactory.swift`.
- **`PresentationFactory`**는 `DomainFactory`만 받는다. `DataFactory`에 직접 접근하지 않는다.
- **`RootCoordinator`**는 `DomainFactory`를 주입받아 `DefaultPresentationFactory`를 구성한다.

**실용**: `App` → `Data` 링크는 조립 루트에서 허용. OAuth URL은 `SceneDelegate` 등에서 `Data`의 `AuthRedirect`로 직접 처리해도 된다.

---

## import 규범

○ = 허용, ✗ = 금지.

| ↓ / → | Domain | Data | Presentation | App | Networking | Storage | Logger | Analytics | Ads | DesignSystem | Utils |
|--------|--------|------|--------------|-----|------------|---------|---------|-----------|-----|--------------|-------|
| Domain | — | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| Data | ○ | — | ✗ | ✗ | ○ | ○ | ○ | ○ | ✗ | ✗ | ○ |
| Presentation | ○ | ✗ | — | ✗ | ✗ | ✗ | ○ | ○ | ○ | ○ | ○ |
| App | ○ | ○ | ○ | — | ○ | ○ | — | ○ | — | ○ | ○ |

---

## Presentation 패턴 (요약)

- **`BaseViewModel<State, Action, Event, Route>`** — `state` / `action` / `event` / `route` 릴레이, `mutate()`, `emit()`, `navigate(to:)`.
- **`BaseCoordinator<Route, ParentRoute>`** — `navigate`, `navigateToParent`, `children`·`parent`.
- **BaseViewController** — `bindState()`, `bindRoute()`, `bindViewModel()`.

---

## Domain / Data 폴더 (피처별)

**Domain** (`Projects/Domain/Sources/{Feature}/`):

```
Model/       # 엔티티
UseCase/
Repository/  # 프로토콜
Error/
```

**Data** (`Projects/Data/Sources/{Feature}/`):

```
Endpoint/
Remote/
Local/
DTO/
Repository/
```

Auth 등: `Service/OAuth/`, `Service/Token/` 등.

---

## 네트워킹 (요약)

- `APIEndpoint` 프로토콜(Networking) — 구체 정의는 Data `Endpoint/`.
- path, method, headers, parameters, body.
- `NetworkClient` / `DefaultNetworkClient`: `authed()`(토큰 갱신), `plain()`(비인증).
- 멀티파트: `MultipartEndpoint`.
- 응답: `APIResponse<T: Decodable>`.

---

## 새 모듈 추가

1. 레이어 결정.
2. `Module.swift`에 case·`path` 추가.
3. `ModuleDependencies.swift`에 의존성 추가(순환 없이).
4. 필요 시 `ExternalLibrary.swift`, `Tuist/Package.swift` 갱신.
5. `Projects/{모듈}/Project.swift`에 타깃 정의.
6. `tuist generate` 후 클린 빌드.
