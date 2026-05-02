import SwiftUI

struct BuddyOnboardingFlow: View {
    @Environment(AppState.self) private var appState
    @State private var step: Int = 0

    // Step 2 — personal info
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var city: String = ""

    // Step 3 — photo
    @State private var photoConfirmed: Bool = false

    // Step 4 — ID
    @State private var idSubmitted: Bool = false

    // Step 5 — VOG
    @State private var vogSubmitted: Bool = false

    // Step 6 — IBAN
    @State private var iban: String = ""

    // Step 7 — Availability
    @State private var availability: [String: Set<String>] = [:]

    // Step 8 — Agreement
    @State private var agreedToTerms: Bool = false

    // Pending view
    @State private var showPending: Bool = false

    var body: some View {
        if showPending {
            VerificationPendingView {
                appState.isOnboardingComplete = true
            }
        } else {
            NavigationStack {
                VStack(spacing: 0) {
                    stepProgressBar

                    Group {
                        switch step {
                        case 0: welcomeStep
                        case 1: personalInfoStep
                        case 2: photoStep
                        case 3: idVerificationStep
                        case 4: vogStep
                        case 5: bankStep
                        case 6: availabilityStep
                        case 7: agreementStep
                        default: EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    VStack(spacing: 0) {
                        Divider()
                        BCOnboardingPhoneFooter()
                            .padding(.horizontal, BCSpacing.lg)
                        bottomBar
                    }
                }
                .background(BCColors.background.ignoresSafeArea())
                .navigationTitle("Aanmelden als buddy")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    // MARK: - Progress bar

    private var stepProgressBar: some View {
        HStack(spacing: BCSpacing.xs) {
            ForEach(0..<8) { i in
                Capsule()
                    .fill(i <= step ? BCColors.primary : BCColors.border)
                    .frame(height: 5)
            }
        }
        .padding(.horizontal, BCSpacing.lg)
        .padding(.top, BCSpacing.sm)
    }

    // MARK: - Step 0: Welcome

    private var welcomeStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.lg) {
                VStack(alignment: .leading, spacing: BCSpacing.sm) {
                    Text("Welkom bij Buddy Care")
                        .font(BCTypography.title)
                        .foregroundStyle(BCColors.textPrimary)
                    Text("Verdien geld, bouw ervaring op en help ouderen in jouw buurt. De aanmelding duurt ca. 5 minuten.")
                        .font(BCTypography.body)
                        .foregroundStyle(BCColors.textSecondary)
                }

                VStack(spacing: BCSpacing.sm) {
                    OnboardingFeatureRow(icon: "eurosign.circle.fill", color: BCColors.success,
                        title: "Verdien €13–25 per uur",
                        detail: "Zelf je uren bepalen, flexibel werken")
                    OnboardingFeatureRow(icon: "graduationcap.fill", color: BCColors.primary,
                        title: "Bouw certificaten op",
                        detail: "Erkende e-learning modules")
                    OnboardingFeatureRow(icon: "checkmark.shield.fill", color: BCColors.accent,
                        title: "Veilig en gescreend",
                        detail: "VOG-verificatie voor elke buddy")
                }

                // Legal disclaimer per spec
                BCCard {
                    VStack(alignment: .leading, spacing: BCSpacing.xs) {
                        Label("Belangrijk", systemImage: "exclamationmark.triangle.fill")
                            .font(BCTypography.captionEmphasized)
                            .foregroundStyle(BCColors.warning)
                        Text("Voorbehouden handelingen (Wet BIG art. 36) zoals injecteren mogen nooit worden uitgevoerd door niet-BIG-geregistreerde personen. Buddy Care biedt deze taken niet aan.")
                            .font(BCTypography.caption)
                            .foregroundStyle(BCColors.textSecondary)
                    }
                }
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.top, BCSpacing.lg)
            .padding(.bottom, BCSpacing.xl)
        }
    }

    // MARK: - Step 1: Personal info

    private var personalInfoStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                Text("Jouw gegevens")
                    .font(BCTypography.title2)
                    .foregroundStyle(BCColors.textPrimary)

                VStack(alignment: .leading, spacing: BCSpacing.sm) {
                    FieldLabel("Voornaam")
                    TextField("Voornaam", text: $firstName)
                        .styledTextField()
                        .textContentType(.givenName)

                    FieldLabel("Achternaam")
                    TextField("Achternaam", text: $lastName)
                        .styledTextField()
                        .textContentType(.familyName)

                    FieldLabel("Woonplaats")
                    TextField("Rotterdam of Amsterdam", text: $city)
                        .styledTextField()
                        .textContentType(.addressCity)
                }
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.top, BCSpacing.lg)
            .padding(.bottom, BCSpacing.xl)
        }
    }

    // MARK: - Step 2: Photo

    private var photoStep: some View {
        VStack(spacing: BCSpacing.lg) {
            Spacer()

            Text("Profielfoto")
                .font(BCTypography.title2)
                .foregroundStyle(BCColors.textPrimary)

            ZStack {
                Circle()
                    .fill(BCColors.primaryMuted)
                    .frame(width: 120, height: 120)
                if photoConfirmed {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(BCColors.primary)
                } else {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(BCColors.primary)
                }
            }

            if photoConfirmed {
                BCStatusPill(label: "Foto geselecteerd ✓", color: BCColors.success)
            }

            BCSecondaryButton(title: photoConfirmed ? "Andere foto kiezen" : "Kies foto", icon: "photo.fill") {
                photoConfirmed = true
            }
            .padding(.horizontal, BCSpacing.xl)

            Button { step += 1 } label: {
                Text("Sla over")
                    .font(BCTypography.subheadline)
                    .foregroundStyle(BCColors.textTertiary)
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal, BCSpacing.lg)
    }

    // MARK: - Step 3: ID verification

    private var idVerificationStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                Text("Identiteitsverificatie")
                    .font(BCTypography.title2)
                    .foregroundStyle(BCColors.textPrimary)
                Text("Wij verifiëren uw identiteit om de veiligheid van ouderen te garanderen.")
                    .font(BCTypography.body)
                    .foregroundStyle(BCColors.textSecondary)

                if idSubmitted {
                    BCCard {
                        HStack(spacing: BCSpacing.sm) {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(BCColors.success)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("ID ontvangen ✓")
                                    .font(BCTypography.bodyEmphasized)
                                    .foregroundStyle(BCColors.success)
                                Text("Wij verifiëren binnen 24 uur.")
                                    .font(BCTypography.caption)
                                    .foregroundStyle(BCColors.textSecondary)
                            }
                        }
                    }
                } else {
                    VStack(spacing: BCSpacing.sm) {
                        IDUploadBox(icon: "rectangle.and.hand.point.up.left.fill",
                                    title: "Identiteitsbewijs",
                                    subtitle: "Paspoort, ID-kaart of rijbewijs")
                        IDUploadBox(icon: "person.fill.viewfinder",
                                    title: "Selfie",
                                    subtitle: "Maak een selfie om te bevestigen")
                    }

                    BCPrimaryButton(title: "Upload en verifieer", icon: "arrow.up.doc.fill") {
                        // TODO[real-integration]: Onfido KYC
                        idSubmitted = true
                    }
                    // COMPLIANCE: AVG art. 13 — privacy notice must be shown
                    Text("Uw identiteitsgegevens worden verwerkt conform de AVG.")
                        .font(BCTypography.caption)
                        .foregroundStyle(BCColors.textTertiary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.top, BCSpacing.lg)
            .padding(.bottom, BCSpacing.xl)
        }
    }

    // MARK: - Step 4: VOG

    private var vogStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                Text("Verklaring Omtrent Gedrag")
                    .font(BCTypography.title2)
                    .foregroundStyle(BCColors.textPrimary)
                Text("Een VOG is verplicht voor alle buddies. U kunt er één aanvragen via Justis (gratis voor vrijwilligers).")
                    .font(BCTypography.body)
                    .foregroundStyle(BCColors.textSecondary)

                if vogSubmitted {
                    BCCard {
                        HStack(spacing: BCSpacing.sm) {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(BCColors.success)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("VOG ingediend ✓")
                                    .font(BCTypography.bodyEmphasized)
                                    .foregroundStyle(BCColors.success)
                                Text("Wij ontvangen de VOG direct van Justis.")
                                    .font(BCTypography.caption)
                                    .foregroundStyle(BCColors.textSecondary)
                            }
                        }
                    }
                } else {
                    // COMPLIANCE: VOG required every 3 years, track expiry
                    VStack(spacing: BCSpacing.sm) {
                        BCSecondaryButton(title: "Aanvragen via Justis", icon: "arrow.up.right.square") { }
                        BCPrimaryButton(title: "Ik heb al een VOG — upload", icon: "arrow.up.doc.fill") {
                            // TODO[real-integration]: VOG tracking
                            vogSubmitted = true
                        }
                    }
                }
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.top, BCSpacing.lg)
            .padding(.bottom, BCSpacing.xl)
        }
    }

    // MARK: - Step 5: Bank account

    private var bankStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                Text("Bankrekening")
                    .font(BCTypography.title2)
                    .foregroundStyle(BCColors.textPrimary)
                Text("Uw verdiensten worden wekelijks uitbetaald op maandag. Geef hier uw IBAN op.")
                    .font(BCTypography.body)
                    .foregroundStyle(BCColors.textSecondary)

                FieldLabel("IBAN-nummer")
                TextField("NL00 BANK 0000 0000 00", text: $iban)
                    .styledTextField()
                    .textContentType(.none)
                    .autocorrectionDisabled()
                    .keyboardType(.asciiCapable)

                // TODO[real-integration]: SEPA mandate
                BCCard {
                    VStack(alignment: .leading, spacing: BCSpacing.xs) {
                        Label("Betaaltiming", systemImage: "clock.fill")
                            .font(BCTypography.captionEmphasized)
                            .foregroundStyle(BCColors.textSecondary)
                        Text("Uitbetalingen vinden elke maandag plaats voor de taken van de afgelopen week. Platform neemt \(Int(Config.platformCommissionPercent * 100))% commissie.")
                            .font(BCTypography.caption)
                            .foregroundStyle(BCColors.textTertiary)
                    }
                }
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.top, BCSpacing.lg)
            .padding(.bottom, BCSpacing.xl)
        }
    }

    // MARK: - Step 6: Availability

    private var availabilityStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                Text("Beschikbaarheid")
                    .font(BCTypography.title2)
                    .foregroundStyle(BCColors.textPrimary)
                Text("Op welke momenten ben je beschikbaar? Je kunt dit later altijd aanpassen.")
                    .font(BCTypography.body)
                    .foregroundStyle(BCColors.textSecondary)

                let days = ["Ma", "Di", "Wo", "Do", "Vr", "Za", "Zo"]
                let slots = ["Ochtend", "Middag", "Avond"]

                VStack(spacing: BCSpacing.sm) {
                    ForEach(days, id: \.self) { day in
                        BCCard {
                            HStack {
                                Text(day)
                                    .font(BCTypography.bodyEmphasized)
                                    .foregroundStyle(BCColors.textPrimary)
                                    .frame(width: 32, alignment: .leading)
                                Spacer()
                                HStack(spacing: BCSpacing.xs) {
                                    ForEach(slots, id: \.self) { slot in
                                        let isOn = availability[day]?.contains(slot) ?? false
                                        Button {
                                            var set = availability[day] ?? Set<String>()
                                            if isOn { set.remove(slot) } else { set.insert(slot) }
                                            availability[day] = set
                                        } label: {
                                            Text(slot)
                                                .font(BCTypography.captionEmphasized)
                                                .foregroundStyle(isOn ? .white : BCColors.textSecondary)
                                                .padding(.horizontal, BCSpacing.sm)
                                                .padding(.vertical, BCSpacing.xs)
                                                .background(
                                                    Capsule().fill(isOn ? BCColors.primary : BCColors.border)
                                                )
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.top, BCSpacing.lg)
            .padding(.bottom, BCSpacing.xl)
        }
    }

    // MARK: - Step 7: Agreement

    private var agreementStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                Text("Huisregels & privacyverklaring")
                    .font(BCTypography.title2)
                    .foregroundStyle(BCColors.textPrimary)

                BCCard {
                    // TODO[real-content]: Replace with actual house rules
                    VStack(alignment: .leading, spacing: BCSpacing.sm) {
                        RuleRow(number: "1", text: "Behandel elke oudere met respect en geduld.")
                        RuleRow(number: "2", text: "Wees altijd op tijd. Geef minimaal 2 uur van tevoren aan als je niet kunt.")
                        RuleRow(number: "3", text: "Voer alleen taken uit die overeenkomen met je niveau.")
                        RuleRow(number: "4", text: "Meld incidenten direct via de app.")
                        RuleRow(number: "5", text: "Neem nooit geld of waardevolle bezittingen van een cliënt aan.")
                    }
                }

                BCCard {
                    VStack(alignment: .leading, spacing: BCSpacing.xs) {
                        // COMPLIANCE: AVG art. 13 — privacy notice must be shown
                        Label("Privacyverklaring", systemImage: "lock.shield.fill")
                            .font(BCTypography.captionEmphasized)
                            .foregroundStyle(BCColors.textSecondary)
                        Text("Buddy Care verwerkt uw persoonsgegevens conform de AVG. Uw gegevens worden niet gedeeld met derden zonder uw toestemming.")
                            .font(BCTypography.caption)
                            .foregroundStyle(BCColors.textTertiary)
                    }
                }

                Button {
                    agreedToTerms.toggle()
                } label: {
                    HStack(spacing: BCSpacing.sm) {
                        Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(agreedToTerms ? BCColors.primary : BCColors.textTertiary)
                        Text("Ik ga akkoord met de huisregels en de privacyverklaring")
                            .font(BCTypography.body)
                            .foregroundStyle(BCColors.textPrimary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(BCSpacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                            .fill(BCColors.surface)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                            .stroke(agreedToTerms ? BCColors.primary : BCColors.border, lineWidth: agreedToTerms ? 2 : 1)
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Akkoord gaan met huisregels en privacyverklaring")
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.top, BCSpacing.lg)
            .padding(.bottom, BCSpacing.xl)
        }
    }

    // MARK: - Bottom bar

    private var bottomBar: some View {
        HStack(spacing: BCSpacing.sm) {
            if step > 0 {
                BCSecondaryButton(title: "Terug", icon: "chevron.left") {
                    step -= 1
                }
            }
            BCPrimaryButton(
                title: step == 7 ? "Maak account aan" : "Volgende",
                icon: step == 7 ? "checkmark" : "chevron.right"
            ) {
                if step == 7 {
                    showPending = true
                } else {
                    step += 1
                }
            }
            .opacity(canContinue ? 1.0 : 0.4)
            .disabled(!canContinue)
        }
        .padding(.horizontal, BCSpacing.lg)
        .padding(.vertical, BCSpacing.md)
    }

    private var canContinue: Bool {
        switch step {
        case 1: return !firstName.isEmpty && !lastName.isEmpty && !city.isEmpty
        case 5: return !iban.isEmpty
        case 7: return agreedToTerms
        default: return true
        }
    }
}

// MARK: - Verification Pending View

struct VerificationPendingView: View {
    let onComplete: () -> Void
    @State private var animating = false

    var body: some View {
        VStack(spacing: BCSpacing.xl) {
            Spacer()

            ZStack {
                Circle()
                    .stroke(BCColors.primary.opacity(0.15), lineWidth: 4)
                    .frame(width: 100, height: 100)
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(BCColors.primary, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(animating ? 360 : 0))
                    .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: animating)
                Image(systemName: "person.fill.checkmark")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(BCColors.primary)
            }
            .onAppear { animating = true }

            VStack(spacing: BCSpacing.sm) {
                Text("Aanvraag ingediend!")
                    .font(BCTypography.title2)
                    .foregroundStyle(BCColors.textPrimary)
                Text("Uw aanvraag wordt beoordeeld. Dit duurt maximaal 2 werkdagen.")
                    .font(BCTypography.body)
                    .foregroundStyle(BCColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, BCSpacing.lg)
            }

            BCCard {
                VStack(spacing: BCSpacing.sm) {
                    Label("Vragen?", systemImage: "phone.fill")
                        .font(BCTypography.captionEmphasized)
                        .foregroundStyle(BCColors.textSecondary)
                    Text("Bel ons op \(Config.supportPhoneNumber) of mail naar \(Config.supportEmail)")
                        .font(BCTypography.caption)
                        .foregroundStyle(BCColors.textTertiary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, BCSpacing.lg)

            Spacer()

            BCPrimaryButton(title: "Ga door (prototype)", icon: "arrow.right") {
                onComplete()
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.bottom, BCSpacing.xl)
        }
        .background(BCColors.background.ignoresSafeArea())
    }
}

// MARK: - Local helpers

private struct OnboardingFeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let detail: String

    var body: some View {
        HStack(spacing: BCSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 44, height: 44)
                .background(Circle().fill(color.opacity(0.12)))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(BCTypography.bodyEmphasized).foregroundStyle(BCColors.textPrimary)
                Text(detail).font(BCTypography.caption).foregroundStyle(BCColors.textSecondary)
            }
            Spacer()
        }
    }
}

private struct IDUploadBox: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: BCSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(BCColors.primary)
                .frame(width: 56, height: 56)
                .background(RoundedRectangle(cornerRadius: BCRadius.md).fill(BCColors.primaryMuted))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(BCTypography.bodyEmphasized).foregroundStyle(BCColors.textPrimary)
                Text(subtitle).font(BCTypography.caption).foregroundStyle(BCColors.textSecondary)
            }
            Spacer()
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 22))
                .foregroundStyle(BCColors.primary)
        }
        .padding(BCSpacing.md)
        .background(RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous).fill(BCColors.surface))
        .overlay(RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous).stroke(BCColors.border, lineWidth: 1))
    }
}

private struct RuleRow: View {
    let number: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: BCSpacing.sm) {
            Text(number)
                .font(BCTypography.captionEmphasized)
                .foregroundStyle(.white)
                .frame(width: 22, height: 22)
                .background(Circle().fill(BCColors.primary))
            Text(text)
                .font(BCTypography.body)
                .foregroundStyle(BCColors.textPrimary)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}

private struct FieldLabel: View {
    let text: String
    init(_ text: String) { self.text = text }

    var body: some View {
        Text(text)
            .font(BCTypography.captionEmphasized)
            .foregroundStyle(BCColors.textSecondary)
    }
}

// MARK: - TextField style extension

private extension View {
    func styledTextField() -> some View {
        self
            .font(BCTypography.body)
            .padding(BCSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: BCRadius.md, style: .continuous)
                    .fill(BCColors.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: BCRadius.md, style: .continuous)
                    .stroke(BCColors.border, lineWidth: 1)
            )
    }
}

#Preview {
    BuddyOnboardingFlow().environment(AppState())
}
