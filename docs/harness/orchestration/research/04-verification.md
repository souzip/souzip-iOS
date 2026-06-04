# 04. Verification

Plan 종료 검증과 실패 처리 기준을 조사합니다.

## 조사한 레퍼런스

| 레퍼런스 | 볼 점 |
|----------|-------|
| [superpowers verification-before-completion](https://github.com/obra/superpowers/blob/main/skills/verification-before-completion/SKILL.md) | 완료라고 말하기 전에 방금 실행한 검증 명령과 결과가 있어야 한다. |
| [superpowers requesting-code-review](https://github.com/obra/superpowers/blob/main/skills/requesting-code-review/SKILL.md) | 작업 후 리뷰를 별도 관점으로 요청하고, Critical/Important 이슈는 진행 전에 처리한다. |
| [superpowers subagent-driven-development](https://github.com/obra/superpowers/blob/main/skills/subagent-driven-development/SKILL.md) | 구현 뒤 spec 준수 리뷰와 코드 품질 리뷰를 분리한다. |
| [gstack skills](https://github.com/garrytan/gstack/blob/main/docs/skills.md) | `/qa`, `/review`, `/investigate`처럼 검증, 리뷰, 원인 조사를 역할로 나눈다. |
| [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) | 성공 기준을 검증 가능한 형태로 만들고 테스트 루프와 연결한다. |
| [Tuist test docs](https://tuist.dev/en/docs/cli/test) | `tuist test`는 프로젝트 테스트를 실행하며 scheme, target, configuration, device 같은 옵션을 받는다. |

## 로컬 확인 결과

- 도구 버전은 `.mise.toml`에 둡니다.
- 현재 도구는 `tuist`, `swiftformat`, `swiftlint`입니다.
- Tuist 버전은 `4.109.2`입니다.
- SwiftFormat 설정은 `.swiftformat`입니다.
- SwiftLint 설정은 `.swiftlint.yml`입니다.
- `docs/harness/scripts/preflight.sh`는 `tuist install`, `tuist generate`까지만 확인합니다.
- 빌드 스크립트는 SwiftFormat을 빌드 전 자동 실행합니다.
- 테스트 타깃이 있는 모듈은 `Data`, `Domain`, `Presentation`, `Storage`입니다.

## 레퍼런스에서 가져올 패턴

- 완료 주장은 검증 명령을 새로 실행한 뒤에만 합니다.
- 검증 결과는 명령, 성공/실패, 실패 이유를 함께 남깁니다.
- lint 통과는 build 통과를 대신하지 않습니다.
- build 통과는 테스트 통과를 대신하지 않습니다.
- 구현한 세션과 검증한 세션을 분리하면 놓친 범위나 회귀를 더 잘 잡을 수 있습니다.
- 실패를 바로 고치기 전에 Plan 범위 안인지 먼저 분류합니다.
- 같은 실패를 반복해서 고치는 경우 원인 조사를 먼저 합니다.

## Souzip 하네스에 반영할 결정

- Plan 종료 기본 검증은 format lint, SwiftLint, Tuist generate, Tuist build, 관련 테스트입니다.
- 관련 테스트는 Plan에서 `VERIFY_TEST_TARGETS` 또는 `VERIFY_TEST_SCHEME`으로 지정합니다.
- 관련 테스트가 없으면 Plan 문서에 생략 이유를 적습니다.
- Story 종료 또는 PR 직전에는 전체 테스트를 검토합니다.
- 완료라고 말할 때는 실행한 명령과 결과를 함께 말합니다.
- Plan 범위 안의 실패는 AI가 수정하고 같은 검증을 다시 실행합니다.
- Plan 밖 구조 변경이 필요한 실패는 멈추고 사용자에게 묻습니다.
- 같은 실패를 두 번 이상 수정해도 해결되지 않으면 원인 조사로 전환합니다.

## 검증 단계

### Plan 기본 검증

1. `swiftformat . --config .swiftformat --lint`
2. `swiftlint lint --config .swiftlint.yml`
3. `tuist generate`
4. `tuist build "$VERIFY_BUILD_SCHEME"`
5. 관련 테스트

### Story 종료 검증

- Plan 기본 검증
- Story 안에서 바뀐 모듈의 테스트
- 필요하면 전체 테스트
- PR 전 `develop` 변경으로 Plan이 낡지 않았는지 확인

### PR 직전 검증

- Story 종료 검증
- verifier 관점의 변경 파일 리뷰
- 실패, 생략, 남은 리스크 정리

## 답해야 할 질문

- Plan마다 어떤 검증을 기본으로 돌릴 것인가?
- lint, build, 관련 테스트의 실행 순서는 어떻게 잡을 것인가?
- 검증 실패를 AI가 고쳐도 되는 경우는 어디까지인가?
- 큰 구조 변경이 필요한 실패는 어떻게 감지할 것인가?
- Story 종료 또는 PR 직전에는 더 강한 검증을 돌려야 하는가?

## 참고할 레퍼런스 후보

- `multica-ai/andrej-karpathy-skills`: success criteria, tests-first, verified loop
- `obra/superpowers`: TDD, implementation plan, review를 묶은 흐름
- `garrytan/gstack`: `/qa`, `/qa-only`, `/review`, `/investigate`
- `Yeachan-Heo/oh-my-codex`: review, TDD, hooks, session state 흐름
- test pyramid
- CI quality gate
- pre-merge checklist
- automated verification loop
- reviewer agent / verifier agent 사례

## 우리 기준 초안

- Plan 종료 기본 검증은 lint, build, 관련 테스트입니다.
- Plan 범위 안의 실패는 AI가 고치고 다시 검증합니다.
- Tuist, Factory, 모듈 경계, 레이어 규칙 변경은 멈추고 사용자에게 묻습니다.
- 전체 테스트 같은 무거운 검증은 Story 종료 또는 PR 직전에 검토합니다.

## 조사 후 반영할 문서

- `docs/harness/verification.md`
- `docs/harness/workflow/gates.md`
- `.agents/agents/workflow/verifier.md`
- `docs/harness/scripts/verify.sh`

## 남은 질문

- 없음.
