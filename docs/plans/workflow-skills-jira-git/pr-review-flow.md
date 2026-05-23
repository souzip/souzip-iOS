# PR 규칙 (`souzip-pr`)

> **구현 스킬**: `.cursor/skills/souzip-pr` · **G4**  
> **템플릿**: [`.github/pull_request_template.md`](../../../.github/pull_request_template.md) · [`docs/harness/templates/pr-body.md`](../../harness/templates/pr-body.md)  
> **선행**: 리뷰 단위 커밋 ([`commit-review-flow.md`](commit-review-flow.md))

---

## 철학

| | 내용 |
|---|------|
| **PR 1개** | `feat/SOU-XXX/slug` → base **`develop`** |
| **상태** | **Ready for review** — `gh pr create` (**`--draft` 없음**, intake **A**) |
| **본문** | `develop...HEAD` **전체** · 기존 📌 섹션 + **변경 요약에 Plan 한 줄** |
| **제목** | `[SOU-XXX] 한국어 요약` |
| **순서** | **verify → PR** — `gh pr` 전 `souzip-verify` 체크 (스킬 내장) |

---

## 게이트

- **G4**: 「PR 만들어줘」 등 명시 시만
- **G3 (PR)**: Critical 없을 때만 `gh pr` · No-Go면 PR 중단
- **cwd**: worktree ([`worktree-start-flow.md`](worktree-start-flow.md))
- verify 생략(사용자 명시) → PR **기타**에 1줄 경고

---

## 1. 검증 (PR 전 필수)

[`souzip-verify`](../../../.cursor/skills/souzip-verify/SKILL.md) · [`00-triggers.md`](../../harness/workflows/00-triggers.md) §5

- `develop...HEAD` · plan 범위 · 레이어 · plan 테스트 실행
- 산출: 심각도별 이슈 · **Go / No-Go**
- **Critical** → PR 만들지 않음 (수정 후 재요청)
- 예외: 「verify 생략하고 PR」→ 기타 1줄 경고 후 진행

---

## 2. 사전 조사 (병렬)

```bash
git status
git branch -vv
git log develop..HEAD --oneline
git diff develop...HEAD
```

---

## 3. PR 제목

```text
[SOU-633] 마이페이지 찜 그리드 UI 구현
```

- `[SOU-XXX]` ← 브랜치 · 커밋 메시지에는 티켓 번호 **붙이지 않음**

---

## 4. PR 본문 (하네스 + 기존 템플릿)

GitHub이 `.github/pull_request_template.md`를 넣어 주면, AI가 섹션을 채운다.

| 섹션 | 내용 |
|------|------|
| **📌 변경 요약** | `docs/plans/{feature-slug}/plan.md` · bullet (`develop...HEAD` 전체) |
| **📌 변경 내용** | 레이어/기능 bullet |
| **📌 스크린샷 / 동작 확인** | UI 있을 때 표 |
| **📌 기타 참고 사항** | worktree·임시·생략 사유 |

상세 채우기: [`docs/harness/templates/pr-body.md`](../../harness/templates/pr-body.md)

---

## 5. Push

| 상황 | 동작 |
|------|------|
| remote 없음 | 「PR 만들어줘」 시 `git push -u origin HEAD` (PR용 1회) |
| 이미 push됨 | 생략 |

---

## 6. 생성 (Go 이후만)

```bash
gh pr create --base develop --title "[SOU-XXX] …" --body-file …
# 또는 HEREDOC — --draft 없음
```

---

## 예시 — SOU-633

**커밋:** `feat` Domain·Data · `docs` plan · `feat` Presentation

**본문 요약 bullet 예:**

- Domain/Data 위시리스트 · Presentation 찜 탭 UI · plan 갱신

**테스트 예:** plan §완료 기준 → preflight, 빌드, 찜 토글 동작

---

## 변경 이력

| 날짜 | 내용 |
|------|------|
| 2026-05 | Ready for review (A) · 기존 PR 템플릿 + Jira·plan·테스트 섹션 |
| 2026-05-24 | PR 전 `souzip-verify` 필수 (G3) · 생략은 사용자 명시 + 기타 경고 |
