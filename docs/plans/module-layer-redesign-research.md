# 모듈·레이어 대개편 전 리서치 (2차)

## 목적

- **대규모 변경을 허용**하는 전제에서, 현재 Tuist 모듈·실제 `import`·부트스트랩이 **어떻게 얽혀 있는지**를 다시 끝까지 추적한다.
- 이후 **모듈 합치기/쪼개기·레이어 규범 재정의** 플랜을 세울 때의 근거 자료로 쓴다.
- 이전 문서 [`tuist-module-structure-consistency-research.md`](./tuist-module-structure-consistency-research.md)는 1차 스냅샷이며, 본 문서는 **구조 개편 관점**을 보강한다.

---

## 1. Tuist 선언 의존성 (단일 진실: `ModuleDependencies.swift`)

```
App
  → Presentation, Domain, Data

Presentation
  → Domain, Logger, DesignSystem, Utils, AdMob
  → RxSwift, RxRelay, RxCocoa, Kingfisher, MapboxMaps

Domain
  → Utils, Logger

Data
  → Domain, Networking, Logger, Keychain, UserDefaults, Utils
  → Kakao* (3), GoogleSignIn

Networking → Logger
Logger → AmplitudeSwift
Keychain → Logger, Utils
UserDefaults → Logger, Utils
AdMob → Logger, Utils, GoogleMobileAds

DesignSystem → Logger, Utils, SnapKit
Utils → (없음)
```

**요약**: 레이어는 `App → Presentation → Domain ← Data` + **Shared/Core**가 `Presentation`·`Data`에 붙는 형태. `Presentation`은 `Data`를 Tuist 상 **직접 링크하지 않음** (의도와 일치).

---

## 2. 실제 소스 `import`로 본 결합 (추가 발견)

### 2.1 Presentation은 Data / Networking / Keychain / UserDefaults를 import하지 않음

`Projects/Presentation`에서 `^import (Data|Networking|Keychain|UserDefaults|Data)\b` 검색 → **매치 없음**.  
클린 아키텍처 의도대로 **Repository는 DomainFactory 경유**로만 사용되는 편.

### 2.2 Domain은 `Logger`·`Utils`를 소스에서 쓰지 않음

`Projects/Domain/Sources` 전체에서 `import Logger`, `import Utils`, `Utils`/`Logger` 식별자 식 검색 → **매치 없음**.  
그런데 Tuist는 **Domain → Logger, Utils**를 선언한다. 즉 **링크 그래프에만 존재**하고, 실제 코드 의존은 없는 상태(빌드에 불필요한 링크·빌드 캐시 비용 가능).

### 2.3 App 레이어의 강한 결합 (개편 시 핵심 타깃)

| 파일 | import | 비고 |
|------|--------|------|
| `AppFactory.swift` | Data, Domain, Keychain, Networking, UserDefaults, Utils | 조립 — **Core 팩토리를 App이 직접 알고 있음** |
| `SceneDelegate.swift` | **Data**, Presentation, UIKit | `AuthRedirect` — **App → Data** 직접 참조 |
| `AppConfiguration.swift` | **DesignSystem**, **Logger**, **Presentation**, Utils | 부트스트랩 |

**`AppConfiguration` 상세** (`Projects/App/Sources/Factory/AppConfiguration.swift`):

- `FontRegistration.register()` — **DesignSystem** (`FontRegistration`은 DesignSystem 모듈).
- `ImageCacheConfiguration.shared.setup()` — **Presentation** (`ImageCacheConfigurator.swift`에 정의).
- `AnalyticsManager.shared.configure(apiKey:)` — **Logger** 모듈.

즉 **Application 레이어**가 **UI 폰트·이미지 캐시·분석 초기화**를 한곳에서 수행하고, 그 과정에서 **Presentation 모듈을 반드시 링크**한다.  
“App은 조립만 한다”는 규범과 비교하면, **부트스트랩 책임이 App/Presentation/DesignSystem/Logger에 걸쳐** 있고 경계가 흐림.

### 2.4 Data가 Networking을 쓰는 방식

- Remote DataSource·Endpoint·Repository 구현체가 `import Networking` 사용.
- `TokenRefresher`는 Networking 모듈에 프로토콜이 있고, 구현은 Data의 Auth/Service 쪽에 존재 — **Networking ↔ Data** 사이에 **인증 토큰 흐름**이 걸려 있음 (리서치 1차와 동일, 개편 시 `Infrastructure` 한 덩어리로 묶기 좋은 축).

---

## 3. 모듈 규모 (대략)

| 영역 | `Sources` 내 Swift 파일 수 (glob 기준) |
|------|----------------------------------------|
| Presentation | **약 208** |
| Domain | **약 64** |
| Data | **약 60** |
| Networking | **12** |
| DesignSystem | **27** (리서치 1차) |
| Utils | **7** |
| Core 나머지 | 소수 (Logger/Keychain/UD/AdMob 각각 작음) |

**시사점**: Presentation이 압도적으로 크다. **기능 단위로 쪼개기**를 하면 이 모듈에서 이득이 가장 크다. Domain/Data는 이미 피처 폴더로 나뉘어 있으나 **Tuist 타깃은 각 1개**.

---

## 4. 무거운 SDK 사용 위치

| SDK | Tuist 선언 위치 | 실제 사용 집중 |
|-----|-----------------|----------------|
| MapboxMaps | Presentation | `Globe`·`LocationMapView`·`MapBox+Rx` 등 **소수 파일** (4파일 부근) |
| GoogleMobileAds | AdMob | 배너·초기화 |
| Kakao / Google Sign-In | Data | OAuth |
| Amplitude | Logger | `AnalyticsManager` |
| Kingfisher | Presentation | 이미지, `ImageCacheConfiguration`이 Presentation에 |

