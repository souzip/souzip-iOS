# Jira × Goal · Story

Jira는 작업을 추적하기 위한 도구이고, 자세한 합의는 로컬 Goal, Story, Plan 문서에 둡니다.

## 기준

| 로컬 단위 | Jira |
|-----------|------|
| Goal | Epic 선택 |
| Story | active 후보 1~2개부터 Story 생성 |
| Plan | 없음 |

Story 하나는 PR 하나입니다. PR 링크는 해당 Jira Story에 연결합니다.

Goal 승인 뒤 Story 목록을 만들지만, Jira Story를 한 번에 전부 만들지는 않습니다.
먼저 진행할 active Story 1~2개만 Jira에 만들고, 나머지는 후보로 둡니다.

active Story는 아래 기준으로 고릅니다.

- 첫 번째는 작지만 끝단 흐름을 실제로 연결해 볼 수 있는 Story입니다.
- 두 번째가 필요하면 가장 불확실한 기술 리스크를 검증하는 Story입니다.
- 너무 큰 Story는 Jira 생성 전에 다시 쪼갭니다.

## 막는 조건

Story를 Jira에 만들거나 연결하기 전에 아래가 있어야 합니다.

- Goal 문서
- 인터뷰 합의
- Story 후보와 slug
- 사용자의 확인

Jira 연동 방식은 이후 Codex 기준 도구가 정해지면 다시 구체화합니다.
