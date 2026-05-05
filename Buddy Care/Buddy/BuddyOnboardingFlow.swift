import SwiftUI

struct BuddyOnboardingFlow: View {
    @Environment(AppState.self) private var appState
    @State private var step: Int = 0

    // Step 1 — account
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""

    // Step 2 — profile
    @State private var bio: String = ""
    @State private var postcode: String = ""
    @State private var photoConfirmed: Bool = false
    @State private var locationGranted: Bool = false

    // Step 3 — ID
    @State private var idSubmitted: Bool = false

    // Step 4 — VOG
    @State private var vogSubmitted: Bool = false

    // Step 5 — ZZP
    @State private var isZzper: Bool? = nil
    @State private var kvkNumber: String = ""
    @State private var btwNumber: String = ""

    // Step 6 — payment
    @State private var iban: String = ""
    @State private var ibanHolderName: String = ""

    // Step 7 — insurance
    @State private var hasInsurance: Bool? = nil

    // Step 8 — availability
    @State private var availability: [String: Set<String>] = [:]
    @State private var maxDistanceKm: Int = 10

    // Step 9 — services
    @State private var selectedServices: Set<String> = []

    // Step 10 — rate
    @State private var hourlyRateCents: Int = 1500

    // Step 11 — contract
    @State private var agreedToHouseRules: Bool = false
    @State private var agreedToZzpContract: Bool = false

    private let totalSteps = 14

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                stepProgressBar

