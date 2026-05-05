import SwiftUI
import Observation

struct ToastMessage: Equatable {
    let text: String
    let icon: String
}

@Observable
final class AppState {
    // Navigation
    var currentRole: UserRole? = nil
    var hasSeenSplash: Bool = false
    var isOnboardingComplete: Bool = false
    var showLogin: Bool = false

    // Auth & initialization
    var authService = AuthService()
    var isInitializing: Bool = true
    var isDemoMode: Bool = false
    var realUserId: UUID? = nil
    private let profileService = ProfileService()

    // User data (used by both demo and real mode)
    var elderlyUser: ElderlyUser = MockData.omaRiet
    var buddyUser: BuddyUser = MockData.buddyAiyla
    var familyUser: FamilyUser = MockData.familySandra

    // Tasks
    var openTasks: [ServiceTask] = MockData.openTasks
    var activeTaskForElderly: ServiceTask? = nil
    var activeTaskForBuddy: ServiceTask? = nil
    var taskHistory: [ServiceTask] = MockData.completedTasks

    // UI state
    var showSOS: Bool = false
    var toastMessage: ToastMessage? = nil

    // Elderly preferences (not on ElderlyUser struct to avoid breaking init)
    var largeTextEnabled: Bool = false
    var prefersFormal: Bool = true

    // Buddy availability
    var isAvailableNow: Bool = true

    // Check-in state
    private var selfieCapturedAt: Date? = nil
    var hasSelfieToday: Bool {
        guard let d = selfieCapturedAt else { return false }
        return Calendar.current.isDateInToday(d)
    }
    func recordSelfie() { selfieCapturedAt = Date() }

    // Elderly — favorites & ratings
    var favoriteBuddyNames: Set<String> = ["Aiyla", "Mark"]
    var taskRatings: [UUID: Int] = [:]
    var skippedReviews: Set<UUID> = []

    func toggleFavorite(buddyName: String) {
        if favoriteBuddyNames.contains(buddyName) {
            favoriteBuddyNames.remove(buddyName)
        } else {
            favoriteBuddyNames.insert(buddyName)
            showToast(text: "\(buddyName) toegevoegd aan vaste buddies", icon: "heart.fill")
        }
    }

    func rateTask(taskId: UUID, stars: Int, body: String) {
        taskRatings[taskId] = stars
        skippedReviews.remove(taskId)
        elderlySubmitsReview(stars: stars, body: body)
    }

    func skipReview(taskId: UUID) {
        skippedReviews.insert(taskId)
    }

    func unskipReview(taskId: UUID) {
        skippedReviews.remove(taskId)
    }

    // Course progress: courseId → set of completed moduleIds
    var completedModules: [UUID: Set<UUID>] = [:]

    private let taskService = TaskService()

    func debugCompleteLevel(_ level: ServiceLevel) {
        for course in MockData.courses where course.level == level {
            for module in course.modules {
                completedModules[course.id, default: []].insert(module.id)
            }
        }
    }

    func recordModuleComplete(courseId: UUID, moduleId: UUID) {
        completedModules[courseId, default: []].insert(moduleId)
        if !isDemoMode, let userId = realUserId {
            Task {
                try? await taskService.markModuleComplete(
                    buddyId: userId,
                    courseId: courseId.uuidString,
                    moduleId: moduleId.uuidString
                )
            }
        }
    }

    // MARK: - Initialization (called on app start)

    func initialize() async {
        await authService.restoreSession()
        if let userId = authService.currentUserId {
            await handleAuthSuccess(userId: userId)
        }
        isInitializing = false
    }

    // MARK: - Auth success handler

    func handleAuthSuccess(userId: UUID, role: UserRole? = nil) async {
        realUserId = userId
        if let role = role {
            currentRole = role
        } else {
            do {
                let profile = try await profileService.fetchProfile(userId: userId)
                switch profile.role {
                case "elderly": currentRole = .elderly
                case "buddy":   currentRole = .buddy
                case "family":  currentRole = .family
                default: break
                }
            } catch {
                // Profile not loaded — user stays on auth screen
                return
            }
        }
        showLogin = false
        hasSeenSplash = true
        isOnboardingComplete = true
    }

    // MARK: - Sign out

    func signOut() async {
        try? await authService.signOut()
        realUserId = nil
        currentRole = nil
        hasSeenSplash = false
        isDemoMode = false
        showLogin = false
        isOnboardingComplete = false
    }

    // MARK: - Navigation

    func resetToRoleSelection() {
        currentRole = nil
        activeTaskForElderly = nil
        activeTaskForBuddy = nil
        showSOS = false
    }

    // MARK: - Task actions

