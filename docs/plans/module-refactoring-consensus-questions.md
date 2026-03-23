# 모듈·레이어 리팩토링 합의 질문지

**용도**: 구현 전에 아래에 답을 채워 합의를 고정한다.  
**관련 문서**: [`module-layer-redesign-plan.md`](./module-layer-redesign-plan.md), [`../claude/module-layer-constitution.md`](../claude/module-layer-constitution.md)

---

## 1. OAuth / App 레이어

### Q1-1

`SceneDelegate`(또는 유사 진입점)에서 OAuth URL 처리 시 **`import Data` + `AuthRedirect` 직접 호출**을 계속 허용할지, 나중에 Domain 프로토콜로 감쌀 여지를 둘지.

**답:**
`SceneDelegate`(또는 유사 진입점)에서 OAuth URL 처리 시 **`import Data` + `AuthRedirect` 직접 호출**

### Q1-2

위와 별개로, **지금 당장** `AuthURLHandling` 같은 추상화를 도입할 계획이 있는지. (없음 / 나중 / 이번 마일스톤에 포함)

**답:**
없음 굳이같음

---

## 2. Bootstrap (앱 기동)

### Q2-1

폰트 등록, Kingfisher, Amplitude(또는 분석) 초기화를 **`Bootstrap` 전용 모듈**로 모을지. (예 / 아니오 / 보류)

**답:**
전용 모듈을 하나 만들자

### Q2-2

“예”일 때, **`AppConfiguration`은 Utils + `Bootstrap` 호출만** 하도록 줄이는 것을 이번 범위에 넣을지.

**답:**
예. `AppConfiguration`은 설정 읽기·`Bootstrap` 한 번 호출 위주로 줄인다.

### Q2-3

`Bootstrap` 모듈 위치 선호: `Projects/Shared/Bootstrap` / `Projects/Bootstrap` / 기타 (경로)

**답:**
Projects/Shared/Bootstrap

---

## 3. Infrastructure (Core 정리)

### Q3-1

Networking + Keychain + UserDefaults를 **하나의 `Infrastructure`(가칭) 모듈**로 묶을지. (예 / 아니오 / 단계적으로)

**답:**
Keychain + UserDefaults 이 두개만 영속성 모듈로 묶는게 나을듯

### Q3-2

“아니오” 또는 “단계적”이면, **1차로 Persistence(Keychain+UD)만 합치고 Networking은 분리**해도 되는지.

**답:**
그게 좋을듯

### Q3-3

통합 시 모듈 이름 선호: `Infrastructure` / `PlatformKit` / 기타

**답:**
Storage

---

## 4. Logger / 관측 (Observability)

### Q4-1

기존 `Logger` 모듈을 **`Observability`로 이름 변경**하는 것에 동의하는지. (예 / 아니오 / 이름 후보 있음)

**답:**
아니오

### Q4-2

Amplitude 등 분석과 OSLog 로깅을 **한 모듈에 유지**할지, **`Logger` + `Analytics`로 분리**할지.

**답:**
분리하자

---

## 5. 광고 (AdMob)

### Q5-1

`Core/AdMob`을 **`Shared/Ads`(또는 `Monetization`)** 등으로 옮기고 모듈명을 정리할지. (이번 마일스톤 / 나중 / 안 함)

**답:**
Core로 하자

### Q5-2

선호하는 모듈·폴더 이름: `Ads` / `Monetization` / 기타

**답:**
Ads

---

## 6. Presentation 구조 (후순위)

### Q6-1

`Presentation`을 **`PresentationCore` + 피처 모듈(예: FeatureGlobe)** 로 나누는 작업을 **이번에 할지, 안정화 후로 미룰지.**

**답:**
안정화 이후

### Q6-2

미룰 경우, **언제쯤** 재검토할지 (예: Bootstrap·Infrastructure 끝난 뒤)

**답:**
일단 다음 이번작업(PR) 이후에

---

## 7. Domain / Tuist

### Q7-1

