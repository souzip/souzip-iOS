# 모듈·레이어 구조 정립 플랜

**전제**: [`tuist-module-structure-consistency-research.md`](./tuist-module-structure-consistency-research.md).  
**이전 플랜과의 차이**: 철자·폴더 위생이 아니라, **Tuist 모듈을 무엇으로 둘지·레이어 규칙을 어떻게 고정할지**를 먼저 합의하고 그에 맞춰 정리하는 것이 본 플랜의 중심이다.

**승인 전 구현 금지** — 특히 **「헌장(문서)」**에 대한 합의 후 `구현해` 지시 시 코드 변경을 시작한다.

---

## 1. 사용자 요구사항 정렬

| 원하는 것 | 이 플랜에서의 위치 |
|-----------|-------------------|
| 모듈이 **막 만든 느낌**이 아니라 **의도가 보이게** | §2 헌장 + §3 모듈 카탈로그 + §4 의존성 규칙 |
| **레이어 구성**을 확실히 | §4 허용/금지 import 표 + App/Presentation/Domain/Data/Core/Shared 역할 정의 |
| **모듈 자체**를 정리 | §5 구조안 선택(합치기·이름·개수) → §6 구현 단계 |

부가적으로 필요하면 **부록**(철자, 미사용 SPM, `AuthURLHandling` 등)을 같은 리팩토링 브랜치에서 처리할 수 있으나, **본질은 아님**.

---

## 2. 1차 산출물: 모듈·레이어 헌장 (문서)

구현에 앞서 `docs/claude/` 아래에 **`module-layer-constitution.md`**(가칭)를 추가하거나 `architecture.md`에 동등 분량의 절을 넣는다. 아래 목차를 **채워 넣는 것**이 1차 목표다.

**필수 목차**

1. **레이어 다이어그램** (한 장): App → Presentation → Domain ← Data → Core/Shared  
2. **모듈 카탈로그 표**: 모듈명 | 한 줄 책임 | 속한 레이어 | 리소스/테스트 유무  
3. **의존성 행렬**: 행=모듈, 열=다른 모듈, 셀=허용/금지/조건부(이유 한 줄)  
4. **금지 규칙 예시**: `Presentation`은 `Data` import 금지, `Domain`은 UIKit 금지 등  
5. **Factory / DI 경계**: 누가 `DataFactory`·`DomainFactory`·`PresentationFactory`를 알고 있는지 한 단락  
6. **새 모듈 추가 절차**: “이 레이어에 속하는가 → `Module.swift`에 추가 → `ModuleDependencies` → 문서 표 갱신”

이 문서가 **팀 합의본**이 되면, Tuist·코드는 그 **단일 진실**에 맞춘다.

---

## 3. 모듈 카탈로그 (현 상태 — 헌장 작성 시 붙여 넣을 초안)

리서치 기준 **현재 Tuist 타깃**과 역할 요약. 이름 변경·통합은 §5에서 결정.

| 모듈 | 레이어 | 한 줄 책임 |
|------|--------|------------|
| **App** | Application | 진입점, 전역 조립(`AppFactory`), 설정 |
| **Presentation** | Feature UI | UIKit+Rx, Coordinator, ViewModel, 화면 Factory |
| **Domain** | Domain | 엔티티, Repository 프로토콜, UseCase, Factory **계약** |
| **Data** | Infrastructure | Repository 구현, API, OAuth, 로컬 저장 연동 |
| **Networking** | Core / Platform | HTTP 클라이언트, `APIEndpoint`, 토큰 재시도 훅 |
| **Keychain** | Core / Platform | Keychain 추상화 + 구현 |
| **UserDefaults** | Core / Platform | UserDefaults 타입드 래퍼 |
| **Logger** | Core / Platform | OSLog + **Amplitude**(이름과 실제 역할 불일치 — §5에서 정리 후보) |
| **AdMob** | Core / Platform (UI 의존) | 광고 SDK + `AdBannerView` |
| **DesignSystem** | Shared UI | DS 컴포넌트·토큰·폰트 리소스 |
| **Utils** | Shared | `AppInfo`, 저장소 키 타입 등 횡단 계약 |

