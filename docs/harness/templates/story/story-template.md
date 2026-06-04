# Story: {story}

feature: {feature}
status: pending
jira:
base_branch: develop
base_commit:
target_branch: develop
branch:
worktree:

## 한 줄

...

## 범위

- ...

## 하지 않을 것

- ...

## Plans

| plan | status | verify |
|------|--------|--------|
| ... | pending | - |

## 완료 기준

- [ ] 모든 Plan 완료
- [ ] 기본 검증 통과
- [ ] `base_commit..origin/develop` 변경 파일 확인
- [ ] `base_commit..HEAD` 변경 파일 확인
- [ ] 두 변경 파일 목록의 겹침 없음 또는 사용자 확인 완료
- [ ] PR 생성
- [ ] Jira Story 갱신
