# 01. Workflow Structure

Goal → Story → Plan 흐름과 PR 단위 작업 구조를 조사합니다.

## 답해야 할 질문

- Goal, Story, Plan을 어떤 기준으로 나누는가?
- Story 하나를 PR 하나로 보는 구조가 적절한가?
- Story는 기술 경계와 사용자 가치 중 무엇을 우선해야 하는가?
- Plan은 어느 정도 작아야 한 세션에서 구현과 검증까지 끝나는가?
- 작업 문서는 Git에 올리는 것과 로컬에 두는 것을 어떻게 나누는가?

## 참고할 레퍼런스 후보

- `obra/superpowers`: 대화에서 spec을 끌어내고, 승인 뒤 plan과 subagent 개발로 넘어가는 흐름
- `Yeachan-Heo/oh-my-codex`: Codex 중심의 deep interview, plan, ultragoal 흐름
- `garrytan/gstack`: `/spec`과 GitHub issue, worktree, ship 흐름
- `multica-ai/andrej-karpathy-skills`: success criteria와 verification loop 중심의 Goal-driven execution
- spec-driven development
- PRD to tasks 흐름
- task decomposition
- PR 단위 작업 방식

## 조사한 레퍼런스

| 레퍼런스 | 확인한 점 |
|----------|-----------|
| [`obra/superpowers`](https://github.com/obra/superpowers) | 코드 작성 전에 질문으로 설계를 뽑고, 사용자가 설계에 동의한 뒤 구현 계획을 만든다. 이후 작은 작업, 테스트 주도 구현, 리뷰, 브랜치 마무리로 이어진다. |
| [`obra/superpowers` subagent-driven-development](https://github.com/obra/superpowers/blob/main/skills/subagent-driven-development/SKILL.md) | 계획이 있는 상태에서 독립 작업을 fresh subagent에 넘기고, 작업마다 명세 준수와 코드 품질을 따로 리뷰한다. |
| [`obra/superpowers` issue #989](https://github.com/obra/superpowers/issues/989) | 병렬 세션에서는 spec과 plan이 낡을 수 있다. 분석을 시작하기 전 코드 상태를 고정하거나, 병합 전에 main 변경분을 다시 확인해야 한다. |
| [`garrytan/gstack` AGENTS.md](https://github.com/garrytan/gstack/blob/main/AGENTS.md) | `/office-hours`, `/spec`, plan 리뷰, QA, ship처럼 역할별 스킬이 분리되어 있다. `/spec`은 모호한 의도를 실행 가능한 spec으로 바꾸고 issue/worktree/ship으로 이어진다. |
| [`Yeachan-Heo/oh-my-codex`](https://github.com/Yeachan-Heo/oh-my-codex) | Codex 중심으로 deep interview → plan review → goal execution 흐름을 둔다. 계획, 로그, 상태를 작업 폴더에 남기는 방향이 강하다. |
| [`multica-ai/andrej-karpathy-skills`](https://github.com/multica-ai/andrej-karpathy-skills) | 생각 먼저, 단순하게, 필요한 곳만 수정, 검증 가능한 목표로 실행하라는 네 가지 원칙이 핵심이다. |

## 조사하면서 얻은 패턴

### 1. 코드 전 단계가 따로 있다

Superpowers와 gstack 모두 코드 전에 요구를 다시 묻고, 설계나 spec을 먼저 만든다.
이 단계는 구현 계획과 다르다. 사용자의 의도, 범위, 성공 기준을 확인하는 단계다.

Souzip에 맞게 바꾸면, 이 단계는 **Goal 인터뷰와 Goal 문서 작성**입니다.

### 2. 설계 승인 뒤에 Plan이 나온다

Superpowers는 설계 동의 뒤 구현 계획을 만들고, gstack도 spec과 plan 리뷰를 분리한다.
계획은 “무엇을 만들지”가 아니라 “어떤 순서로 바꾸고 어떻게 확인할지”를 담는다.

Souzip에서는 Goal 승인 뒤 Story를 나누고, Story 안에서 Plan을 만든다.

### 3. Plan은 검증 가능한 작은 작업이어야 한다

Superpowers의 writing-plans는 아주 작은 작업과 검증 단계를 강조한다.
Karpathy 계열 원칙도 성공 기준과 검증 루프가 약하면 AI가 독립적으로 끝내기 어렵다고 본다.

Souzip에서는 Plan을 “한 세션에서 구현과 기본 검증까지 끝낼 수 있는 단위”로 유지합니다.

### 4. Story와 Plan 사이에 코드 상태 문제가 생길 수 있다

Superpowers issue #989는 병렬 세션에서 spec과 plan이 낡는 문제를 지적한다.
분석 시점과 실행 시점 사이에 main이 바뀌면, 파일 경로와 설계가 더 이상 맞지 않을 수 있다.

Souzip에서는 병렬보다 독립 세션에 초점을 둡니다.
그래도 Story 시작 시 코드 기준점을 기록하고, PR 전에는 main 변경으로 Story나 Plan이 낡지 않았는지 확인해야 합니다.

### 5. 역할은 많아도 메인 흐름은 단순해야 한다

gstack과 oh-my-codex는 역할과 스킬이 많다.
하지만 Souzip은 처음부터 전체 실행층을 들여오면 다시 무거워진다.

Souzip은 먼저 Goal → Story → Plan만 고정하고, 서브에이전트는 그 흐름을 보조하는 역할로 둡니다.

## Souzip 하네스에 반영할 결정

- Goal은 코드 작성 전 인터뷰와 합의 단계입니다.
- Goal 문서는 사용자의 의도, 이해관계, 범위, 성공 기준을 담습니다.
- Story는 PR 하나가 되는 작업 단위입니다.
- Story는 기본적으로 기술 경계로 나누고, 너무 크면 사용자 가치 기준으로 다시 나눕니다.
- Story 하나는 worktree 하나입니다.
- Story worktree는 항상 `develop`에서 만듭니다.
- Story PR은 항상 `develop`으로 보냅니다.
- Goal 승인 뒤 Story 목록을 만들지만, Jira Story는 처음부터 전부 만들지 않습니다.
- Jira Story는 실제로 시작할 active Story 1~2개만 먼저 만듭니다.
- 첫 번째 active Story는 작지만 API, 도메인, 저장, UI 같은 끝단 흐름을 실제로 연결해 볼 수 있는 얇은 Story를 우선합니다.
- 두 번째 active Story가 필요하면 가장 불확실한 기술 리스크를 검증하는 Story를 고릅니다.
- 너무 큰 Story는 active Story로 올리기 전에 다시 쪼갭니다.
- Plan은 Story 안의 실행 단위이며, 한 세션에서 구현과 기본 검증까지 끝낼 수 있어야 합니다.
- Plan에는 검증 방법이 반드시 있어야 합니다.
- Story 시작 시점의 `develop` 기준점을 기록합니다.
- PR 전에는 `develop` 변경으로 Story/Plan이 낡지 않았는지 확인합니다.

## 버릴 것 또는 보류할 것

- Superpowers처럼 작업을 2~5분 단위까지 쪼개지는 않습니다. Souzip Plan은 한 세션 단위가 더 맞습니다.
- gstack처럼 많은 역할 스킬을 한 번에 들여오지 않습니다. 먼저 필요한 역할만 문서로 둡니다.
- oh-my-codex처럼 별도 런타임, 훅, 상태 관리 CLI를 지금 도입하지 않습니다.
- 모든 작업을 처음부터 병렬 worktree로 운영하지 않습니다. 병렬은 나중에 Story 분리가 안정된 뒤 검토합니다.

## 우리 기준 초안

- Goal은 기능 목표와 이해관계를 담습니다.
- Story는 기본적으로 기술 경계로 나눕니다.
- 기술 경계가 너무 크면 사용자 가치 기준으로 다시 나눕니다.
- Story 하나는 worktree 하나이자 PR 하나입니다.
- Story는 항상 `develop`에서 시작하고 `develop`으로 PR을 보냅니다.
- Story 목록은 Goal 승인 뒤 만들지만, Jira Story는 active 후보 1~2개만 먼저 만듭니다.
- active Story 선택은 얇은 끝단 흐름을 1순위, 기술 리스크 검증을 2순위로 둡니다.
- Plan 하나는 한 세션에서 구현과 검증까지 끝낼 수 있어야 합니다.

## 조사 후 반영할 문서

- `docs/harness/workflow/story-plan-session.md`
- `docs/harness/templates/goal/goal-template.md`
- `docs/harness/templates/story/story-template.md`
- `docs/harness/templates/plan/plan-template.md`

## 조사 후 정리

- Story 문서의 코드 기준점은 `base_branch: develop`, `base_commit`, `target_branch: develop`, `branch`, `worktree`로 둡니다.
- Goal 승인은 Story 후보를 만들 수 있다는 합의이고, Story 분리안은 별도로 사용자 확인 후 확정합니다.
- 실제 Goal, Story, Plan 문서는 `docs/goals/` 아래에 로컬 보관하고 Git에 올리지 않습니다.
- PR 전 staleness check는 변경 파일 겹침 기준으로 합니다.
- `base_commit..origin/develop`과 `base_commit..HEAD`의 변경 파일이 겹치면 멈추고 사용자에게 알립니다.

## 남은 질문

- 없음.
