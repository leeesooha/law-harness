---
name: scaffold-api
description: Spring Boot + MyBatis 구조로 CRUD API 엔드포인트를 스캐폴딩한다.
             "API 만들어줘", "엔드포인트 추가해줘", "CRUD 만들어줘", "Controller/Service/Mapper 만들어줘" 요청 시 사용.
             Controller · Service(interface+impl) · Mapper · DTO · XML Mapper를 한 번에 생성한다.
---

# API 스캐폴딩 (Spring Boot + MyBatis)

## 전제
- 패키지 루트: `com.lawrence.<프로젝트명>_api`
- DB: SQL Server (테이블명은 snake_case)
- Lombok 사용 (`@RequiredArgsConstructor`, `@Getter`, `@Builder` 등)
- MyBatis XML Mapper 방식 (어노테이션 쿼리 지양)

## 입력 확인
1. **도메인명** — 예: `User`, `Product` (PascalCase)
2. **필요한 작업** — 전체 CRUD인지, 일부(조회만 등)인지
3. **주요 필드** — DTO에 들어갈 컬럼 목록
4. **테이블명** — 없으면 도메인명을 snake_case로 변환해 추정

## 파일 생성 위치

```
src/main/java/com/lawrence/<프로젝트명>_api/
├── controller/
│   └── <Domain>Controller.java
├── service/
│   ├── <Domain>Service.java          (interface)
│   └── impl/
│       └── <Domain>ServiceImpl.java
├── mapper/
│   └── <Domain>Mapper.java
└── dto/
    ├── <Domain>RequestDto.java
    └── <Domain>ResponseDto.java

src/main/resources/mapper/
└── <Domain>Mapper.xml
```

## 템플릿

### Controller
```java
package com.lawrence.{{project}}_api.controller;

import com.lawrence.{{project}}_api.dto.{{Domain}}RequestDto;
import com.lawrence.{{project}}_api.dto.{{Domain}}ResponseDto;
import com.lawrence.{{project}}_api.service.{{Domain}}Service;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/{{domain}}s")
@RequiredArgsConstructor
public class {{Domain}}Controller {

    private final {{Domain}}Service {{domain}}Service;

    @GetMapping
    public ResponseEntity<List<{{Domain}}ResponseDto>> getList() {
        return ResponseEntity.ok({{domain}}Service.getList());
    }

    @GetMapping("/{id}")
    public ResponseEntity<{{Domain}}ResponseDto> getById(@PathVariable Long id) {
        return ResponseEntity.ok({{domain}}Service.getById(id));
    }

    @PostMapping
    public ResponseEntity<Void> create(@RequestBody {{Domain}}RequestDto requestDto) {
        {{domain}}Service.create(requestDto);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/{id}")
    public ResponseEntity<Void> update(@PathVariable Long id, @RequestBody {{Domain}}RequestDto requestDto) {
        {{domain}}Service.update(id, requestDto);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        {{domain}}Service.delete(id);
        return ResponseEntity.ok().build();
    }
}
```

### Service (interface)
```java
package com.lawrence.{{project}}_api.service;

import com.lawrence.{{project}}_api.dto.{{Domain}}RequestDto;
import com.lawrence.{{project}}_api.dto.{{Domain}}ResponseDto;

import java.util.List;

public interface {{Domain}}Service {
    List<{{Domain}}ResponseDto> getList();
    {{Domain}}ResponseDto getById(Long id);
    void create({{Domain}}RequestDto requestDto);
    void update(Long id, {{Domain}}RequestDto requestDto);
    void delete(Long id);
}
```

