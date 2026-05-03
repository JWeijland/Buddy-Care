import SwiftUI

struct ElderlyHomeView: View {
    @Environment(AppState.self) private var appState
    @State private var showRequestFlow = false
    @State private var showReview = false
    @State private var selectedHistoryTask: ServiceTask? = nil

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                BCNavBar(title: "Hallo \(appState.elderlyUser.firstName)", subtitle: "Buddy Care")

                ScrollView {
                    VStack(spacing: BCSpacing.lg) {
                        if let active = appState.activeTaskForElderly {
                            ActiveTaskBanner(task: active)
                                .padding(.horizontal, BCSpacing.lg)
                                .padding(.top, BCSpacing.md)
                        }

                        VStack(alignment: .leading, spacing: BCSpacing.md) {
                            Text("Waar kan ik u mee helpen?")
                                .font(BCTypography.elderlyHeading)
                                .foregroundStyle(BCColors.textPrimary)
                                .padding(.horizontal, BCSpacing.lg)

                            VStack(spacing: BCSpacing.sm) {
                                BCBigTile(
                                    title: "Hulp vragen",
                                    subtitle: "Iemand komt u zo helpen",
                                    icon: "hand.raised.fill",
                                    color: BCColors.primary
                                ) {
                                    showRequestFlow = true
                                }

                                BCBigTile(
                                    title: "Mijn vaste buddies",
                                    subtitle: "Bel of nodig direct uit",
                                    icon: "person.2.fill",
                                    color: BCColors.accent
                                ) {
                                    // Tab switch handled visually
                                }

                                BCBigTile(
                                    title: "Bezoek aan de deur",
                                    subtitle: "Bekijk wie er staat (camera)",
                                    icon: "video.fill",
                                    color: BCColors.level1
                                ) { }
                            }
                            .padding(.horizontal, BCSpacing.lg)
                        }
                        .padding(.top, BCSpacing.md)

                        upcomingSection
                            .padding(.horizontal, BCSpacing.lg)

                        // Spacer for SOS floating button
                        Color.clear.frame(height: 100)
                    }
                    .padding(.bottom, BCSpacing.lg)
                }
            }

            sosFloatingButton
                .padding(.trailing, BCSpacing.lg)
                .padding(.bottom, BCSpacing.lg)
        }
        .background(BCColors.background.ignoresSafeArea())
        .sheet(isPresented: $showRequestFlow) {
            RequestHelpFlow()
        }
        .sheet(item: $selectedHistoryTask) { task in
            PastVisitSheet(task: task)
        }
        .fullScreenCover(isPresented: $showReview) {
            if let task = appState.taskHistory.first, let buddyName = task.assignedBuddyName {
                ReviewView(buddyName: buddyName) {
                    showReview = false
                }
            }
        }
        .onChange(of: appState.activeTaskForElderly?.status) { _, newStatus in
            if newStatus == .completed {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showReview = true
                }
            }
        }
    }

    private var upcomingSection: some View {
        VStack(alignment: .leading, spacing: BCSpacing.sm) {
            Text("Eerder geholpen")
                .font(BCTypography.title3)
                .foregroundStyle(BCColors.textPrimary)

            if appState.taskHistory.isEmpty {
                BCCard {
                    Text("Nog geen eerdere bezoeken.")
                        .font(BCTypography.body)
                        .foregroundStyle(BCColors.textSecondary)
                }
            } else {
                ForEach(appState.taskHistory.prefix(5)) { task in
                    Button { selectedHistoryTask = task } label: {
                        BCCard {
                            HStack(spacing: BCSpacing.md) {
                                Image(systemName: task.category.icon)
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(BCColors.primary)
                                    .frame(width: 44, height: 44)
                                    .background(Circle().fill(BCColors.primary.opacity(0.10)))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(task.category.displayName)
                                        .font(BCTypography.headline)
                                        .foregroundStyle(BCColors.textPrimary)
                                    if let buddy = task.assignedBuddyName {
                                        HStack(spacing: BCSpacing.xs) {
                                            Text("Met \(buddy)")
                                                .font(BCTypography.subheadline)
                                                .foregroundStyle(BCColors.textSecondary)
                                            if appState.favoriteBuddyNames.contains(buddy) {
                                                Image(systemName: "heart.fill")
                                                    .font(.system(size: 10))
                                                    .foregroundStyle(BCColors.danger)
                                            }
                                        }
                                    }
                                    if let date = task.completedAt {
                                        Text(relativeFormatter.localizedString(for: date, relativeTo: Date()))
                                            .font(BCTypography.caption)
                                            .foregroundStyle(BCColors.textTertiary)
                                    }
                                }
                                Spacer()
                                if let stars = appState.taskRatings[task.id] {
                                    HStack(spacing: 2) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 11))
                                            .foregroundStyle(BCColors.warning)
                                        Text("\(stars)")
                                            .font(BCTypography.captionEmphasized)
                                            .foregroundStyle(BCColors.textSecondary)
                                    }
                                } else {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(BCColors.textTertiary)
                                }
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var sosFloatingButton: some View {
        Button {
            appState.showSOS = true
        } label: {
            VStack(spacing: 0) {
                Image(systemName: "phone.fill.arrow.up.right")
                    .font(.system(size: 22, weight: .heavy))
                Text("SOS")
                    .font(.system(size: 13, weight: .heavy))
            }
            .foregroundStyle(.white)
            .frame(width: 72, height: 72)
            .background(
                Circle().fill(BCColors.danger)
            )
            .shadow(color: BCColors.danger.opacity(0.35), radius: 12, x: 0, y: 6)
        }
        .accessibilityLabel("SOS knop, alarmeer hulp")
        .buttonStyle(.plain)
    }
}

struct ActiveTaskBanner: View {
    let task: ServiceTask

    var body: some View {
        BCCard {
            VStack(alignment: .leading, spacing: BCSpacing.sm) {
                HStack {
                    BCStatusPill(label: task.status.label, color: task.status.color)
                    Spacer()
                    if let eta = task.assignedBuddyEtaMinutes {
                        Label("\(eta) min", systemImage: "clock.fill")
                            .font(BCTypography.captionEmphasized)
                            .foregroundStyle(BCColors.textSecondary)
                    }
                }
                Text(task.category.displayName)
                    .font(BCTypography.elderlyHeading)
                    .foregroundStyle(BCColors.textPrimary)
                if let buddy = task.assignedBuddyName {
                    HStack(spacing: BCSpacing.sm) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(BCColors.primary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(buddy) komt naar u toe")
                                .font(BCTypography.headline)
                                .foregroundStyle(BCColors.textPrimary)
                            if let r = task.assignedBuddyRating {
                                BCRatingStars(value: r)
                            }
                        }
                    }
                } else {
                    Text("We zoeken een buddy voor u…")
                        .font(BCTypography.body)
                        .foregroundStyle(BCColors.textSecondary)
                }
            }
        }
    }
}

// MARK: - Past Visit Sheet

private struct PastVisitSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    let task: ServiceTask

    @State private var selectedStars: Int = 0
    @State private var reviewText: String = ""
    @State private var submitted: Bool = false

    private var buddy: BuddyUser? {
        guard let name = task.assignedBuddyName else { return nil }
        return MockData.allBuddies.first { $0.firstName == name }
    }

    private var alreadyRated: Bool { appState.taskRatings[task.id] != nil }
    private var isFavorite: Bool {
        guard let name = task.assignedBuddyName else { return false }
        return appState.favoriteBuddyNames.contains(name)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: BCSpacing.lg) {

                    // Buddy header
                    VStack(spacing: BCSpacing.sm) {
                        ZStack {
                            Circle().fill(BCColors.primary.opacity(0.10)).frame(width: 80, height: 80)
                            Image(systemName: buddy?.avatarSystemName ?? "person.crop.circle.fill")
                                .font(.system(size: 44, weight: .regular))
                                .foregroundStyle(BCColors.primary)
                        }
                        Text(task.assignedBuddyName ?? "Buddy")
                            .font(BCTypography.title2)
                            .foregroundStyle(BCColors.textPrimary)
                        if let b = buddy {
                            HStack(spacing: BCSpacing.sm) {
                                BCLevelBadge(level: b.level)
                                BCRatingStars(value: b.ratingAverage)
                                Text("\(b.totalTasks) bezoeken")
                                    .font(BCTypography.caption)
                                    .foregroundStyle(BCColors.textTertiary)
                            }
                        }
                    }
                    .padding(.top, BCSpacing.md)

                    // Visit summary
                    BCCard {
                        VStack(spacing: BCSpacing.sm) {
                            HStack {
                                Label(task.category.displayName, systemImage: task.category.icon)
                                    .font(BCTypography.bodyEmphasized)
                                    .foregroundStyle(BCColors.textPrimary)
                                Spacer()
                                BCStatusPill(label: "Voltooid", color: BCColors.success)
                            }
                            if let date = task.completedAt {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundStyle(BCColors.textTertiary)
                                    Text(date.formatted(date: .long, time: .shortened))
                                        .font(BCTypography.caption)
                                        .foregroundStyle(BCColors.textSecondary)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, BCSpacing.lg)

                    // Favorite toggle
                    if let name = task.assignedBuddyName {
                        Button {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            appState.toggleFavorite(buddyName: name)
                        } label: {
                            HStack(spacing: BCSpacing.md) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(isFavorite ? BCColors.danger : BCColors.textSecondary)
                                    .frame(width: 44, height: 44)
                                    .background(Circle().fill(isFavorite ? BCColors.danger.opacity(0.10) : BCColors.surface))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(isFavorite ? "Vaste buddy" : "Voeg toe aan vaste buddies")
                                        .font(BCTypography.headline)
                                        .foregroundStyle(BCColors.textPrimary)
                                    Text(isFavorite ? "\(name) krijgt voorrang bij uw volgende aanvraag" : "Dan krijgt \(name) voorrang bij uw volgende aanvraag")
                                        .font(BCTypography.caption)
                                        .foregroundStyle(BCColors.textSecondary)
                                }
                                Spacer()
                                if isFavorite {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(BCColors.success)
                                }
                            }
                            .padding(BCSpacing.md)
                            .background(
                                RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                                    .fill(BCColors.surface)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                                            .stroke(isFavorite ? BCColors.danger.opacity(0.3) : BCColors.border, lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, BCSpacing.lg)
                        .animation(.easeInOut(duration: 0.2), value: isFavorite)
                    }

                    // Rating section
                    if alreadyRated {
                        BCCard {
                            HStack {
                                Text("Uw beoordeling")
                                    .font(BCTypography.subheadline)
                                    .foregroundStyle(BCColors.textSecondary)
                                Spacer()
                                BCRatingStars(value: Double(appState.taskRatings[task.id] ?? 0))
                            }
                        }
                        .padding(.horizontal, BCSpacing.lg)
                    } else if !submitted {
                        VStack(spacing: BCSpacing.md) {
                            Text("Hoe was het bezoek?")
                                .font(BCTypography.elderlyHeading)
                                .foregroundStyle(BCColors.textPrimary)

                            HStack(spacing: BCSpacing.md) {
                                ForEach(1...5, id: \.self) { star in
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        selectedStars = star
                                    } label: {
                                        Image(systemName: star <= selectedStars ? "star.fill" : "star")
                                            .font(.system(size: 36, weight: .semibold))
                                            .foregroundStyle(star <= selectedStars ? BCColors.warning : BCColors.border)
                                            .frame(width: 56, height: 56)
                                            .scaleEffect(star <= selectedStars ? 1.1 : 1.0)
                                            .animation(.spring(response: 0.2), value: selectedStars)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }

                            if selectedStars > 0 {
                                BCCard {
                                    TextField("Vertel er iets meer over (optioneel)", text: $reviewText, axis: .vertical)
                                        .lineLimit(3, reservesSpace: true)
                                        .font(BCTypography.elderlyBody)
                                        .foregroundStyle(BCColors.textPrimary)
                                }
                                .padding(.horizontal, BCSpacing.lg)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))

                                BCPrimaryButton(title: "Verstuur beoordeling", icon: "star.fill") {
                                    appState.rateTask(taskId: task.id, stars: selectedStars, body: reviewText)
                                    withAnimation { submitted = true }
                                }
                                .padding(.horizontal, BCSpacing.lg)
                                .transition(.opacity)
                            }
                        }
                        .animation(.easeInOut(duration: 0.2), value: selectedStars)
                    } else {
                        VStack(spacing: BCSpacing.sm) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(BCColors.warning)
                            Text("Bedankt voor uw beoordeling!")
                                .font(BCTypography.headline)
                                .foregroundStyle(BCColors.textPrimary)
                        }
                        .padding(BCSpacing.xl)
                    }

                    Spacer(minLength: BCSpacing.xl)
                }
            }
            .background(BCColors.background.ignoresSafeArea())
            .navigationTitle("Bezoek details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sluiten") { dismiss() }.tint(BCColors.primary)
                }
            }
        }
        .onAppear {
            selectedStars = appState.taskRatings[task.id] ?? 0
        }
    }
}

private let relativeFormatter: RelativeDateTimeFormatter = {
    let f = RelativeDateTimeFormatter()
    f.locale = Locale(identifier: "nl_NL")
    f.unitsStyle = .full
    return f
}()
