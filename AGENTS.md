# Souzip — Codex 작업 기준

수집(Souzip)은 여행 기념품 iOS 앱입니다. 이 레포에서 AI 작업 기준은 **Codex**입니다.

## 말하는 방식

사용자에게는 한국어 존댓말로, 평소 작업 설명하듯 답합니다.
왜 그런지 먼저 말하고, 파일·폴더 이름은 그다음에 말합니다.
낯선 영어와 기술 용어는 처음 나올 때 바로 풀어 설명합니다.

자세한 기준: [`docs/harness/communication.md`](docs/harness/communication.md)

## 기본 흐름

```text
Goal
  └── Story
        └── Plan
```

- **Goal**: 기능 목표와 이해관계를 문서화한 단위입니다.
- **Story**: PR 하나가 되는 작업 단위입니다.
- **Plan**: 한 세션에서 구현과 검증까지 끝낼 수 있는 작업 단위입니다.

AI는 인터뷰로 요구사항을 먼저 명확히 하고, 목표 문서를 만든 뒤 Story를 나눕니다.
Story 하나는 PR 하나입니다. Story를 끝내기 위해 여러 Plan을 차례로 처리합니다.

## 지켜야 할 선

- 목표 문서와 Story 분리안은 사용자 확인 후 확정합니다.
- Story worktree는 항상 `develop` 기준으로 만듭니다.
- Plan은 사용자 승인 후 구현합니다.
- 사용자가 "구현해"라고 하기 전에는 코드를 고치지 않습니다.
- Plan 범위 안의 검증 실패는 AI가 고치고 다시 검증합니다.
- Tuist, Factory, 모듈 경계, 레이어 규칙처럼 큰 구조 변경이 필요하면 멈추고 묻습니다.
- 사용자가 "커밋해"라고 하기 전에는 commit을 하지 않습니다.
- 사용자가 "PR"이라고 하기 전에는 PR 생성과 PR 생성을 위한 push를 하지 않습니다.

## 서브에이전트

역할 지시는 [`.agents/agents/`](.agents/agents/)에 둡니다.
현재 기준은 독립된 세션으로 메인 대화를 깨끗하게 유지하는 것입니다. 병렬 작업은 나중에 필요할 때 붙입니다.

## 참고 문서

- 하네스 개요: [`docs/harness/README.md`](docs/harness/README.md)
- 실제 작업 순서: [`docs/harness/workflow/operating-sequence.md`](docs/harness/workflow/operating-sequence.md)
- 워크플로우 스킬: [`docs/harness/skills.md`](docs/harness/skills.md)
- 작업 흐름: [`docs/harness/workflow/story-plan-session.md`](docs/harness/workflow/story-plan-session.md)
- 검증 기준: [`docs/harness/verification.md`](docs/harness/verification.md)