    func requestHelp(category: TaskCategory, timing: TaskTiming, note: String, recurringSchedule: RecurringSchedule? = nil) {
        var task = ServiceTask(
            id: UUID(),
            elderlyName: elderlyUser.firstName,
            elderlyAddress: elderlyUser.address,
            coordinate: elderlyUser.coordinate,
            category: category,
            requiredLevel: category.minimumLevel,
            timing: timing,
            note: note,
            priceCents: category.suggestedPriceCents,
            status: .open,
            createdAt: Date(),
            assignedBuddyName: nil,
            assignedBuddyRating: nil,
            assignedBuddyEtaMinutes: nil
        )
        task.recurringSchedule = recurringSchedule
        openTasks.insert(task, at: 0)
        activeTaskForElderly = task
    }

    func simulateBuddyAccepts(taskID: UUID) {
        guard let idx = openTasks.firstIndex(where: { $0.id == taskID }) else { return }
        var task = openTasks[idx]
        task.status = .accepted
        task.assignedBuddyName = MockData.buddyAiyla.firstName
        task.assignedBuddyRating = MockData.buddyAiyla.ratingAverage
        task.assignedBuddyEtaMinutes = Int.random(in: 8...18)
        openTasks[idx] = task
        if activeTaskForElderly?.id == taskID {
            activeTaskForElderly = task
        }
        MockPushService().send(notification: .taskAccepted(
            buddyName: MockData.buddyAiyla.firstName,
            etaMinutes: task.assignedBuddyEtaMinutes ?? 12
        ))
        MockSMSService().sendSMS(
            to: elderlyUser.phoneNumber,
            message: BuddieNotification.taskAccepted(buddyName: MockData.buddyAiyla.firstName, etaMinutes: task.assignedBuddyEtaMinutes ?? 12).title
        )
    }

    func buddyAcceptsTask(_ task: ServiceTask) {
        guard let idx = openTasks.firstIndex(where: { $0.id == task.id }) else { return }
        var updated = openTasks[idx]
        updated.status = .accepted
        updated.assignedBuddyName = buddyUser.firstName
        updated.assignedBuddyRating = buddyUser.ratingAverage
        updated.assignedBuddyEtaMinutes = Int.random(in: 6...15)
        openTasks[idx] = updated
        activeTaskForBuddy = updated
    }

    func buddyArrives(checkIn: CheckInRecord) {
        guard var task = activeTaskForBuddy else { return }
        task.status = .arrived
        task.checkInRecord = checkIn
        activeTaskForBuddy = task
        if let idx = openTasks.firstIndex(where: { $0.id == task.id }) {
            openTasks[idx] = task
        }
        if activeTaskForElderly?.id == task.id {
            activeTaskForElderly = task
        }
        MockPushService().send(notification: .buddyArrived(buddyName: buddyUser.firstName))
        MockSMSService().sendSMS(
            to: elderlyUser.phoneNumber,
            message: BuddieNotification.buddyArrived(buddyName: buddyUser.firstName).title
        )
    }

    func buddyCompletes(notes: String) {
        guard var task = activeTaskForBuddy else { return }
        task.status = .completed
        task.completionNote = notes
        task.completedAt = Date()
        if let idx = openTasks.firstIndex(where: { $0.id == task.id }) {
            openTasks.remove(at: idx)
        }
        taskHistory.insert(task, at: 0)
        activeTaskForBuddy = nil
        // Update elderly so they see the completed state and review prompt
        if activeTaskForElderly?.id == task.id {
            activeTaskForElderly = task
        }
        MockPushService().send(notification: .taskCompleted)
    }

    func elderlySubmitsReview(stars: Int, body: String) {
        activeTaskForElderly = nil
        showToast(text: "Bedankt voor uw beoordeling!", icon: "star.fill")
    }

    // MARK: - SOS

    func triggerSOS() {
        showSOS = true
        MockSMSService().sendSMS(
            to: "06-00000000",
            message: BuddieNotification.sosTriggered(elderlyName: elderlyUser.firstName).title
        )
        MockPushService().send(notification: .sosTriggered(elderlyName: elderlyUser.firstName))
    }

    // MARK: - Toast

    func showToast(text: String, icon: String = "checkmark.circle.fill") {
        toastMessage = ToastMessage(text: text, icon: icon)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            if self?.toastMessage?.text == text {
                self?.toastMessage = nil
            }
        }
    }
}

enum UserRole: String, CaseIterable, Identifiable {
    case elderly
    case buddy
    case family

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .elderly: return "Ik ben oudere"
        case .buddy: return "Ik ben buddy"
        case .family: return "Ik ben familielid"
        }
    }

    var subtitle: String {
        switch self {
        case .elderly: return "Vraag hulp aan een buddy in de buurt"
        case .buddy: return "Verdien geld met zorgtaken bij jou in de buurt"
        case .family: return "Regel hulp voor je vader, moeder of opa/oma"
        }
    }

    var icon: String {
        switch self {
        case .elderly: return "figure.wave"
        case .buddy: return "person.2.fill"
        case .family: return "house.and.flag.fill"
        }
    }
}
