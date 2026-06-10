# frontend 플러그인

스킬 `frontend-conventions`·`scaffold-component`·`consume-api` · 에이전트 `frontend`.

## 대상 프로젝트

`prac` — React 19 + TypeScript + Vite + pnpm + ESLint

## 포함 파일

```
frontend/
├── .claude-plugin/plugin.json
├── agents/
│   └── frontend.md                    # FE 구현 서브에이전트
└── skills/
    ├── frontend-conventions/SKILL.md   # FE 코딩 컨벤션 SSOT (/frontend:frontend-conventions)
    ├── scaffold-component/SKILL.md     # 컴포넌트/훅 스캐폴딩 (/frontend:scaffold-component)
    └── consume-api/SKILL.md            # BE API 연동 절차 (/frontend:consume-api)
```

## 개발 서버

```bash
# prac-fe/ 디렉토리에서
pnpm dev     # http://localhost:5173
pnpm lint    # ESLint 검사
pnpm build   # 프로덕션 빌드
```

BE API(`http://localhost:8080`)와 CORS 이슈 발생 시 `vite.config.ts`에 proxy 설정 추가.
