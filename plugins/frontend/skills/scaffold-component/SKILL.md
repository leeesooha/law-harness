---
name: scaffold-component
description: React 19 + TypeScript 컴포넌트를 스캐폴딩한다. "컴포넌트 만들어줘", "페이지 만들어줘", "훅 만들어줘" 요청 시 사용. 올바른 위치 배치, props 타입, named export까지 일관 생성한다.
argument-hint: "<ComponentName> [페이지|컴포넌트|훅] [props: prop1:type, ...]"
allowed-tools: Read Write Edit
---

# 컴포넌트 스캐폴딩 (React 19 + TypeScript)

`frontend-conventions` 스킬을 전제로 한다.

## 확인할 입력

1. **이름** — PascalCase (컴포넌트/페이지), camelCase `use*` (훅)
2. **종류** — `component` | `page` | `hook`
3. **props** — 필요한 prop 목록과 타입 (없으면 생략)

## 배치 규칙

| 종류 | 위치 |
|---|---|
| 재사용 컴포넌트 | `src/components/<Name>.tsx` |
| 페이지 컴포넌트 | `src/pages/<Name>.tsx` |
| 커스텀 훅 | `src/hooks/<hookName>.ts` |
| API 타입 | `src/types/<domain>.ts` |

## 템플릿

### 컴포넌트 (재사용)
```tsx
type {{Name}}Props = {
  // props 목록
};

export function {{Name}}({ /* props */ }: {{Name}}Props) {
  return (
    <div>
      {/* {{Name}} */}
    </div>
  );
}
```

### 페이지
```tsx
export default function {{Name}}Page() {
  return (
    <main>
      {/* {{Name}}Page */}
    </main>
  );
}
```

### 커스텀 훅
```ts
import { useState, useEffect } from 'react';

export function {{hookName}}() {
  // 상태 및 로직

  return { /* 반환값 */ };
}
```

## 절차

1. 입력에서 이름·종류·props 확인
2. `{{Name}}`을 실제 이름으로 치환
3. props 타입 채움
4. 해당 위치에 파일 생성
5. 생성된 경로 보고

## 주의

- `React.FC` 사용 금지
- `export default`는 페이지 컴포넌트에만
- 재사용 컴포넌트는 named export
- `any` 금지 — 타입 불명확하면 `unknown` 또는 제네릭
