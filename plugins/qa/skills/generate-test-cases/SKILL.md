---
name: generate-test-cases
description: spec.md와 구현을 대조해 테스트 케이스를 생성하는 절차. "테스트 만들어줘", "테스트 케이스 작성해줘" 요청 시 사용. Vitest 단위 테스트를 생성하고 docs/handoff/<feature>/qa-report.md에 결과를 기록한다.
argument-hint: "<feature명>"
allowed-tools: Read Write Edit Bash(pnpm:*)
---

# 테스트 케이스 생성

## 입력/산출

- 입력: `docs/handoff/<feature>/spec.md` + 구현 코드
- 산출: `src/**/*.test.ts(x)`, `docs/handoff/<feature>/qa-report.md`

## 테스트 작성 기준

spec.md의 요구사항을 다음 4가지로 매핑한다:

| 유형 | 대상 | 예시 |
|---|---|---|
| 정상 경로 | 주요 기능이 동작 | 목록 조회 성공, 폼 제출 성공 |
| 경계값 | 입력 한계 | 빈 값, 최대 길이 |
| 에러 경로 | 실패 케이스 | API 오류 시 에러 메시지 표시 |
| 상태 변화 | 인터랙션 후 | 삭제 후 목록에서 제거됨 |

## 템플릿

### 커스텀 훅 테스트 (`hooks/useXxx.test.ts`)
```ts
import { renderHook, waitFor } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import { use{{Domain}} } from './use{{Domain}}';

describe('use{{Domain}}', () => {
  it('목록을 불러온다', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve([{ id: 1, name: '테스트' }]),
    }));
    const { result } = renderHook(() => use{{Domain}}());
    await waitFor(() => expect(result.current.loading).toBe(false));
    expect(result.current.items).toHaveLength(1);
  });
});
```

### 컴포넌트 테스트 (`components/Xxx.test.tsx`)
```tsx
import { render, screen } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import { {{Name}} } from './{{Name}}';

describe('{{Name}}', () => {
  it('렌더링된다', () => {
    render(<{{Name}} />);
    expect(screen.getByRole('...')).toBeInTheDocument();
  });
});
```

## 절차

1. spec.md 요구사항을 테스트 항목으로 매핑한다.
2. Vitest 설치 여부를 확인하고 없으면 안내한다.
3. 훅·컴포넌트 단위 테스트를 작성한다.
4. `pnpm test:run`으로 실행하고 결과를 `qa-report.md`에 기록한다.
