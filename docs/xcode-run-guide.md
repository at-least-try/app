# Xcode Run Guide (macOS Desktop + iOS Simulator)

You are now at the stage where you can open this package in Xcode and run the desktop shell.

## A) Run mac desktop app shell in Xcode

1. Open Xcode.
2. Choose **File → Open...** and select the repository root (`/workspace/app`) on your machine.
3. In the top toolbar, pick the scheme **LifeAdminDesktop**.
4. Select destination **My Mac**.
5. Press **Run** (⌘R).

Expected result:

- A macOS window opens with the Life Admin sidebar and dashboard shell.
- Data is seeded from in-memory repository and shown in the dashboard summary.

## B) Run core CLI demos (optional)

- Scheme: **LifeAdminDemo** → destination **My Mac** → Run.

## C) iOS simulator status

The repo already contains SwiftUI scaffold files in `ios/LifeAdminApp/`.
To run in iOS Simulator, create an iOS app target in Xcode and attach these files.

Suggested quick setup:

1. **File → New → Project... → iOS App** (`LifeAdminiOS`).
2. Set Interface to **SwiftUI**.
3. Add package dependency pointing to local repo path and link product `LifeAdminCore`.
4. Copy in:
   - `ios/LifeAdminApp/LifeAdminApp.swift`
   - `ios/LifeAdminApp/Screens/DashboardScreen.swift`
   - `ios/LifeAdminApp/ViewModels/DashboardViewModel.swift`
5. Pick an iPhone simulator (e.g., iPhone 16) and run.

Once this is done, you can start simulator-based UI iteration.
