import SwiftUI

struct RequestHelpFlow: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var step: Int = 0
    @State private var selectedCategory: TaskCategory? = nil
    @State private var selectedTiming: TaskTiming? = nil
    @State private var note: String = ""
    @State private var showingConfirmation = false
    @State private var customDate: Date = Date().addingTimeInterval(3600)
    @State private var useCustomDate: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                progressBar
                    .padding(.horizontal, BCSpacing.lg)
                    .padding(.top, BCSpacing.md)

                Group {
                    switch step {
                    case 0: categoryStep
                    case 1: timingStep
                    case 2: confirmStep
                    default: EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                bottomBar
            }
            .background(BCColors.background.ignoresSafeArea())
            .navigationTitle("Hulp vragen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Annuleer") { dismiss() }
                        .tint(BCColors.primary)
                }
            }
        }
    }

    private var progressBar: some View {
        HStack(spacing: BCSpacing.xs) {
            ForEach(0..<3) { i in
                Capsule()
                    .fill(i <= step ? BCColors.primary : BCColors.border)
                    .frame(height: 6)
            }
        }
    }

    // STEP 0 — categorie
    private var categoryStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                Text("Waar heeft u hulp bij nodig?")
                    .font(BCTypography.elderlyHeading)
                    .foregroundStyle(BCColors.textPrimary)
                    .padding(.horizontal, BCSpacing.lg)
                    .padding(.top, BCSpacing.md)

                LazyVGrid(columns: [GridItem(.flexible(), spacing: BCSpacing.sm), GridItem(.flexible(), spacing: BCSpacing.sm)], spacing: BCSpacing.sm) {
                    ForEach(TaskCategory.allCases) { category in
                        CategoryTile(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal, BCSpacing.lg)

                if let cat = selectedCategory {
                    BCCard {
                        VStack(alignment: .leading, spacing: BCSpacing.xs) {
                            HStack {
                                Text(cat.displayName)
                                    .font(BCTypography.headline)
                                    .foregroundStyle(BCColors.textPrimary)
                                Spacer()
                                BCLevelBadge(level: cat.minimumLevel)
                            }
                            Text(cat.description)
                                .font(BCTypography.body)
                                .foregroundStyle(BCColors.textSecondary)
                        }
                    }
                    .padding(.horizontal, BCSpacing.lg)
                }
            }
            .padding(.bottom, BCSpacing.lg)
        }
    }

    // STEP 1 — tijd
    private var timingStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                Text("Wanneer wilt u hulp?")
                    .font(BCTypography.elderlyHeading)
                    .foregroundStyle(BCColors.textPrimary)
                    .padding(.horizontal, BCSpacing.lg)
                    .padding(.top, BCSpacing.md)

                VStack(spacing: BCSpacing.sm) {
                    TimingTile(
                        title: "Zo snel mogelijk",
                        subtitle: "Een buddy in de buurt komt eraan",
                        icon: "bolt.fill",
                        isSelected: selectedTiming == .now && !useCustomDate
                    ) {
                        useCustomDate = false
                        selectedTiming = .now
                    }
                    TimingTile(
                        title: "Vandaag om 16:00",
                        subtitle: "Plan vandaag in",
                        icon: "clock.fill",
                        isSelected: selectedTiming == .today(hour: 16) && !useCustomDate
                    ) {
                        useCustomDate = false
                        selectedTiming = .today(hour: 16)
                    }
                    TimingTile(
                        title: "Morgen om 10:00",
                        subtitle: "Plan voor morgen",
                        icon: "calendar",
                        isSelected: selectedTiming == .scheduled(date: tomorrowAt10) && !useCustomDate
                    ) {
                        useCustomDate = false
                        selectedTiming = .scheduled(date: tomorrowAt10)
                    }
                    TimingTile(
                        title: "Zelf kiezen",
                        subtitle: "Kies een datum en tijd",
                        icon: "calendar.badge.clock",
                        isSelected: useCustomDate
                    ) {
                        useCustomDate = true
                        selectedTiming = .scheduled(date: customDate)
                    }

                    if useCustomDate {
                        DatePicker(
                            "",
                            selection: $customDate,
                            in: Date()...,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.graphical)
                        .tint(BCColors.primary)
                        .padding(BCSpacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                                .fill(BCColors.surface)
                        )
                        .onChange(of: customDate) { _, newDate in
                            selectedTiming = .scheduled(date: newDate)
                        }
                    }
                }
                .padding(.horizontal, BCSpacing.lg)

                VStack(alignment: .leading, spacing: BCSpacing.xs) {
                    Text("Iets toevoegen voor de buddy? (optioneel)")
                        .font(BCTypography.subheadline)
                        .foregroundStyle(BCColors.textSecondary)
                    TextField("Bijvoorbeeld: bel maar twee keer aan", text: $note, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
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
                .padding(.horizontal, BCSpacing.lg)
                .padding(.top, BCSpacing.md)
            }
            .padding(.bottom, BCSpacing.lg)
        }
    }

    private var tomorrowAt10: Date {
        let cal = Calendar.current
        let tomorrow = cal.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        return cal.date(bySettingHour: 10, minute: 0, second: 0, of: tomorrow) ?? tomorrow
    }

    // STEP 2 — bevestiging
    private var confirmStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BCSpacing.md) {
                Text("Klopt dit?")
                    .font(BCTypography.elderlyHeading)
                    .foregroundStyle(BCColors.textPrimary)
                    .padding(.horizontal, BCSpacing.lg)
                    .padding(.top, BCSpacing.md)

                BCCard {
                    VStack(alignment: .leading, spacing: BCSpacing.sm) {
                        SummaryRow(label: "Soort hulp", value: selectedCategory?.displayName ?? "—",
                                   icon: selectedCategory?.icon ?? "questionmark")
                        Divider()
                        SummaryRow(label: "Wanneer", value: selectedTiming?.displayName ?? "—", icon: "clock.fill")
                        Divider()
                        SummaryRow(label: "Adres", value: appState.elderlyUser.address, icon: "house.fill")
                        if !note.isEmpty {
                            Divider()
                            SummaryRow(label: "Opmerking", value: note, icon: "text.bubble.fill")
                        }
                    }
                }
                .padding(.horizontal, BCSpacing.lg)

                BCCard {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Geschat tarief")
                                .font(BCTypography.subheadline)
                                .foregroundStyle(BCColors.textSecondary)
                            Text(formattedPrice)
                                .font(BCTypography.title2)
                                .foregroundStyle(BCColors.textPrimary)
                        }
                        Spacer()
                        Image(systemName: "creditcard.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(BCColors.primary)
                    }
                }
                .padding(.horizontal, BCSpacing.lg)

                Text("Door op Bevestigen te tikken vraagt u officieel hulp aan. We zoeken meteen iemand in de buurt voor u.")
                    .font(BCTypography.caption)
                    .foregroundStyle(BCColors.textTertiary)
                    .padding(.horizontal, BCSpacing.lg)
            }
            .padding(.bottom, BCSpacing.lg)
        }
    }

    private var formattedPrice: String {
        guard let cat = selectedCategory else { return "—" }
        let euros = Double(cat.suggestedPriceCents) / 100
        return String(format: "€ %.2f", euros).replacingOccurrences(of: ".", with: ",")
    }

    private var bottomBar: some View {
        VStack(spacing: BCSpacing.sm) {
            Divider()
            HStack(spacing: BCSpacing.sm) {
                if step > 0 {
                    BCSecondaryButton(title: "Terug", icon: "chevron.left", fullWidth: true) {
                        step -= 1
                    }
                }
                BCPrimaryButton(
                    title: step == 2 ? "Bevestigen" : "Volgende",
                    icon: step == 2 ? "checkmark" : "chevron.right",
                    fullWidth: true
                ) {
                    next()
                }
                .opacity(canContinue ? 1.0 : 0.5)
                .disabled(!canContinue)
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.bottom, BCSpacing.md)
        }
        .background(BCColors.background)
    }

    private var canContinue: Bool {
        switch step {
        case 0: return selectedCategory != nil
        case 1: return selectedTiming != nil
        case 2: return true
        default: return false
        }
    }

    private func next() {
        if step < 2 {
            step += 1
        } else {
            confirm()
        }
    }

    private func confirm() {
        guard let cat = selectedCategory, let timing = selectedTiming else { return }
        appState.requestHelp(category: cat, timing: timing, note: note)
        dismiss()
        // Simulate buddy accepting after a brief delay
        if let task = appState.activeTaskForElderly {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                appState.simulateBuddyAccepts(taskID: task.id)
            }
        }
    }
}

