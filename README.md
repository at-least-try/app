# Life Admin Autopilot

Life Admin Autopilot is a focused iOS application for managing recurring life obligations:

- Personal document renewals (passport, licenses, tax forms)
- Deadline management for routine life-admin cycles
- Subscription tracking and policy alerts
- Medical bill follow-up workflows
- Lightweight relationship cadence reminders

This repository now includes an executable core Swift package plus MVP planning docs.

## MVP focus

This project is intentionally **not** a generic to-do list. It is a cycle-driven operations system for repetitive life admin.

## Planned stack

- iOS client: SwiftUI
- Backend: Firebase (Auth, Firestore, Cloud Functions, Cloud Messaging)
- Authentication providers: Anonymous, Google, Email/Password

## Repository layout

- `Sources/LifeAdminCore/` domain models, dashboard planning, policy evaluation, and repository interfaces
- `Sources/LifeAdminDemo/` executable demo for visible end-to-end core flow
- `ios/LifeAdminApp/` SwiftUI app scaffold (dashboard screen + view model wiring)
- `Tests/LifeAdminCoreTests/` unit tests for core domain logic
- `docs/` product and technical planning docs
- `prototype/` HTML UI prototypes (screen flow + full component system)
- `firebase/` Firestore security rules

## Local development

Run unit tests:

```bash
swift test
```

Run visible process demo:

```bash
swift run LifeAdminDemo
```


Run desktop shell (macOS):

```bash
swift run LifeAdminDesktop
```
