# Jira × Goal · Story

Jira는 작업을 추적하기 위한 도구이고, 자세한 합의는 로컬 Goal, Story, Plan 문서에 둡니다.

실행 스킬: `souzip-jira-story`

## 기준

| 로컬 단위 | Jira |
|-----------|------|
| Goal | Epic 1개 |
| Story | active 후보 1~2개부터 Story 생성 |
| Plan | 없음 |

Story 하나는 PR 하나입니다. PR 링크는 해당 Jira Story에 연결합니다.

Goal 승인 뒤 Story 목록을 만들지만, Jira Story를 한 번에 전부 만들지는 않습니다.
먼저 진행할 active Story 1~2개만 Jira에 만들고, 나머지는 후보로 둡니다.

active Story는 아래 기준으로 고릅니다.

- 첫 번째는 작지만 끝단 흐름을 실제로 연결해 볼 수 있는 Story입니다.
- 두 번째가 필요하면 가장 불확실한 기술 리스크를 검증하는 Story입니다.
- 너무 큰 Story는 Jira 생성 전에 다시 쪼갭니다.

## 흐름

1. `souzip-story`로 active Story를 확정합니다.
2. `souzip-jira-story`가 Epic·Story 초안을 준비합니다.
3. 사용자가 초안을 승인합니다.
4. 사용자가 `Jira 만들어`처럼 명시적으로 말하면 Jira에 생성하거나 기존 이슈에 연결합니다.
5. worktree·브랜치 순서는 자유입니다. Jira 키가 생기면 브랜치명 `feat/SOU-xxx/{slug}`를 제안만 합니다.

## Jira 필드 기본값

| 필드 | Epic | Story |
|------|------|-------|
| project | `SOU` | `SOU` |
| issue type | `에픽` | `스토리` |
| summary | `[iOS] {Goal 한 줄}` | `[iOS] {Story 한 줄}` |
| labels | 없음 | `ios` |
| parent | 없음 | Epic 키 |

`priority`와 `description`은 넣지 않습니다.

## 중복 검색

1. Goal Story 표나 Story 문서의 `jira` 키를 먼저 확인합니다.
2. 없으면 같은 Epic 아래 summary·slug 유사 이슈를 검색합니다.
3. 유사 이슈가 있으면 연결할지 새로 만들지 사용자에게 묻습니다.

## 막는 조건

Story를 Jira에 만들거나 연결하기 전에 아래가 있어야 합니다.

- Goal 문서
- 인터뷰 합의
- Story 후보와 slug
- active Story 확정
- Jira 초안 승인
- Jira 생성 명시 지시

## PR 타이틀

- Jira 키 있음: `[SOU-xxx] {제목}`
- Jira 키 없음: `[NO-ISSUE] {제목}`

## 로컬 문서 갱신

Jira 생성·연결 후 아래를 갱신합니다.

- Goal 문서: Epic 키, Story 표 `jira` 컬럼
- Story 문서: `jira:` 필드
- 브랜치명: 제안만, 자동 rename 없음
