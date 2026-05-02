import SwiftUI

@main
struct Buddie_CareApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .preferredColorScheme(.light)
                // COMPLIANCE: AVG art. 13 — privacy notice must be shown at onboarding
        }
    }
}
