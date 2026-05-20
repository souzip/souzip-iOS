# Context — 프로젝트 구조·규칙 (AI용)

구현·리뷰·플랜 작성 전 **정적 맥락**. 채팅·전체 코드 스캔 대신 여기서 시작.

## 문서 목록

| 문서 | 언제 읽나 |
|------|-----------|
| [`architecture.md`](architecture.md) | **전체 구조** — 레이어·부트스트랩·Coordinator 트리 (먼저) |
| [`layers.md`](layers.md) | Tuist 모듈·import·Factory 경계 |
| [`presentation.md`](presentation.md) | ViewModel·View·Coordinator·Scene 폴더 |
| [`domain-and-data.md`](domain-and-data.md) | UseCase·Repository·Endpoint·DTO·Mapper |
| [`feature-playbook.md`](feature-playbook.md) | **새 기능** Domain→Data→Presentation 순서 |
| [`project.md`](project.md) | 앱 개요·빌드·preflight 한 줄 |

## 읽는 순서 (권장)

1. 처음 / 큰 그림 → `architecture.md`
2. import·모듈 위반 검증 → `layers.md`
3. 화면 작업 → `presentation.md` + 해당 `Scene/` 코드
4. API·UseCase → `domain-and-data.md` + `feature-playbook.md`
5. 세션만 → `project.md` + [`../progress.md`](../progress.md)

## 하네스와의 관계

| 층 | 경로 | 역할 |
|----|------|------|
| constitution | [`../constitution.md`](../constitution.md) | 금지·게이트 |
| **context** | 이 폴더 | 프로젝트 구조·패턴 |
| workflow | [`../workflows/`](../workflows/) | 5모드·게이트 |
| artifact | [`../../plans/`](../../plans/) | `plan.md` |

기능별 완료: `plan.md` §완료 기준 · 공통 금지: `constitution.md`.
