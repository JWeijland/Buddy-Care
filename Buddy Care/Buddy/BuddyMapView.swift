import SwiftUI
import MapKit

struct BuddyMapView: View {
    @Environment(AppState.self) private var appState
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: MockData.rotterdamCenter,
            span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        )
    )
    @State private var selectedTask: ServiceTask? = nil
    @State private var maxLevelFilter: Int = 1
    @State private var showActiveTask = false

    var visibleTasks: [ServiceTask] {
        appState.openTasks.filter { $0.requiredLevel.rawValue <= maxLevelFilter }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $cameraPosition, selection: Binding(
                get: { selectedTask?.id },
                set: { id in
                    if let id, let task = appState.openTasks.first(where: { $0.id == id }) {
                        selectedTask = task
                    } else {
                        selectedTask = nil
                    }
                })) {
                ForEach(visibleTasks) { task in
                    Annotation(task.category.displayName, coordinate: task.coordinate) {
                        MapPin(task: task, isSelected: selectedTask?.id == task.id)
                    }
                    .tag(task.id)
                }
                UserAnnotation()
            }
            .mapControlVisibility(.hidden)
            .ignoresSafeArea()

            VStack(spacing: BCSpacing.sm) {
                topBar
                filterStrip
            }
            .padding(.horizontal, BCSpacing.md)
            .padding(.top, BCSpacing.sm)
        }
        .sheet(item: $selectedTask) { task in
            TaskDetailSheet(task: task) {
                appState.buddyAcceptsTask(task)
                selectedTask = nil
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showActiveTask) {
            if let task = appState.activeTaskForBuddy {
                TaskInProgressView(task: task)
            }
        }
        .onChange(of: appState.activeTaskForBuddy) { _, newValue in
            if newValue != nil { showActiveTask = true }
        }
    }

    private var topBar: some View {
        HStack(spacing: BCSpacing.sm) {
            HStack(spacing: BCSpacing.xs) {
                Image(systemName: "heart.text.square.fill")
                    .foregroundStyle(BCColors.accent)
                Text("Buddy Care")
                    .font(BCTypography.bodyEmphasized)
                    .foregroundStyle(BCColors.textPrimary)
            }
            Spacer()
            BCStatusPill(label: "\(visibleTasks.count) open", color: BCColors.primary)
        }
        .padding(.horizontal, BCSpacing.md)
        .padding(.vertical, BCSpacing.sm)
        .background(
            Capsule().fill(BCColors.surface)
                .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: 2)
        )
    }

    private var filterStrip: some View {
        HStack(spacing: BCSpacing.xs) {
            ForEach(ServiceLevel.allCases.prefix(4), id: \.self) { level in
                Button {
                    maxLevelFilter = level.rawValue
                } label: {
                    Text("Niv. \(level.rawValue)")
                        .font(BCTypography.captionEmphasized)
                        .foregroundStyle(maxLevelFilter == level.rawValue ? .white : BCColors.textPrimary)
                        .padding(.horizontal, BCSpacing.md)
                        .padding(.vertical, BCSpacing.sm)
                        .background(
                            Capsule().fill(
                                maxLevelFilter == level.rawValue ? BCColors.primary : BCColors.surface
                            )
                        )
                        .overlay(
                            Capsule().stroke(BCColors.border, lineWidth: maxLevelFilter == level.rawValue ? 0 : 1)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(BCSpacing.xs)
        .background(
            Capsule().fill(BCColors.background.opacity(0.95))
        )
    }
}

private struct MapPin: View {
    let task: ServiceTask
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(task.requiredLevel.color)
                    .frame(width: isSelected ? 52 : 44, height: isSelected ? 52 : 44)
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
                Image(systemName: task.category.icon)
                    .font(.system(size: isSelected ? 22 : 18, weight: .semibold))
                    .foregroundStyle(.white)
            }
            Triangle()
                .fill(task.requiredLevel.color)
                .frame(width: 12, height: 8)
        }
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.closeSubpath()
        return p
    }
}

#Preview {
    BuddyMapView().environment(AppState())
}
