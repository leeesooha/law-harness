# backend 플러그인

스킬 `backend-conventions`·`scaffold-api` · 에이전트 `backend`·`api-design-reviewer`.

## 대상 프로젝트

`prac` — Spring Boot 4.0.6 + Java 17 + MyBatis + SQL Server 2022 (Docker)

## 포함 파일

```
backend/
├── .claude-plugin/plugin.json
├── agents/
│   ├── backend.md              # BE 구현 서브에이전트
│   └── api-design-reviewer.md  # API 설계 검토 서브에이전트 (읽기전용)
└── skills/
    ├── scaffold-api/SKILL.md        # CRUD 스캐폴딩 절차·템플릿 (/backend:scaffold-api)
    └── backend-conventions/SKILL.md  # BE 코딩 컨벤션 SSOT (/backend:backend-conventions)
```

## DB 연결 (SQL Server · Docker)

```bash
# prac-api/ 디렉토리에서
docker compose up -d
```

연결 정보는 `prac-api/src/main/resources/application.properties`에서 관리한다. 레포에 커밋 금지.
