---
name: evaluation-criteria
description: 기능 결과물을 채점하는 공용 평가 기준(rubric). generator(구현 에이전트)와 qa-verifier(evaluator)가 둘 다 참조한다. 각 기준은 하드 임계값을 가지며 하나라도 미달이면 FAIL. 검증 루프의 단일 기준점.
user-invocable: false
---

# 평가 기준 (Generator ↔ Evaluator 공용 rubric)

> generator는 이 기준을 목표로 만들고, evaluator는 이 기준으로 채점한다.
> 채점은 **하드 임계값** 방식: 각 기준 PASS/FAIL. **하나라도 FAIL이면 전체 FAIL.**
> 점수가 후하게 나오는 경향이 있으니 의심스러우면 FAIL로 둔다.

## 기준

### 1. 기능 정확성 (Functionality) — 필수
핵심 사용자 플로우가 **실제로 끝까지 동작**하는가.
BE API(`http://localhost:8080`)가 계약(api-contract.md)대로 응답하고, FE가 데이터를 올바르게 표시·처리하는가.
- FAIL 예: 버튼이 눌리지만 아무 일도 없음 / 목록 갱신 안 됨 / 4xx·5xx 미처리

### 2. 제품 완성도 (Product depth) — 필수
spec.md에 명시된 기능이 껍데기 없이 구현됐는가. "보이지만 상호작용 불가"는 미달.
- FAIL 예: 입력 폼이 있지만 제출 안 됨 / 삭제 버튼이 작동 안 함

### 3. 디자인 일관성 (Design consistency)
CSS 변수 토큰(`--accent`, `--bg` 등)을 사용했는가. raw 값 하드코딩 없음.
라이트/다크 모드에서 깨지지 않는가.
- FAIL 예: `color: #aa3bff` 직접 사용 / 다크모드에서 텍스트 안 보임

### 4. 크래프트 (Craft)
레이아웃 정렬, 간격 일관성, 반응형(모바일 깨짐 없음).
- FAIL 예: 요소 겹침 / 모바일에서 스크롤 불가 / 버튼 텍스트 잘림

### 5. 접근성 (Accessibility)
인터랙티브 요소에 `aria-label` 또는 텍스트 레이블. 키보드 포커스 이동 가능.
- FAIL 예: 아이콘 버튼에 레이블 없음 / Tab으로 주요 요소 도달 불가

### 6. 코드 품질 (Code quality)
`pnpm lint` 통과. `any` 없음. BE/FE 파일 소유권 규칙 준수.
- FAIL 예: ESLint 에러 / `any` 사용 / FE 코드에서 BE 파일 수정

## 채점 출력 형식

```
## 평가 결과: PASS | FAIL

| 기준 | 판정 | 근거 (파일:라인 / 재현 단계) |
|---|---|---|
| 기능 정확성 | FAIL | hooks/useUser.ts:23 — create 호출 후 목록 reload 없음 |
| ... | ... | ... |

## 수정 지시 (FAIL 항목별)
- [파일:라인] 무엇이 왜 틀렸는가 → 어떻게 고칠지

## 다음 행동 권고
- refine (현 방향 개선) | pivot (접근 전환)
```

## 원칙
- 근거는 **재현 단계 또는 파일:라인**으로 구체적으로. 추상적 코멘트 금지.
- 통과를 위해 기준을 낮추지 않는다. 미달은 미달로 보고한다.
