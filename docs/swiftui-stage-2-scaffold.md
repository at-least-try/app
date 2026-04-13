# SwiftUI Stage 2 Scaffold

This scaffold starts the app shell integration phase by introducing:

- `LifeAdminApp.swift` entry point
- `DashboardViewModel` that calls `DashboardUseCase`
- `DashboardScreen` that renders grouped sections and triggered actions

## Notes

- Files are guarded with `#if canImport(SwiftUI)` so core package/test workflow continues on non-Apple environments.
- Current preview uses `InMemoryCycleRepository` with seeded sample cycles.
- Next step is wiring this scaffold into an Xcode iOS app target and replacing in-memory storage with a Firestore-backed repository.
