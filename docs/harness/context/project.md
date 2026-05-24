# Souzip — 프로젝트 맥락

## 개요

**수집(Souzip)**: 여행 기념품을 기록·공유하는 iOS 앱.

| 항목 | 값 |
|------|-----|
| 번들 (Release) | `com.swyp.souzip` |
| 표시 이름 | 수집 |
| Swift | 5.9 |
| iOS | 16.0+ |
| 빌드 | Tuist → Xcode workspace |

도메인 영역: Souvenir, Auth, Onboarding, Country, User, Discovery, Location, Notice, Wishlist.

## 빌드·기준선

```bash
tuist install
tuist generate
# Xcode에서 *.xcworkspace 열기
swiftformat .
```

세션·implement 전 기준선: [`../scripts/preflight.sh`](../scripts/preflight.sh)

## 레이어 (한 줄)

```text
App → Presentation → Domain ← Data → Core / Shared
```

전체 구조: [`architecture.md`](architecture.md) · 모듈: [`layers.md`](layers.md) · UI: [`presentation.md`](presentation.md) · API: [`domain-and-data.md`](domain-and-data.md) · 새 기능: [`feature-playbook.md`](feature-playbook.md)

## 저장소·문서

| 경로 | 용도 |
|------|------|
| `docs/harness/context/` | 프로젝트 구조·규칙 (이 폴더) |
| `docs/harness/workflows/` | AI 협업 5모드·게이트 |
| `docs/plans/{feature}/` | 기능별 plan·tracker |
| `Projects/` | Tuist 모듈 소스 |

`Config/*.xcconfig` — API 키 등, **git 제외**.
