import SwiftUI

struct AdminTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        TabView {
            AdminMembershipsView()
                .tabItem { Label("Aanvragen", systemImage: "person.badge.clock.fill") }

            AdminBillingView()
                .tabItem { Label("Facturatie", systemImage: "eurosign.circle.fill") }

            AdminOrganizationsView()
                .tabItem { Label("Takken", systemImage: "building.2.fill") }

            AdminSettingsView()
                .tabItem { Label("Instellingen", systemImage: "gearshape.fill") }
        }
        .tint(BCColors.primary)
    }
}

// MARK: - Takken beheer (placeholder)

private struct AdminOrganizationsView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(spacing: 0) {
            BCNavBar(title: "Takken", subtitle: "Partnerorganisaties")
            ScrollView {
                VStack(spacing: BCSpacing.md) {
                    ForEach(appState.availableOrganizations) { org in
                        OrgManageCard(org: org)
                    }

                    Button {
                        appState.showToast(text: "Organisatie toevoegen — binnenkort beschikbaar", icon: "building.2.fill")
                    } label: {
                        HStack(spacing: BCSpacing.sm) {
                            Image(systemName: "plus.circle.fill")
                            Text("Nieuwe organisatie toevoegen")
                        }
                        .font(BCTypography.bodyEmphasized)
                        .foregroundStyle(BCColors.primary)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(
                            RoundedRectangle(cornerRadius: BCRadius.lg)
                                .stroke(BCColors.primary, style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, BCSpacing.lg)
                }
                .padding(.top, BCSpacing.md)
                .padding(.bottom, BCSpacing.xl)
            }
        }
        .background(BCColors.background.ignoresSafeArea())
    }
}

private struct OrgManageCard: View {
    let org: Organization

    var body: some View {
        BCCard {
            HStack(spacing: BCSpacing.md) {
                ZStack {
                    Circle()
                        .fill(BCColors.primary.opacity(0.08))
                        .frame(width: 48, height: 48)
                    Image(systemName: org.logoSymbol)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(BCColors.primary)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(org.name)
                        .font(BCTypography.headline)
                        .foregroundStyle(BCColors.textPrimary)
                    Text("Buddy: \(formatted(org.buddyHourlyRateCents))/uur · Klant: \(formatted(org.clientHourlyRateCents))/uur")
                        .font(BCTypography.caption)
                        .foregroundStyle(BCColors.textSecondary)
                    Label(org.isActive ? "Actief" : "Inactief", systemImage: org.isActive ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(BCTypography.caption)
                        .foregroundStyle(org.isActive ? BCColors.success : BCColors.danger)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(BCColors.textTertiary)
            }
        }
        .padding(.horizontal, BCSpacing.lg)
    }

    private func formatted(_ cents: Int) -> String {
        String(format: "€ %.2f", Double(cents) / 100).replacingOccurrences(of: ".", with: ",")
    }
}

// MARK: - Admin instellingen (placeholder)

private struct AdminSettingsView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(spacing: 0) {
            BCNavBar(title: "Instellingen", subtitle: "Admin configuratie")
            ScrollView {
                VStack(spacing: BCSpacing.md) {
                    BCCard {
                        VStack(spacing: 0) {
                            AdminRow(icon: "person.crop.circle.fill", label: "Admin account") { }
                            Divider().padding(.leading, 56)
                            AdminRow(icon: "bell.fill", label: "Meldingen") { }
                            Divider().padding(.leading, 56)
                            AdminRow(icon: "lock.fill", label: "Beveiliging") { }
                        }
                    }
                    .padding(.horizontal, BCSpacing.lg)

                    Button {
                        appState.resetToRoleSelection()
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Uitloggen")
                        }
                        .font(BCTypography.bodyEmphasized)
                        .foregroundStyle(BCColors.danger)
                        .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, BCSpacing.lg)
                }
                .padding(.top, BCSpacing.md)
                .padding(.bottom, BCSpacing.xl)
            }
        }
        .background(BCColors.background.ignoresSafeArea())
    }
}

private struct AdminRow: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: BCSpacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(BCColors.primary)
                    .frame(width: 32)
                Text(label)
                    .font(BCTypography.body)
                    .foregroundStyle(BCColors.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13))
                    .foregroundStyle(BCColors.textTertiary)
            }
            .padding(.vertical, BCSpacing.md)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AdminTabView().environment(AppState())
}
