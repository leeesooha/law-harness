---
name: write-prd
description: 기능 스펙(spec.md)을 작성하는 절차. "스펙 써줘", "기획해줘", "어떻게 만들지 정리해줘" 요청 시 사용. GitHub Issues에서 관련 이슈를 조회/생성하고, BE/FE 작업 범위를 분리해 docs/handoff/<feature>/spec.md를 산출한다.
argument-hint: "<기능명/설명> [--issue <번호>]"
allowed-tools: Read Write Edit Bash(gh issue:*) Bash(gh repo:*)
---

# 기능 스펙 작성

## 산출물
`docs/handoff/<feature>/spec.md`

## GitHub Issues 연동

### 관련 이슈 조회
```bash
gh issue list --label "feature" --state open
gh issue view <번호>
```

### 이슈 생성 (없을 때)
```bash
gh issue create \
  --title "<기능명>" \
  --body "<스펙 요약>" \
  --label "feature"
```

### 이슈 상태 업데이트
```bash
# spec 승인 후 개발 시작 시
gh issue edit <번호> --add-label "in-progress"

# 완료 시
gh issue close <번호>
```

## spec.md 템플릿

```md
# <기능명> 스펙

> GitHub Issue: #<번호> <이슈 제목>

## 배경/문제
<왜 이 기능이 필요한가>

## 목표 / 비목표
- 목표:
- 비목표:

## 사용자 스토리
- 사용자는 ~할 수 있다.

## 요구사항

### 기능 요구사항
- [ ] ...

### 비기능 요구사항
- [ ] ...

## BE 작업 범위 (Spring Boot + MyBatis)
| 항목 | 내용 |
|---|---|
| 도메인 | <엔티티명> |
| 엔드포인트 | GET/POST/PUT/DELETE /api/... |
| 테이블 변경 | 없음 / <변경 내용> |
| 주요 필드 | field1:type, field2:type |

## FE 작업 범위 (React 19 + Vite)
| 항목 | 내용 |
|---|---|
| 페이지/컴포넌트 | <이름> |
| API 연동 | <엔드포인트> |
| 상태 관리 | <훅명> |

## DB 변경 여부
- [ ] 없음
- [ ] 있음 → **사람 승인 게이트 필요**

## 오픈 퀘스천
- ?

## 완료 정의
- [ ] ...
```

## 절차

1. `--issue <번호>`가 주어지면 `gh issue view`로 이슈 내용을 읽는다.
2. 없으면 `gh issue list`로 관련 이슈를 검색하고, 없으면 새로 생성한다.
3. 현재 코드베이스(`prac-api/`, `prac-fe/`)를 읽어 기존 구조와 맥락을 파악한다.
4. 위 템플릿으로 spec.md 초안을 작성하고 이슈 번호를 상단에 명시한다.
5. BE/FE 작업 범위를 명확히 분리하고 오픈 퀘스천을 남긴다.
6. **사람 승인**을 요청한다. 승인되면 이슈에 `in-progress` 라벨을 추가한다.
7. 승인 후 backend/frontend 단계로 핸드오프.

## 주의

- DB 테이블 추가/변경이 필요하면 스펙에 명시하고 반드시 사람 승인 게이트를 둔다.
- 불확실한 요구사항은 추측하지 말고 오픈 퀘스천으로 남긴다.
- 이슈 생성/변경 전에 사람에게 확인한다 (`gh issue create`는 외부에 공개됨).
