# 프로젝트 아키텍처

> **이 문서**: 앱 전체 구조·레이어·부트스트랩·네비게이션 토폴로지만 다룹니다.  
> 레이어별 구현 패턴 → [`presentation.md`](presentation.md), [`domain-and-data.md`](domain-and-data.md)

## 개요

| 항목 | 내용 |
|------|------|
| 앱 | **수집(Souzip)** — 여행 기념품 기록·공유 iOS |
| 스택 | Swift 5.9 · iOS 16+ · Tuist 멀티모듈 |
| 스타일 | **Clean Architecture** + **MVVM-C** |
| UI | 코드 only (SnapKit), Storyboard/XIB 없음 |
| 리액티브 | RxSwift 단일 (Combine 없음) |

## 레이어 구조

```text
┌─────────────────────────────────────────────────────────┐
│  App (조립·진입·플랫폼 콜백)                              │
└───────────────────────────┬─────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────┐
│  Presentation (UI·Coordinator·ViewModel)                 │
└───────────────────────────┬─────────────────────────────┘
                            │ UseCase·Domain Model
┌───────────────────────────▼─────────────────────────────┐
│  Domain (비즈니스·Repository 프로토콜)  ← 의존성 0        │
└───────────────────────────▲─────────────────────────────┘
                            │
┌───────────────────────────┴─────────────────────────────┐
│  Data (API·Repository 구현·DTO)                          │
└───────────────────────────┬─────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────┐
│  Core (Networking, Logger, Storage, Analytics, Ads)      │
│  Shared (DesignSystem, Utils)                            │
└─────────────────────────────────────────────────────────┘
```

- **의존 방향·import·Tuist 모듈**: [`layers.md`](layers.md)
- **Presentation 패턴**: [`presentation.md`](presentation.md)
- **Domain/Data·API 흐름**: [`domain-and-data.md`](domain-and-data.md)
- **새 기능 추가 순서**: [`feature-playbook.md`](feature-playbook.md)

## 런타임 부트스트랩

```text
SceneDelegate
  ├─ AppConfiguration()          // xcconfig → AppInfo, Analytics·폰트 등
  ├─ AppFactory(config)
  │    ├─ Keychain · Network
  │    ├─ DataFactory  → Repository (lazy)
  │    └─ DomainFactory → UseCase
  ├─ RootCoordinator(nav, domainFactory)
  │    └─ PresentationFactory(domainFactory only)
  └─ UINavigationController → window
```

- 설정·시크릿: `Config/*.xcconfig` (git 제외).
- OAuth URL: App `SceneDelegate` → Data `AuthRedirect` (Presentation 경유 없음).

Factory 상세·경계: [`layers.md`](layers.md) § Factory.

## 앱 네비게이션 (Coordinator)

```text
RootCoordinator
├─ AuthCoordinator        … 스플래시 · 로그인 · 온보딩
└─ TabBarCoordinator
     ├─ HomeCoordinator       … 지도(Globe)
     ├─ DiscoveryCoordinator  … 발견
     └─ MyPageCoordinator     … 마이페이지 · 설정 · 공지
```

- 탭 밖·공통 플로우: `SouvenirCoordinator`, `LoginBottomSheetCoordinator` 등 — 부모 `*Route`에 **embedded route**로 연결.
- 화면 생성: `PresentationFactory` → `RoutedScene` → Coordinator `bindRoute`. 상세: [`presentation.md`](presentation.md) § Coordinator.

## 레이어별 책임 (한 줄)

| 레이어 | 책임 | 하지 않는 것 |
|--------|------|----------------|
| **Domain** | Model, UseCase, Repository **protocol**, Error | UI, HTTP, DTO |
| **Data** | Endpoint, DTO, DataSource, Repository **구현**, Mapper | UI, ViewModel |
| **Presentation** | 화면·상태·내비 의도·Coordinator | Repository/DTO 직접 접근 |
| **App** | DI 조립, 앱 라이프사이클·딥링크 | 비즈니스 로직 |
| **Core/Shared** | 인프라·디자인 토큰 | 기능 도메인 규칙 |

## Domain 기능 경계 (현재)

Auth · Onboarding · Country · Souvenir · Discovery · User · Notice · Wishlist

→ 폴더·UseCase·Repository 목록: [`layers.md`](layers.md) § Domain 기능 영역.

## 빌드·검증

- Tuist: `tuist install` → `tuist generate` → Xcode workspace.
- 기준선: [`../scripts/preflight.sh`](../scripts/preflight.sh).
- 빌드·버전 요약: [`project.md`](project.md).

## 금지 사항

비협상 규칙 전체: [`../constitution.md`](../constitution.md).

## 문서 맵

| 궁금한 것 | 문서 |
|-----------|------|
| 모듈 11개·import 표 | `layers.md` |
| ViewModel 4타입·BaseView·Scene 폴더 | `presentation.md` |
| Endpoint→Repository·Mapper | `domain-and-data.md` |
| 기능 추가 체크리스트 | `feature-playbook.md` |
