# Plan: {date}-{slice}

feature: {feature}
story: {story}
status: draft

## 이번 Plan

...

## 하지 않을 것

- ...

## 할 일

- [ ] ...

## 검증 명령

```bash
docs/harness/scripts/verify.sh plan
```

관련 테스트:

```bash
# 예: VERIFY_TEST_TARGETS="DomainTests" docs/harness/scripts/verify.sh plan
```

## 완료 기준

- [ ] 구현 완료
- [ ] SwiftFormat lint 통과
- [ ] SwiftLint 통과
- [ ] Tuist generate 통과
- [ ] Tuist build 통과
- [ ] 관련 테스트 통과 또는 생략 이유 기록

## 검증 결과

- swiftformat:
- swiftlint:
- generate:
- build:
- test:
- 생략한 검증과 이유:

## 메모

Plan에 없는 요구가 생기면 먼저 Plan을 고칩니다.