private struct CategoryTile: View {
    let category: TaskCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: BCSpacing.xs) {
                Image(systemName: category.icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(isSelected ? .white : BCColors.primary)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle().fill(isSelected ? BCColors.primary : BCColors.primary.opacity(0.10))
                    )
                Text(category.displayName)
                    .font(BCTypography.bodyEmphasized)
                    .foregroundStyle(BCColors.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .padding(BCSpacing.md)
            .frame(maxWidth: .infinity, minHeight: 130)
            .background(
                RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                    .fill(BCColors.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                    .stroke(isSelected ? BCColors.primary : BCColors.border, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct TimingTile: View {
    let title: String
    let subtitle: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: BCSpacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(isSelected ? .white : BCColors.primary)
                    .frame(width: 48, height: 48)
                    .background(
                        Circle().fill(isSelected ? BCColors.primary : BCColors.primary.opacity(0.10))
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(BCTypography.headline)
                        .foregroundStyle(BCColors.textPrimary)
                    Text(subtitle)
                        .font(BCTypography.subheadline)
                        .foregroundStyle(BCColors.textSecondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(BCColors.primary)
                }
            }
            .padding(BCSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                    .fill(BCColors.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                    .stroke(isSelected ? BCColors.primary : BCColors.border, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct SummaryRow: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        HStack(alignment: .top, spacing: BCSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(BCColors.primary)
                .frame(width: 24)
                .padding(.top, 2)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(BCTypography.caption)
                    .foregroundStyle(BCColors.textSecondary)
                Text(value)
                    .font(BCTypography.bodyEmphasized)
                    .foregroundStyle(BCColors.textPrimary)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
