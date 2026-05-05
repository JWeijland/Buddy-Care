import SwiftUI

struct EarningsView: View {
    private var totalThisWeek: Int {
        let cal = Calendar.current
        let weekStart = cal.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        return MockData.earnings.filter { $0.date >= weekStart }.reduce(0) { $0 + $1.amountCents }
    }

    private var totalThisMonth: Int {
        let cal = Calendar.current
        let monthStart = cal.dateInterval(of: .month, for: Date())?.start ?? Date()
        return MockData.earnings.filter { $0.date >= monthStart }.reduce(0) { $0 + $1.amountCents }
    }

    private var totalAllTime: Int {
        MockData.earnings.reduce(0) { $0 + $1.amountCents }
    }

    var body: some View {
        VStack(spacing: 0) {
            BCNavBar(title: "Verdiensten", subtitle: "Wat je deze maand hebt verdiend")

            ScrollView {
                VStack(spacing: BCSpacing.md) {
                    HStack(spacing: BCSpacing.sm) {
                        StatCard(label: "Deze week", value: cents(totalThisWeek), color: BCColors.primary)
                        StatCard(label: "Deze maand", value: cents(totalThisMonth), color: BCColors.accent)
                    }
                    .padding(.horizontal, BCSpacing.lg)
                    .padding(.top, BCSpacing.md)

                    BCCard {
                        VStack(alignment: .leading, spacing: BCSpacing.sm) {
                            HStack {
                                Text("Totaal verdiend")
                                    .font(BCTypography.headline)
                                    .foregroundStyle(BCColors.textPrimary)
                                Spacer()
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .foregroundStyle(BCColors.success)
                            }
                            Text(cents(totalAllTime))
                                .font(BCTypography.largeTitle)
                                .foregroundStyle(BCColors.textPrimary)
                            Text("Volgende uitbetaling: maandag")
                                .font(BCTypography.caption)
                                .foregroundStyle(BCColors.textSecondary)
                        }
                    }
                    .padding(.horizontal, BCSpacing.lg)

                    HStack {
                        Text("Recente bezoeken")
                            .font(BCTypography.title3)
                            .foregroundStyle(BCColors.textPrimary)
                        Spacer()
                        Button("Exporteer voor belasting") { }
                            .font(BCTypography.subheadline)
                            .foregroundStyle(BCColors.primary)
                    }
                    .padding(.horizontal, BCSpacing.lg)

                    VStack(spacing: 0) {
                        ForEach(Array(MockData.earnings.enumerated()), id: \.element.id) { index, entry in
                            EarningRow(entry: entry)
                            if index < MockData.earnings.count - 1 {
                                Divider()
                                    .padding(.leading, BCSpacing.lg)
                            }
                        }
                    }
                    .background(BCColors.surface)

                    Spacer().frame(height: BCSpacing.xl)
                }
            }
        }
        .background(BCColors.background.ignoresSafeArea())
    }

    private func cents(_ c: Int) -> String {
        String(format: "€ %.2f", Double(c) / 100).replacingOccurrences(of: ".", with: ",")
    }
}

private struct StatCard: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        BCCard {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(BCTypography.caption)
                    .foregroundStyle(BCColors.textSecondary)
                Text(value)
                    .font(BCTypography.title2)
                    .foregroundStyle(color)
            }
        }
    }
}

private struct EarningRow: View {
    let entry: EarningEntry

    var body: some View {
        HStack(spacing: BCSpacing.md) {
            Image(systemName: entry.category.icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(BCColors.primary)
                .frame(width: 40, height: 40)
                .background(Circle().fill(BCColors.primary.opacity(0.10)))
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.elderlyName)
                    .font(BCTypography.bodyEmphasized)
                    .foregroundStyle(BCColors.textPrimary)
                Text(entry.category.displayName)
                    .font(BCTypography.caption)
                    .foregroundStyle(BCColors.textSecondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "€ %.2f", Double(entry.amountCents) / 100).replacingOccurrences(of: ".", with: ","))
                    .font(BCTypography.bodyEmphasized)
                    .foregroundStyle(BCColors.success)
                Text(dateFormatter.string(from: entry.date))
                    .font(BCTypography.caption)
                    .foregroundStyle(BCColors.textTertiary)
            }
        }
        .padding(.horizontal, BCSpacing.lg)
        .padding(.vertical, BCSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private let dateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "nl_NL")
    f.dateFormat = "d MMM"
    return f
}()

#Preview {
    EarningsView().environment(AppState())
}
