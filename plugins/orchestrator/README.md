# orchestrator 플러그인

스킬 `/orchestrator:build-feature` — 전체 기능 워크플로우 진입점.

## 워크플로우

```
/orchestrator:build-feature <기능명>

planning ─spec.md─▶ ┌─ backend ─api-contract.md─┐
                    │   (병렬·worktree 격리)      ├─▶ frontend ⇄ qa ─▶ 머지 승인
                    └─ design  ─design-notes.md──┘      (검증 루프, 최대 3회)
```

## 핸드오프 파일

```
docs/handoff/<feature>/
├── spec.md           ← planning 산출
├── api-contract.md   ← backend 산출
├── design-notes.md   ← design 산출
├── contract.md       ← frontend↔qa 합의
└── qa-report.md      ← qa-verifier 채점 결과
```

## 사용법

```
/orchestrator:build-feature 유저 목록 페이지
/orchestrator:build-feature 상품 등록 기능 --issue 42
```

`disable-model-invocation: true` — 사용자가 직접 호출해야 실행됩니다.