                Group {
                    switch step {
                    case 0:  introStep
                    case 1:  accountStep
                    case 2:  profileStep
                    case 3:  idStep
                    case 4:  vogStep
                    case 5:  zzpStep
                    case 6:  bankStep
                    case 7:  insuranceStep
                    case 8:  availabilityStep
                    case 9:  servicesStep
                    case 10: rateStep
                    case 11: contractStep
                    case 12: reviewStep
                    case 13: activationStep
                    default: EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                if step < 13 {
                    VStack(spacing: 0) {
                        Divider()
                        BCOnboardingPhoneFooter()
                            .padding(.horizontal, BCSpacing.lg)
                        bottomBar
                    }
                }
            }
            .background(BCColors.background.ignoresSafeArea())
            .navigationTitle("Aanmelden als buddy")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Progress bar

    private var stepProgressBar: some View {
        HStack(spacing: 3) {
            ForEach(0..<totalSteps, id: \.self) { i in
                Capsule()
                    .fill(i <= step ? BCColors.primary : BCColors.border)
                    .frame(height: 4)
            }
        }
        .padding(.horizontal, BCSpacing.lg)
        .padding(.top, BCSpacing.sm)
    }

    // MARK: - Step 0: Intro

    private var introStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.lg) {
                VStack(alignment: .leading, spacing: BCSpacing.sm) {
                    Text("Welkom bij Buddy Care")
                        .font(BCTypography.title)
                        .foregroundStyle(BCColors.textPrimary)
                    Text("Verdien geld met zorgtaken bij jou in de buurt — op jouw momenten, als zelfstandige.")
                        .font(BCTypography.body)
                        .foregroundStyle(BCColors.textSecondary)
                }

                VStack(spacing: BCSpacing.sm) {
                    OnboardingFeatureRow(
                        icon: "clock.badge.checkmark.fill", color: BCColors.primary,
                        title: "Werk flexibel als Buddy",
                        detail: "Jij kiest wanneer en hoeveel je werkt"
                    )
                    OnboardingFeatureRow(
                        icon: "eurosign.circle.fill", color: BCColors.success,
                        title: "Verdien geld op jouw momenten",
                        detail: "€13–25 per uur, wekelijks uitbetaald"
                    )
                    OnboardingFeatureRow(
                        icon: "building.2.fill", color: BCColors.accent,
                        title: "Je werkt als zelfstandige (zzp'er)",
                        detail: "Geen loondienst — jij bent de baas"
                    )
                    OnboardingFeatureRow(
                        icon: "graduationcap.fill", color: BCColors.primary,
                        title: "Bouw certificaten op",
                        detail: "Erkende e-learning modules per niveau"
                    )
                }

                BCCard {
                    VStack(alignment: .leading, spacing: BCSpacing.xs) {
                        Label("Juridisch", systemImage: "exclamationmark.triangle.fill")
                            .font(BCTypography.captionEmphasized)
                            .foregroundStyle(BCColors.warning)
                        Text("Voorbehouden handelingen (Wet BIG art. 36) zoals injecteren mogen nooit worden uitgevoerd door niet-BIG-geregistreerde personen. Buddy Care biedt deze taken niet aan.")
                            .font(BCTypography.caption)
                            .foregroundStyle(BCColors.textSecondary)
                    }
                }

                BCCard {
                    HStack(spacing: BCSpacing.sm) {
                        Image(systemName: "timer")
                            .foregroundStyle(BCColors.primary)
                        Text("De aanmelding duurt ca. 8 minuten. Houd je ID-bewijs en IBAN bij de hand.")
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

    // MARK: - Step 1: Account

    private var accountStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                StepHeader(title: "Account aanmaken", subtitle: "Dit wordt jouw inlogaccount bij Buddy Care.")

                VStack(alignment: .leading, spacing: BCSpacing.sm) {
                    FieldLabel("Voornaam")
                    TextField("Voornaam", text: $firstName)
                        .styledTextField()
                        .textContentType(.givenName)

                    FieldLabel("Achternaam")
                    TextField("Achternaam", text: $lastName)
                        .styledTextField()
                        .textContentType(.familyName)

                    FieldLabel("E-mailadres")
                    TextField("jij@email.nl", text: $email)
                        .styledTextField()
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    FieldLabel("Telefoonnummer")
                    TextField("+31 6 12345678", text: $phone)
                        .styledTextField()
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }

                BCCard {
                    HStack(spacing: BCSpacing.sm) {
                        Image(systemName: "message.fill")
                            .foregroundStyle(BCColors.primary)
                        Text("Je ontvangt een SMS-code ter verificatie na het aanmelden.")
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

    // MARK: - Step 2: Profile

    private var profileStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                StepHeader(title: "Basis profiel", subtitle: "Zo zien ouderen jou in de app.")

                // Photo row
                HStack(spacing: BCSpacing.md) {
                    ZStack {
                        Circle()
                            .fill(BCColors.primaryMuted)
                            .frame(width: 72, height: 72)
                        if photoConfirmed {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(BCColors.primary)
                        } else {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 26))
                                .foregroundStyle(BCColors.primary)
                        }
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(photoConfirmed ? "Foto geselecteerd" : "Profielfoto")
                            .font(BCTypography.bodyEmphasized)
                            .foregroundStyle(BCColors.textPrimary)
                        Button(photoConfirmed ? "Andere foto kiezen" : "Kies foto uit bibliotheek") {
                            photoConfirmed = true
                        }
                        .font(BCTypography.caption)
                        .foregroundStyle(BCColors.primary)
                    }
                    Spacer()
                    if photoConfirmed {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(BCColors.success)
                    }
                }
                .padding(BCSpacing.md)
                .background(RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous).fill(BCColors.surface))
                .overlay(RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous).stroke(BCColors.border, lineWidth: 1))

                // Bio
                VStack(alignment: .leading, spacing: 4) {
                    FieldLabel("Korte bio")
                    TextField("Wie ben je en waarom wil je buddy worden?", text: $bio, axis: .vertical)
                        .lineLimit(4, reservesSpace: true)
                        .styledTextField()
                }

                // Location
                VStack(alignment: .leading, spacing: BCSpacing.xs) {
                    FieldLabel("Locatie")
                    HStack(spacing: BCSpacing.sm) {
                        TextField("Postcode (bijv. 3012 AB)", text: $postcode)
                            .styledTextField()
                            .keyboardType(.default)
                            .frame(maxWidth: .infinity)
                        Text("of")
                            .font(BCTypography.caption)
                            .foregroundStyle(BCColors.textTertiary)
                        Button {
                            locationGranted = true
                            if postcode.isEmpty { postcode = "GPS ✓" }
                        } label: {
                            Label("GPS", systemImage: "location.fill")
                                .font(BCTypography.captionEmphasized)
                                .foregroundStyle(locationGranted ? .white : BCColors.primary)
                                .padding(.horizontal, BCSpacing.md)
                                .padding(.vertical, 12)
                                .background(Capsule().fill(locationGranted ? BCColors.primary : BCColors.primaryMuted))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.top, BCSpacing.lg)
            .padding(.bottom, BCSpacing.xl)
        }
    }

    // MARK: - Step 3: ID verification

    private var idStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                StepHeader(title: "Identiteitsverificatie", subtitle: "Wij verifiëren je identiteit om de veiligheid van ouderen te garanderen.")

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
                        IDUploadBox(
                            icon: "rectangle.and.hand.point.up.left.fill",
                            title: "Identiteitsbewijs",
                            subtitle: "Paspoort, ID-kaart of rijbewijs"
                        )
                        IDUploadBox(
                            icon: "person.fill.viewfinder",
                            title: "Selfie",
                            subtitle: "Maak een selfie om je identiteit te bevestigen"
                        )
                    }

