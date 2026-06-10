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
    ├── shared-conventions/  # 팀 공통 규칙 SSOT
    ├── planning/            # GitHub Issues 연동 스펙 작성
    ├── backend/             # Spring Boot + MyBatis 스캐폴딩
    ├── frontend/            # React + Vite 컴포넌트 스캐폴딩
    ├── design/              # CSS 변수 디자인 토큰 관리
    ├── qa/                  # Vitest + Playwright 검증 루프
    └── orchestrator/        # 풀스택 워크플로우 진입점
```

## 플러그인 목록

| 플러그인 | 상태 | 설명 |
|---|---|---|
| `shared-conventions` | ✅ | BUG-PLAN/FEAT-PLAN 프로세스, 승인 게이트, 커밋 규칙, BE/FE 파일 소유권 |
| `planning` | ✅ | GitHub Issues 연동 기능 스펙 작성 (write-prd 스킬) |
| `backend` | ✅ | Spring Boot + MyBatis CRUD API 스캐폴딩 |
| `frontend` | ✅ | React 19 + Vite 컴포넌트 스캐폴딩 및 BE API 연동 |
| `design` | ✅ | CSS 변수 기반 디자인 토큰 관리 (라이트/다크 모드) |
| `qa` | ✅ | Vitest + Playwright CLI/MCP 검증 루프, 커밋 게이트 훅 |
| `orchestrator` | ✅ | /build-feature 풀스택 워크플로우 진입점 |

### 스킬 목록

| 플러그인 | 스킬 | 설명 |
|---|---|---|
| `backend` | `scaffold-api` | Controller / Service / Mapper / DTO / XML Mapper 한 번에 생성 |
| `frontend` | `scaffold-component` | React 컴포넌트 + 훅 스캐폴딩 |
| `frontend` | `consume-api` | BE API 연동 코드 생성 |
| `planning` | `write-prd` | BE/FE 작업 범위를 분리한 spec.md 산출 |
| `design` | `tokens-to-code` | 라이트/다크 모드 토큰을 index.css에 추가 |
| `qa` | `qa-verifier` | 테스트 검증 루프 실행 |
| `orchestrator` | `build-feature` | planning → (backend ∥ design) → frontend ⇄ qa 전 과정 지휘 |

## 프로젝트에 연결하는 법

### 1. 마켓플레이스 등록

`.claude/settings.json`에 추가:

```json
{
  "extraKnownMarketplaces": {
    "law-harness": {
      "source": {
        "source": "github",
        "repo": "leeesooha/law-harness"
      }
    }
  },
  "enabledPlugins": {
    "shared-conventions@law-harness": true,
    "planning@law-harness": true,
    "backend@law-harness": true,
    "frontend@law-harness": true,
    "design@law-harness": true,
    "qa@law-harness": true,
    "orchestrator@law-harness": true
  }
}
```

### 2. 플러그인 설치

마켓플레이스 캐시를 최신화한 뒤 설치:

```bash
claude plugin marketplace update law-harness

for p in shared-conventions planning backend frontend design qa orchestrator; do
  claude plugins install ${p}@law-harness
done
```

### 3. 재시작

Claude Code를 재시작하면 스킬이 활성화됩니다.
