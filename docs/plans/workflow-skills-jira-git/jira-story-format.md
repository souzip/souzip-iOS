# Jira 스토리 작성 규칙 (intake 확정)

> **용도**: `souzip-start` · Atlassian MCP `createJiraIssue`  
> **플러그인**: Cursor Atlassian (MCP) — 미연결 시 [연결 가이드](../../harness/jira-mcp-setup.md) 후 진행  
> **plan 연동**: 본문은 Jira 비움 → [`docs/plans/{feature-slug}/plan.md`](../) 에 상세

---

## 필드 규칙

| 필드 | 규칙 |
|------|------|
| **프로젝트** | SOU (`souzip`) |
| **이슈 타입** | 스토리 (Story) |
| **Summary** | `[iOS] {영역} — {한 줄}` |
| **Description** | **비움** (항상) |
| **담당자 (Assignee)** | 생성자 본인 (`currentUser`) |
| **Reporter** | MCP 기본 (보통 생성자) |
| **레이블** | `ios` |
| **Priority** | **Medium** (기본, 별도 질문 없음) |
| **스프린트** | **현재 활성 스프린트** 1개 (MCP 조회 후 자동) |

### Summary — `{영역}`

- **AI가** 사용자 기능 설명에서 추론 (intake **B**)
- 확인 표에 영역 표시 → 틀리면 수정 후 생성
- 예: `마이페이지`, `발견`, `기념품`, `인증·온보딩`, `지도`, `공통`

### plans 폴더 (레포)

- 경로: **`docs/plans/{feature-slug}/`** (kebab-case, intake **B**)
- Jira 키는 **`plan.md` 상단**에만:
  ```markdown
  # …
  > **Jira**: [SOU-633](https://souzip.atlassian.net/browse/SOU-633)
  ```
- `feature-slug` ≠ 브랜치 slug와 같게 두는 것을 **권장** (필수는 아님)

### 브랜치 (start 후속)

- `feat/SOU-{번호}/{slug}` — [`plan.md`](plan.md) §worktree

---

## 생성 전 확인 (intake **A**)

`createJiraIssue` **직전** 사용자에게 표시:

| 항목 | 예 |
|------|-----|
| Summary 초안 | `[iOS] 마이페이지 — 찜 그리드 UI 구현` |
| 영역 (추론) | 마이페이지 |
| 활성 스프린트 | (MCP로 조회한 이름, 예: `SOU Sprint 3`) |
| (암묵) | Assignee: 본인 · Label: ios · Priority: Medium |

사용자 **「만들어」/「확인」** 후에만 생성. 수정 요청 시 표만 갱신.

---

## MCP 생성 흐름 (요약)

1. MCP 게이트 — 없으면 **중단**, 연결 안내
2. (신규) 기능 설명 수집 → summary·영역·slug 초안
3. 활성 스프린트 조회
4. **확인 표** → 승인
5. `createJiraIssue` — 위 필드 적용
6. 반환 키 `SOU-XXX` 기록 → `progress.md` · `docs/plans/{feature-slug}/` 제안

**이미 키가 있으면** (예: SOU-633): 생성 생략 → 이슈 조회만 → worktree 단계로.

---

## 예시 — 신규 스토리

**사용자:** 「마이페이지 찜 그리드 UI 스토리 만들고 시작 준비해줘」

**AI 초안:**

```text
Summary: [iOS] 마이페이지 — 찜 그리드 UI 구현
영역:    마이페이지 (추론)
스프린트: SOU Sprint N (활성)
Assignee: 박주성 · Label: ios · Priority: Medium
Description: (비움)
plan 경로: docs/plans/wishlist-mypage-grid/
```

**사용자:** 「만들어」

**결과:** `SOU-634` 생성 → 이후 worktree·preflight는 `souzip-start` 본문.

---

## 예시 — 기존 스토리

**사용자:** 「SOU-633 작업 시작」

- Jira 조회만
- 생성·확인 표 **생략**
- worktree: `~/work/souzip/SOU-633-{slug}/`

---

## 비목표 (이 문서)

- Description·AC를 Jira에 쓰기
- Epic·subtask·대량 백로그 (`spec-to-backlog`는 별도)
- 웹에서 수동 생성을 **기본 경로**로 두기
- Priority·스프린트·레이블을 매번 질문하기

---

## 변경 이력

| 날짜 | 내용 |
|------|------|
| 2026-05 | intake 확정 (summary B, description 비움, 확인 A, 영역 B, plans B, priority A) |
