---
name: tokens-to-code
description: 디자인 토큰을 CSS 변수로 추가/수정하는 절차. "토큰 추가해줘", "색상 변수 만들어줘", "다크모드 색 바꿔줘" 요청 시 사용. index.css의 :root 블록에 라이트/다크 두 값을 모두 정의한다.
argument-hint: "<토큰명> <라이트값> <다크값>"
allowed-tools: Read Edit
---

# 디자인 토큰 → CSS 변수

## 토큰 파일 위치

```
prac-fe/src/index.css
├── :root { }                              ← 라이트 모드 기본값
└── @media (prefers-color-scheme: dark) { :root { } }  ← 다크 모드 오버라이드
```

## 추가 절차

1. 토큰명·라이트값·다크값 확인
2. `:root` 블록에 라이트 값 추가
3. `@media (prefers-color-scheme: dark)` 블록에 다크 값 추가
4. 기존 컴포넌트에서 raw 값을 쓰고 있으면 변수로 교체 안내

## 토큰명 규칙

- kebab-case: `--color-primary`, `--spacing-md`
- 카테고리 접두사 권장: `--color-*`, `--font-*`, `--spacing-*`, `--radius-*`, `--shadow-*`
- 기존 패턴(`--text`, `--bg`, `--accent` 등)과 일관성 유지

## 템플릿

```css
/* :root 블록에 추가 */
--{{token-name}}: {{light-value}};

/* @media (prefers-color-scheme: dark) :root 블록에 추가 */
--{{token-name}}: {{dark-value}};
```

## 주의

- **전역 토큰 변경(기존 값 수정·삭제)은 사람 승인 게이트** — 다른 컴포넌트 전체에 영향
- 새 토큰 추가는 두 블록(라이트+다크) 모두 필수
- raw 값 직접 사용 금지 — 항상 `var(--token-name)` 참조
