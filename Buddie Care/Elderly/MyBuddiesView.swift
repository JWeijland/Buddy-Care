import SwiftUI

struct MyBuddiesView: View {
    @Environment(AppState.self) private var appState

    private var favoriteBuddies: [BuddyUser] {
        MockData.allBuddies.filter { appState.favoriteBuddyNames.contains($0.firstName) }
    }

    private var pastBuddies: [BuddyUser] {
        let pastNames = Set(appState.taskHistory.compactMap(\.assignedBuddyName))
        return MockData.allBuddies.filter {
            pastNames.contains($0.firstName) && !appState.favoriteBuddyNames.contains($0.firstName)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            BCNavBar(title: "Mijn buddies", subtitle: "Vaste mensen die u kennen")

            ScrollView {
                VStack(alignment: .leading, spacing: BCSpacing.md) {

                    // Favorites
                    Text("Vaste buddies")
                        .font(BCTypography.title3)
                        .foregroundStyle(BCColors.textPrimary)
                        .padding(.horizontal, BCSpacing.lg)
                        .padding(.top, BCSpacing.md)

                    Text("Vaste buddies krijgen 5 minuten voorrang als u hulp aanvraagt.")
                        .font(BCTypography.subheadline)
                        .foregroundStyle(BCColors.textSecondary)
                        .padding(.horizontal, BCSpacing.lg)

                    if favoriteBuddies.isEmpty {
                        BCCard {
                            Text("U heeft nog geen vaste buddies. Tik op een eerder bezoek om iemand toe te voegen.")
                                .font(BCTypography.body)
                                .foregroundStyle(BCColors.textSecondary)
                        }
                        .padding(.horizontal, BCSpacing.lg)
                    } else {
                        VStack(spacing: BCSpacing.sm) {
                            ForEach(favoriteBuddies) { buddy in
                                BuddyRow(buddy: buddy, isFavorite: true) {
                                    appState.toggleFavorite(buddyName: buddy.firstName)
                                }
                            }
                        }
                        .padding(.horizontal, BCSpacing.lg)
                    }

                    // Past (not favorited)
                    if !pastBuddies.isEmpty {
                        Text("Eerder geholpen")
                            .font(BCTypography.title3)
                            .foregroundStyle(BCColors.textPrimary)
                            .padding(.horizontal, BCSpacing.lg)
                            .padding(.top, BCSpacing.lg)

                        VStack(spacing: BCSpacing.sm) {
                            ForEach(pastBuddies) { buddy in
                                BuddyRow(buddy: buddy, isFavorite: false) {
                                    appState.toggleFavorite(buddyName: buddy.firstName)
                                }
                            }
                        }
                        .padding(.horizontal, BCSpacing.lg)
                    }
                }
                .padding(.bottom, BCSpacing.xl)
            }
        }
        .background(BCColors.background.ignoresSafeArea())
    }
}

private struct BuddyRow: View {
    @Environment(AppState.self) private var appState
    let buddy: BuddyUser
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        BCCard {
            HStack(spacing: BCSpacing.md) {
                ZStack {
                    Circle().fill(BCColors.primary.opacity(0.10)).frame(width: 56, height: 56)
                    Image(systemName: buddy.avatarSystemName)
                        .font(.system(size: 30, weight: .regular))
                        .foregroundStyle(BCColors.primary)
                }
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: BCSpacing.xs) {
                        Text(buddy.firstName)
                            .font(BCTypography.headline)
                            .foregroundStyle(BCColors.textPrimary)
                        if isFavorite {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(BCColors.danger)
                        }
                    }
                    BCRatingStars(value: buddy.ratingAverage)
                    HStack(spacing: BCSpacing.xs) {
                        BCLevelBadge(level: buddy.level)
                        Text("\(buddy.totalTasks) bezoeken")
                            .font(BCTypography.caption)
                            .foregroundStyle(BCColors.textTertiary)
                    }
                }
                Spacer()
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    onToggleFavorite()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(isFavorite ? BCColors.danger : BCColors.textTertiary)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(isFavorite ? BCColors.danger.opacity(0.10) : BCColors.surface))
                }
                .buttonStyle(.plain)
                .animation(.easeInOut(duration: 0.2), value: isFavorite)
            }
        }
    }
}

#Preview {
    MyBuddiesView().environment(AppState())
}