**인지된 “막 만든 느낌”의 원인** (헌장에서 짚고 규칙으로 닫을 것):

- **Logger** = 로깅 + 제품 분석이 한 모듈에 공존.  
- **AdMob** = “Core”이지만 UIKit·Google SDK·Analytics까지 엮임.  
- **Core가 세분**되어 있으나 “왜 Networking만 따로인지 / Keychain과 UserDefaults를 왜 나눴는지”가 문서에 없음.  
- **App → Data** 직접 참조 등 레이어 예외가 암묵적.

---

## 4. 레이어·import 규칙 (헌장에 넣을 규범 초안)

아래는 **권장 규범**. 팀에서 수정해도 되나, **모순 없이 한 세트**로 확정할 것.

### 4.1 레이어 정의

- **Application (App)**: 프로세스 생명주기, 윈도우, **조립만**. 비즈니스 규칙 없음.  
- **Presentation**: 사용자 입력·표시, 내비게이션. Domain 타입·Factory만 의존.  
- **Domain**: 순수 규칙과 포트(Repository). 외부 I/O SDK 없음.  
- **Data**: Domain 포트 구현. Networking, Keychain, UserDefaults, 외부 OAuth SDK.  
- **Core (Platform)**: 여러 레이어가 공유하는 **기술 어댑터**. Domain은 가능하면 직접 링크하지 않고 Data/App 경유(현재는 Domain이 Logger·Utils만 링크 — 헌장에 “예외 허용”으로 명시).  
- **Shared**: UI(DesignSystem)와 비UI(Utils) **명시적 분리** — “Shared 한 덩어리”가 아니라 역할이 다른 두 모듈.

### 4.2 import 허용 표 (초안)

| ↓가 / →를 import | Domain | Data | Presentation | App | Networking | Keychain | UD | Logger | AdMob | DS | Utils |
|-------------------|--------|------|--------------|-----|------------|----------|----|--------|-------|----|----|
| Domain | — | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ○(명시) | ✗ | ✗ | ○ |
| Data | ○ | — | ✗ | ✗ | ○ | ○ | ○ | ○ | ✗ | ✗ | ○ |
| Presentation | ○ | ✗ | — | ✗ | ✗ | ✗ | ✗ | ○ | ○ | ○ | ○ |
| App | ○ | ○(조립만·금지 지향) | ○ | — | ○ | ○ | ○ | — | — | — | — |

- **App → Data**: 이상적으로는 **금지**; 조립을 Domain 추상(`AuthURLHandling` 등)으로만 노출(부록 참고).  
- **Presentation → AdMob**: UI 배너를 Core에 두었기 때문에 발생 — 헌장에 “광고는 Core 어댑터로만” 같은 문장으로 정당화하거나, 장기적으로 `Presentation`이 `AdServing` **프로토콜(Domain)** 만 보게 분리하는 후보를 적어둘 수 있음.

---

## 5. 모듈 구조안 선택 (합의 사항)

**반드시 팀이 하나를 고른다.** (구현은 그 다음.)

### 5.1 Core 유지 + 문서만으로 정당화 (변경 최소)

- 모듈 개수·이름 유지.  
- 헌장에 각 Core 모듈이 **왜 분리**되었는지(테스트 단위, 링크 비용, 책임)를 적는다.  
- Logger 모듈명은 유지하되, 헌장에 **“본 모듈은 로깅 및 Amplitude 분석을 포함한다”**고 명시.

**적합**: 당장 빌드 그래프를 건드리기 싫고, “막 만든 느낌”을 **설명 가능한 구조**로 바꾸고 싶을 때.

### 5.2 Core 일부 통합 (모듈 수 감소)

예시 (택일, 조합 가능):

- **Persistence**: `Keychain` + `UserDefaults` → 단일 모듈 `Persistence`(또는 `Storage`). Factory도 하나로.  
- **Observability**: `Logger` + `Analytics`로 쪼개거나, 반대로 이름을 `Observability`로 바꿔 **책임을 이름에 반영**.

