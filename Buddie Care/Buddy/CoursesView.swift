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
                        if course.requiresPhysicalCertification {
                            Label("Praktijktoets", systemImage: "building.2.fill")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(BCColors.level2)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(BCColors.level2.opacity(0.1)))
                        }
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
    @State private var courseState: Course
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState

    @State private var activeModule: CourseModuleData? = nil
    @State private var showCertificate: Bool = false

    init(course: Course) {
        _courseState = State(initialValue: course)
    }

    private var firstIncompleteModule: CourseModuleData? {
        courseState.modules.first(where: { !$0.isCompleted })
    }

    private var progressPercent: Int {
        let done = courseState.modules.filter(\.isCompleted).count
        let total = courseState.modules.count
        guard total > 0 else { return 0 }
        return Int(Double(done) / Double(total) * 100)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: BCSpacing.md) {
                    HStack {
                        BCLevelBadge(level: courseState.level)
                        if progressPercent == 100 {
                            BCStatusPill(label: "Voltooid", color: BCColors.success)
                        } else if progressPercent > 0 {
                            BCStatusPill(label: "\(progressPercent)% voltooid", color: BCColors.primary)
                        }
                        Spacer()
                    }

                    Text(courseState.title)
                        .font(BCTypography.title)
                        .foregroundStyle(BCColors.textPrimary)

                    Text(courseState.summary)
                        .font(BCTypography.body)
                        .foregroundStyle(BCColors.textSecondary)

                    HStack(spacing: BCSpacing.md) {
                        Label("\(courseState.durationMinutes) min", systemImage: "clock.fill")
                        Label("\(courseState.modulesCount) modules", systemImage: "list.bullet")
                    }
                    .font(BCTypography.caption)
                    .foregroundStyle(BCColors.textTertiary)

                    if progressPercent > 0 && progressPercent < 100 {
                        BCProgressBar(value: Double(progressPercent) / 100, label: "Voortgang", color: BCColors.primary)
                    }

                    if courseState.requiresPhysicalCertification {
                        physicalCertBanner
                    }

                    BCCard {
                        VStack(alignment: .leading, spacing: BCSpacing.sm) {
                            Text("Modules")
                                .font(BCTypography.headline)
                                .foregroundStyle(BCColors.textPrimary)
                            ForEach(Array(courseState.modules.enumerated()), id: \.element.id) { index, mod in
                                let isAccessible = mod.isCompleted || mod.id == firstIncompleteModule?.id
                                Button {
                                    if isAccessible { activeModule = mod }
                                } label: {
                                    HStack(spacing: BCSpacing.sm) {
                                        ZStack {
                                            Circle()
                                                .fill(mod.isCompleted ? BCColors.success : (isAccessible ? BCColors.primary.opacity(0.12) : BCColors.border))
                                                .frame(width: 32, height: 32)
                                            if mod.isCompleted {
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 13, weight: .bold))
                                                    .foregroundStyle(.white)
                                            } else {
                                                Image(systemName: moduleIcon(mod.type))
                                                    .font(.system(size: 13, weight: .semibold))
                                                    .foregroundStyle(isAccessible ? BCColors.primary : BCColors.textSecondary)
                                            }
                                        }
                                        VStack(alignment: .leading, spacing: 1) {
                                            Text(mod.title)
                                                .font(BCTypography.body)
                                                .foregroundStyle(mod.isCompleted ? BCColors.textSecondary : BCColors.textPrimary)
                                                .strikethrough(mod.isCompleted, color: BCColors.textTertiary)
                                            Text("\(mod.durationMinutes) min")
                                                .font(BCTypography.caption)
                                                .foregroundStyle(BCColors.textTertiary)
                                        }
                                        Spacer()
                                        if mod.id == firstIncompleteModule?.id {
                                            BCStatusPill(label: "Volgende", color: BCColors.primary)
                                        } else if !isAccessible {
                                            Image(systemName: "lock.fill")
                                                .font(.system(size: 12))
                                                .foregroundStyle(BCColors.textTertiary)
                                        }
                                    }
                                    .padding(.vertical, BCSpacing.xs)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    if courseState.unlocked {
                        if progressPercent == 100 {
                            BCSecondaryButton(title: "Bekijk certificaat", icon: "rosette") {
                                showCertificate = true
                            }
                        } else {
                            BCPrimaryButton(
                                title: progressPercent > 0 ? "Doorgaan" : "Start cursus",
                                icon: progressPercent > 0 ? "arrow.right.circle.fill" : "play.fill"
                            ) {
                                activeModule = firstIncompleteModule
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
            .sheet(item: $activeModule) { mod in
                CourseModuleView(module: mod, courseTitle: courseState.title) {
                    handleModuleComplete(mod)
                }
            }
            .sheet(isPresented: $showCertificate) {
                CertificateView(level: courseState.level, buddyName: appState.buddyUser.fullName)
            }
        }
    }

    // MARK: - Module completion & auto-advance

    private func handleModuleComplete(_ mod: CourseModuleData) {
        // Mark done
        if let idx = courseState.modules.firstIndex(where: { $0.id == mod.id }) {
            courseState.modules[idx].isCompleted = true
        }
        activeModule = nil

        let next = courseState.modules.first(where: { !$0.isCompleted })

        if next == nil {
            // All modules done → certificate
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                showCertificate = true
            }
        } else if mod.type != .quiz {
            // Auto-advance to next module
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                activeModule = next
            }
        }
    }

    private var physicalCertBanner: some View {
        HStack(alignment: .top, spacing: BCSpacing.md) {
            Image(systemName: "building.2.fill")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(BCColors.level2)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: BCSpacing.xs) {
                Text("Praktijktoets vereist")
                    .font(BCTypography.bodyEmphasized)
                    .foregroundStyle(BCColors.level2)
                Text("Na het afronden van de e-learning moet je een praktijktoets afleggen bij een erkende Buddy Care-locatie. Locaties worden bekendgemaakt zodra Niveau 2 beschikbaar komt. Na de toets ontvang je het officiële niveau-certificaat.")
                    .font(BCTypography.caption)
                    .foregroundStyle(BCColors.textSecondary)
            }
        }
        .padding(BCSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: BCRadius.md, style: .continuous)
                .fill(BCColors.level2.opacity(0.07))
                .overlay(
                    RoundedRectangle(cornerRadius: BCRadius.md, style: .continuous)
                        .stroke(BCColors.level2.opacity(0.3), lineWidth: 1)
                )
        )
    }

    private func moduleIcon(_ type: ModuleType) -> String {
        switch type {
        case .video:   return "play.fill"
        case .quiz:    return "checkmark.circle"
        case .reading: return "book.fill"
        }
    }
}

#Preview {
    CoursesView().environment(AppState())
}
