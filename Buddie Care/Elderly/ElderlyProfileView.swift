import SwiftUI

struct ElderlyProfileView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.largeTextEnabled) private var largeText
    @State private var notificationsEnabled = true
    private var et: BCElderlyType { BCElderlyType(large: largeText) }

    var body: some View {
        VStack(spacing: 0) {
            BCNavBar(title: "Profiel", subtitle: "Mijn gegevens")

            ScrollView {
                VStack(spacing: BCSpacing.md) {
                    BCCard {
                        HStack(spacing: BCSpacing.md) {
                            ZStack {
                                Circle().fill(BCColors.primary.opacity(0.12)).frame(width: 64, height: 64)
                                Text(initials)
                                    .font(BCTypography.title2)
                                    .foregroundStyle(BCColors.primary)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(appState.elderlyUser.fullName)
                                    .font(et.heading)
                                    .foregroundStyle(BCColors.textPrimary)
                                Text("\(appState.elderlyUser.age) jaar")
                                    .font(et.body)
                                    .foregroundStyle(BCColors.textSecondary)
                                Text(appState.elderlyUser.address)
                                    .font(et.caption)
                                    .foregroundStyle(BCColors.textTertiary)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal, BCSpacing.lg)

                    BCCard {
                        VStack(alignment: .leading, spacing: BCSpacing.sm) {
                            Label("Tegoed", systemImage: "creditcard.fill")
                                .font(BCTypography.headline)
                                .foregroundStyle(BCColors.textPrimary)
                            HStack(alignment: .firstTextBaseline) {
                                Text(String(format: "€ %.2f", appState.elderlyUser.creditEuros).replacingOccurrences(of: ".", with: ","))
                                    .font(BCTypography.title)
                                    .foregroundStyle(BCColors.primary)
                                Spacer()
                                BCStatusPill(label: "Welkom-tegoed", color: BCColors.success)
                            }
                            Text("Bij elke nieuwe oma die zich via uw deel-link aanmeldt, krijgt u € 10 erbij.")
                                .font(BCTypography.caption)
                                .foregroundStyle(BCColors.textSecondary)
                        }
                    }
                    .padding(.horizontal, BCSpacing.lg)

                    BCCard {
                        VStack(spacing: 0) {
                            ProfileRow(icon: "phone.fill", label: "Telefoonnummer", value: appState.elderlyUser.phoneNumber)
                            Divider().padding(.leading, 36)
                            ProfileRow(icon: "house.fill", label: "Adres", value: appState.elderlyUser.address)
                            Divider().padding(.leading, 36)
                            ProfileRow(icon: "exclamationmark.triangle.fill", label: "Allergieën", value: appState.elderlyUser.allergies.joined(separator: ", "))
                            Divider().padding(.leading, 36)
                            ProfileRow(icon: "pills.fill", label: "Medicatie", value: appState.elderlyUser.medicationNotes)
                        }
                    }
                    .padding(.horizontal, BCSpacing.lg)

                    BCCard {
                        VStack(spacing: 0) {
                            Toggle(isOn: Binding(
                                get: { appState.largeTextEnabled },
                                set: { appState.largeTextEnabled = $0 }
                            )) {
                                Label("Grote letters", systemImage: "textformat.size")
                                    .font(et.body)
                                    .foregroundStyle(BCColors.textPrimary)
                            }
                            .tint(BCColors.primary)
                            Divider()
                            Toggle(isOn: Binding(
                                get: { appState.prefersFormal },
                                set: { appState.prefersFormal = $0 }
                            )) {
                                VStack(alignment: .leading, spacing: 1) {
                                    Label("Formeel aanspreken", systemImage: "person.fill")
                                        .font(et.body)
                                        .foregroundStyle(BCColors.textPrimary)
                                    Text(appState.prefersFormal ? "Buddies zeggen u" : "Buddies zeggen jij")
                                        .font(et.caption)
                                        .foregroundStyle(BCColors.textTertiary)
                                }
                            }
                            .tint(BCColors.primary)
                            Divider()
                            Toggle(isOn: $notificationsEnabled) {
                                Label("Meldingen", systemImage: "bell.fill")
                                    .font(et.body)
                                    .foregroundStyle(BCColors.textPrimary)
                            }
                            .tint(BCColors.primary)
                        }
                    }
                    .padding(.horizontal, BCSpacing.lg)

                    // Trust row per spec
                    HStack(spacing: BCSpacing.md) {
                        TrustPill(text: "AVG conform")
                        TrustPill(text: "VOG-gescreend")
                        TrustPill(text: "WMO (aanvraag)")
                    }
                    .padding(.horizontal, BCSpacing.lg)

                    Button {
                        appState.resetToRoleSelection()
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Wissel rol (prototype)")
                        }
                        .font(BCTypography.bodyEmphasized)
                        .foregroundStyle(BCColors.primary)
                        .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, BCSpacing.lg)
                    .padding(.top, BCSpacing.sm)
                }
                .padding(.top, BCSpacing.md)
                .padding(.bottom, BCSpacing.xl)
            }
        }
        .background(BCColors.background.ignoresSafeArea())
    }

    private var initials: String {
        let first = appState.elderlyUser.firstName.first.map { String($0) } ?? ""
        let last = appState.elderlyUser.lastName.first.map { String($0) } ?? ""
        return "\(first)\(last)"
    }
}

private struct TrustPill: View {
    let text: String
    var body: some View {
        Text(text)
            .font(BCTypography.caption)
            .foregroundStyle(BCColors.textSecondary)
            .padding(.horizontal, BCSpacing.sm)
            .padding(.vertical, BCSpacing.xs)
            .background(
                Capsule().fill(BCColors.surfaceMuted)
            )
            .frame(maxWidth: .infinity)
    }
}

private struct ProfileRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: BCSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(BCColors.primary)
                .frame(width: 24)
                .padding(.top, 4)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(BCTypography.caption)
                    .foregroundStyle(BCColors.textSecondary)
                Text(value)
                    .font(BCTypography.body)
                    .foregroundStyle(BCColors.textPrimary)
            }
            Spacer()
        }
        .padding(.vertical, BCSpacing.sm)
    }
}

#Preview {
    ElderlyProfileView().environment(AppState())
}
