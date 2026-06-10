---
name: frontend-conventions
description: FE 코딩 컨벤션 SSOT. React 19 + TypeScript + Vite + pnpm + ESLint 프로젝트의 컴포넌트 구조, 네이밍, 훅 규칙, 타입 규칙, 스타일, API 연동 패턴. FE 코드를 작성/리뷰/리팩터링하기 전에 참조한다.
---

# FE 코딩 컨벤션

> 스택: **React 19 · TypeScript · Vite · pnpm · ESLint**

## 디렉터리 구조

```
prac-fe/src/
├── components/   # 재사용 UI 컴포넌트
├── pages/        # 페이지 단위 컴포넌트
├── hooks/        # 커스텀 훅
├── api/          # API 호출 함수
├── types/        # 공용 타입/인터페이스
└── utils/        # 순수 유틸리티 함수
```

## 네이밍

| 대상 | 규칙 | 예시 |
|---|---|---|
| 컴포넌트 파일 | PascalCase | `UserList.tsx` |
| 커스텀 훅 | camelCase, `use` 접두사 | `useUserList.ts` |
| 타입/인터페이스 | PascalCase, `I` 접두사 없이 | `UserItem`, `ApiResponse` |
| 일반 함수/변수 | camelCase | `fetchUsers` |
| 상수 | UPPER_SNAKE_CASE | `API_BASE_URL` |
| 이벤트 핸들러 prop | `on*` | `onClick`, `onChange` |
| 이벤트 핸들러 구현 | `handle*` | `handleClick`, `handleSubmit` |

## 컴포넌트 규칙

- `function` 선언 + named export 사용 (`export default` 지양, 페이지 최상위 컴포넌트 제외)
- props 타입은 `<Name>Props`로 명명, 구조분해 사용
- `React.FC` 사용 금지
- 컴포넌트 파일 하나에 컴포넌트 하나 원칙

```tsx
type UserCardProps = {
  id: number;
  name: string;
  onClick?: () => void;
};

export function UserCard({ id, name, onClick }: UserCardProps) {
  return <div onClick={onClick}>{name}</div>;
}
```

## 타입 규칙

- `any` 사용 금지 — 타입 불명확하면 `unknown` 후 좁히기
- `interface` 대신 `type` 우선
- `as` 단언 최소화 — 타입 가드로 좁히기
- BE 응답 타입은 `types/` 또는 `api/` 옆에 정의

## 커스텀 훅

- `hooks/` 또는 기능별 폴더에 위치
- 단일 책임: 하나의 관심사만 담당
- 반환값은 객체로 (튜플 지양, 구조분해 편의)

```ts
// hooks/useUsers.ts
export function useUsers() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(false);
  // ...
  return { users, loading };
}
```

## API 연동

- API 호출 함수는 `api/` 폴더에 집중
- BE 기본 URL: `http://localhost:8080/api`
- `fetch` 또는 `axios` 사용, 컴포넌트 내 직접 `fetch` 금지
- 에러는 `try/catch`로 처리, 사용자에게 피드백 제공

## 금지 사항

- `any` 남용
- 컴포넌트 내 직접 API 호출 (훅 또는 `api/` 함수로 분리)
- `../../../` 깊은 상대 경로 (tsconfig paths 설정 권장)
- 기존 코드 주석 삭제
