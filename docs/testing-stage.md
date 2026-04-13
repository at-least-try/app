# Testing Stage Guide (Visible Process)

This repository now includes a visible MVP process demo and unit tests.

## 1) Run the interactive process demo

```bash
swift run LifeAdminDemo
```

This shows:

- Dashboard bucket classification (`overdue`, `soon`, `upcoming`, `later`)
- Policy-rule evaluation output and triggered actions
- The exact stage to connect into SwiftUI view models

## 2) Run unit tests

```bash
swift test
```

Current test suites validate:

- Model normalization and recurrence behavior
- Repository behavior
- Dashboard planner logic
- Policy engine triggers
- Auth session linking behavior

## 3) UI design handoff

Open the visual wireframe prototype:

```bash
open prototype/life-admin-mvp.html
```

(Use `xdg-open` on Linux.)

Open full component system:

```bash
open prototype/life-admin-component-system.html
```

(Use `xdg-open` on Linux.)

Run desktop shell demo:

```bash
swift run LifeAdminDesktop
```
