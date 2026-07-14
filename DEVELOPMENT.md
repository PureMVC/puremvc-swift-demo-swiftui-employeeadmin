# Testing Strategy

The project follows a layered testing approach. Each layer is tested in isolation, while a small number of integration tests verify that the layers work together correctly.

## ViewModel Tests (Unit)

**Dependencies:** Mock UseCases

**Purpose**

* Verify UI state changes.
* Verify loading, success, and error states.
* Verify user interactions and commands.

```text
ViewModel
    ↓
Mock UseCase or Repository or Data or Service
```

---

## UseCase Tests (Unit)

**Dependencies:** Mock or Spy Repositories

**Purpose**

* Verify business rules.
* Verify orchestration between repositories.
* Verify repository interactions.

```text
UseCase
    ↓
Mock/Spy Repository or Data or Service
```

---

## Repository Tests (Unit)

**Dependencies:** Mock Data Sources

Only required when the repository contains business logic such as:

* Mapping between models
* Validation
* Multiple data sources
* Caching
* Error transformation

If the repository is merely a pass-through to the data layer, these tests may be omitted.

```text
Repository
    ↓
Mock Data or Service
```

---

## Data Tests (Integration)

**Dependencies:** In-memory Core Data

**Purpose**

* Verify persistence.
* Verify fetch requests and predicates.
* Verify relationships.
* Verify save, update, delete, and count operations.

```text
UserData
    ↓
In-memory Core Data
```

---

## Integration Tests (Optional)

Use a real in-memory Core Data stack to verify the complete feature wiring.

```text
ViewModel
    ↓
UseCase
    ↓
Repository
    ↓
UserData
    ↓
In-memory Core Data
```

Only a few happy-path integration tests are typically needed.

---

## UI Tests (End-to-End)

**Dependencies:** Entire application

**Purpose**

* Verify complete user workflows.
* Verify navigation between screens.
* Verify forms and user interactions.
* Verify integration of all application layers.
* Catch regressions from a user's perspective.

```text
User
    ↓
UI
    ↓
ViewModel
    ↓
UseCase
    ↓
Repository
    ↓
UserData
    ↓
Core Data
```

Typical scenarios include:

* Create a user.
* Edit a user.
* Delete a user.
* Search or filter users.
* Validate navigation flows.
* Verify error messages and recovery.

UI tests should focus on a small number of critical user journeys. They are slower and more expensive to maintain than unit or integration tests, so the majority of tests should remain at the lower layers.

---

| Layer                 | Test Type                   | Dependencies                                            |
| --------------------- | --------------------------- | ------------------------------------------------------- |
| ViewModel             | Unit                        | Mock UseCase/Repository/Data/Service                    |
| ViewModel or Feature  | Integration (optional)      | Real UseCase/Repository/Data (in-memory infrastructure) |
| UseCase               | Unit                        | Mock/Spy Repository/Data/Service                        |
| Repository            | Unit (if it contains logic) | Mock Data Sources and Services                          |
| Data                  | Integration                 | In-memory Core Data                                     |
| UI                    | End-to-End (UI)             | Entire application                                      |
