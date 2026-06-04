# 03. Interview and Goal Document

인터뷰 방식과 목표 문서 템플릿을 조사합니다.

## 조사한 레퍼런스

| 레퍼런스 | 볼 점 |
|----------|-------|
| [obra/superpowers](https://github.com/obra/superpowers) | 코드 작성 전에 질문, 대안 탐색, 설계 승인, 계획으로 넘어가는 흐름을 둔다. |
| [superpowers brainstorming](https://www.skills.sh/obra/superpowers/brainstorming) | 단순해 보여도 짧은 설계 확인을 거치고, 코드·스캐폴딩 전에 승인을 받는다. |
| [superpowers issue #565](https://github.com/obra/superpowers/issues/565) | 설계 문서와 구현 계획을 분리하지 않거나, 문서 작성 뒤 사용자 게이트를 건너뛰면 흐름이 깨진다. |
| [gstack skills](https://github.com/garrytan/gstack/blob/main/docs/skills.md) | `/office-hours`는 먼저 문제를 다시 묻고, `/spec`은 모호한 의도를 실행 가능한 spec으로 바꾼다. |
| [Yeachan-Heo/oh-my-codex](https://github.com/Yeachan-Heo/oh-my-codex) | 인터뷰, 목표, 플랜을 별도 흐름으로 나눠 Codex 실행 전에 맥락을 만든다. |

## 레퍼런스에서 가져올 패턴

- 코드 전에는 요구사항을 바로 구현하지 않고, 먼저 의도와 문제를 확인합니다.
- 질문은 한 번에 너무 많이 던지지 않고, 답에 따라 다음 질문을 좁힙니다.
- 목표 문서와 구현 Plan은 분리합니다.
- Goal 문서가 작성된 뒤에도 사용자가 승인하기 전에는 Story와 Plan을 확정하지 않습니다.
- 열린 질문과 최종 합의는 분리합니다.
- 성공 기준은 나중에 검증 가능한 문장으로 씁니다.
- 하지 않을 범위를 함께 적어야 Story가 커지는 것을 막을 수 있습니다.

## Souzip 하네스에 반영할 결정

- 인터뷰는 Goal 문서를 만들기 위한 단계입니다.
- 인터뷰는 기본 질문 순서를 따르되, 이미 답이 있는 항목은 건너뜁니다.
- 질문은 한 번에 1~3개만 던집니다.
- Goal 문서는 PR 단위 Story를 나눌 수 있을 만큼만 씁니다.
- Story 후보는 Goal 문서에 둡니다.
- 자세한 Story 본문은 Story 시작 시 별도 Story 문서에 둡니다.
- Goal 승인 조건은 체크리스트와 사용자 명시 합의를 함께 둡니다.
- Goal 승인 문구는 고정하지 않습니다. 사용자가 자연어로 명확히 동의하면 승인으로 봅니다.
- 사용자가 Goal을 승인하기 전에는 Story Jira, worktree, Plan으로 넘어가지 않습니다.

## 인터뷰 질문 순서

1. 목표: 무엇을 바꾸려는가?
2. 배경: 왜 지금 필요한가?
3. 사용자와 이해관계: 누가 영향을 받고 무엇을 얻는가?
4. 성공 기준: 무엇이 되면 끝났다고 볼 수 있는가?
5. 하지 않을 것: 이번 Goal에서 제외할 것은 무엇인가?
6. 현재 흐름과 원하는 흐름: 지금은 어떻게 동작하고, 바뀐 뒤에는 어떻게 흘러야 하는가?
7. UI: 화면, 진입 경로, 상태, 에러, 빈 상태가 필요한가?
8. API, 데이터, 도메인: 모델, 저장, 네트워크, 실패 케이스가 바뀌는가?
9. 제약과 리스크: 일정, 기술, 호환성, 모듈 경계에서 걸리는 것이 있는가?
10. Story 후보: PR 단위로 어떻게 나눌 수 있는가?
11. 최종 합의: 열린 질문이 닫혔고, 사용자가 이 Goal로 진행해도 된다고 말했는가?

## Goal 완료 체크리스트

- 한 줄 목표가 있다.
- 성공 기준이 검증 가능한 문장이다.
- 하지 않을 것이 적혀 있다.
- UI 영향이 있으면 화면과 상태가 적혀 있다.
- API, 데이터, 도메인 영향이 있으면 변경 범위가 적혀 있다.
- Story 후보가 있다.
- active Story 1~2개를 고를 수 있다.
- 열린 질문이 없거나, 남은 질문을 보류해도 되는 이유가 적혀 있다.
- 사용자가 명시적으로 승인했다.

## 답해야 할 질문

- AI가 기능 요구사항을 묻는 순서는 어떻게 잡아야 하는가?
- 목표 문서에는 어떤 항목이 꼭 있어야 하는가?
- 이해관계는 어떤 형식으로 적어야 Story 분리에 도움이 되는가?
- UI, API, 데이터, 제약을 어느 깊이까지 Goal 문서에 적어야 하는가?
- 열린 질문과 최종 합의를 어떻게 분리해야 하는가?

## 참고할 레퍼런스 후보

- `obra/superpowers`: code 전에 spec과 design approval을 먼저 만드는 흐름
- `garrytan/gstack`: `/office-hours`, `/spec`, 제품·설계·엔지니어링 리뷰
- `Yeachan-Heo/oh-my-codex`: `$deep-interview`, `$ralplan`, `$ultragoal` 흐름
- product requirements document
- design doc
- RFC template
- user story mapping
- discovery interview
- acceptance criteria 작성 방식

## 우리 기준 초안

Goal 문서에는 아래 항목을 둡니다.

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

## 조사 후 반영할 문서

- `docs/harness/templates/goal/goal-template.md`
- `docs/harness/templates/interview/interview-template.md`
- `.agents/agents/workflow/interviewer.md`
- `.agents/agents/workflow/story-splitter.md`

## 남은 질문

- 없음.
