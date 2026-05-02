import SwiftUI

struct ElderlyHomeView: View {
    @Environment(AppState.self) private var appState
    @State private var showRequestFlow = false
    @State private var showReview = false

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
                ForEach(appState.taskHistory.prefix(3)) { task in
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
                                    Text("Met \(buddy)")
                                        .font(BCTypography.subheadline)
                                        .foregroundStyle(BCColors.textSecondary)
                                }
                                if let date = task.completedAt {
                                    Text(relativeFormatter.localizedString(for: date, relativeTo: Date()))
                                        .font(BCTypography.caption)
                                        .foregroundStyle(BCColors.textTertiary)
                                }
                            }
                            Spacer()
                            BCStatusPill(label: "Voltooid", color: BCColors.success)
                        }
                    }
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

private let relativeFormatter: RelativeDateTimeFormatter = {
    let f = RelativeDateTimeFormatter()
    f.locale = Locale(identifier: "nl_NL")
    f.unitsStyle = .full
    return f
}()
