# planning 플러그인

스킬 `write-prd` · 에이전트 `planning`.

## 대상 프로젝트

`prac` — Spring Boot + React 풀스택 (이슈 트래커 없음)

## 포함 파일

```
planning/
├── .claude-plugin/plugin.json
├── agents/
│   └── planning.md                  # 기획 서브에이전트
└── skills/
    └── write-prd/SKILL.md           # 기능 스펙 작성 절차 (/planning:write-prd)
```

## 산출물

```
docs/handoff/<feature>/
└── spec.md    ← planning 산출, backend/frontend가 입력으로 읽음
```

DB 변경이 필요한 경우 spec.md에 명시 → 사람 승인 필수.
