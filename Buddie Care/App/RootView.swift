import SwiftUI

struct RootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            Group {
                if !appState.hasSeenSplash {
                    SplashView {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            appState.hasSeenSplash = true
                        }
                    } onDemoMap: {
                        appState.isOnboardingComplete = true
                        appState.currentRole = .buddy
                        withAnimation(.easeInOut(duration: 0.35)) {
                            appState.hasSeenSplash = true
                        }
                    }
                } else {
                    switch appState.currentRole {
                    case .none:
                        RoleSelectionView()
                    case .elderly:
                        ElderlyTabView()
                    case .buddy:
                        BuddyTabView()
                    case .family:
                        FamilyTabView()
                    }
                }
            }
            .animation(.easeInOut(duration: 0.25), value: appState.currentRole)
            .animation(.easeInOut(duration: 0.35), value: appState.hasSeenSplash)

            // Global toast overlay
            if let toast = appState.toastMessage {
                VStack {
                    Spacer()
                    BCToast(message: toast.text, icon: toast.icon)
                        .padding(.bottom, 80)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .ignoresSafeArea(edges: .bottom)
                .allowsHitTesting(false)
                .animation(.spring(response: 0.35), value: appState.toastMessage != nil)
            }
        }
        .animation(.spring(response: 0.35), value: appState.toastMessage != nil)
    }
}

#Preview {
    RootView()
        .environment(AppState())
}
