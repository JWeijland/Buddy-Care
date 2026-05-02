import SwiftUI

struct MyBuddiesView: View {
    var body: some View {
        VStack(spacing: 0) {
            BCNavBar(title: "Mijn buddies", subtitle: "Vaste mensen die u kennen")

            ScrollView {
                VStack(alignment: .leading, spacing: BCSpacing.md) {
                    Text("Vaste buddies")
                        .font(BCTypography.title3)
                        .foregroundStyle(BCColors.textPrimary)
                        .padding(.horizontal, BCSpacing.lg)
                        .padding(.top, BCSpacing.md)

                    Text("Vaste buddies krijgen 5 minuten voorrang als u hulp aanvraagt.")
                        .font(BCTypography.subheadline)
                        .foregroundStyle(BCColors.textSecondary)
                        .padding(.horizontal, BCSpacing.lg)

                    VStack(spacing: BCSpacing.sm) {
                        ForEach([MockData.buddyAiyla, MockData.buddyMark]) { buddy in
                            BuddyRow(buddy: buddy, isFavorite: true)
                        }
                    }
                    .padding(.horizontal, BCSpacing.lg)

                    Text("Eerder geholpen")
                        .font(BCTypography.title3)
                        .foregroundStyle(BCColors.textPrimary)
                        .padding(.horizontal, BCSpacing.lg)
                        .padding(.top, BCSpacing.lg)

                    VStack(spacing: BCSpacing.sm) {
                        BuddyRow(buddy: MockData.buddySophie, isFavorite: false)
                    }
                    .padding(.horizontal, BCSpacing.lg)
                }
                .padding(.bottom, BCSpacing.xl)
            }
        }
        .background(BCColors.background.ignoresSafeArea())
    }
}

private struct BuddyRow: View {
    let buddy: BuddyUser
    let isFavorite: Bool

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
                Button { } label: {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(BCColors.primary))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    MyBuddiesView().environment(AppState())
}
