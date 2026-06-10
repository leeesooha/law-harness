---
name: design-system-guide
description: 디자인 시스템 사용 가이드. CSS 변수 토큰 사용 원칙, 라이트/다크 모드 대응, 컴포넌트 상태, 접근성 기준. FE 컴포넌트 작성/리뷰 시 디자인 일관성 기준으로 참조한다.
user-invocable: false
---

# 디자인 시스템 가이드

> 토큰 정의 위치: `prac-fe/src/index.css` `:root` 블록

## 토큰 목록

### 색상
| 변수 | 용도 |
|---|---|
| `--text` | 본문 텍스트 |
| `--text-h` | 제목·강조 텍스트 |
| `--bg` | 페이지 배경 |
| `--border` | 테두리 |
| `--code-bg` | 코드 블록 배경 |
| `--accent` | 주요 강조색 (버튼·링크) |
| `--accent-bg` | 강조색 배경 (옅게) |
| `--accent-border` | 강조색 테두리 |
| `--social-bg` | 소셜 버튼 배경 |
| `--shadow` | 그림자 |

### 타이포그래피
| 변수 | 용도 |
|---|---|
| `--sans` | 본문 폰트 |
| `--heading` | 제목 폰트 |
| `--mono` | 코드 폰트 |

## 토큰 사용 원칙

- **raw 값(hex, px 직접 사용) 금지** — 반드시 CSS 변수로 참조
- `color: #aa3bff` ❌ → `color: var(--accent)` ✅
- `background: #fff` ❌ → `background: var(--bg)` ✅

## 라이트/다크 모드

토큰은 `:root`에 라이트 기본값, `@media (prefers-color-scheme: dark)` 블록에 다크 오버라이드로 관리한다. 새 토큰 추가 시 **두 블록 모두** 정의해야 한다.

```css
:root {
  --new-token: #lightvalue;
}
@media (prefers-color-scheme: dark) {
  :root {
    --new-token: #darkvalue;
  }
}
```

## 컴포넌트 상태

| 상태 | 처리 방식 |
|---|---|
| `hover` | `opacity` 또는 `filter: brightness()` 조정 |
| `active` | `transform: scale(0.98)` |
| `disabled` | `opacity: 0.4`, `cursor: not-allowed` |
| `focus` | `outline: 2px solid var(--accent)` |

## 접근성

- 색상 대비비: 텍스트 최소 4.5:1 (WCAG AA)
- 인터랙티브 요소에 `focus-visible` 스타일 필수
- 아이콘만 있는 버튼에 `aria-label` 필수
- `role="presentation"` / `aria-hidden="true"` — 장식용 이미지/SVG에 적용
