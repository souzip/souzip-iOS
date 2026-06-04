# Harness Requirements

현재까지 사용자와 합의한 기본 요구입니다.

## 작업 흐름

- 인터뷰로 요구사항과 이해관계를 명확히 합니다.
- 목표 문서를 기준으로 Story를 나눕니다.
- Story는 기본적으로 기술 경계로 나눕니다.
- 기술 경계 안에서도 너무 크면 사용자 가치 기준으로 다시 나눕니다.
- Story 하나는 PR 하나입니다.
- Story 하나는 worktree 하나입니다.
- Story worktree는 항상 `develop`에서 만듭니다.
- Story PR은 항상 `develop`으로 보냅니다.
- Goal 승인 뒤 Story 목록을 만들지만, Jira Story는 active 후보 1~2개부터 만듭니다.
- 첫 번째 active Story는 작지만 끝단 흐름을 실제로 연결해 볼 수 있는 Story입니다.
- 두 번째 active Story가 필요하면 가장 불확실한 기술 리스크를 검증하는 Story입니다.
- 너무 큰 Story는 Jira와 worktree로 올리기 전에 다시 쪼갭니다.
- Plan 하나는 한 세션에서 구현과 검증까지 끝낼 수 있어야 합니다.
- 실제 Goal, Story, Plan 문서는 `docs/goals/` 아래에 로컬 보관하고 Git에 올리지 않습니다.
- Goal 승인 문구는 고정하지 않습니다. 사용자가 자연어로 명확히 동의하면 승인으로 봅니다.
- Goal 승인 전에는 Story Jira, worktree, Plan으로 넘어가지 않습니다.
- PR 전에는 `base_commit..origin/develop` 변경 파일과 `base_commit..HEAD` 변경 파일이 겹치는지 확인합니다.
- 변경 파일이 겹치면 멈추고 사용자에게 알립니다.

## 검증

- Plan 종료 시 기본 검증을 합니다.
- 기본 검증은 SwiftFormat lint, SwiftLint, Tuist generate, Tuist build, 관련 테스트입니다.
- 검증 스크립트는 `docs/harness/scripts/verify.sh`입니다.
- 관련 테스트는 `VERIFY_TEST_TARGETS` 또는 `VERIFY_TEST_SCHEME`으로 지정합니다.
- 관련 테스트가 없으면 Plan 문서에 생략 이유를 적습니다.
- Plan 범위 안의 실패는 AI가 고치고 다시 검증합니다.
- 같은 실패를 두 번 이상 수정해도 해결되지 않으면 원인 조사로 전환합니다.
- 큰 구조 변경이 필요하면 AI가 멈추고 사용자에게 묻습니다.

## 서브에이전트

- 우선 목적은 병렬보다 독립된 세션으로 메인 대화를 깨끗하게 유지하는 것입니다.
- 메인 세션은 사용자 합의, 범위 판단, 최종 선택을 맡습니다.
- 서브에이전트는 조사, 초안, 구현, 검증처럼 좁은 역할만 맡습니다.
- 병렬은 먼저 researcher와 verifier 같은 읽기 중심 역할에만 씁니다.
- implementer는 당장은 독립형으로만 씁니다.
- 구현 병렬은 나중에 Story와 worktree 분리가 안정되면 붙입니다.
