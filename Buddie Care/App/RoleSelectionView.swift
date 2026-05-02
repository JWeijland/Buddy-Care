import SwiftUI

struct RoleSelectionView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            BCColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView {
                    VStack(spacing: BCSpacing.lg) {
                        introBlock
                            .padding(.top, BCSpacing.xl)

                        VStack(spacing: BCSpacing.md) {
                            ForEach(UserRole.allCases) { role in
                                RoleCard(role: role) {
                                    appState.currentRole = role
                                }
                            }
                        }
                        .padding(.horizontal, BCSpacing.lg)

                        trustStrip
                            .padding(.horizontal, BCSpacing.lg)
                            .padding(.top, BCSpacing.lg)

                        prototypeNote
                            .padding(.horizontal, BCSpacing.lg)
                            .padding(.bottom, BCSpacing.xl)
                    }
                }
            }
        }
    }

    private var header: some View {
        ZStack(alignment: .bottom) {
            BCColors.primary.ignoresSafeArea(edges: .top)
            HStack(spacing: BCSpacing.sm) {
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(BCColors.accent)
                Text("Buddy Care")
                    .font(BCTypography.titleEmphasized)
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.vertical, BCSpacing.md)
        }
        .frame(height: 64)
    }

    private var introBlock: some View {
        VStack(spacing: BCSpacing.sm) {
            Text("Welkom bij Buddy Care")
                .font(BCTypography.largeTitle)
                .foregroundStyle(BCColors.textPrimary)
                .multilineTextAlignment(.center)
            Text("Hulp om de hoek, met een hart erbij. Kies hieronder hoe u Buddy Care wilt gebruiken.")
                .font(BCTypography.body)
                .foregroundStyle(BCColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, BCSpacing.lg)
        }
    }

    private var trustStrip: some View {
        HStack(spacing: BCSpacing.md) {
            TrustBadge(icon: "checkmark.shield.fill", label: "VOG\ngescreend")
            TrustBadge(icon: "lock.fill", label: "AVG\nveilig")
            TrustBadge(icon: "hand.raised.fill", label: "Verzekerde\ndienst")
        }
    }

    private var prototypeNote: some View {
        Text("Prototype — selecteer een rol om de bijbehorende app-ervaring te bekijken. In de echte app wordt uw rol bepaald bij het aanmaken van uw account.")
            .font(BCTypography.caption)
            .foregroundStyle(BCColors.textTertiary)
            .multilineTextAlignment(.center)
            .padding(.top, BCSpacing.lg)
    }
}

private struct RoleCard: View {
    let role: UserRole
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: BCSpacing.md) {
                ZStack {
                    Circle()
                        .fill(BCColors.primary.opacity(0.08))
                        .frame(width: 56, height: 56)
                    Image(systemName: role.icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(BCColors.primary)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(role.displayName)
                        .font(BCTypography.headline)
                        .foregroundStyle(BCColors.textPrimary)
                    Text(role.subtitle)
                        .font(BCTypography.subheadline)
                        .foregroundStyle(BCColors.textSecondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(BCColors.textTertiary)
            }
            .padding(BCSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                    .fill(BCColors.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                    .stroke(BCColors.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct TrustBadge: View {
    let icon: String
    let label: String

    var body: some View {
        VStack(spacing: BCSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(BCColors.primary)
            Text(label)
                .font(BCTypography.caption)
                .foregroundStyle(BCColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, BCSpacing.sm)
        .background(
            RoundedRectangle(cornerRadius: BCRadius.md, style: .continuous)
                .fill(BCColors.surfaceMuted)
        )
    }
}

#Preview {
    RoleSelectionView()
        .environment(AppState())
}
