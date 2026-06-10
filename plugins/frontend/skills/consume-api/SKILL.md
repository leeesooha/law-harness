---
name: consume-api
description: Spring Boot BE의 API 엔드포인트를 FE에서 연동하는 절차. "API 붙여줘", "백엔드 연동해줘", "fetch/훅 만들어줘" 요청 시 사용. api/ 함수 + 커스텀 훅 패턴으로 생성한다.
argument-hint: "<도메인명> [엔드포인트: GET /api/users, ...]"
allowed-tools: Read Write Edit
---

# BE API 연동 (Spring Boot → React)

## 전제

- BE 기본 URL: `http://localhost:8080`
- API 경로 패턴: `/api/<도메인>s`
- 응답은 JSON, 에러 시 HTTP 상태 코드로 구분

## FE 배치 규칙

```
src/
├── api/
│   └── <domain>Api.ts     # fetch 함수 (순수 HTTP 호출)
├── hooks/
│   └── use<Domain>.ts     # 상태 관리 + api 호출 래핑
└── types/
    └── <domain>.ts        # 요청/응답 타입
```

## 템플릿

### 타입 (`src/types/{{domain}}.ts`)
```ts
export type {{Domain}}Item = {
  id: number;
  // BE ResponseDto 필드에 맞춰 채움
};

export type {{Domain}}Request = {
  // BE RequestDto 필드에 맞춰 채움
};
```

### API 함수 (`src/api/{{domain}}Api.ts`)
```ts
import type { {{Domain}}Item, {{Domain}}Request } from '../types/{{domain}}';

const BASE = 'http://localhost:8080/api/{{domain}}s';

export async function fetchList(): Promise<{{Domain}}Item[]> {
  const res = await fetch(BASE);
  if (!res.ok) throw new Error(`fetchList failed: ${res.status}`);
  return res.json();
}

export async function fetchById(id: number): Promise<{{Domain}}Item> {
  const res = await fetch(`${BASE}/${id}`);
  if (!res.ok) throw new Error(`fetchById failed: ${res.status}`);
  return res.json();
}

export async function create(body: {{Domain}}Request): Promise<void> {
  const res = await fetch(BASE, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  if (!res.ok) throw new Error(`create failed: ${res.status}`);
}

export async function update(id: number, body: {{Domain}}Request): Promise<void> {
  const res = await fetch(`${BASE}/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  if (!res.ok) throw new Error(`update failed: ${res.status}`);
}

export async function remove(id: number): Promise<void> {
  const res = await fetch(`${BASE}/${id}`, { method: 'DELETE' });
  if (!res.ok) throw new Error(`remove failed: ${res.status}`);
}
```

### 커스텀 훅 (`src/hooks/use{{Domain}}.ts`)
```ts
import { useState, useEffect, useCallback } from 'react';
import { fetchList, create, update, remove } from '../api/{{domain}}Api';
import type { {{Domain}}Item, {{Domain}}Request } from '../types/{{domain}}';

export function use{{Domain}}() {
  const [items, setItems] = useState<{{Domain}}Item[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      setItems(await fetchList());
    } catch (e) {
      setError(e instanceof Error ? e.message : '오류가 발생했습니다.');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { load(); }, [load]);

  return { items, loading, error, reload: load, create, update, remove };
}
```

## 절차

1. 도메인명·엔드포인트 확인 (CRUD 전체인지 일부인지)
2. `types/` 타입 먼저 정의 (BE ResponseDto/RequestDto 기준)
3. `api/` fetch 함수 생성 (필요한 엔드포인트만)
4. `hooks/` 커스텀 훅 생성
5. 생성 경로 보고

## 주의

- 컴포넌트 내 직접 `fetch` 금지 — 반드시 `api/` 함수 경유
- CRUD 중 필요한 것만 생성 (오버엔지니어링 금지)
- `any` 금지 — BE DTO 필드 기반으로 타입 정의
- CORS 이슈 시 Vite `server.proxy` 설정 안내
