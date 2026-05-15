import SwiftUI

struct FamilyTabView: View {
    @Environment(AppState.self) private var appState
    @State private var selection = 0
    @State private var showLinking = false

    var body: some View {
        TabView(selection: $selection) {
            FamilyDashboardView(showLinking: $showLinking)
                .tag(0)
                .tabItem { Label("Overzicht", systemImage: "house.fill") }
            ActivityTimelineView()
                .tag(1)
                .tabItem { Label("Activiteit", systemImage: "list.bullet.rectangle") }
            FamilyProfileView()
                .tag(2)
                .tabItem { Label("Profiel", systemImage: "person.crop.circle") }
        }
        .tint(BCColors.primary)
        .sheet(isPresented: $showLinking) {
            FamilyLinkingView()
        }
    }
}

#Preview {
    FamilyTabView().environment(AppState())
}
