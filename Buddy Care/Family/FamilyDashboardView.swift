import SwiftUI

struct FamilyDashboardView: View {
    @Environment(AppState.self) private var appState
    @State private var showRequestFlow = false
    @State private var showEditProfile = false
    @State private var showWMOGuide = false
    @Binding var showLinking: Bool

    init(showLinking: Binding<Bool> = .constant(false)) {
        _showLinking = showLinking
    }

    var body: some View {
        VStack(spacing: 0) {
            BCNavBar(title: "Hallo \(appState.familyUser.firstName)", subtitle: "Familie-overzicht")

            ScrollView {
                VStack(spacing: BCSpacing.md) {
                    // Linked elderly card
                    BCCard {
                        VStack(alignment: .leading, spacing: BCSpacing.sm) {
                            HStack {
                                ZStack {
                                    Circle().fill(BCColors.primary.opacity(0.12)).frame(width: 56, height: 56)
                                    Text("R")
                                        .font(BCTypography.title3)
                                        .foregroundStyle(BCColors.primary)
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(appState.elderlyUser.fullName)
                                        .font(BCTypography.headline)
                                        .foregroundStyle(BCColors.textPrimary)
                                    Text("\(appState.elderlyUser.age) jaar — \(appState.elderlyUser.address)")
                                        .font(BCTypography.caption)
                                        .foregroundStyle(BCColors.textSecondary)
                                }
                                Spacer()
                                Button {
                                    showEditProfile = true
                                } label: {
                                    Label("Aanpassen", systemImage: "pencil")
                                        .font(BCTypography.captionEmphasized)
                                        .foregroundStyle(BCColors.primary)
                                        .padding(.horizontal, BCSpacing.sm)
                                        .padding(.vertical, BCSpacing.xs)
                                        .background(Capsule().fill(BCColors.primary.opacity(0.08)))
                                }
                                .buttonStyle(.plain)
                            }
                            Divider()
                            HStack(spacing: BCSpacing.md) {
                                StatPill(icon: "heart.fill", value: "12", label: "Bezoeken")
                                StatPill(icon: "star.fill", value: "4.9", label: "Tevreden")
                                StatPill(icon: "exclamationmark.shield.fill", value: "0", label: "Incidenten")
                            }
                        }
                    }
                    .padding(.horizontal, BCSpacing.lg)
                    .padding(.top, BCSpacing.md)

                    // Quick actions
                    BCSectionHeader(title: "Snel regelen")
                        .padding(.horizontal, BCSpacing.lg)

                    VStack(spacing: BCSpacing.sm) {
                        BCBigTile(
                            title: "Hulp aanvragen voor \(appState.elderlyUser.firstName)",
                            subtitle: "Plan een buddy in",
                            icon: "hand.raised.fill",
                            color: BCColors.primary
                        ) {
                            showRequestFlow = true
                        }
                        BCBigTile(
                            title: "Vergoeding aanvragen via Wmo",
                            subtitle: "Gemeentelijke financiering voor hulpkosten",
                            icon: "eurosign.circle.fill",
                            color: BCColors.success
                        ) {
                            showWMOGuide = true
                        }
                        BCBigTile(
                            title: "Bekijk recente bezoeken",
                            subtitle: "Wat is er gebeurd",
                            icon: "list.bullet.rectangle",
                            color: BCColors.accent
                        ) { }
                        BCBigTile(
                            title: "Koppel met oudere",
                            subtitle: "Verbind via 6-cijferige code",
                            icon: "link.badge.plus",
                            color: BCColors.level1
                        ) {
                            showLinking = true
                        }
                    }
                    .padding(.horizontal, BCSpacing.lg)

                    // Last visit
                    if let last = appState.taskHistory.first {
                        BCSectionHeader(title: "Laatste bezoek")
                            .padding(.horizontal, BCSpacing.lg)
                        BCCard {
                            VStack(alignment: .leading, spacing: BCSpacing.sm) {
                                HStack {
                                    Image(systemName: last.category.icon)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .frame(width: 40, height: 40)
                                        .background(Circle().fill(BCColors.primary))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(last.category.displayName)
                                            .font(BCTypography.bodyEmphasized)
                                            .foregroundStyle(BCColors.textPrimary)
                                        if let buddy = last.assignedBuddyName {
                                            Text("Met \(buddy)")
                                                .font(BCTypography.caption)
                                                .foregroundStyle(BCColors.textSecondary)
                                        }
                                    }
                                    Spacer()
                                    BCStatusPill(label: "Voltooid", color: BCColors.success)
                                }
                                if let note = last.completionNote {
                                    Text("\u{201C}\(note)\u{201D}")
                                        .font(BCTypography.body)
                                        .foregroundStyle(BCColors.textPrimary)
                                        .italic()
                                }
                            }
                        }
                        .padding(.horizontal, BCSpacing.lg)
                    }

                    Spacer().frame(height: BCSpacing.xl)
                }
            }
        }
        .background(BCColors.background.ignoresSafeArea())
        .sheet(isPresented: $showRequestFlow) {
            RequestHelpFlow()
        }
        .sheet(isPresented: $showWMOGuide) {
            WMOGuideView()
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileSheet()
        }
    }
}

private struct StatPill: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(BCColors.primary)
            Text(value)
                .font(BCTypography.headline)
                .foregroundStyle(BCColors.textPrimary)
            Text(label)
                .font(BCTypography.caption)
                .foregroundStyle(BCColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    FamilyDashboardView().environment(AppState())
}
