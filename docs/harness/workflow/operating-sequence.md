# Operating Sequence

Souzip 기능 작업을 시작할 때 따르는 순서입니다.

## 1. Goal 만들기

사용 스킬: `souzip-goal`

AI는 먼저 인터뷰로 요구사항과 이해관계를 묻습니다.
질문은 한 번에 1~3개만 합니다.

Goal 문서에는 아래가 있어야 합니다.

- 한 줄 목표
- 배경과 문제
- 사용자와 이해관계
- 성공 기준
- 하지 않을 것
- 현재 흐름과 원하는 흐름
- UI 영향
- API, 데이터, 도메인 영향
- 제약 조건
- 열린 질문
- Story 후보
- 최종 합의

사용자가 자연어로 명확히 동의하면 Goal 승인으로 봅니다.
실제 Goal 문서는 `docs/goals/` 아래에 로컬로만 보관하고 Git에 올리지 않습니다.

## 2. Story 후보 고르기

사용 스킬: `souzip-story`

Goal 승인 뒤 Story 후보 전체를 만듭니다.
Jira는 처음부터 전부 만들지 않습니다.

먼저 active Story 1~2개만 고릅니다.

- 첫 번째: 작지만 끝단 흐름을 실제로 연결해 볼 수 있는 Story
- 두 번째: 필요하면 가장 불확실한 기술 리스크를 검증하는 Story

너무 큰 Story는 Jira와 worktree로 올리기 전에 다시 쪼갭니다.

## 3. Story 시작하기

Story 하나는 worktree 하나이자 PR 하나입니다.

- base branch: `develop`
- target branch: `develop`
- Jira Story: active Story만 생성
- Story 문서: worktree, branch, base commit 기록
- 새 worktree 준비: `docs/harness/scripts/bootstrap-worktree.sh`

Story를 시작하기 전에는 `develop` 기준점이 분명해야 합니다.
새 worktree를 만든 직후에는 bootstrap 스크립트를 한 번 실행합니다.
이 스크립트는 로컬 `Config` 파일을 복사한 뒤 `tuist install`과 `tuist generate`를 실행합니다.
`tuist install`은 `Tuist/Package.resolved`를 기준으로 필요한 의존성 상태를 맞추며, 도구의 캐시가 있으면 재사용합니다.
실제 Story 문서는 `docs/goals/` 아래에 로컬로만 보관하고 Git에 올리지 않습니다.

## 4. Plan 만들기

사용 스킬: `souzip-plan`

Plan은 Story 안의 세션 단위 작업입니다.

Plan은 아래 기준을 만족해야 합니다.

- 한 세션에서 구현과 검증까지 끝낼 수 있습니다.
- 검증 명령이 있습니다.
- 하지 않을 범위가 분명합니다.

사용자가 Plan을 승인하고 “구현해”라고 말한 뒤에만 코드를 고칩니다.
실제 Plan 문서는 `docs/goals/` 아래에 로컬로만 보관하고 Git에 올리지 않습니다.

## 5. 구현하기

구현은 승인된 Plan 범위 안에서만 합니다.
Plan 밖 요구가 생기면 Plan을 먼저 고칩니다.

Tuist, Factory, 모듈 경계, 레이어 규칙처럼 큰 구조 변경이 필요하면 멈추고 사용자에게 묻습니다.

## 6. 검증하기

사용 스킬: `souzip-verify`

Plan 종료 기본 검증은 아래 순서입니다.

```bash
docs/harness/scripts/verify.sh plan
```

관련 테스트가 있으면 Plan에 맞게 지정합니다.

```bash
VERIFY_TEST_TARGETS="DomainTests" docs/harness/scripts/verify.sh plan
VERIFY_TEST_SCHEME="Domain" docs/harness/scripts/verify.sh plan
```

검증 실패가 Plan 범위 안이면 AI가 고치고 같은 검증을 다시 실행합니다.
같은 실패를 두 번 이상 수정해도 해결되지 않으면 원인 조사로 전환합니다.

## 7. Story 끝내기

Story의 모든 Plan이 끝나면 Story 종료 검증을 합니다.

```bash
docs/harness/scripts/verify.sh story
```

PR 전에는 Story 시작 이후 `develop`이 바뀌어 Plan이 낡지 않았는지 확인합니다.
확인은 변경 파일 겹침 기준으로 합니다.

```bash
git fetch origin develop
git diff --name-only {base_commit}..origin/develop
git diff --name-only {base_commit}..HEAD
```

두 결과에서 겹치는 파일이 있으면 멈추고 사용자에게 알립니다.
겹치는 파일이 없으면 Story 종료 검증을 유지하고 PR로 갈 수 있습니다.

## 8. Ship

사용 스킬: `souzip-commit`, `souzip-pr`

commit, PR 생성, PR 생성을 위한 push는 사용자가 명시적으로 말한 뒤에만 합니다.

- “커밋해”: commit 가능
- “PR”: PR 준비 확인 통과 뒤 Story 브랜치 push와 PR 생성 가능

Story PR은 `develop`으로 보냅니다.
