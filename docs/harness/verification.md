# Verification

Plan은 구현만 끝났다고 닫지 않습니다.
기본 검증을 통과해야 합니다.

## 기본 검증

- SwiftFormat lint
- SwiftLint
- Tuist generate
- Tuist build
- 관련 테스트

기본 스크립트:

```bash
docs/harness/scripts/verify.sh plan
```

관련 테스트는 Plan에 맞게 지정합니다.

```bash
VERIFY_TEST_TARGETS="DomainTests" docs/harness/scripts/verify.sh plan
VERIFY_TEST_SCHEME="Domain" docs/harness/scripts/verify.sh plan
```

관련 테스트가 없으면 Plan 문서에 생략 이유를 적습니다.

## 실패 처리

Plan 범위 안에서 고칠 수 있는 실패는 AI가 고치고 다시 검증합니다.

예:

- lint 오류
- 타입 오류
- 이번 Plan에서 추가한 테스트 실패
- 작은 누락 수정

아래처럼 범위를 키우는 문제는 멈추고 사용자에게 묻습니다.

- Tuist 설정 변경
- Factory 구성 변경
- 모듈 경계 변경
- 레이어 규칙 변경
- Plan 밖 대규모 리팩터링

같은 실패를 두 번 이상 수정해도 해결되지 않으면 원인 조사로 전환합니다.

## Story 종료 검증

Story의 모든 Plan이 끝나면 아래를 확인합니다.

- Plan 기본 검증
- Story 안에서 바뀐 모듈의 테스트
- 필요하면 전체 테스트
- `develop` 변경으로 Story/Plan이 낡지 않았는지 확인

## PR 직전 검증

PR 전에는 아래를 확인합니다.

- Story 종료 검증 결과
- `base_commit..origin/develop` 변경 파일과 `base_commit..HEAD` 변경 파일이 겹치는지 확인
- 실패하거나 생략한 검증
- 남은 리스크

변경 파일이 겹치면 멈추고 사용자에게 알립니다.
겹치지 않으면 Story 종료 검증 결과를 유지하고 PR로 갈 수 있습니다.

완료라고 말할 때는 실행한 명령과 결과를 함께 말합니다.
