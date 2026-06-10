---
name: team-conventions
description: 팀 공통 규칙 SSOT. 역할 무관 모든 작업에 적용되는 협업·커밋·승인 게이트·금지 사항. 코드/문서 작성 또는 워크플로우 진행 전에 항상 참조한다.
user-invocable: false
---

# 팀 공통 컨벤션

## 1. 스택 요약

| 영역 | 기술 |
|---|---|
| FE | React 19 · TypeScript · Vite · pnpm · ESLint |
| BE | Spring Boot 4.0.6 · Java 17 · MyBatis · Lombok · Gradle |
| DB | SQL Server 2022 (Docker) |

## 2. 작업 프로세스

### 버그 수정 — 코드 변경 전 반드시 아래 순서로 명시
```
[BUG-PLAN]  원인 분석: <재현 조건, 발생 위치, 근본 원인>
[BUG-PLAN]  수정 대상: <파일 경로>
[BUG-PLAN]  변경 내용: <무엇을 어떻게 바꿀지>
[BUG-PLAN]  영향 범위: <다른 파일/화면에 영향이 있는지>
```

### 기능 추가 — 코드 변경 전 반드시 아래 순서로 명시
```
[FEAT-PLAN]  요구사항: <입력된 내용>
[FEAT-PLAN]  수정 대상: <파일 경로>
[FEAT-PLAN]  변경 내용: <무엇을 어떻게 바꿀지>
[FEAT-PLAN]  영향 범위: <다른 파일/화면에 영향이 있는지>
```

## 3. 승인 게이트 (반자동)

다음 작업은 **반드시 사람 승인 후** 진행한다:
- DB 스키마 변경 (테이블 추가/컬럼 변경/삭제)
- `git push` / `git commit`
- 파일 삭제
- 공용 API 계약 변경 (다른 레이어에 영향)

에이전트는 게이트에서 멈추고 요약 + 리스크 + 다음 액션을 제시한다.

## 4. 커밋 & PR

- Conventional Commits: `feat` / `fix` / `chore` / `refactor` / `test` / `docs`
- `git push` / `git commit` — 사용자 명시 요청 시에만 실행
- PR 본문에 "무엇/왜" 명시

## 5. 파일 소유권

| 역할 | 담당 영역 |
|---|---|
| backend | `prac-api/src/` |
| frontend | `prac-fe/src/` |

각 역할은 자기 영역만 쓴다. 상대 영역은 읽기만 허용.

## 6. 공통 금지

- 비밀키·환경변수 커밋 (`.env` 파일 커밋 금지)
- `any` 남용 (FE · BE 모두)
- 미검증 외부 입력 직접 사용
- 승인 없는 비가역 작업 (스키마 변경, 배포 등)
- 기존 코드 주석 삭제
