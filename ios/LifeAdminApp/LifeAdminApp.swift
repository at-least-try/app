#if canImport(SwiftUI)
import SwiftUI

@main
struct LifeAdminApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardScreen(viewModel: .preview)
        }
    }
}
#endif
