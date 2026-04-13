# Stage 2 Implementation Plan (App Shell + Integration Prep)

## Goal

Move from validated core logic to app-usable flows by introducing use-case orchestration and preparing the SwiftUI integration boundary.

## Delivered in this stage increment

- `DashboardUseCase` that composes:
  - cycle retrieval from `CycleRepository`
  - dashboard bucketing via `DashboardPlanner`
  - policy evaluation via `PolicyEngine`
- test coverage for the orchestrated result shape (`DashboardUseCaseTests`)
- demo process upgraded to run through `DashboardUseCase` instead of direct planner/engine calls

## Next implementation tasks

1. Add SwiftUI app target and dashboard view model.
2. Add Firestore-backed `CycleRepository` adapter.
3. Add simple auth session manager that upgrades anonymous users to Google/email.
4. Connect `DashboardUseCase` output to sections and action cards in SwiftUI.
