# Best Practices - General Architecture

> **Note**: This document covers general architectural principles used across the Shortkey monorepo.  
> For project-specific best practices, see:
> - [Mac App Best Practices](../shortkey-mac/docs/BEST_PRACTICES.md)
> - [Backend Best Practices](../shortkey-api/docs/BEST_PRACTICES.md)

---

## SOLID Principles

### Single Responsibility Principle (SRP)

Each component has one job:

- `StatusIndicator` - Only renders a colored dot
- `KeychainService` - Only handles Keychain operations
- `NotificationManager` - Only manages system notifications
- `ActionsManager` - Only manages CRUD for actions

### Open/Closed Principle (OCP)

The `AIModelProvider` protocol allows adding new providers without modifying existing code:

```swift
protocol AIModelProvider {
    func transform(text: String, prompt: String, model: String) async throws -> String
    // ...
}

// OpenAI implementation
class OpenAIProvider: AIModelProvider { ... }

// Future: Add Gemini without changing existing code
class GeminiProvider: AIModelProvider { ... }
```

### Liskov Substitution Principle (LSP)

Any `AIModelProvider` implementation can be used interchangeably:

```swift
let manager = AIProviderManager(provider: OpenAIProvider())
// or
let manager = AIProviderManager(provider: GeminiProvider())
```

### Interface Segregation Principle (ISP)

Small, focused protocols:

```swift
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

protocol KeychainServiceProtocol {
    func save(key: String, value: String) throws
    func retrieve(key: String) throws -> String?
    func delete(key: String) throws
}
```

### Dependency Inversion Principle (DIP)

High-level modules depend on abstractions:

```swift
class AIProviderManager {
    private var provider: AIModelProvider  // Protocol, not concrete type
    
    init(provider: AIModelProvider) {
        self.provider = provider
    }
}
```

---

## Architecture Patterns

### Services vs Managers

**Key Distinction**: State and purpose

#### Services (Stateless System Integration)
- ✅ Wrap system APIs or external services
- ✅ Usually stateless or minimal state
- ✅ No `@Published` properties (Swift) or reactive state
- ✅ Direct system/API integration

**Examples:**
- `KeychainService` - Wraps macOS Keychain
- `CryptoService` - Wraps CryptoKit
- Backend services - Wrap HTTP APIs

#### Managers (Stateful Business Logic)
- ✅ Manage application state
- ✅ Have reactive properties (`@Published` in Swift)
- ✅ Business rules and logic
- ✅ Observed by UI layer

**Examples:**
- `ActionsManager` - Manages user's actions
- `SubscriptionManager` - Manages subscription state

**Decision Tree**: "Does it need to be observed by the UI?"
- YES → Manager (with reactive state)
- NO → Service (stateless)

### Domain Models vs DTOs

**Key Distinction**: Public API vs internal implementation

#### Domain Models (`Models/` folder)
- ✅ Represent business concepts
- ✅ Rich domain logic (computed properties, methods)
- ✅ Used throughout the app
- ✅ Independent of external APIs
- ✅ Public to entire codebase

**Example:**
```swift
struct QuotaInfo {
    let used: Int
    let limit: Int
    let resetsAt: String
    
    // Rich domain logic
    var remaining: Int {
        max(0, limit - used)
    }
    
    var isExceeded: Bool {
        used >= limit
    }
    
    var usagePercentage: Double {
        guard limit > 0 else { return 0 }
        return Double(used) / Double(limit)
    }
}
```

#### DTOs - Data Transfer Objects (Inside service folders)
- ✅ Match API/external structure exactly
- ✅ Only used inside specific service
- ✅ No business logic
- ✅ Convert to domain models
- ✅ Internal implementation detail

**Example:**
```swift
// ShortkeyBackend/BackendResponseModels.swift
struct QuotaInfoResponse: Decodable {
    let used: Int
    let limit: Int
    let resetsAt: String
    
    // Convert DTO to domain model
    func toDomain() -> QuotaInfo {
        QuotaInfo(used: used, limit: limit, resetsAt: resetsAt)
    }
}
```

#### Data Flow (Clean Architecture)
```
External API → DTO (internal) → .toDomain() → Domain Model (public) → App
```

**Benefits:**
- API structure can change without affecting the app
- Domain models stay stable
- Business logic centralized in domain models
- Clear separation of concerns

### Service Folder Organization

For complex services, use folder structure with multiple focused files:

```
Services/
├── SimpleService.swift              # Small, single file
└── ComplexService/                  # Folder for multi-file services
    ├── ComplexService.swift         # Main coordinator
    ├── HelperA.swift                # Single responsibility
    ├── HelperB.swift                # Single responsibility
    ├── ResponseModels.swift         # Internal DTOs
    └── ServiceError.swift           # Error types
```

**Examples in codebase:**
- `SubscriptionManager/` - Complex manager with multiple files
- `ShortkeyBackend/` - Complex service with multiple files

**Benefits:**
- Each file has single responsibility
- Easy to find relevant code
- Easy to test independently
- Easy to maintain and extend

### Naming Conventions

#### Implementation-Agnostic Names
✅ **Good**: `ShortkeyBackendService` (domain-focused)  
❌ **Bad**: `FirebaseBackendManager` (implementation detail)

**Why?** If you switch from Firebase to AWS, you don't want to rename everything.

#### Configuration Location
✅ **Client config** → Client constants  
✅ **Backend config** → Backend constants

**Why?** Each side owns its own configuration.

---

## Error Handling

### Typed Errors

Use enums with `LocalizedError`:

```swift
enum TextTransformError: LocalizedError {
    case textTooLong
    case providerNotConfigured
    case noTextSelected
    
    var errorDescription: String? {
        switch self {
        case .textTooLong: return "Text too long"
        case .providerNotConfigured: return "Provider not configured"
        case .noTextSelected: return "No text selected"
        }
    }
}
```

### Graceful Degradation

Handle errors without crashing:

```swift
do {
    availableModels = try await provider.fetchAvailableModels()
} catch {
    logger.error("Failed to fetch models: \(error)")
    // Keep using existing models - don't crash!
}
```

---

## Code Organization

### File Structure

Group related files in folders:

```
Feature/
├── FeatureView.swift          # Main view
├── FeatureSubView.swift       # Sub-component
└── FeatureViewModel.swift     # If needed
```

### Comment Style

Use MARK comments for organization:

```swift
// MARK: - Properties
// MARK: - Initialization
// MARK: - Public Methods
// MARK: - Private Methods
```

---

## Project-Specific Practices

For detailed best practices specific to each project:

- **macOS App**: See [shortkey-mac/docs/BEST_PRACTICES.md](../shortkey-mac/docs/BEST_PRACTICES.md)
  - SwiftUI patterns
  - Apple HIG compliance
  - Localization
  - Testing strategies

- **Backend API**: See [shortkey-api/docs/BEST_PRACTICES.md](../shortkey-api/docs/BEST_PRACTICES.md)
  - TypeScript conventions
  - Firebase best practices
  - API design patterns
  - Security practices