### ServiceImpl
```java
package com.lawrence.{{project}}_api.service.impl;

import com.lawrence.{{project}}_api.dto.{{Domain}}RequestDto;
import com.lawrence.{{project}}_api.dto.{{Domain}}ResponseDto;
import com.lawrence.{{project}}_api.mapper.{{Domain}}Mapper;
import com.lawrence.{{project}}_api.service.{{Domain}}Service;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class {{Domain}}ServiceImpl implements {{Domain}}Service {

    private final {{Domain}}Mapper {{domain}}Mapper;

    @Override
    public List<{{Domain}}ResponseDto> getList() {
        return {{domain}}Mapper.selectList();
    }

    @Override
    public {{Domain}}ResponseDto getById(Long id) {
        return {{domain}}Mapper.selectById(id);
    }

    @Override
    public void create({{Domain}}RequestDto requestDto) {
        {{domain}}Mapper.insert(requestDto);
    }

    @Override
    public void update(Long id, {{Domain}}RequestDto requestDto) {
        {{domain}}Mapper.update(id, requestDto);
    }

    @Override
    public void delete(Long id) {
        {{domain}}Mapper.delete(id);
    }
}
```

### Mapper (interface)
```java
package com.lawrence.{{project}}_api.mapper;

import com.lawrence.{{project}}_api.dto.{{Domain}}RequestDto;
import com.lawrence.{{project}}_api.dto.{{Domain}}ResponseDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface {{Domain}}Mapper {
    List<{{Domain}}ResponseDto> selectList();
    {{Domain}}ResponseDto selectById(@Param("id") Long id);
    void insert({{Domain}}RequestDto requestDto);
    void update(@Param("id") Long id, @Param("dto") {{Domain}}RequestDto requestDto);
    void delete(@Param("id") Long id);
}
```

### RequestDto
```java
package com.lawrence.{{project}}_api.dto;

import lombok.Getter;

@Getter
public class {{Domain}}RequestDto {
    // 필드를 입력에 따라 채운다
}
```

### ResponseDto
```java
package com.lawrence.{{project}}_api.dto;

import lombok.Getter;
import lombok.Builder;

@Getter
@Builder
public class {{Domain}}ResponseDto {
    // 필드를 입력에 따라 채운다
}
```

### XML Mapper
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="com.lawrence.{{project}}_api.mapper.{{Domain}}Mapper">

    <resultMap id="{{Domain}}ResultMap" type="com.lawrence.{{project}}_api.dto.{{Domain}}ResponseDto">
        <!-- 컬럼↔필드 매핑을 여기에 -->
    </resultMap>

    <select id="selectList" resultMap="{{Domain}}ResultMap">
        SELECT *
        FROM {{table_name}}
        WHERE 1=1
    </select>

    <select id="selectById" parameterType="Long" resultMap="{{Domain}}ResultMap">
        SELECT *
        FROM {{table_name}}
        WHERE id = #{id}
    </select>

    <insert id="insert" parameterType="com.lawrence.{{project}}_api.dto.{{Domain}}RequestDto">
        INSERT INTO {{table_name}} ()
        VALUES ()
    </insert>

    <update id="update">
        UPDATE {{table_name}}
        SET
        WHERE id = #{id}
    </update>

    <delete id="delete" parameterType="Long">
        DELETE FROM {{table_name}}
        WHERE id = #{id}
    </delete>

</mapper>
```

## 절차
1. 입력에서 도메인명 · 필드 목록 · 테이블명 확인
2. `{{Domain}}` → 실제 도메인명, `{{domain}}` → camelCase, `{{project}}` → 프로젝트명, `{{table_name}}` → 실제 테이블명으로 치환
3. RequestDto · ResponseDto 필드를 입력받은 컬럼 기준으로 채움
4. XML Mapper의 SELECT/INSERT/UPDATE 컬럼 목록 채움
5. 전체 파일 생성 후 생성된 경로 목록 보고

## 주의
- 전체 CRUD가 불필요하면 요청한 작업만 생성한다 (오버엔지니어링 금지)
- SQL Server 문법 사용 (MySQL 문법 혼용 금지 — `TOP` 대신 `LIMIT` 사용 금지 등)
- XML Mapper 파일이 classpath에 잡히려면 `application.yml`에 `mybatis.mapper-locations` 설정 필요
