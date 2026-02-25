# 아키텍처 상세 참조

CLAUDE.md의 아키텍처 섹션에서 이어지는 상세 내용입니다.

## Tuist 설정 파일

- 모듈 정의: `Tuist/ProjectDescriptionHelpers/Core/Module.swift`
- 의존성 그래프: `Tuist/ProjectDescriptionHelpers/Dependencies/ModuleDependencies.swift`
- 프로젝트 템플릿: `Tuist/ProjectDescriptionHelpers/Templates/Project+App.swift`, `Project+Framework.swift`
- 환경 설정: `Tuist/ProjectDescriptionHelpers/Core/Environment.swift` (번들: `com.swyp.souzip`, 앱 이름: "수집")
- 빌드 설정: `Config/Debug.xcconfig`, `Config/Release.xcconfig`

## DI / Factory 체인

`SceneDelegate` → `AppConfiguration` → `AppFactory` 순으로 부트스트랩:

```
AppFactory
├── KeychainFactory
├── NetworkFactory (plain + authed clients)
├── DataFactory (lazy-cached repositories)
├── DomainFactory (protocol composition of per-feature factories)
└── PresentationFactory (scene + coordinator creation)
```

- Factory는 **프로토콜 컴포지션** 사용 (`DomainFactory: DomainAuthFactory & DomainSouvenirFactory & ...`)
- Repository는 DataFactory에서 **lazy var**로 캐싱 (단일 인스턴스)
- 핵심 파일: `Projects/App/Sources/Factory/AppFactory.swift`

## Presentation 패턴

**BaseViewModel<State, Action, Event, Route>** — 4개 타입 파라미터의 제네릭 베이스:
- `state: BehaviorRelay<State>` — UI의 단일 진실 공급원
- `action: PublishRelay<Action>` — 사용자 입력
- `event: PublishRelay<Event>` — 사이드 이펙트 (토스트, 알럿)
- `route: PublishRelay<Route>` — 내비게이션 의도
- 상태 변경은 `mutate()`, 이벤트 발행은 `emit()`, 라우팅은 `navigate(to:)`

**BaseCoordinator<Route, ParentRoute>** — 내비게이션 계층:
- `navigate(_ route:)` — 로컬 라우트 처리
- `navigateToParent(_ route:)` — 부모 코디네이터에 위임
- `children` 배열 + `parent` 약한 참조

**BaseViewController<ViewModel>**는 `bindState()`, `bindRoute()`, `bindViewModel()`로 바인딩.

## Domain 폴더 구조 (피처별)

각 도메인(Auth, Souvenir, Country, Onboarding, Discovery, User, Location):

```
{Feature}/
├── Model/       # 도메인 엔티티
├── UseCase/     # 비즈니스 로직
├── Repository/  # 프로토콜 (Data 레이어에서 구현)
└── Error/       # 도메인 전용 에러
```

## Data 폴더 구조 (피처별)

```
{Feature}/
├── Remote/      # API 데이터 소스
├── Local/       # Keychain/UserDefaults 데이터 소스
├── DTO/         # 요청/응답 DTO (Mapper로 도메인 변환)
├── Endpoint/    # APIEndpoint 구현체
└── Repository/  # 프로토콜 구현체
```

## 네트워킹

- `APIEndpoint` 프로토콜: path, method, headers, parameters, body 정의
- `NetworkClient` 프로토콜 / `DefaultNetworkClient` 구현체
- `DefaultNetworkClient.authed()` — `TokenRefresher`로 자동 토큰 갱신
- `DefaultNetworkClient.plain()` — 인증 없음 (로그인 엔드포인트)
- 멀티파트 업로드: `MultipartEndpoint`
- API 응답: `APIResponse<T: Decodable>`로 래핑
