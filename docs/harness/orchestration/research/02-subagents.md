# 02. Subagents

서브에이전트 역할 분리와 독립 세션 기준을 조사합니다.

## 조사한 레퍼런스

| 레퍼런스 | 볼 점 |
|----------|-------|
| [OpenAI Codex Subagents](https://developers.openai.com/codex/subagents) | Codex 서브에이전트는 사용자가 명시적으로 요청할 때만 생긴다. built-in agent와 custom agent 위치가 있다. |
| [OpenAI Codex Subagents concepts](https://developers.openai.com/codex/concepts/subagents) | 서브에이전트의 핵심은 컨텍스트 오염을 줄이고, 읽기·검토·반복 작업을 나누는 것이다. |
| [obra/superpowers subagent-driven-development](https://github.com/obra/superpowers/blob/main/skills/subagent-driven-development/SKILL.md) | fresh subagent per task, 구현 후 spec review와 code quality review를 분리한다. 구현 병렬은 충돌 위험이 있어 조심한다. |
| [garrytan/gstack skills](https://github.com/garrytan/gstack/blob/main/docs/skills.md) | 제품, 설계, 엔지니어링, QA처럼 역할별 리뷰를 나누고, 계획 단계에서 검증 관점을 먼저 넣는다. |
| [Yeachan-Heo/oh-my-codex](https://github.com/Yeachan-Heo/oh-my-codex) | Codex를 실행 엔진으로 두고, 인터뷰·플랜·목표·상태를 별도 워크플로우 레이어로 관리한다. |
| [GitHub Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent) | 독립 환경에서 repository research, plan, branch 작업, PR 준비를 수행한다. 작업 단위와 기록이 PR 흐름에 남는다. |
| [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) | 가정 확인, 단순한 변경, 필요한 부분만 고치기, 검증 가능한 성공 기준을 강조한다. |

## 레퍼런스에서 가져올 패턴

- 서브에이전트는 메인 세션의 전체 대화 기록을 그대로 물려받지 않고, 필요한 입력만 받아야 합니다.
- 메인 세션은 사용자 합의, 범위 판단, 최종 선택을 맡습니다.
- 서브에이전트는 조사, 초안, 구현, 검증처럼 좁은 역할을 맡습니다.
- 구현 결과는 다른 관점의 검토를 거친 뒤 완료로 봅니다.
- 병렬은 읽기 중심 작업이나 서로 파일이 겹치지 않는 작업에 먼저 씁니다.
- 구현 병렬은 Story worktree가 안정되고 충돌 범위가 분명할 때만 씁니다.
- 결과는 항상 요약, 근거, 리스크, 남은 질문 형태로 메인 세션에 돌아와야 합니다.

## Souzip 하네스에 반영할 결정

- 첫 목적은 병렬보다 독립 세션입니다.
- 메인 세션은 판단과 사용자 합의를 맡습니다.
- 서브에이전트는 메인 세션이 준 입력 밖으로 결정을 확장하지 않습니다.
- 조사, 인터뷰 보조, Story 분리, Plan 작성, 구현, 검증을 나눕니다.
- `researcher`, `interviewer`, `story-splitter`, `planner`, `verifier`는 기본적으로 독립형입니다.
- `researcher`는 여러 레퍼런스를 나눠 보는 경우 병렬형으로도 쓸 수 있습니다.
- `verifier`는 PR 전 보안, 회귀, 테스트 누락처럼 읽기 중심 검토를 나눌 때 병렬형으로도 쓸 수 있습니다.
- `implementer`는 당장은 독립형입니다. 병렬 구현은 Story 하나가 worktree 하나로 안정되고, 서로 다른 Story의 파일 충돌 가능성이 낮을 때만 허용합니다.
- 같은 Story 안에서 여러 구현 에이전트를 동시에 돌리지 않습니다.

## 에이전트 호출 입력

서브에이전트에는 아래 입력을 줍니다.

- 맡길 역할
- 현재 Goal, Story, Plan 중 어디에 속하는지
- 허용된 파일과 금지된 파일
- 사용할 레퍼런스나 문서
- 검증해야 할 기준
- 멈춰야 하는 조건
- 결과 형식

## 에이전트 결과 형식

서브에이전트는 아래 순서로 보고합니다.

- 결론
- 근거 파일 또는 링크
- 추천안
- 리스크
- 남은 질문
- 직접 고친 파일과 검증 결과

구현하지 않는 역할은 파일을 고치지 않습니다.
조사와 검토 역할은 코드 변경 없이 근거만 남깁니다.

## Codex 실행 형식

지금은 `.agents/agents/*.md`를 역할 설계 문서로 둡니다.
Codex의 실행 가능한 project custom agent가 필요해지면 `.codex/agents/*.toml`로 옮깁니다.

Codex 공식 형식 기준으로 custom agent에는 최소한 아래가 필요합니다.

- `name`
- `description`
- `developer_instructions`

읽기 전용 에이전트는 가능한 한 read-only sandbox로 둡니다.
동시에 여러 에이전트를 쓸 경우 thread 수와 깊이는 작게 유지합니다.

## 답해야 할 질문

- 어떤 역할을 서브에이전트로 분리하면 메인 세션이 덜 오염되는가?
- 어떤 역할은 병렬 작업에 적합한가?
- 서브에이전트 결과를 메인 세션이 어떻게 검토해야 하는가?
- 사용자 승인이 필요한 결과와 그렇지 않은 결과를 어떻게 나누는가?
- Codex 기준에서 역할 설명 파일을 어디에 두는 것이 적절한가?

## 참고할 레퍼런스 후보

- `garrytan/gstack`: CEO, engineering, design, QA, release 같은 역할 기반 스킬 구조
- `obra/superpowers`: subagent-driven development와 review 흐름
- `Yeachan-Heo/oh-my-codex`: agent catalog, team 실행, 상태 관리
- `sigridjineth/oh-my-codex`: structured planning, specialized agents, lifecycle hooks 사례
- reviewer / verifier agent 패턴
- research agent 패턴
- planner / implementer 분리 사례
- agent role prompt 구조

## 우리 기준 초안

- 첫 목적은 병렬보다 독립 세션입니다.
- 메인 세션은 판단과 사용자 합의를 맡습니다.
- 조사, 인터뷰 보조, Story 분리, Plan 작성, 구현, 검증을 나눕니다.
- 구현 에이전트는 당장은 독립형으로만 씁니다.
- 병렬은 researcher와 verifier 같은 읽기 중심 역할부터 허용합니다.

## 조사 후 반영할 문서

- `docs/harness/agents.md`
- `.agents/agents/workflow/*.md`

## 조사 후 정리

- `story-splitter`와 `planner`는 계속 분리합니다. Story는 PR 단위 판단이고, Plan은 세션 단위 실행 판단이라 실패 기준이 다릅니다.
- `researcher`는 웹 조사와 로컬 문서 조사를 모두 맡습니다. 단, 코드 변경은 하지 않습니다.

## 남은 질문

- `.codex/agents/*.toml`을 언제 실제 실행 형식으로 만들지 정해야 합니다.
