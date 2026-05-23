# Jira MCP 연결 (Atlassian Rovo)

> **souzip-start** 전제 조건: MCP 없으면 스토리·티켓 작업 **중단** → 이 문서대로 연결 후 재시도.  
> 웹에서 수동 생성은 **비상용**만 (MCP 장애 시).

## 필요한 것

- Atlassian **Cloud** (Jira) 사이트
- Node.js **18+** (`node -v`)
- 브라우저 (OAuth 2.1 로그인)
- (조직 정책 시) [API 토큰](https://id.atlassian.com/manage-profile/security/api-tokens) — 관리자가 MCP 토큰 인증을 켠 경우

## 1. 워크스페이스 설정

권장: Cursor 플러그인/설정 UI에서 Atlassian MCP를 추가한다.  
로컬 파일을 쓸 때만 `.cursor/mcp.json`을 만들며, 이 파일은 `.gitignore` 대상이라 커밋하지 않는다.

```json
{
  "mcpServers": {
    "atlassian": {
      "command": "npx",
      "args": ["-y", "mcp-remote@latest", "https://mcp.atlassian.com/v1/mcp/authv2"]
    }
  }
}
```

최신 Cursor는 UI에서 **HTTP** 서버로 같은 URL을 추가해도 된다:  
`https://mcp.atlassian.com/v1/mcp/authv2`  
(공식: [Atlassian — Setting up IDEs](https://support.atlassian.com/rovo/docs/setting-up-ides/))

## 2. Cursor에서 활성화

1. **Cursor Settings** → **MCP** (또는 Features → MCP)
2. `atlassian` 서버가 보이면 **Enable**
3. **Cursor 완전 재시작** (창 닫았다가 다시 열기)
4. 첫 사용 시 브라우저 **Atlassian 로그인·권한 허용** (터미널에 `mcp-remote` 세션이 뜰 수 있음 — 닫지 말 것)

## 3. 연결 확인

채팅에서 예:

- 「내게 할당된 Jira 이슈 최근 3개 보여줘」
- 「프로젝트 SOU 에픽 목록 검색해줘」

Agent 도구 목록에 **Jira / Atlassian** 관련 MCP 도구가 보이면 성공.

## 4. 실패 시

| 증상 | 조치 |
|------|------|
| MCP 목록에 `atlassian` 없음 | Cursor 플러그인/설정 UI 확인. 로컬 파일 사용 시 `.cursor/mcp.json` 경로·JSON 문법 확인, 재시작 |
| OAuth 안 뜸 | 터미널에서 `npx -y mcp-remote@latest https://mcp.atlassian.com/v1/mcp/authv2` 수동 실행 후 브라우저 인증 |
| 권한 거부 | Jira 사이트 관리자 — [Rovo MCP 설정](https://support.atlassian.com/security-and-access-policies/docs/control-atlassian-rovo-mcp-server-settings/) |
| `npx` 없음 | Node 18+ 설치 |

## 5. 보안

- API 토큰·비밀번호를 **`mcp.json`·plan·커밋에 넣지 않음**
- MCP는 **본인 Jira 권한**으로만 동작 — least privilege 유지

## 참고

- 엔드포인트 구형: `.../v1/sse` → **2026-06-30 이후 미지원**, `authv2` 사용
- 구현 플랜: [`docs/plans/workflow-skills-jira-git/plan.md`](../plans/workflow-skills-jira-git/plan.md)
