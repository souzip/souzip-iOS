# Context — 프로젝트 구조·규칙

구현·리뷰·Plan 작성 전에 읽는 Souzip iOS 정적 맥락입니다.
채팅으로 매번 재설명하거나 코드 전체를 훑기 전에 여기서 시작합니다.

## 문서 목록

| 문서 | 언제 읽나 |
|------|-----------|
| [`architecture.md`](architecture.md) | 전체 구조, 레이어, 부트스트랩, Coordinator 트리 |
| [`layers.md`](layers.md) | Tuist 모듈, import, Factory 경계 |
| [`presentation.md`](presentation.md) | ViewModel, View, Coordinator, Scene 폴더 |
| [`domain-and-data.md`](domain-and-data.md) | UseCase, Repository, Endpoint, DTO, Mapper |
| [`feature-playbook.md`](feature-playbook.md) | 새 기능 Domain → Data → Presentation 순서 |
| [`project.md`](project.md) | 앱 개요, 빌드, 검증 한 줄 |

## 읽는 순서

1. 처음 / 큰 그림 → `architecture.md`
2. import·모듈 위반 검증 → `layers.md`
3. 화면 작업 → `presentation.md` + 해당 `Scene/` 코드
4. API·UseCase → `domain-and-data.md` + `feature-playbook.md`
5. 세션만 → `project.md`

## 하네스와의 관계

| | 경로 |
|---|------|
| 규칙 | [`../constitution.md`](../constitution.md) |
| 작업 흐름 | [`../workflow/`](../workflow/) |
| 작업 문서 | [`../../goals/`](../../goals/README.md) |