Domain 타깃에서 **Logger·Utils Tuist 의존 제거** 방향을 **유지할지 / 되돌릴지.**

**답:**
유지하자

---

## 8. 위생 / 소규모 정리

### Q8-1

`Utill` → `Util` 등 **폴더명 오타 정리**, **SwiftSVG 미사용 제거**를 **같은 마일스톤에 포함**할지, **별도 PR**로 할지.

**답:**
정리해줘

---

## 9. 이번 마일스톤 범위 (한 줄)

### Q9-1

위 답을 반영해 **이번에 반드시 끝낼 것**과 **다음으로 미룰 것**을 각각 한 줄로 적는다.

**이번에:** 아래 §10 마일스톤 실행안 전체(한 번에 끝내는 범위).

**다음에:** `PresentationCore` / 피처 모듈 분리 등 Q6 합의 항목(이번 PR·마일스톤 직후 재검토).

---

## 10. 이번 마일스톤 실행안 (합의 반영)

**전제**: 한 마일스톤에서 아래 작업을 **순서대로** 완료한다. 중간마다 `tuist generate` + 클린 빌드로 검증한다.

### 10.1 이번에 포함하는 것

| # | 작업 | 비고 |
|---|------|------|
| A | **`Storage` 모듈** | Keychain + UserDefaults만 통합. **Networking은 기존 모듈 유지.** Tuist·import 일괄 갱신. |
| B | **`Logger` + `Analytics` 타깃 분리** (OSLog vs Amplitude) | `Observability`로의 **이름 변경은 하지 않음**(Q4-1). 두 타깃으로 쪼개고 의존성 정리. |
| C | **`Bootstrap` 모듈** | 경로 `Projects/Shared/Bootstrap`. 폰트·Kingfisher·분석 초기화 등 기동 루틴 응집. |
| D | **`AppConfiguration` 축소** | Utils + `Bootstrap` 호출 중심. 불필요한 cross-import 제거. |
| E | **광고** | **`Core` 아래**로 두고 폴더·모듈명 **`Ads`** 로 정리 (Q5-1, Q5-2). |
| F | **Domain Tuist** | Logger·Utils **의존 제거 유지**, 빌드로 재검증. |
| G | **위생** | `Utill` → `Util` 등 폴더명, **SwiftSVG** 미사용 시 제거. |
| H | **문서** | `module-layer-constitution.md`, 필요 시 `module-layer-redesign-plan.md` 요약 갱신. |

### 10.2 이번에 포함하지 않는 것 (합의 유지)

- `AuthURLHandling` 등 Domain 추상화 (Q1-2).
- **`Observability`로 Logger 타깃 단순 리네임** (Q4-1 아니오).
- Networking까지 한 모듈로 묶는 **풀 `Infrastructure`** (Q3 — **Storage만**).
- **`PresentationCore` / `FeatureGlobe` 등 Presentation 쪼개기** — **이번 마일스톤 다음**에 재검토 (Q6).

### 10.3 권장 구현 순서 (의존성·리스크 기준)

1. **Storage** — Data·App 등이 Keychain/UD를 새 모듈로만 보도록 먼저 고정.
2. **Logger / Analytics** — 기존 소비처가 많으면 import만 일괄 치환.
3. **Bootstrap** + **AppConfiguration** — 기동 경로 단일화.
4. **Ads** (Core 경로·이름 정리).
5. **위생** + **문서** — 마지막에 폴더 rename·SPM 정리로 충돌 최소화(팀에 따라 5번을 앞당겨도 됨).

### 10.4 완료 정의 (스모크)

- 콜드 스타트 → 폰트·이미지 캐시·분석·로그·첫 화면.
- OAuth URL (`AuthRedirect`) 동작.
- 광고 배너 경로(있다면) 로딩.

---

## 개정 이력

| 날짜 | 내용 |
|------|------|
| 2025-03-23 | 초안 (합의 질문 템플릿) |
| 2025-03-23 | §10 마일스톤 실행안 추가, Q2-2·Q9-1 반영 |
