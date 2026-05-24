# 레이어·모듈·import

> 근거: `Tuist/ProjectDescriptionHelpers/Core/Module.swift`, `Dependencies/ModuleDependencies.swift`, 각 `Project.swift` 및 실제 `import` 사용.

## 한 줄 방향

```text
App → Presentation → Domain ← Data → Core / Shared
```

- **Domain**: 외부 프레임워크·다른 모듈 **의존성 0** (`ModuleDependencies`에서 `domain: []`).
- **Data**: Domain 타입만 알고, Presentation은 Data를 **모름**.
- **App**: 조립 루트 — Presentation·Domain·Data·Core를 모두 링크해 Factory 체인을 만든다.

## Tuist 모듈 (11개)

| 모듈 | 경로 | product | 역할 |
|------|------|---------|------|
| **App** | `Projects/App` | app | 진입, `AppFactory`, `SceneDelegate` |
| **Presentation** | `Projects/Presentation` | framework | UI, Coordinator, ViewModel |
| **Domain** | `Projects/Domain` | framework | Model, UseCase, Repository **프로토콜**, Error |
| **Data** | `Projects/Data` | framework | DTO, Endpoint, DataSource, Repository **구현** |
| **Networking** | `Projects/Core/Networking` | framework | HTTP, `APIEndpoint`, `NetworkClient` |
| **Logger** | `Projects/Core/Logger` | framework | 로깅 |
| **Analytics** | `Projects/Core/Analytics` | framework | Amplitude |
| **Storage** | `Projects/Core/Storage` | framework | Keychain, UserDefaults |
| **Ads** | `Projects/Core/Ads` | framework | Google Mobile Ads |
| **DesignSystem** | `Projects/Shared/DesignSystem` | framework | DS 컴포넌트, SnapKit UI |
| **Utils** | `Projects/Shared/Utils` | framework | 공용 유틸 |

모듈 enum·경로 규칙: `Tuist/ProjectDescriptionHelpers/Core/Module.swift`.

## Tuist 선언 의존성 (빌드 그래프)

`ModuleDependencies.dependencies(for:)` 기준.

| 모듈 | 의존 모듈 | 주요 SPM |
|------|-----------|----------|
| App | Presentation, Domain, Data, DesignSystem, Analytics, Storage, Networking, Utils | — |
| Presentation | Domain, Logger, Analytics, DesignSystem, Utils, Ads | RxSwift, RxRelay, RxCocoa, Kingfisher, MapboxMaps, Parchment |
| Domain | — | — |
| Data | Domain, Networking, Logger, Storage, Utils, Analytics | Kakao SDK, Google Sign-In |
| Networking | Logger | — |
| Analytics | — | AmplitudeSwift |
| Storage | Logger, Utils | — |
| Ads | Logger, Analytics, Utils | GoogleMobileAds |
| DesignSystem | Logger, Utils | SnapKit |
| Utils | — | — |

새 SPM 추가 시: `Tuist/Package.swift` + `ModuleDependencies.swift` (+ 필요 시 `ExternalLibrary`).

## Domain 기능 영역 (현재)

`Projects/Domain/Sources/` 하위:

| 폴더 | Repository | 대표 UseCase |
|------|------------|--------------|
| Auth | ✓ | 로그인, 자동로그인, 탈퇴, 인증 확인 |
| Onboarding | ✓ | 닉네임·약관·프로필 이미지 |
| Country | ✓ | 국가·위치 검색·주소 |
| Souvenir | ✓ | CRUD, 상세, 주변 |
| Discovery | ✓ | AI 추천, 카테고리/국가 Top |
| User | ✓ | 프로필, 업로드 버블 |
| Notice | ✓ | 공지 목록·상세 |
| Wishlist | ✓ | 찜 추가·삭제 |

새 기능은 **폴더명 = 도메인 경계**로 추가한다.

## import 규범 (코드)

○ 허용 · ✗ 금지. Tuist와 어긋나면 **빌드 전에** 막힌다.

| 소스 ↓ / 대상 → | Domain | Data | Presentation | App | Core·Shared |
|-----------------|--------|------|--------------|-----|-------------|
| **Domain** | — | ✗ | ✗ | ✗ | ✗ |
| **Data** | ○ | — | ✗ | ✗ | Networking, Storage, Logger, Analytics, Utils ○ |
| **Presentation** | ○ | ✗ | — | ✗ | Logger, Analytics, DesignSystem, Utils, Ads ○ |
| **App** | ○ | ○ | ○ | — | 조립에 필요한 Core ○ |

### 자주 하는 실수

- Presentation에서 `import Data` → **금지**. UseCase·Domain Model만 주입.
- Domain에서 `import RxSwift` / `import Networking` → **금지**.
- DTO·`APIEndpoint`를 Domain에 두기 → **금지** (Data 전용).
- Repository 구현체를 Domain에 두기 → **금지** (프로토콜만 Domain).

### 예외 (의도적)

- **App → Data**: `SceneDelegate`에서 OAuth URL (`AuthRedirect`) 처리 등 **조립·플랫폼 콜백** 한정.
- **DataFactory 프로토콜이 Domain에 있음**: Domain UseCase/Factory가 Repository **생성 인터페이스**만 알기 위함. 구현은 Data.

## Factory 경계

```text
SceneDelegate
  → AppFactory → DomainFactory (DefaultDomainFactory)
  → RootCoordinator(domainFactory)
       → DefaultPresentationFactory(domainFactory)   // Data 접근 없음
```

| Factory | 위치 | 받는 것 | 만드는 것 |
|---------|------|---------|-----------|
| `AppFactory` | App | `AppConfiguration` | Keychain, Network, **Data**, **Domain** |
| `DataFactory` | Data (프로토콜 Domain) | Network, OAuth, Storage | Repository (lazy 캐시) |
| `DomainFactory` | Domain | `DataFactory` | UseCase, Repository 노출 |
| `PresentationFactory` | Presentation | `DomainFactory` | Scene (`RoutedScene`), Coordinator용 VM |

- Feature별 확장: `DomainFactory+{Feature}.swift`, `PresentationFactory+{Feature}.swift`, DataFactory 내부 `lazy var cached*Repository`.
- Presentation의 `AuthSessionStore`, `UserSouvenirInvalidationStore`는 **UI 세션·캐시 무효화**용; Domain 로직 대체 아님.

## 검증 시 빠른 체크

- [ ] 새 파일의 `import`가 위 표를 위반하지 않음
- [ ] `ModuleDependencies`에 새 모듈/패키지 반영 (해당 시)
- [ ] `DefaultPresentationFactory`가 `DataFactory`를 들고 있지 않음
- [ ] DTO → Domain 변환이 Mapper에만 있음 (`*DTOMapper`)