**시사점**: Mapbox는 **지리·홈 글로브**에 국한되어 분리 후보. **AdMob**은 Core이지만 UI·Analytics와 엮임.

---

## 5. Factory·DI 체인 (개편 시 영향 범위)

1. **AppFactory**: `KeychainFactory`, `NetworkFactory`, `DefaultDataFactory`, `DefaultDomainFactory` 생성.  
2. **DefaultDataFactory**: Networking + OAuth + Keychain + UD 조립, Repository lazy 캐시.  
3. **DefaultDomainFactory**: `DataFactory`만 보고 UseCase/Repository 노출.  
4. **RootCoordinator**: `DomainFactory`만 받아 `DefaultPresentationFactory(domainFactory:)` 생성.  
5. **PresentationFactory**: extension으로 `+Auth`, `+Home`, `+Souvenir`, `+TabBar`, `+Discovery`, `+MyPage` 등 **8개 파일** 수준.

**모듈을 합치거나 나누면** 이 체인의 **프로토콜 위치(App vs Domain vs Infrastructure)** 와 **lazy 캐시 단위**를 다시 정해야 함.

---

## 6. 구조 개편 시 검토할 축 (옵션 — 아직 결정 아님)

아래는 **코드 근거를 바탕으로 한 후보**이며, 플랜 단계에서 승인 대상이다.

1. **부트스트랩 모듈 분리**  
   - `AppConfiguration`의 폰트·Kingfisher·Amplitude 초기화를 **`AppBootstrap` / `InfrastructureKit` / `CompositionRoot`** 같은 한 모듈로 모으거나,  
   - 또는 **Presentation** 안의 `Bootstrap` 네임스페이스로만 두고 App은 `Presentation`의 `public` API 한 줄만 호출하도록 **의존 방향을 단순화**.

2. **Core 통합**  
   - `Keychain` + `UserDefaults` → `Persistence` 또는 `Storage`.  
   - `Networking` + (일부) OAuth HTTP 클라이언트 의존은 Data와 함께 **`Infrastructure`** 단일 프레임워크로 묶기 — **링크 단순화 vs 컴파일 캐시**.

3. **Logger 역할 분리**  
   - `Logger`(OSLog) vs `Analytics`(Amplitude) 타깃 분리 또는 모듈명 `Observability`로 통일.

4. **AdMob**  
   - UIKit 의존이 강하므로 `Presentation` 근처 **`AdsUI` / `Monetization`** 으로 이동 검토하거나,  
   - 반대로 `Domain`에 `BannerDisplaying` **프로토콜**만 두고 구현만 모듈 분리(장기).

5. **Presentation 피처 모듈**  
   - `Globe`(Mapbox)·`Souvenir`·`Auth` 등으로 **타깃 분리** — Factory·Coordinator 공유를 위해 **`PresentationCore`**(BaseViewModel, Coordinator 프로토콜) 선행.

6. **Domain의 불필요한 Tuist 의존성**  
   - `Logger`/`Utils` 링크 제거 가능 여부 검증 (빌드 후 전체 링크 확인).

7. **Domain `Location` 빈 폴더**  
   - 개편과 함께 **삭제**하거나, `Country`·지도 책임을 문서/타입으로 정리.

---

## 7. 위험 요소 (대개편 시)

| 위험 | 설명 |
|------|------|
| **부트스트랩 순서** | 폰트·캐시·Analytics 초기화 순서가 깨지면 스플래시/이미지/이벤트에 회귀. |
| **Factory 순환 참조** | 모듈 쪼개기 시 `Domain` ↔ `Infrastructure` 사이 프로토콜 방향을 엄격히 정해야 함. |
| **Tuist/SPM** | `ExternalLibrary`·`productTypes`·Mapbox 등 **정적/동적 프레임워크** 설정 재검증 필요. |
| **테스트** | 모듈 분리 후 단위 테스트 타깃·`@testable` 경로 재설정. |

---

## 8. 영향받는 주요 파일·디렉터리

- `Tuist/ProjectDescriptionHelpers/Core/Module.swift`
- `Tuist/ProjectDescriptionHelpers/Dependencies/ModuleDependencies.swift`
- `Tuist/ProjectDescriptionHelpers/Dependencies/ExternalLibrary.swift`
- `Tuist/Package.swift`
- `Projects/App/Sources/Factory/*`, `SceneDelegate.swift`
- `Projects/Presentation/Sources/Utill/Factory/*`
- `Projects/Data/Sources/Utill/Factory/DataFactory.swift`
- `Projects/Domain/Sources/Utill/Factory/*`
- `Projects/Shared/DesignSystem/.../FontRegistration.swift`
- `Projects/Presentation/Sources/Utill/Extension/Kingfisher/ImageCacheConfigurator.swift`

---

## 9. 리서치 요약 (플랜 전에 합의할 질문)

1. **App이 Presentation을 부트스트랩 때문에 링크하는 구조**를 유지할지, **Bootstrap 전용 모듈**로 뺄지.  
2. **Domain의 Logger/Utils Tuist 의존**을 제거할지 (실사용 없음).  
3. **Core를 물리적으로 통합**할지, **Presentation만 피처 분리**할지, **둘 다** 할지.  
4. **AdMob**을 “Core”로 둘지 “UI/수익화” 레이어로 옮길지.

---

## 10. 다음 단계

- 본 리서치를 바탕으로 **`module-layer-redesign-plan.md`**(가칭)에서 **목표 모듈 그래프·마이그레이션 단계·트레이드오프**를 확정한다.  
- **플랜 승인 전까지 코드 변경 없음.**