                    BCPrimaryButton(title: "Upload en verifieer", icon: "arrow.up.doc.fill") {
                        idSubmitted = true
                    }

                    Text("Je identiteitsgegevens worden verwerkt conform de AVG.")
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
                StepHeader(title: "Verklaring Omtrent Gedrag", subtitle: "Een VOG is verplicht voor alle buddies. Gratis aanvraagbaar via Justis voor vrijwilligers.")

                BCCard {
                    VStack(alignment: .leading, spacing: BCSpacing.xs) {
                        Label("Heb je al een VOG?", systemImage: "doc.badge.checkmark")
                            .font(BCTypography.captionEmphasized)
                            .foregroundStyle(BCColors.textSecondary)
                        Text("Een VOG mag niet ouder zijn dan 3 jaar. Heb je er nog geen, vraag hem dan aan via Justis — dit duurt doorgaans 3–5 werkdagen.")
                            .font(BCTypography.caption)
                            .foregroundStyle(BCColors.textTertiary)
                    }
                }

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
                    VStack(spacing: BCSpacing.sm) {
                        BCSecondaryButton(title: "Aanvragen via Justis", icon: "arrow.up.right.square") { }
                        BCPrimaryButton(title: "Ik heb al een VOG — upload", icon: "arrow.up.doc.fill") {
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

    // MARK: - Step 5: ZZP verification

    private var zzpStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                StepHeader(
                    title: "ZZP-verificatie",
                    subtitle: "Om via Buddy Care te werken, moet je als zzp'er ingeschreven staan bij de Kamer van Koophandel."
                )

                HStack(spacing: BCSpacing.sm) {
                    ChoiceButton(
                        label: "Ja, ik ben zzp'er",
                        icon: "checkmark.circle.fill",
                        selected: isZzper == true
                    ) { isZzper = true }

                    ChoiceButton(
                        label: "Nee, nog niet",
                        icon: "xmark.circle.fill",
                        selected: isZzper == false
                    ) { isZzper = false }
                }

                if isZzper == true {
                    VStack(alignment: .leading, spacing: BCSpacing.sm) {
                        FieldLabel("KvK-nummer")
                        TextField("12345678", text: $kvkNumber)
                            .styledTextField()
                            .keyboardType(.numberPad)

                        FieldLabel("BTW-nummer (optioneel)")
                        TextField("NL000000000B01", text: $btwNumber)
                            .styledTextField()
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.characters)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

                if isZzper == false {
                    BCCard {
                        VStack(alignment: .leading, spacing: BCSpacing.sm) {
                            Label("Hoe word je zzp'er?", systemImage: "building.2.fill")
                                .font(BCTypography.headline)
                                .foregroundStyle(BCColors.textPrimary)
                            Text("Inschrijven bij de KvK kost ca. 10 minuten en €75,–. Na inschrijving kun je direct via Buddy Care aan de slag.")
                                .font(BCTypography.body)
                                .foregroundStyle(BCColors.textSecondary)
                            BCPrimaryButton(title: "Word zzp'er via KvK", icon: "arrow.up.right.square") { }
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))

                    BCCard {
                        HStack(spacing: BCSpacing.sm) {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(BCColors.primary)
                            Text("Je kunt alvast doorgaan. Voeg je KvK-nummer toe zodra je bent ingeschreven — je profiel wordt dan pas geactiveerd.")
                                .font(BCTypography.caption)
                                .foregroundStyle(BCColors.textSecondary)
                        }
                    }
                    .transition(.opacity)
                }
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.top, BCSpacing.lg)
            .padding(.bottom, BCSpacing.xl)
            .animation(.easeInOut(duration: 0.2), value: isZzper)
        }
    }

