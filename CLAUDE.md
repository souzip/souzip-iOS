# CLAUDE.md

이 파일은 Claude Code(claude.ai/code)가 이 저장소에서 작업할 때 참고하는 가이드입니다.

## 프로젝트 개요

**수집(Souzip)**은 여행 기념품을 기록하고 공유하는 iOS 앱입니다.
주요 도메인: 기념품(Souvenir), 인증(Auth), 국가(Country), 사용자(User), 탐색(Discovery), 위치(Location)

## 빌드 환경

**Tuist**로 관리되는 iOS 프로젝트입니다. Swift 5.9, iOS 16.0+ 배포 타겟.

```bash
tuist install    # 외부 의존성 다운로드
tuist generate   # xcworkspace, xcodeproj 파일 생성
swiftformat .    # 코드 포맷
```

`tuist generate` 후 Xcode에서 빌드 및 실행. CLI 빌드 명령 없음 — xcworkspace를 사용.

## 아키텍처

**Clean Architecture + MVVM-C(Coordinator)** 기반의 Tuist 멀티모듈 구조.

### 레이어 의존성 흐름
```
App → Presentation → Domain ← Data → Core
```
- **Domain**: 외부 의존성 없음 (순수 비즈니스 로직)
- **Data**: Domain의 Repository 프로토콜 구현
- **Presentation**: Domain에만 의존 (Data 직접 참조 불가)
- **App**: Factory 체인으로 DI 부트스트랩

### 모듈 구조 (`Projects/`)

| 레이어 | 모듈 | 경로 |
|--------|------|------|
| App | App (진입점, DI) | `Projects/App/` |
| Presentation | Presentation | `Projects/Presentation/` |
| Domain | Domain | `Projects/Domain/` |
| Data | Data | `Projects/Data/` |
| Core | Networking, Logger, Keychain, UserDefaults, AdMob | `Projects/Core/{module}/` |
| Shared | DesignSystem, Utils | `Projects/Shared/{module}/` |

상세 내용(Tuist 설정, Factory 체인, Presentation 패턴, Domain/Data 구조, Networking): [`docs/claude/architecture.md`](docs/claude/architecture.md) 참조.

## 금지 사항 (DO NOT)

- `force_unwrapping` (`!`) 사용 금지
- `implicitly_unwrapped_optional` 사용 금지
- Storyboard/XIB 사용 금지 — 모든 UI는 SnapKit 코드로 작성
- Domain 레이어에 외부 의존성 추가 금지 — 순수 비즈니스 로직만
- Data 레이어를 Presentation에서 직접 참조 금지
- `Config/*.xcconfig` 파일 커밋 금지 (`.gitignore`에 포함됨, API 키/시크릿 포함)
- `tuist generate`로 생성되는 `*.xcodeproj`, `*.xcworkspace`, `Derived/` 커밋 금지
- `Combine` 사용 금지 — 프로젝트는 RxSwift 사용

## 컨벤션

- 한국어 커밋 메시지 & 코드 주석
- SnapKit으로 프로그래매틱 UI (스토리보드 사용 안 함)
- RxSwift/RxRelay/RxCocoa로 리액티브 바인딩
- BaseViewModel 4타입 패턴 준수 (State, Action, Event, Route)
- DTO → Domain 변환은 **Mapper** 사용 (`toDomain()` 직접 구현 금지)
- Repository는 Domain에 프로토콜, Data에 구현체
- DI는 Factory 패턴으로 (직접 init 주입 대신 Factory 체인)
- `import` 정렬: testable을 맨 아래로 (SwiftFormat `testable-bottom`)

## Git 컨벤션

**커밋 메시지**:
```
<type>: <한국어 설명>
```

| 타입 | 설명 |
|------|------|
| `feat` | 새로운 기능 추가 |
| `fix` | 버그 수정 |
| `refactor` | 리팩토링 (기능 변경 없이 구조 개선) |
| `style` | 코드 포맷, 네이밍, 세미콜론 등 스타일 수정 |
| `docs` | 문서 수정 (README, 주석 등) |
| `test` | 테스트 코드 추가 또는 수정 |
| `chore` | 빌드 설정, 패키지 설치 등 기타 잡일 |

**브랜치 네이밍**:
```
<type>/<JIRA-ID>/<설명>
```
예시: `feat/SOU-398/nickname-policy`, `fix/SOU-380/profile-image-downsampling`, `refactor/SOU-422/souvenirs-api-v2`

**기본 브랜치**: `develop` (PR 타겟)

## 새 기능 추가 절차

1. **Domain**: `Projects/Domain/Sources/{Feature}/`에 Model, UseCase, Repository 프로토콜, Error 추가
2. **Data**: `Projects/Data/Sources/{Feature}/`에 DTO, Endpoint, DataSource, Repository 구현체 추가
3. **Presentation**: `Projects/Presentation/Sources/`에 ViewModel(BaseViewModel 상속), ViewController, Coordinator 라우트 추가
4. **Factory 연결**: Domain/Data/Presentation Factory 프로토콜 메서드 추가 후 `AppFactory`에서 연결
5. **의존성**: 새 외부 라이브러리가 필요한 경우 `Tuist/Package.swift`와 `ModuleDependencies.swift` 업데이트
