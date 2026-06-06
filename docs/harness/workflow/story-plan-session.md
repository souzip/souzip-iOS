# Goal → Story → Plan

이 문서는 Codex 기준의 Souzip 작업 흐름을 설명합니다.

## 1. Goal

Goal은 기능 목표와 이해관계를 문서화한 단위입니다.
AI는 먼저 인터뷰로 요구사항을 명확히 하고, 목표 문서를 만듭니다.

Goal 문서에는 아래를 담습니다.

- 한 줄 목표
- 배경과 문제
- 사용자와 이해관계
- 성공 기준
- 하지 않을 것
- 현재 흐름과 원하는 흐름
- UI 구조
- API, 데이터, 도메인
- 제약 조건
- Story 후보
- 최종 합의

## 2. Story

Story는 PR 하나가 되는 작업 단위입니다.
Story 하나는 worktree 하나입니다.

Story는 기본적으로 기술 경계로 나눕니다. 예를 들어 API, Domain, Data, UI, Analytics처럼 구현 영역이 다르면 Story를 나눕니다.
한 기술 영역이 너무 크면 사용자 가치 기준으로 한 번 더 나눕니다.

어떤 방식으로 나누든 Story 하나는 PR 하나로 들어가도 앱이 깨지지 않아야 합니다.
Story worktree는 `develop`에서 만들고, Story PR도 `develop`으로 보냅니다.
새 worktree를 만든 직후에는 아래 bootstrap을 한 번 실행합니다.

```bash
docs/harness/scripts/bootstrap-worktree.sh
```

bootstrap은 Git에 올리지 않는 `Config/Debug.xcconfig`, `Config/Release.xcconfig`를 로컬 설정 저장소에서 복사하고, `Tuist/Package.resolved` 기준으로 `tuist install`과 `tuist generate`를 실행합니다.
로컬 설정 저장소 기본 위치는 `~/.souzip/config`이며, 필요하면 `SOUZIP_CONFIG_DIR` 환경 변수로 바꿀 수 있습니다.

Goal 승인 뒤 Story 목록을 만들지만, Jira Story를 처음부터 전부 만들지는 않습니다.
실제로 시작할 active Story 1~2개만 먼저 Jira에 만들고, 나머지는 후보로 둡니다.

active Story는 아래 순서로 고릅니다.

- 첫 번째는 작지만 API, 도메인, 저장, UI 같은 끝단 흐름을 실제로 연결해 볼 수 있는 얇은 Story입니다.
- 두 번째가 필요하면 가장 불확실한 기술 리스크를 검증하는 Story입니다.
- 너무 큰 Story는 Jira와 worktree로 올리기 전에 다시 쪼갭니다.

## 3. Plan

Plan은 Story를 끝내기 위한 작은 작업 단위입니다.

Plan은 아래 기준을 만족해야 합니다.

- 한 세션에서 구현과 검증까지 끝낼 수 있습니다.
- 테스트나 빌드로 확인할 수 있습니다.
- 하지 않을 범위가 분명합니다.

사용자가 Plan을 승인하고 “구현해”라고 말한 뒤에만 코드를 고칩니다.

## 4. Verify

Plan 종료 시 기본 검증을 합니다.

- SwiftFormat lint
- SwiftLint
- Tuist generate
- Tuist build
- 관련 테스트

기본 스크립트는 아래입니다.

```bash
docs/harness/scripts/verify.sh plan
```

검증 실패가 Plan 범위 안이면 AI가 고치고 다시 검증합니다.
같은 실패를 두 번 이상 수정해도 해결되지 않으면 원인 조사로 전환합니다.
Tuist, Factory, 모듈 경계, 레이어 규칙 같은 큰 구조 변경이 필요하면 멈추고 사용자에게 묻습니다.

## 5. Finish

Plan이 끝나면 검증 결과를 Plan 문서에 남깁니다.
Story의 모든 Plan이 끝나면 PR을 만들 수 있습니다.
PR 전에는 Story 시작 이후 `develop`이 바뀌어 Plan이 낡지 않았는지 확인합니다.
확인은 변경 파일 겹침 기준으로 합니다.

- `base_commit..origin/develop` 변경 파일
- `base_commit..HEAD` 변경 파일
- 두 목록에 겹치는 파일이 있으면 멈추고 사용자에게 알립니다.
- 겹치는 파일이 없으면 Story 종료 검증을 유지하고 PR로 갈 수 있습니다.

Story 종료 검증은 아래입니다.

```bash
docs/harness/scripts/verify.sh story
```

commit은 사용자가 “커밋해”라고 말한 뒤에만 진행합니다.
PR 생성을 위한 push와 PR 생성은 사용자가 “PR”이라고 말한 뒤에만 진행합니다.
