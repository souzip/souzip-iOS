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
swiftformat .
```

기본 검증: [`../scripts/verify.sh`](../scripts/verify.sh)

## 레이어

```text
App → Presentation → Domain ← Data → Core / Shared
```

전체 구조: [`architecture.md`](architecture.md) · 모듈: [`layers.md`](layers.md) · UI: [`presentation.md`](presentation.md) · API: [`domain-and-data.md`](domain-and-data.md) · 새 기능: [`feature-playbook.md`](feature-playbook.md)

## 저장소·문서

| 경로 | 용도 |
|------|------|
| `docs/harness/context/` | 프로젝트 구조 |
| `docs/harness/workflow/` | Goal → Story → Plan 흐름 |
| `docs/goals/{feature}/` | Goal, Story, Plan 실행 문서 (로컬) |
| `Projects/` | Tuist 소스 |

`Config/*.xcconfig` — API 키 등, **git 제외**.
새 worktree에서는 `docs/harness/scripts/bootstrap-worktree.sh`가 `~/.souzip/config`에서 필요한 xcconfig를 복사합니다.
다른 위치를 쓰려면 `SOUZIP_CONFIG_DIR`를 지정합니다.
