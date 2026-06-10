---
name: build-feature
description: 기능 전체 워크플로우 지휘자. planning→(backend∥design)→frontend⇄qa 순서로 서브에이전트에 위임한다. "기능 만들어줘", "풀스택으로 구현해줘", "/build-feature <기능명>" 요청 시 사용.
argument-hint: "<기능명/설명> [--issue <번호>]"
allowed-tools: Read Write Edit Bash(git worktree:*) Bash(git merge:*) Bash(git status:*) Bash(git diff:*) Bash(gh issue:*) Bash(pnpm:*) Bash(./gradlew:*)
disable-model-invocation: true
---

# /build-feature — 병렬 DAG + 검증→수정 루프

너(메인 세션)는 **지휘자**다. 직접 구현하지 말고 역할 서브에이전트에 위임한다.
의존성 없는 단계는 병렬, 있는 단계는 순차. **구현 단계는 generator↔evaluator 검증 루프**로 품질을 끌어올린다.
단계 연결은 `docs/handoff/<feature>/` 파일 핸드오프, 배치/루프 종료마다 **사람 승인 게이트**.

대상 기능: $ARGUMENTS

## 의존성 그래프

```
planning ─spec.md─▶ ┌─ backend ─api-contract.md─┐
                    │   (병렬, worktree 격리)     ├─▶ frontend ⇄ qa(검증 루프) ─▶ (머지 승인)
                    └─ design  ─design-notes.md──┘
```

## GAN식 검증 루프 (핵심)

generator(frontend)와 evaluator(qa-verifier)를 **분리**한다. 채점 기준은 공용 `evaluation-criteria` 스킬.

```
[계약] frontend + qa-verifier가 contract.md 합의 (완료 정의 + 검증 항목)
   ↓
[빌드] frontend가 contract대로 구현 + 핸드오프 전 evaluation-criteria로 자가평가
   ↓
[평가] qa-verifier가 실제 앱 조작 + lint/test/build + rubric 채점 → qa-report.md
   ↓
FAIL? ──예──▶ 수정 지시를 frontend에 전달 → [빌드]로 (최대 3회)
   │
   └──아니오(PASS)──▶ 사람 승인 게이트
```

- evaluator는 **회의적으로** 채점한다. 기준 하나라도 미달이면 FAIL.
- 같은 항목이 반복 실패하면 **pivot(접근 전환)**, 잘 되면 **refine(개선)** 권고.
- 3회 내 PASS 못 하면 멈추고 사람에게 남은 이슈를 보고한다(무한 루프 금지).

## 진행 절차

### 0. 준비
- feature 슬러그 확정 (`kebab-case`, 예: `user-login`)
- `docs/handoff/<feature>/` 디렉터리 생성
- `--issue <번호>` 있으면 `gh issue view`로 요구사항 읽기
- 전체 계획을 사람에게 한 번 확인

### 1. planning (단독)
`planning` 에이전트에 위임. 산출: `spec.md`.
- GitHub Issue 있으면 연동 (`gh issue edit --add-label "in-progress"`)

⛔ **게이트**: spec.md 검토·승인 후 다음 단계 진행.

### 2. backend ∥ design (병렬, worktree 격리)
spec 승인 후 **동시에** 두 에이전트 호출.

```bash
# 각자 독립 worktree에서 작업
git worktree add ../prac-backend-<feature> -b feat/<feature>-backend
git worktree add ../prac-design-<feature>  -b feat/<feature>-design
```

- **backend** 소유권: `prac-api/src/` + `api-contract.md`
  - `api-design-reviewer`로 설계 검토 후 마무리
  - DB 스키마 변경 시 ⛔ **사람 승인 게이트**
- **design** 소유권: `prac-fe/src/index.css` `:root` 토큰 + `design-notes.md`

둘 다 반환되면 worktree 머지:
```bash
git merge feat/<feature>-backend
git merge feat/<feature>-design
git worktree remove ../prac-backend-<feature>
git worktree remove ../prac-design-<feature>
```

⛔ **게이트**: `api-contract.md` + `design-notes.md` 함께 검토·승인.

### 3. frontend ⇄ qa 검증 루프 (조인)
backend·design 완료 후 시작.

**a. 계약**
frontend가 구현 범위·검증 항목 제안 → qa-verifier 검토 → 합의 → `contract.md` 작성.

**b. 빌드**
`frontend` 에이전트 위임. `api-contract.md` + `design-notes.md` 참조해 구현.
핸드오프 전 `evaluation-criteria`로 자가평가.

**c. 평가**
`qa-verifier` 에이전트 위임.
- `pnpm lint` + `pnpm test:run` + `pnpm build`
- Playwright CLI(`npx playwright test`) → E2E
- Playwright MCP → 탐색적 검증
- rubric 채점 → `qa-report.md` (PASS/FAIL + 수정 지시)

**d. 루프**
FAIL이면 수정 지시를 frontend에 전달해 b로(최대 3회). PASS면 e.

**e.** ⛔ **게이트**: `qa-report.md` 검토 후 머지 승인.

### 4. 완료
```bash
# GitHub Issue 닫기
gh issue close <번호>
```

## 공통 규칙

- 비가역 작업(DB 스키마 변경, 배포, 전역 토큰 변경)은 예외 없이 사람 승인.
- 핸드오프 파일이 없거나 모순되면 멈추고 질문.
- 사소한 변경은 계약/루프를 1패스로 줄이거나 생략 가능(불필요한 오버헤드 회피).
- `git push` / `git commit`은 사람 명시 요청 시에만.
