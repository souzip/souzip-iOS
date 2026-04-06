---
name: create-pr
description: >
  Souzip 프로젝트의 PR을 생성하는 스킬.
  사용자가 "PR 만들어줘", "PR 생성해줘", "PR 올려줘" 등을 요청할 때 이 스킬을 사용한다.
---

# PR 생성 스킬

## 트리거

"PR 만들어줘", "PR 생성해", "PR 올려줘", "PR 해줘"

---

## 사전 준비 (병렬 실행)

다음 명령을 모두 **병렬로** 실행해 현재 브랜치 상태를 파악한다:

```bash
git status
git diff
git log
git diff develop...HEAD
```

원격 브랜치가 없으면 `git push -u origin <branch>` 먼저 실행.

---

## PR 제목 규칙

```
[SOU-XXX] 한국어 제목
```

- JIRA 티켓 번호는 브랜치명에서 추출 (예: `feat/SOU-398/...` → `[SOU-398]`)
- 브랜치명에 티켓 번호가 없으면 `[SOU-XXX]` 대신 변경 내용을 한 줄로 요약
- 70자 이하
- 한국어로 작성

---

## PR 본문 형식

```markdown
## 📌 변경 요약
- 변경 항목 요약 1
- 변경 항목 요약 2
- 변경 항목 요약 3

## 📌 변경 내용
#### 소제목 1
- 세부 항목
- 세부 항목

#### 소제목 2
- 세부 항목
- 세부 항목
```

**작성 기준:**
- `변경 요약`: 전체 변경의 핵심을 3줄 이내로 요약
- `변경 내용`: 파일/모듈/기능 단위로 소제목을 나눠 상세 기술
- 최신 커밋만 보지 말고 `develop` 대비 **모든 커밋**을 분석해 작성
- 한국어로 작성

---

## 금지 사항

- `Co-Authored-By` 절대 포함 금지 (PR 본문, 커밋 모두)
- base 브랜치는 항상 `develop`

---

## 실행 명령

```bash
gh pr create \
  --title "[SOU-XXX] 한국어 제목" \
  --base develop \
  --body "$(cat <<'EOF'
## 📌 변경 요약
- ...

## 📌 변경 내용
#### ...
- ...
EOF
)"
```

---

## 예시

브랜치: `refactor/SOU-572/core-modules-restructure`
커밋 요약: Core 모듈 구조 재편, App Factory·기동 구성 반영, Util 경로 정리

```
gh pr create \
  --title "[SOU-572] Core 모듈 구조 재편 및 경로 정리" \
  --base develop \
  --body "..."
```

**제목:** `[SOU-572] Core 모듈 구조 재편 및 경로 정리`

**본문:**

```markdown
## 📌 변경 요약
- Core 모듈을 독립 모듈로 재구성하고 App Factory·기동 구성에 반영
- Domain·Presentation·Data 레이어의 Util 경로 및 Factory 정리
- 모듈 헌장·아키텍처·플랜 문서 동기화

## 📌 변경 내용
#### Core 모듈 재편
- Core 모듈을 `Projects/Core/{module}/` 구조로 분리
- App Factory 및 기동 구성(`AppFactory`, `AppDelegate`)에 Core 모듈 의존성 연결

#### Util 경로 및 Factory 정리
- Domain Util을 `Projects/Domain/Sources/Util/`로 이동
- Presentation Util을 `Projects/Presentation/Sources/Util/`로 이동
- Data Util을 `Projects/Data/Sources/Util/`로 이동
- Configuration·Factory 파일 경로를 레이어 관례에 맞게 재배치

#### 문서 동기화
- `docs/claude/architecture.md`, `module-layer-constitution.md` 최신 구조 반영
```
