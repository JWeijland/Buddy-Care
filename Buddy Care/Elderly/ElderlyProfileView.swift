import SwiftUI

struct ElderlyProfileView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.largeTextEnabled) private var largeText
    @State private var notificationsEnabled = true
    @State private var showEditSheet = false
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

                    VStack(spacing: 0) {
                        HStack {
                            Label("Mijn gegevens", systemImage: "person.text.rectangle.fill")
                                .font(et.body)
                                .foregroundStyle(BCColors.textPrimary)
                            Spacer()
                            Button {
                                showEditSheet = true
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
                        .padding(.horizontal, BCSpacing.lg)
                        .padding(.vertical, BCSpacing.md)
                        Divider()
                        ProfileRow(icon: "phone.fill", label: "Telefoonnummer", value: appState.elderlyUser.phoneNumber)
                            .padding(.horizontal, BCSpacing.lg)
                        Divider()
                        ProfileRow(icon: "house.fill", label: "Adres", value: appState.elderlyUser.address)
                            .padding(.horizontal, BCSpacing.lg)
                        Divider()
                        ProfileRow(icon: "exclamationmark.triangle.fill", label: "Allergieën", value: appState.elderlyUser.allergies.joined(separator: ", "))
                            .padding(.horizontal, BCSpacing.lg)
                        Divider()
                        ProfileRow(icon: "pills.fill", label: "Medicatie", value: appState.elderlyUser.medicationNotes)
                            .padding(.horizontal, BCSpacing.lg)
                    }
                    .background(BCColors.surface)
                    .sheet(isPresented: $showEditSheet) {
                        EditProfileSheet()
                    }

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
                        .padding(.horizontal, BCSpacing.lg)
                        .padding(.vertical, BCSpacing.md)
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
                        .padding(.horizontal, BCSpacing.lg)
                        .padding(.vertical, BCSpacing.md)
                        Divider()
                        Toggle(isOn: $notificationsEnabled) {
                            Label("Meldingen", systemImage: "bell.fill")
                                .font(et.body)
                                .foregroundStyle(BCColors.textPrimary)
                        }
                        .tint(BCColors.primary)
                        .padding(.horizontal, BCSpacing.lg)
                        .padding(.vertical, BCSpacing.md)
                    }
                    .background(BCColors.surface)

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

// MARK: - Edit sheet

struct EditProfileSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.largeTextEnabled) private var largeText
    private var et: BCElderlyType { BCElderlyType(large: largeText) }

    @State private var phone: String = ""
    @State private var address: String = ""
    @State private var allergiesText: String = ""
    @State private var medication: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: BCSpacing.md) {
                    editField(icon: "phone.fill", label: "Telefoonnummer",
                              placeholder: "06 12 34 56 78", text: $phone,
                              keyboard: .phonePad)
                    editField(icon: "house.fill", label: "Adres",
                              placeholder: "Straat, huisnummer, stad", text: $address)
                    editField(icon: "exclamationmark.triangle.fill", label: "Allergieën",
                              placeholder: "Bijv. Penicilline, noten", text: $allergiesText)
                    editField(icon: "pills.fill", label: "Medicatie",
                              placeholder: "Bijv. 2x daags bloeddrukpil", text: $medication,
                              multiline: true)
                }
                .padding(BCSpacing.lg)
            }
            .background(BCColors.background.ignoresSafeArea())
            .navigationTitle("Gegevens aanpassen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Annuleer") { dismiss() }.tint(BCColors.primary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Opslaan") { save() }
                        .font(BCTypography.bodyEmphasized)
                        .tint(BCColors.primary)
                }
            }
        }
        .onAppear {
            phone = appState.elderlyUser.phoneNumber
            address = appState.elderlyUser.address
            allergiesText = appState.elderlyUser.allergies.joined(separator: ", ")
            medication = appState.elderlyUser.medicationNotes
        }
    }

    @ViewBuilder
    private func editField(icon: String, label: String, placeholder: String,
                           text: Binding<String>, keyboard: UIKeyboardType = .default,
                           multiline: Bool = false) -> some View {
        BCCard {
            VStack(alignment: .leading, spacing: BCSpacing.sm) {
                Label(label, systemImage: icon)
                    .font(et.caption)
                    .foregroundStyle(BCColors.textSecondary)
                if multiline {
                    TextField(placeholder, text: text, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                        .font(et.body)
                        .foregroundStyle(BCColors.textPrimary)
                } else {
                    TextField(placeholder, text: text)
                        .keyboardType(keyboard)
                        .font(et.body)
                        .foregroundStyle(BCColors.textPrimary)
                }
            }
        }
    }

    private func save() {
        let allergies = allergiesText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        appState.elderlyUser.phoneNumber = phone
        appState.elderlyUser.address = address
        appState.elderlyUser.allergies = allergies
        appState.elderlyUser.medicationNotes = medication
        dismiss()
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