    // MARK: - Step 6: Bank

    private var bankStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                StepHeader(title: "Betalingen instellen", subtitle: "Je verdiensten worden wekelijks op maandag uitbetaald op je bankrekening.")

                VStack(alignment: .leading, spacing: BCSpacing.sm) {
                    FieldLabel("IBAN-nummer")
                    TextField("NL00 BANK 0000 0000 00", text: $iban)
                        .styledTextField()
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .keyboardType(.asciiCapable)

                    FieldLabel("Naam rekeninghouder")
                    TextField("Zoals op je bankpas", text: $ibanHolderName)
                        .styledTextField()
                        .textContentType(.name)
                }

                BCCard {
                    VStack(alignment: .leading, spacing: BCSpacing.xs) {
                        Label("Betaaltiming", systemImage: "clock.fill")
                            .font(BCTypography.captionEmphasized)
                            .foregroundStyle(BCColors.textSecondary)
                        Text("Uitbetalingen vinden elke maandag plaats voor de taken van de afgelopen week. Het platform neemt \(Int(Config.platformCommissionPercent * 100))% commissie.")
                            .font(BCTypography.caption)
                            .foregroundStyle(BCColors.textTertiary)
                    }
                }

                BCCard {
                    HStack(spacing: BCSpacing.sm) {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(BCColors.success)
                        Text("Je IBAN wordt beveiligd opgeslagen en nooit gedeeld met derden.")
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

    // MARK: - Step 7: Insurance

    private var insuranceStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                StepHeader(
                    title: "Aansprakelijkheidsverzekering",
                    subtitle: "Als zzp'er ben je zelf verantwoordelijk voor een beroepsaansprakelijkheidsverzekering."
                )

                HStack(spacing: BCSpacing.sm) {
                    ChoiceButton(
                        label: "Ja, ik ben verzekerd",
                        icon: "checkmark.shield.fill",
                        selected: hasInsurance == true
                    ) { hasInsurance = true }

                    ChoiceButton(
                        label: "Nee, nog niet",
                        icon: "xmark.circle.fill",
                        selected: hasInsurance == false
                    ) { hasInsurance = false }
                }

                if hasInsurance == true {
                    BCCard {
                        HStack(spacing: BCSpacing.sm) {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(BCColors.success)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Goed geregeld ✓")
                                    .font(BCTypography.bodyEmphasized)
                                    .foregroundStyle(BCColors.success)
                                Text("Je bent gedekt voor eventuele claims tijdens je taken.")
                                    .font(BCTypography.caption)
                                    .foregroundStyle(BCColors.textSecondary)
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

                if hasInsurance == false {
                    BCCard {
                        VStack(alignment: .leading, spacing: BCSpacing.sm) {
                            Label("Nog geen verzekering?", systemImage: "exclamationmark.shield.fill")
                                .font(BCTypography.headline)
                                .foregroundStyle(BCColors.warning)
                            Text("Wij werken aan een collectieve verzekering voor buddies. Zodra dit beschikbaar is, word je hierover geïnformeerd.")
                                .font(BCTypography.body)
                                .foregroundStyle(BCColors.textSecondary)
                            Text("Je kunt alvast doorgaan met aanmelden.")
                                .font(BCTypography.caption)
                                .foregroundStyle(BCColors.textTertiary)
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.top, BCSpacing.lg)
            .padding(.bottom, BCSpacing.xl)
            .animation(.easeInOut(duration: 0.2), value: hasInsurance)
        }
    }

    // MARK: - Step 8: Availability

    private let days = ["Ma", "Di", "Wo", "Do", "Vr", "Za", "Zo"]
    private let slots = ["Ochtend", "Middag", "Avond"]

    private var availabilityStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                StepHeader(title: "Beschikbaarheid", subtitle: "Jij bepaalt wanneer je werkt. Je kunt dit altijd aanpassen in je profiel.")

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
                                                .background(Capsule().fill(isOn ? BCColors.primary : BCColors.border))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                    }
                }

                // Max distance slider
                VStack(alignment: .leading, spacing: BCSpacing.sm) {
                    HStack {
                        Text("Maximale reisafstand")
                            .font(BCTypography.bodyEmphasized)
                            .foregroundStyle(BCColors.textPrimary)
                        Spacer()
                        Text("\(maxDistanceKm) km")
                            .font(BCTypography.bodyEmphasized)
                            .foregroundStyle(BCColors.primary)
                            .monospacedDigit()
                    }
                    Slider(
                        value: Binding(get: { Double(maxDistanceKm) }, set: { maxDistanceKm = Int($0) }),
                        in: 1...50, step: 1
                    )
                    .tint(BCColors.primary)
                    HStack {
                        Text("1 km")
                        Spacer()
                        Text("50 km")
                    }
                    .font(BCTypography.caption)
                    .foregroundStyle(BCColors.textTertiary)
                }
                .padding(BCSpacing.md)
                .background(RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous).fill(BCColors.surface))
                .overlay(RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous).stroke(BCColors.border, lineWidth: 1))
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.top, BCSpacing.lg)
            .padding(.bottom, BCSpacing.xl)
        }
    }

    // MARK: - Step 9: Services

    private let serviceOptions: [(icon: String, name: String, subtitle: String, level: String)] = [
        ("figure.walk",     "Wandelen",          "Begeleiding buiten",              "Niveau 0"),
        ("person.2.fill",   "Gezelschap",        "Gesprek en aanwezigheid",         "Niveau 0"),
        ("cart.fill",       "Boodschappen",      "Inkopen doen of begeleiden",      "Niveau 0"),
        ("fork.knife",      "Maaltijdbereiding", "Eenvoudige maaltijden klaarmaken","Niveau 0"),
        ("sparkles",        "Lichte huishouding","Opruimen en schoonmaken",         "Niveau 0"),
        ("pills.fill",      "Medicijnen",        "Herinneringen en toediening",     "Niveau 2+"),
    ]

    private var servicesStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                StepHeader(title: "Diensten", subtitle: "Kies de taken die je wilt uitvoeren. Dit bepaalt met welke ouderen je gematcht wordt.")

                VStack(spacing: BCSpacing.sm) {
                    ForEach(serviceOptions, id: \.name) { opt in
                        let selected = selectedServices.contains(opt.name)
                        Button {
                            if selected { selectedServices.remove(opt.name) }
                            else { selectedServices.insert(opt.name) }
                        } label: {
                            HStack(spacing: BCSpacing.md) {
                                Image(systemName: opt.icon)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(selected ? .white : BCColors.primary)
                                    .frame(width: 44, height: 44)
                                    .background(Circle().fill(selected ? BCColors.primary : BCColors.primaryMuted))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(opt.name)
                                        .font(BCTypography.bodyEmphasized)
                                        .foregroundStyle(BCColors.textPrimary)
                                    Text(opt.subtitle)
                                        .font(BCTypography.caption)
                                        .foregroundStyle(BCColors.textSecondary)
                                }

                                Spacer()

                                BCStatusPill(label: opt.level, color: selected ? BCColors.primary : BCColors.textTertiary)

                                if selected {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(BCColors.primary)
                                }
                            }
                            .padding(BCSpacing.md)
                            .background(RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous).fill(BCColors.surface))
                            .overlay(
                                RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                                    .stroke(selected ? BCColors.primary : BCColors.border, lineWidth: selected ? 1.5 : 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.top, BCSpacing.lg)
            .padding(.bottom, BCSpacing.xl)
        }
    }

    // MARK: - Step 10: Rate

    private var hourlyRateEuro: Double { Double(hourlyRateCents) / 100 }
    private var netRateEuro: Double { hourlyRateEuro * (1 - Config.platformCommissionPercent) }

    private var rateStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                StepHeader(title: "Jouw uurtarief", subtitle: "Jij bepaalt zelf wat je vraagt. Dit is een juridisch kenmerk van zelfstandig werken.")

                // Rate display card
                ZStack {
                    RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                        .fill(LinearGradient(
                            colors: [BCColors.primary, BCColors.primary.opacity(0.75)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                    VStack(spacing: BCSpacing.xs) {
                        Text("Jouw tarief")
                            .font(BCTypography.caption)
                            .foregroundStyle(.white.opacity(0.7))
                        Text(String(format: "€ %.2f / uur", hourlyRateEuro).replacingOccurrences(of: ".", with: ","))
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text(String(format: "Netto ca. € %.2f / uur na commissie", netRateEuro).replacingOccurrences(of: ".", with: ","))
                            .font(BCTypography.caption)
                            .foregroundStyle(.white.opacity(0.75))
                    }
                    .padding(BCSpacing.lg)
                }
                .frame(maxWidth: .infinity)

                // Stepper
                Stepper(
                    value: $hourlyRateCents,
                    in: 1300...3500,
                    step: 50
                ) {
                    HStack {
                        Text("Aanpassen")
                            .font(BCTypography.bodyEmphasized)
                            .foregroundStyle(BCColors.textPrimary)
                        Spacer()
                        Text(String(format: "€ %.2f / uur", hourlyRateEuro).replacingOccurrences(of: ".", with: ","))
                            .font(BCTypography.bodyEmphasized)
                            .foregroundStyle(BCColors.primary)
                            .monospacedDigit()
                    }
                }
                .padding(BCSpacing.md)
                .background(RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous).fill(BCColors.surface))
                .overlay(RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous).stroke(BCColors.border, lineWidth: 1))

                BCCard {
                    VStack(alignment: .leading, spacing: BCSpacing.xs) {
                        Label("Waarom jij het tarief bepaalt", systemImage: "info.circle.fill")
                            .font(BCTypography.captionEmphasized)
                            .foregroundStyle(BCColors.primary)
                        Text("Als zzp'er stel jij je eigen tarief vast. Dit is een juridisch kenmerk van zelfstandig werken en geen loondienst. Buddy Care rekent \(Int(Config.platformCommissionPercent * 100))% als platformkosten.")
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

    // MARK: - Step 11: Contract

    private var contractStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                StepHeader(title: "Akkoord gaan", subtitle: "Lees de huisregels en het zzp-contract door en bevestig je akkoord.")

                BCCard {
                    VStack(alignment: .leading, spacing: BCSpacing.sm) {
                        Text("Huisregels")
                            .font(BCTypography.headline)
                            .foregroundStyle(BCColors.textPrimary)
                        RuleRow(number: "1", text: "Behandel elke oudere met respect en geduld.")
                        RuleRow(number: "2", text: "Wees altijd op tijd. Geef minimaal 2 uur van tevoren aan als je niet kunt.")
                        RuleRow(number: "3", text: "Voer alleen taken uit die overeenkomen met je niveau.")
                        RuleRow(number: "4", text: "Meld incidenten direct via de app.")
                        RuleRow(number: "5", text: "Neem nooit geld of waardevolle bezittingen van een cliënt aan.")
                    }
                }

                BCCard {
                    VStack(alignment: .leading, spacing: BCSpacing.sm) {
                        Label("ZZP-overeenkomst", systemImage: "doc.text.fill")
                            .font(BCTypography.headline)
                            .foregroundStyle(BCColors.textPrimary)
                        Text("Je werkt als zelfstandige ondernemer (zzp'er) via het Buddy Care platform. Er is geen sprake van een arbeidsovereenkomst of dienstverband. Je bent zelf verantwoordelijk voor je belastingaangifte, verzekeringen en andere verplichtingen als zelfstandige.")
                            .font(BCTypography.caption)
                            .foregroundStyle(BCColors.textSecondary)
                    }
                }

                AgreementCheckbox(
                    text: "Ik ga akkoord met de huisregels en de privacyverklaring",
                    checked: $agreedToHouseRules
                )
                AgreementCheckbox(
                    text: "Ik bevestig dat ik als zelfstandige (zzp'er) werk via dit platform — geen loondienst",
                    checked: $agreedToZzpContract
                )

                BCCard {
                    VStack(alignment: .leading, spacing: BCSpacing.xs) {
                        Label("Privacyverklaring", systemImage: "lock.shield.fill")
                            .font(BCTypography.captionEmphasized)
                            .foregroundStyle(BCColors.textSecondary)
                        Text("Buddy Care verwerkt je persoonsgegevens conform de AVG. Je gegevens worden niet gedeeld met derden zonder jouw toestemming.")
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

    // MARK: - Step 12: Review

    private var reviewStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                StepHeader(title: "Overzicht aanvraag", subtitle: "Controleer je gegevens voordat je de aanvraag indient.")

                VStack(spacing: BCSpacing.sm) {
                    ReviewCheckRow(
                        icon: "person.text.rectangle.fill",
                        label: "Identiteitsverificatie",
                        status: idSubmitted ? .done : .pending
                    )
                    ReviewCheckRow(
                        icon: "checkmark.shield.fill",
                        label: "Verklaring Omtrent Gedrag (VOG)",
                        status: vogSubmitted ? .done : .pending
                    )
                    ReviewCheckRow(
                        icon: "building.2.fill",
                        label: "ZZP / KvK-verificatie",
                        status: isZzper == true && !kvkNumber.isEmpty ? .done : isZzper == false ? .later : .pending
                    )
                    ReviewCheckRow(
                        icon: "creditcard.fill",
                        label: "Bankrekening",
                        status: !iban.isEmpty ? .done : .pending
                    )
                    ReviewCheckRow(
                        icon: "checkmark.square.fill",
                        label: "Contract & huisregels",
                        status: agreedToHouseRules && agreedToZzpContract ? .done : .pending
                    )
                }

                BCCard {
                    HStack(spacing: BCSpacing.sm) {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(BCColors.primary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Verwachte doorlooptijd")
                                .font(BCTypography.captionEmphasized)
                                .foregroundStyle(BCColors.textSecondary)
                            Text("Je aanvraag wordt binnen 2 werkdagen beoordeeld. Je ontvangt een melding zodra je profiel is geactiveerd.")
                                .font(BCTypography.caption)
                                .foregroundStyle(BCColors.textTertiary)
                        }
                    }
                }
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.top, BCSpacing.lg)
            .padding(.bottom, BCSpacing.xl)
        }
    }

    // MARK: - Step 13: Activation

    private var activationStep: some View {
        VStack(spacing: BCSpacing.xl) {
            Spacer()

            ZStack {
                Circle()
                    .fill(BCColors.success.opacity(0.12))
                    .frame(width: 120, height: 120)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(BCColors.success)
            }

            VStack(spacing: BCSpacing.sm) {
                Text("Je bent live! 🎉")
                    .font(BCTypography.title)
                    .foregroundStyle(BCColors.textPrimary)
                Text("Je aanvraag is ingediend en wordt beoordeeld. Zodra je profiel is goedgekeurd, kun je direct taken aannemen.")
                    .font(BCTypography.body)
                    .foregroundStyle(BCColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, BCSpacing.lg)
            }

            VStack(spacing: BCSpacing.sm) {
                BCCard {
                    HStack(spacing: BCSpacing.sm) {
                        Image(systemName: "bell.fill")
                            .foregroundStyle(BCColors.primary)
                        Text("Je ontvangt een pushmelding zodra je account is geactiveerd.")
                            .font(BCTypography.caption)
                            .foregroundStyle(BCColors.textSecondary)
                    }
                }
                .padding(.horizontal, BCSpacing.lg)

                BCCard {
                    HStack(spacing: BCSpacing.sm) {
                        Image(systemName: "phone.fill")
                            .foregroundStyle(BCColors.textSecondary)
                        Text("Vragen? Bel \(Config.supportPhoneNumber) of mail \(Config.supportEmail)")
                            .font(BCTypography.caption)
                            .foregroundStyle(BCColors.textSecondary)
                    }
                }
                .padding(.horizontal, BCSpacing.lg)
            }

            Spacer()

            BCPrimaryButton(title: "Ga aan de slag (prototype)", icon: "arrow.right") {
                appState.isOnboardingComplete = true
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.bottom, BCSpacing.xl)
        }
        .background(BCColors.background.ignoresSafeArea())
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
                title: step == 12 ? "Aanvraag indienen" : "Volgende",
                icon: step == 12 ? "checkmark" : "chevron.right"
            ) {
                step += 1
            }
            .opacity(canContinue ? 1.0 : 0.4)
            .disabled(!canContinue)
        }
        .padding(.horizontal, BCSpacing.lg)
        .padding(.vertical, BCSpacing.md)
    }

    private var canContinue: Bool {
        switch step {
        case 1:  return !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !phone.isEmpty
        case 2:  return !postcode.isEmpty || locationGranted
        case 5:  return isZzper != nil && (isZzper == false || !kvkNumber.isEmpty)
        case 6:  return !iban.isEmpty && !ibanHolderName.isEmpty
        case 7:  return hasInsurance != nil
        case 9:  return !selectedServices.isEmpty
        case 11: return agreedToHouseRules && agreedToZzpContract
        default: return true
        }
    }
}

