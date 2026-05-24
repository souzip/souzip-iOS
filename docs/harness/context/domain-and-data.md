# Domain · Data 레이어 패턴

> 상위 구조: [`architecture.md`](architecture.md) · import·Factory: [`layers.md`](layers.md)

## Domain

### 역할

비즈니스 규칙의 **안쪽 원**. 외부 모듈·프레임워크 import 없음.

### 산출물

| 종류 | 규칙 |
|------|------|
| `Model/` | 순수 Swift 타입. UI 전용은 Presentation. |
| `Repository/` | `protocol`, `async` 메서드 |
| `UseCase/` | `protocol` + `Default*UseCase`, Repository만 주입 |
| `Error/` | feature별 `enum` |

### UseCase

```text
ViewModel → UseCase.execute() → Repository (protocol)
```

- ViewModel은 Repository 타입을 모름.
- Factory: `DomainFactory+{Feature}`에서 `Default*UseCase` 조립.

### DataFactory 프로토콜 (Domain에 위치)

- `Domain/Sources/Util/Factory/DataFactory.swift` — `make*Repository()` 시그니처만.
- 구현·네트워크·DTO는 전부 Data 모듈.

## Data

### 역할

Domain Repository **구현**, API·로컬 저장, DTO↔Domain 변환.

### 표준 흐름

```text
Endpoint (APIEndpoint)
  → RemoteDataSource (NetworkClient.request)
    → Default*Repository
      → *DTOMapper.toDomain
      → (실패) NetworkError → Domain Error
```

| 단계 | 규칙 |
|------|------|
| **Endpoint** | `enum` + `APIEndpoint` (path, method, headers, body) |
| **DTO** | Codable, `import Domain` 없음 |
| **Mapper** | `enum *DTOMapper { static func toDomain }` — DTO에 `toDomain()` 직접 금지 |
| **DataSource** | Remote 필수; Local은 Keychain·UD·번들 JSON 등 필요 시 |
| **Repository** | Domain 프로토콜 준수, 에러 매핑은 `private extension` |

### Factory (Data)

- `DefaultDataFactory`: `private lazy var cached*Repository` + `make*Repository()`.
- Authed API: `networkFactory.makeAuthedClient(cachedTokenRefresher)`.
- Token 갱신: `DefaultTokenRefresher` — DataFactory에서 lazy 구성.

## 네트워크 (Core/Networking)

| 개념 | 설명 |
|------|------|
| `NetworkFactory` | `makePlainClient()` / `makeAuthedClient(TokenRefresher)` |
| `APIEndpoint` | `asURLRequest(baseURL:)` |
| 응답 | `APIResponse<T>` 래퍼 |
| 에러 | `NetworkError` → Repository에서 Domain `*Error`로 매핑 |

Networking 모듈은 Logger만 의존. Data가 Networking을 사용.

## 기능 폴더 대칭

Domain·Data 모두 `Sources/{Feature}/` 아래 동일 feature 이름:

```text
Domain/Sources/Wishlist/
  Model/ Repository/ UseCase/ Error/
Data/Sources/Wishlist/
  Endpoint/ DTO/ DataSource/ Repository/
```

새 기능 체크리스트: [`feature-playbook.md`](feature-playbook.md).

## 코드 앵커

| 개념 | 경로 |
|------|------|
| UseCase | `Domain/.../Wishlist/UseCase/AddToWishlistUseCase.swift` |
| Repository protocol | `Domain/.../Wishlist/Repository/WishlistRepository.swift` |
| Repository 구현 | `Data/.../Wishlist/Repository/DefaultWishlistRepository.swift` |
| Mapper | `Data/.../Wishlist/DTO/WishlistDTOMapper.swift` |
| Endpoint | `Data/.../Wishlist/Endpoint/WishlistEndpoint.swift` |
| DataFactory | `Data/.../Util/Factory/DataFactory.swift` |
