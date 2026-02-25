# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development

This is an iOS project managed with **Tuist**. Swift 5.9, iOS 16.0+ deployment target.

```bash
# Generate Xcode project from Tuist manifests
tuist install    # fetch external dependencies
tuist generate   # generate xcworkspace and xcodeproj files

# Format code
swiftformat .

# Lint
swiftlint
```

Build and run via Xcode after `tuist generate`. No CLI build command — the project uses xcworkspace.

## Architecture

**Clean Architecture + MVVM-C (Coordinator)** with Tuist multi-module structure.

### Layer Dependency Flow
```
App → Presentation → Domain ← Data → Core
```
- **Domain** has no external dependencies (pure business logic)
- **Data** implements Domain's repository protocols
- **Presentation** depends on Domain only (not Data)
- **App** bootstraps DI via factory chain

### Module Map (`Projects/`)

| Layer | Module | Path |
|-------|--------|------|
| App | App (entry point, DI) | `Projects/App/` |
| Presentation | Presentation | `Projects/Presentation/` |
| Domain | Domain | `Projects/Domain/` |
| Data | Data | `Projects/Data/` |
| Core | Networking, Logger, Keychain, UserDefaults, AdMob | `Projects/Core/{module}/` |
| Shared | DesignSystem, Utils | `Projects/Shared/{module}/` |

### Tuist Configuration
- Module definitions: `Tuist/ProjectDescriptionHelpers/Core/Module.swift`
- Dependency graph: `Tuist/ProjectDescriptionHelpers/Dependencies/ModuleDependencies.swift`
- Project templates: `Tuist/ProjectDescriptionHelpers/Templates/Project+App.swift`, `Project+Framework.swift`
- Environment config: `Tuist/ProjectDescriptionHelpers/Core/Environment.swift` (bundle: `com.swyp.souzip`, app name: "수집")
- Build configs loaded from `Config/Debug.xcconfig` and `Config/Release.xcconfig`

### DI / Factory Chain
Bootstrap in `SceneDelegate` → `AppConfiguration` → `AppFactory`:
```
AppFactory
├── KeychainFactory
├── NetworkFactory (plain + authed clients)
├── DataFactory (lazy-cached repositories)
├── DomainFactory (protocol composition of per-feature factories)
└── PresentationFactory (scene + coordinator creation)
```
- Factories use **protocol composition** (`DomainFactory: DomainAuthFactory & DomainSouvenirFactory & ...`)
- Repositories are **lazy var cached** in DataFactory (single instance)
- Key file: `Projects/App/Sources/Factory/AppFactory.swift`

### Presentation Pattern
**BaseViewModel<State, Action, Event, Route>** — generic base with 4 type params:
- `state: BehaviorRelay<State>` — single source of truth for UI
- `action: PublishRelay<Action>` — user input
- `event: PublishRelay<Event>` — side effects (toasts, alerts)
- `route: PublishRelay<Route>` — navigation intent
- `mutate()` for state changes, `emit()` for events, `navigate(to:)` for routing

**BaseCoordinator<Route, ParentRoute>** — navigation hierarchy:
- `navigate(_ route:)` — handle local routes
- `navigateToParent(_ route:)` — delegate to parent coordinator
- `children` array + `parent` weak reference

**BaseViewController<ViewModel>** binds via `bindState()`, `bindRoute()`, `bindViewModel()`.

### Domain Structure (per feature)
Each domain (Auth, Souvenir, Country, Onboarding, Discovery, User, Location) follows:
```
{Feature}/
├── Model/       # Domain entities
├── UseCase/     # Business logic
├── Repository/  # Protocol (implemented in Data layer)
└── Error/       # Domain-specific errors
```

### Data Structure (per feature)
```
{Feature}/
├── Remote/      # API data source
├── Local/       # Keychain/UserDefaults data source
├── DTO/         # Request/Response DTOs with toDomain() mapping
├── Endpoint/    # APIEndpoint conforming types
└── Repository/  # Protocol implementation
```

### Networking
- `APIEndpoint` protocol: defines path, method, headers, parameters, body
- `NetworkClient` protocol with `DefaultNetworkClient` implementation
- `DefaultNetworkClient.authed()` — auto token refresh via `TokenRefresher`
- `DefaultNetworkClient.plain()` — no auth (login endpoints)
- Multipart upload via `MultipartEndpoint`
- API responses wrapped in `APIResponse<T: Decodable>`

## Code Style

**SwiftFormat** (`.swiftformat`): 4-space indent, `before-first` wrapping for args/params/collections, `balanced` closing paren.

**SwiftLint** (`.swiftlint.yml`):
- `force_unwrapping` and `implicitly_unwrapped_optional` are opt-in (enforced)
- Disabled: `line_length`, `file_length`, `function_body_length`, `type_body_length`, `identifier_name`, `type_name`, `trailing_comma`
- UI layout uses **SnapKit** (programmatic, no storyboards)
- Reactive binding uses **RxSwift/RxRelay/RxCocoa**

## Adding a New Feature

1. **Domain**: Add Model, UseCase, Repository protocol, Error in `Projects/Domain/Sources/{Feature}/`
2. **Data**: Add DTO, Endpoint, DataSource, Repository implementation in `Projects/Data/Sources/{Feature}/`
3. **Presentation**: Add ViewModel (extending BaseViewModel), ViewController, Coordinator route in `Projects/Presentation/Sources/`
4. **Factory wiring**: Add factory protocol methods in Domain/Data/Presentation factories, wire in `AppFactory`
5. **Dependencies**: If new external lib needed, update `Tuist/Package.swift` and `ModuleDependencies.swift`
