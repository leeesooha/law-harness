#!/usr/bin/env bash
# 커밋 직전 lint + build 강제 게이트.
# Bash 툴 입력(JSON)이 stdin으로 전달된다. `git commit`일 때만 검사한다.
set -euo pipefail

input="$(cat)"
cmd="$(printf '%s' "$input" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null || true)"

case "$cmd" in
  *"git commit"*)
    echo "[qa-gate] 커밋 전 검사: lint + test + build" >&2

    cd prac-fe 2>/dev/null || true

    if ! pnpm lint >/dev/null 2>&1; then
      echo '{"decision":"block","reason":"ESLint 실패 — pnpm lint로 확인 후 다시 커밋하세요."}'; exit 0
    fi

    test_output=$(pnpm test:run 2>&1 || true)
    if echo "$test_output" | grep -q "FAIL\|failed"; then
      echo '{"decision":"block","reason":"단위 테스트 실패 — pnpm test:run으로 확인 후 커밋하세요."}'; exit 0
    fi

    if ! pnpm build >/dev/null 2>&1; then
      echo '{"decision":"block","reason":"빌드 실패 — 타입 에러를 수정 후 다시 커밋하세요."}'; exit 0
    fi

    echo "[qa-gate] 통과" >&2
    ;;
esac

exit 0
