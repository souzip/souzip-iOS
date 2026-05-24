# 하네스 지속 개선 (이벤트 기반)

> 정본: [`00-triggers.md`](00-triggers.md) · 세션: [`01-session-lifecycle.md`](01-session-lifecycle.md)  
> 로그: [`../friction-log.md`](../friction-log.md) · 개선 plan: [`../../plans/harness-improvement/plan.md`](../../plans/harness-improvement/plan.md)

---

## 1. 언제 쓰나

| 상황 | 할 일 | 하지 말 것 |
|------|--------|------------|
| AI가 게이트·스킬을 어김 | **기록** — friction-log 한 행 | workflow·스킬 즉시 수정 |
| 「왜 그렇게 했어?」 회고 | **기록** — 기대/실제/없던 문서 | 채팅만으로 끝내기 |
| 「이거 토대로 개선하자」 | **plan** — 개선 범위·Before/After | G1 없이 정본 수정 |

정기(매주) harness 점검은 **하지 않는다**.

---

## 2. 기록 절차

1. [`friction-log.md`](../friction-log.md) 표에 **한 행** 추가  
2. 열: 날짜 · 작업·세션 · 기대 · 실제 · 문서에 없던 것 · 조치(비워 둠)  
3. `progress.md` Session Record에 “friction N건” 한 줄 (선택)  
4. **조치** 열은 개선 implement 후에만 채움 (예: `00-triggers §3.1 행 추가`)

---

## 3. 개선 절차

1. 사용자 「이거 토대로 개선하자」 (또는 특정 friction 행 날짜·세션 지정)  
2. **plan** — `docs/plans/harness-improvement/plan.md` 갱신 또는 당회 mini-plan (변경 파일·Before/After)  
3. 사용자 승인 · 「구현해」  
4. **implement** — plan에 적힌 harness 파일만 수정 (iOS 코드 ❌)  
5. **verify** — 트리거 표·링크·friction 조치 열 기록  
6. (사용자 지시 시) **ship** — docs/harness 분리 커밋  

---

## 4. friction-log vs 기타

| | friction-log | scratch | agent-harness-rebuild/friction-log |
|--|--------------|---------|-----------------------------------|
| 용도 | 운영 마찰·회고 | 당일 임시 | H3 제작 메타 |
| git | ✅ | ❌ | ✅ (역사) |
| 개선 트리거 | 사용자 명시 시 plan | — | — |

---

## 5. 완료의 뜻 (이 루프 한 사이클)

- friction에 적힌 항목이 plan에 반영됨  
- harness 정본이 plan과 일치  
- friction **조치** 열에 “무엇을 고쳤는지” 한 줄  
