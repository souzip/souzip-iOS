# docs/goals

기능별 Goal, Story, Plan 문서를 두는 곳입니다.
실제 기능 작업 문서는 로컬 작업물로 보고 Git에 올리지 않습니다.
이 폴더에서는 README만 Git에 남깁니다.

## 구조

```text
docs/goals/{feature}/
├── goal.md
├── interview.md
└── stories/
    └── {story}/
        ├── story.md
        └── plans/
            └── YYYY-MM-DD-{slice}/
                └── plan.md
```

템플릿은 [`../harness/templates/`](../harness/templates/README.md)에 있습니다.
