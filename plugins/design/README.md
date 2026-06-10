# design 플러그인

스킬 `design-system-guide`·`tokens-to-code` · 에이전트 `design`.

## 대상 프로젝트

`prac` — CSS 변수 기반 디자인 토큰 (Tailwind 없음, 라이트/다크 모드 지원)

## 포함 파일

```
design/
├── .claude-plugin/plugin.json
├── agents/
│   └── design.md                        # 디자인 서브에이전트
└── skills/
    ├── design-system-guide/SKILL.md      # 토큰 목록·사용 원칙·접근성 기준 (배경 지식)
    └── tokens-to-code/SKILL.md           # CSS 변수 추가/수정 절차 (/design:tokens-to-code)
```

## 토큰 파일

```
prac-fe/src/index.css
  :root { }                                        ← 라이트 기본값
  @media (prefers-color-scheme: dark) { :root { } } ← 다크 오버라이드
```

기존 토큰 변경은 전역 영향 → 사람 승인 필수.
