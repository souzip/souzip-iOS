---
name: souzip-jira-story
description: Create or link Souzip active Stories in Jira after Story confirmation. Use when active Story 1-2 is confirmed, Jira drafts need preparation, Epic linkage is needed, duplicate Story search is required, or the user asks to create Jira Stories. Uses Atlassian MCP.
---

# Souzip Jira Story

Use this skill after `souzip-story` confirms active Story 1-2.

Jira is for tracking. Local Goal and Story documents remain the source of truth.

## Read First

- `docs/harness/jira/workflow.md`
- `docs/harness/workflow/operating-sequence.md`
- `docs/harness/templates/goal/goal-template.md`
- `docs/harness/templates/story/story-template.md`
- `docs/harness/constitution.md`

## Prerequisites

Stop and ask if any item is missing.

- Approved Goal document under `docs/goals/{feature}/`
- Confirmed active Story 1-2 with slug
- Local Story documents or Story rows in the Goal table

## Jira Defaults

Apply these defaults unless the user changes them in the draft review.

| Field | Epic | Story |
|-------|------|-------|
| project | `SOU` | `SOU` |
| issue type | `에픽` | `스토리` |
| summary | `[iOS] {Goal 한 줄}` | `[iOS] {Story 한 줄}` |
| labels | none | `ios` |
| assignee | current user when appropriate | current user when appropriate |
| parent | none | Epic key |

Do not set `priority`.
Do not set `description`.

Atlassian site: `souzip.atlassian.net`

Before the first draft in a session, read a few recent `SOU` issues created by the current user and match the existing Souzip pattern. If the pattern differs from the table above, follow the live Jira pattern and call out the difference in the draft.

## Workflow

### 1. Prepare Epic

1. Read the Goal document.
2. If the Goal already has an Epic key, fetch it and confirm it exists.
3. If no Epic exists, search Jira for a similar Epic under `SOU`.
4. If no suitable Epic exists, draft a new Epic:
   - summary: `[iOS] {Goal 한 줄}`
   - no description
   - no priority
5. Show the Epic draft and wait for user approval.
6. Create the Epic only after draft approval and an explicit create instruction such as `Jira 만들어` or `Epic 생성해`.
7. Record the Epic key in the Goal document.

### 2. Check Duplicates

For each active Story:

1. If the Goal Story table or Story document already has a `jira` key, fetch that issue and prefer linking over creating.
2. Otherwise search Jira under the Goal Epic:
   - same Epic parent
   - similar summary or slug
3. If a likely duplicate exists, show it and ask whether to link or create a new Story.

### 3. Prepare Story Drafts

For each active Story without a confirmed Jira key:

1. Summarize the Story into a short Jira summary only.
2. Draft fields:
   - summary: `[iOS] {Story 한 줄}`
   - issue type: `스토리`
   - parent: Goal Epic key
   - labels: `ios`
   - assignee: current user when appropriate
3. Do not include description or priority.
4. Show the draft and wait for user approval.

Active Story is confirmed does not mean Jira is created automatically.
After draft approval, prepare only.
Create in Jira only after an explicit user instruction.

### 4. Create or Link

When the user explicitly asks to create Jira issues:

1. Use Atlassian MCP:
   - `getAccessibleAtlassianResources`
   - `searchJiraIssuesUsingJql`
   - `getJiraIssue`
   - `createJiraIssue`
2. Create Epic first when needed.
3. Create or link Story issues under the Epic.
4. Return issue keys and browse URLs.

### 5. Update Local Documents

After create or link:

1. Goal document:
   - Epic key
   - Story table `jira` column
2. Story document:
   - frontmatter `jira:` field
3. Branch suggestion only:
   - with Jira key: `feat/SOU-xxx/{slug}`
   - without Jira key: `feat/{slug}`
4. Do not rename branches automatically.
5. Do not create worktrees.

## PR Title Rule

When preparing PR context, use:

- Jira key exists: `[SOU-xxx] {title}`
- Jira key missing: `[NO-ISSUE] {title}`

Actual PR creation stays in `souzip-pr`.

## Output

- Epic status: existing, linked, drafted, or created
- Duplicate search result
- Story draft or linked key per active Story
- Local document updates
- Branch name suggestion
- Blockers or questions

## Boundaries

- Do not create every Jira Story up front.
- Do not create Jira without draft approval.
- Do not create Jira without explicit user instruction after draft approval.
- Do not set `priority` or `description`.
- Do not create Plans.
- Do not edit code.
- Do not create worktrees.
- Do not rename branches automatically.
- Keep Goal and Story documents local under `docs/goals/`; they are not committed.