// MARK: - Review status

private enum ReviewStatus { case done, pending, later }

// MARK: - Shared sub-views

private struct StepHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: BCSpacing.xs) {
            Text(title)
                .font(BCTypography.title2)
                .foregroundStyle(BCColors.textPrimary)
            Text(subtitle)
                .font(BCTypography.body)
                .foregroundStyle(BCColors.textSecondary)
        }
    }
}

private struct ChoiceButton: View {
    let label: String
    let icon: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: BCSpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(selected ? .white : BCColors.primary)
                Text(label)
                    .font(BCTypography.bodyEmphasized)
                    .foregroundStyle(selected ? .white : BCColors.textPrimary)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, minHeight: 56)
            .padding(.horizontal, BCSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                    .fill(selected ? BCColors.primary : BCColors.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                    .stroke(selected ? BCColors.primary : BCColors.border, lineWidth: selected ? 0 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct AgreementCheckbox: View {
    let text: String
    @Binding var checked: Bool

    var body: some View {
        Button { checked.toggle() } label: {
            HStack(alignment: .top, spacing: BCSpacing.sm) {
                Image(systemName: checked ? "checkmark.square.fill" : "square")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(checked ? BCColors.primary : BCColors.textTertiary)
                Text(text)
                    .font(BCTypography.body)
                    .foregroundStyle(BCColors.textPrimary)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(BCSpacing.md)
            .background(RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous).fill(BCColors.surface))
            .overlay(
                RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                    .stroke(checked ? BCColors.primary : BCColors.border, lineWidth: checked ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct ReviewCheckRow: View {
    let icon: String
    let label: String
    let status: ReviewStatus

    private var statusColor: Color {
        switch status {
        case .done:    return BCColors.success
        case .pending: return BCColors.warning
        case .later:   return BCColors.textTertiary
        }
    }

    var body: some View {
        HStack(spacing: BCSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(statusColor)
                .frame(width: 44, height: 44)
                .background(Circle().fill(statusColor.opacity(0.12)))

            Text(label)
                .font(BCTypography.body)
                .foregroundStyle(BCColors.textPrimary)

            Spacer()

            switch status {
            case .done:
                BCStatusPill(label: "Klaar ✓", color: BCColors.success)
            case .pending:
                BCStatusPill(label: "In behandeling", color: BCColors.warning)
            case .later:
                BCStatusPill(label: "Later toevoegen", color: BCColors.textTertiary)
            }
        }
        .padding(BCSpacing.md)
        .background(RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous).fill(BCColors.surface))
        .overlay(RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous).stroke(BCColors.border, lineWidth: 1))
    }
}

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

private extension View {
    func styledTextField() -> some View {
        self
            .font(BCTypography.body)
            .padding(BCSpacing.md)
            .background(RoundedRectangle(cornerRadius: BCRadius.md, style: .continuous).fill(BCColors.surface))
            .overlay(RoundedRectangle(cornerRadius: BCRadius.md, style: .continuous).stroke(BCColors.border, lineWidth: 1))
    }
}

#Preview {
    BuddyOnboardingFlow().environment(AppState())
}
