import SwiftUI

struct CoursesView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedCourse: Course? = nil

    var body: some View {
        VStack(spacing: 0) {
            BCNavBar(title: "Cursussen", subtitle: "Groei naar het volgende niveau")

            ScrollView {
                VStack(spacing: BCSpacing.md) {
                    levelHeader
                        .padding(.horizontal, BCSpacing.lg)
                        .padding(.top, BCSpacing.md)

                    ForEach(ServiceLevel.allCases.prefix(4)) { level in
                        let coursesForLevel = MockData.courses.filter { $0.level == level }
                        if !coursesForLevel.isEmpty {
                            VStack(alignment: .leading, spacing: BCSpacing.sm) {
                                HStack {
                                    BCLevelBadge(level: level)
                                    Text(level.title)
                                        .font(BCTypography.headline)
                                        .foregroundStyle(BCColors.textPrimary)
                                    Spacer()
                                }
                                Text(level.requirementText)
                                    .font(BCTypography.caption)
                                    .foregroundStyle(BCColors.textTertiary)

                                VStack(spacing: BCSpacing.sm) {
                                    ForEach(coursesForLevel) { course in
                                        CourseRow(course: course) {
                                            if course.unlocked {
                                                selectedCourse = course
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, BCSpacing.lg)
                            .padding(.top, BCSpacing.sm)
                        }
                    }
                    Spacer().frame(height: BCSpacing.xl)
                }
            }
        }
        .background(BCColors.background.ignoresSafeArea())
        .sheet(item: $selectedCourse) { course in
            CourseDetailView(course: course)
        }
    }

    private var levelHeader: some View {
        BCCard {
            HStack(spacing: BCSpacing.md) {
                ZStack {
                    Circle().fill(appState.buddyUser.level.color.opacity(0.15)).frame(width: 56, height: 56)
                    Image(systemName: "shield.lefthalf.filled")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(appState.buddyUser.level.color)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Jouw huidige niveau")
                        .font(BCTypography.caption)
                        .foregroundStyle(BCColors.textSecondary)
                    Text("Niveau \(appState.buddyUser.level.rawValue) — \(appState.buddyUser.level.title)")
                        .font(BCTypography.title3)
                        .foregroundStyle(BCColors.textPrimary)
                    Text(appState.buddyUser.level.summary)
                        .font(BCTypography.caption)
                        .foregroundStyle(BCColors.textSecondary)
                }
                Spacer()
            }
        }
    }
}

private struct CourseRow: View {
    let course: Course
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            BCCard {
                VStack(alignment: .leading, spacing: BCSpacing.sm) {
                    HStack {
                        Text(course.title)
                            .font(BCTypography.bodyEmphasized)
                            .foregroundStyle(BCColors.textPrimary)
                        Spacer()
                        if !course.unlocked {
                            Image(systemName: "lock.fill")
                                .foregroundStyle(BCColors.textTertiary)
                        } else if course.progressPercent == 100 {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(BCColors.success)
                        }
                    }
                    Text(course.summary)
                        .font(BCTypography.caption)
                        .foregroundStyle(BCColors.textSecondary)
                        .lineLimit(2)
                    HStack(spacing: BCSpacing.sm) {
                        Label("\(course.modulesCount) modules", systemImage: "list.bullet")
                            .font(BCTypography.caption)
                            .foregroundStyle(BCColors.textTertiary)
                        Label("\(course.durationMinutes) min", systemImage: "clock")
                            .font(BCTypography.caption)
                            .foregroundStyle(BCColors.textTertiary)
                        Spacer()
                    }
                    if course.unlocked && course.progressPercent > 0 && course.progressPercent < 100 {
                        BCProgressBar(value: Double(course.progressPercent) / 100)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .opacity(course.unlocked ? 1.0 : 0.55)
    }
}

// MARK: - Course Detail View

struct CourseDetailView: View {
    let course: Course
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState

    @State private var activeModuleType: ModuleType? = nil
    @State private var activeModuleTitle: String = ""
    @State private var activeModuleDuration: Int = 0
    @State private var showCertificate: Bool = false

    private var modules: [(title: String, type: ModuleType, duration: Int, done: Bool)] {
        let total = course.modulesCount
        return (0..<total).map { i in
            let done = course.progressPercent >= Int(Double(i + 1) / Double(total) * 100)
            if i == total - 1 {
                return (title: "Eindtoets", type: .quiz, duration: 15, done: done)
            } else if i == 0 {
                return (title: "Introductie video", type: .video, duration: 8, done: done)
            } else {
                return (title: "Module \(i + 1): Leesmateriaal", type: .reading, duration: 12, done: done)
            }
        }
    }

    private var firstIncompleteIndex: Int? {
        modules.firstIndex(where: { !$0.done })
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: BCSpacing.md) {
                    HStack {
                        BCLevelBadge(level: course.level)
                        if course.progressPercent == 100 {
                            BCStatusPill(label: "Voltooid", color: BCColors.success)
                        } else if course.progressPercent > 0 {
                            BCStatusPill(label: "\(course.progressPercent)% voltooid", color: BCColors.primary)
                        }
                        Spacer()
                    }

                    Text(course.title)
                        .font(BCTypography.title)
                        .foregroundStyle(BCColors.textPrimary)

                    Text(course.summary)
                        .font(BCTypography.body)
                        .foregroundStyle(BCColors.textSecondary)

                    HStack(spacing: BCSpacing.md) {
                        Label("\(course.durationMinutes) min", systemImage: "clock.fill")
                        Label("\(course.modulesCount) modules", systemImage: "list.bullet")
                    }
                    .font(BCTypography.caption)
                    .foregroundStyle(BCColors.textTertiary)

                    if course.progressPercent > 0 {
                        BCProgressBar(
                            value: Double(course.progressPercent) / 100,
                            label: "Voortgang",
                            color: BCColors.primary
                        )
                    }

                    // Module list
                    BCCard {
                        VStack(alignment: .leading, spacing: BCSpacing.sm) {
                            Text("Modules")
                                .font(BCTypography.headline)
                                .foregroundStyle(BCColors.textPrimary)
                            ForEach(Array(modules.enumerated()), id: \.offset) { idx, module in
                                HStack(spacing: BCSpacing.sm) {
                                    ZStack {
                                        Circle().fill(module.done ? BCColors.success : BCColors.border)
                                            .frame(width: 32, height: 32)
                                        if module.done {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundStyle(.white)
                                        } else {
                                            Image(systemName: moduleIcon(module.type))
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundStyle(BCColors.textSecondary)
                                        }
                                    }
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text(module.title)
                                            .font(BCTypography.body)
                                            .foregroundStyle(module.done ? BCColors.textSecondary : BCColors.textPrimary)
                                            .strikethrough(module.done, color: BCColors.textTertiary)
                                        Text("\(module.duration) min")
                                            .font(BCTypography.caption)
                                            .foregroundStyle(BCColors.textTertiary)
                                    }
                                    Spacer()
                                    if idx == firstIncompleteIndex {
                                        BCStatusPill(label: "Volgende", color: BCColors.primary)
                                    }
                                }
                                .padding(.vertical, BCSpacing.xs)
                            }
                        }
                    }

                    if course.unlocked {
                        if course.progressPercent == 100 {
                            BCSecondaryButton(title: "Bekijk certificaat", icon: "rosette") {
                                showCertificate = true
                            }
                        } else {
                            BCPrimaryButton(
                                title: course.progressPercent > 0 ? "Doorgaan" : "Start cursus",
                                icon: "play.fill"
                            ) {
                                if let idx = firstIncompleteIndex {
                                    let m = modules[idx]
                                    activeModuleTitle = m.title
                                    activeModuleType = m.type
                                    activeModuleDuration = m.duration
                                }
                            }
                        }
                    } else {
                        BCSecondaryButton(title: "Vorig niveau eerst afronden", icon: "lock.fill") { }
                    }
                }
                .padding(BCSpacing.lg)
            }
            .background(BCColors.background.ignoresSafeArea())
            .navigationTitle("Cursus")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sluiten") { dismiss() }.tint(BCColors.primary)
                }
            }
            .sheet(isPresented: Binding(
                get: { activeModuleType != nil },
                set: { if !$0 { activeModuleType = nil } }
            )) {
                if let type = activeModuleType {
                    CourseModuleView(
                        courseTitle: course.title,
                        moduleTitle: activeModuleTitle,
                        type: type,
                        durationMinutes: activeModuleDuration
                    ) {
                        activeModuleType = nil
                        if type == .quiz {
                            showCertificate = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showCertificate) {
                CertificateView(
                    level: course.level,
                    buddyName: appState.buddyUser.fullName
                )
            }
        }
    }

    private func moduleIcon(_ type: ModuleType) -> String {
        switch type {
        case .video: return "play.fill"
        case .quiz: return "checkmark.circle"
        case .reading: return "book.fill"
        }
    }
}

#Preview {
    CoursesView().environment(AppState())
}