**적합**: “작은 모듈이 너무 많다”는 인상을 줄이고 싶을 때.  
**비용**: `Module.swift`, `ModuleDependencies`, 모든 `import`, Factory, Tuist 경로 이동.

### 5.3 광고·지도를 “기능 어댑터”로 명시

- Tuist 타깃 수는 그대로 두더라도, 헌장에서 **AdMob / Mapbox**를 “Presentation 기능이 아닌 **서드파티 어댑터 의존성**”으로 규정하고, Presentation이 직접 SDK 타입을 최소화하는 방향(장기 과제)을 적는다.  
- (선택) 이후 PR에서 `PresentationGlobe` 등 **서브타깃** 분리는 별도 스파이크.

**적합**: 모듈 개수는 유지하되 **무거운 SDK 경계**를 명확히 하고 싶을 때.

### 5.4 Domain/Data/Presentation 피처 모듈화

- `DomainAuth`, `DataAuth` … 처럼 피처 단위 분리.  
- **비권장을 기본**: Factory·순환 의존 관리 비용이 큼. 헌장에 “현 단계에서는 하지 않는다”고 못을 박을 수 있음.

---

## 6. 구현 단계 (모듈·레이어 정립에 맞춘 순서)

**원칙**: 문서(헌장) 합의 → Tuist/경로/이름 → import·Factory 정합 → 부록 위생.

### 단계 A — 헌장 합의 (코드 변경 없음 또는 최소)

- [ ] `module-layer-constitution.md` 초안 작성·리뷰  
- [ ] §5에서 **구조안(5.1~5.3 중심)** 확정

### 단계 B — Tuist와 저장소 구조를 헌장에 맞춤

- [ ] `Tuist/ProjectDescriptionHelpers/Core/Module.swift` — 모듈 열거·`path`가 헌장 표와 1:1  
- [ ] `ModuleDependencies.swift` — 헌장의 의존 행렬과 일치  
- [ ] `Projects/*/Project.swift` — 통합/분리 시 신규·삭제 프로젝트 반영  
- [ ] `ExternalLibrary.swift` / `Package.swift` — 모듈별 SPM 연결 재점검

### 단계 C — 코드 이동·이름 변경 (5.2·5.3 선택 시)

- [ ] 통합 모듈이면 `import Keychain` → `import Persistence` 등 전역 치환  
- [ ] Factory 프로토콜 위치(App vs Data vs Domain) 헌장과 동일하게 유지

### 단계 D — 레이어 누수를 헌장과 맞춤

- [ ] App → Data 직접 import 제거(부록 B)  
- [ ] `grep -r "import Data" Projects/Presentation` 등으로 금지 위반 점검

### 단계 E — 문서 동기화

- [ ] `CLAUDE.md`, `docs/claude/architecture.md`에 헌장 링크 또는 요약 반영

---

## 7. 부록 — 위생·부가 정리 (본 목적 아님)

필요 시 같은 기간에 처리 가능. 헌장과 모순 없어야 함.

### 부록 A: SPM / SwiftSVG

- 미사용이면 `Tuist/Package.swift`에서 제거.

### 부록 B: `AuthURLHandling` (App → Data 누수)

- Domain 프로토콜 + Data 구현체 + `DataFactory` 노출. 상세 스니펫은 이전 버전 플랜과 동일.  
- `SceneDelegate`에서 `AppFactory` 보관 필요.

### 부록 C: 폴더 철자 (`Utill`, `Souvernir` 등)

- 헌장·모듈 구조 확정 **후** 별도 PR로 `git mv` 권장.

---

## 8. 검증

1. 헌장의 **의존 표**와 `ModuleDependencies.swift`를 대조 — 불일치 0.  
2. `tuist generate` 후 전 타깃 빌드.  
3. (통합 시) 기존 테스트 타깃 경로·import 전부 통과.

---

## 9. 승인 후

- 구현 중 모듈 개수·이름을 바꾸면 **헌장을 먼저 수정**하고 코드를 따른다.  
- 체크리스트는 구현 PR에서 이 문서에 반영.

---

## 참고

- [`tuist-module-structure-consistency-research.md`](./tuist-module-structure-consistency-research.md)
