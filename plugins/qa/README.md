# qa 플러그인

에이전트 `qa-verifier` · 스킬 `evaluation-criteria`·`generate-test-cases` · MCP Playwright · 커밋 게이트 훅.

## 대상 프로젝트

`prac` — React 19 + Vite + Spring Boot + ESLint + Vitest

## 포함 파일

```
qa/
├── .claude-plugin/plugin.json
├── .mcp.json                              # Playwright MCP
├── README.md
├── agents/
│   └── qa-verifier.md                     # QA 평가자 서브에이전트
├── hooks/
│   ├── hooks.json                         # PreToolUse 커밋 게이트
│   └── pre-commit-gate.sh                 # lint + build 검사
└── skills/
    ├── evaluation-criteria/SKILL.md        # PASS/FAIL 채점 rubric (배경 지식)
    └── generate-test-cases/SKILL.md        # 테스트 케이스 생성 절차
```

## MCP 인증 (Playwright)

별도 인증 없음. `npx @playwright/mcp@latest` 자동 실행.
브라우저가 없으면: `npx playwright install chromium`

## 커밋 게이트

`git commit` 실행 시 자동으로 `pnpm lint` → `pnpm test:run` → `pnpm build` 순서로 검사한다.
실패하면 커밋을 차단하고 이유를 알려준다.

## Playwright E2E 설치

```bash
cd prac-fe
npx playwright install chromium
```
