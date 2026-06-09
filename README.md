# law-harness

개인 프로젝트용 Claude Code 플러그인 마켓플레이스.
반복 작업을 스킬로 표준화하고, 여러 프로젝트에 재사용한다.

스택: Spring Boot + Java + MyBatis + SQL Server · React + TypeScript + Vite

## 구조

```
law-harness/
├── .claude-plugin/
│   └── marketplace.json   # 플러그인 카탈로그
└── plugins/
    ├── backend/           # Spring Boot + MyBatis 스캐폴딩
    └── frontend/          # React + Vite 스캐폴딩 (준비 중)
```

## 플러그인 목록

| 플러그인 | 상태 | 설명 |
|---|---|---|
| `backend` | ✅ | Spring Boot + MyBatis CRUD API 스캐폴딩 |
| `frontend` | 🚧 준비 중 | React + Vite 컴포넌트 스캐폴딩 |

### backend 플러그인

**스킬**
- `scaffold-api` — 도메인명·필드 입력받아 Controller / Service(interface+impl) / Mapper / DTO / XML Mapper 한 번에 생성

## 프로젝트에 연결하는 법

`.claude/settings.json`에 추가:

```json
{
  "extraKnownMarketplaces": {
    "law-harness": {
      "source": {
        "source": "github",
        "repo": "soohalee/law-harness"
      }
    }
  },
  "enabledPlugins": {
    "backend@law-harness": true
  }
}
```

## 확장 계획

- `frontend` 플러그인 — React 컴포넌트 / 훅 / API 연동 스캐폴딩
- `backend` 플러그인 — 예외 처리 패턴, 공통 응답 래퍼 스킬 추가
