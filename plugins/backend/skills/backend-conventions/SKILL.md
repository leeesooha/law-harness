---
name: backend-conventions
description: BE 코딩 컨벤션 SSOT. Spring Boot + MyBatis + SQL Server 프로젝트의 패키지 구조, 레이어링(controller/service/mapper), DTO 규칙, 응답 형식, 에러 처리, 쿼리 작성 규칙. BE 코드 작성/리뷰 전 참조.
---

# BE 코딩 컨벤션

> 스택: Spring Boot 4.0.6 · Java 17 · MyBatis · SQL Server 2022 · Lombok · Gradle

## 패키지 구조

```
com.lawrence.<프로젝트명>_api/
├── controller/      # HTTP 진입점
├── service/         # 도메인 로직 (interface)
│   └── impl/        # 구현체
├── mapper/          # MyBatis Mapper 인터페이스
└── dto/             # 요청/응답 DTO
```

## 레이어 규칙

- **Controller** — HTTP 요청 수신, 파라미터 바인딩, `ResponseEntity` 반환. 비즈니스 로직 금지.
- **Service(interface + impl)** — 도메인 로직. `@Service`, `@RequiredArgsConstructor` 사용.
- **Mapper** — `@Mapper` 어노테이션. 쿼리는 **반드시 XML Mapper**에 작성(인라인 어노테이션 지양).

## 명명 규칙

| 대상 | 규칙 | 예시 |
|---|---|---|
| 클래스 | PascalCase | `UserController` |
| Mapper 메서드 | `selectList` / `selectById` / `insert` / `update` / `delete` | — |
| DTO | `<Domain>RequestDto`, `<Domain>ResponseDto` | `UserRequestDto` |
| XML Mapper 파일 | `<Domain>Mapper.xml` | `UserMapper.xml` |
| 테이블명 | snake_case | `user_info` |

## Lombok 사용

- `@RequiredArgsConstructor` — 생성자 주입
- `@Getter` — DTO 필드 접근자
- `@Builder` — ResponseDto 생성
- `@Slf4j` — 로거

## DTO 규칙

- RequestDto: `@Getter` (setter 금지, 필드는 요청 파라미터만)
- ResponseDto: `@Getter` + `@Builder` (MyBatis resultMap으로 매핑)
- `null` 허용 필드는 래퍼 타입 사용 (`Long`, `Integer` 등)

## 응답 형식

- 성공: `ResponseEntity.ok(data)` 또는 `ResponseEntity.ok().build()`
- 공통 래퍼가 있으면 `ApiResponse<T>` 사용

## MyBatis XML Mapper

- 위치: `src/main/resources/mapper/<Domain>Mapper.xml`
- `namespace`: `com.lawrence.<프로젝트명>_api.mapper.<Domain>Mapper`
- resultMap을 항상 정의하고 `resultType` 직접 참조 지양
- SQL Server 문법 사용 (`TOP` / `OFFSET-FETCH`, `GETDATE()` 등 — MySQL 문법 혼용 금지)

## 금지 사항

- `@Autowired` 필드 주입 (생성자 주입만 허용)
- MyBatis 인라인 `@Select` / `@Insert` 등 어노테이션 쿼리
- DTO에 `any`-상당 Object 타입 남용
- 스키마 변경(테이블 추가/컬럼 변경) — 사람 승인 게이트 필수
