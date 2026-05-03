import Foundation
import SwiftUI
import CoreLocation

// MARK: - Service levels

enum ServiceLevel: Int, CaseIterable, Identifiable, Codable {
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .zero: return "Basis Buddy"
        case .one: return "Huishoud & Mobiliteit"
        case .two: return "Zorgondersteuning"
        case .three: return "Verzorgende"
        case .four: return "Verpleegkundig"
        }
    }

    var summary: String {
        switch self {
        case .zero: return "Gezelschap, boodschappen, lichte opruimklusjes"
        case .one: return "Steunkousen, opstaan, maaltijd opwarmen"
        case .two: return "Medicatie-toezicht, hulp bij wassen, toiletbegeleiding"
        case .three: return "Volledige ADL, stomazorg, wondverzorging"
        case .four: return "BIG-geregistreerde verpleegkundige taken"
        }
    }

    var color: Color {
        switch self {
        case .zero: return BCColors.level0
        case .one: return BCColors.level1
        case .two: return BCColors.level2
        case .three: return BCColors.level3
        case .four: return BCColors.level4
        }
    }

    var requirementText: String {
        switch self {
        case .zero: return "Onboarding + ID-verificatie + VOG"
        case .one: return "Niveau 0 + e-learning module 1 (~2u)"
        case .two: return "Niveau 1 + e-learning + praktijktoets (~8u)"
        case .three: return "Diploma Verzorgende IG of HBO-V student jaar 2+"
        case .four: return "BIG-registratie verpleegkundige (V&V niveau 4/5)"
        }
    }

    var celebrationMessage: String {
        switch self {
        case .zero: return "Je bent klaar als Basis Buddy. Niveau 1 is nu beschikbaar."
        case .one: return "Geweldig! Je kunt nu helpen met huishoud- en mobiliteitstaken. Niveau 2 is ontgrendeld."
        case .two: return "Top! Je bent gecertificeerd voor zorgondersteuning. Niveau 3 staat voor je klaar."
        case .three: return "Indrukwekkend! Je beheerst volledige ADL-zorg. Niveau 4 is nu toegankelijk."
        case .four: return "Uitzonderlijk! Je hebt het hoogste niveau bereikt. Gefeliciteerd!"
        }
    }
}

// MARK: - Task category

enum TaskCategory: String, CaseIterable, Identifiable, Codable {
    case companionship
    case groceries
    case medicationReminder
    case bedHelp
    case lightCleaning
    case mealPrep
    case walkOutdoors
    case appointment
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .companionship: return "Gezelschap"
        case .groceries: return "Boodschappen"
        case .medicationReminder: return "Medicatie"
        case .bedHelp: return "Naar bed helpen"
        case .lightCleaning: return "Opruimen"
        case .mealPrep: return "Maaltijd"
        case .walkOutdoors: return "Wandelen"
        case .appointment: return "Begeleiding afspraak"
        case .other: return "Anders"
        }
    }

    var description: String {
        switch self {
        case .companionship: return "Een uurtje koffie, kletsen, samen tv kijken"
        case .groceries: return "Boodschappen halen en opruimen"
        case .medicationReminder: return "Even langskomen voor medicatie-toezicht"
        case .bedHelp: return "Hulp bij naar bed gaan of opstaan"
        case .lightCleaning: return "Lichte opruim- en huishoudklusjes"
        case .mealPrep: return "Maaltijd bereiden of opwarmen"
        case .walkOutdoors: return "Samen een ommetje maken"
        case .appointment: return "Begeleiding naar dokter of apotheek"
        case .other: return "Iets anders waar hulp bij nodig is"
        }
    }

    var icon: String {
        switch self {
        case .companionship: return "cup.and.saucer.fill"
        case .groceries: return "bag.fill"
        case .medicationReminder: return "pills.fill"
        case .bedHelp: return "bed.double.fill"
        case .lightCleaning: return "sparkles"
        case .mealPrep: return "fork.knife"
        case .walkOutdoors: return "figure.walk"
        case .appointment: return "calendar.badge.clock"
        case .other: return "ellipsis.circle.fill"
        }
    }

    var minimumLevel: ServiceLevel {
        switch self {
        case .companionship, .groceries, .lightCleaning, .walkOutdoors, .appointment, .other:
            return .zero
        case .mealPrep, .bedHelp:
            return .one
        case .medicationReminder:
            return .two
        }
    }

    var suggestedPriceCents: Int {
        switch self {
        case .companionship: return 1700
        case .groceries: return 1700
        case .lightCleaning: return 1700
        case .walkOutdoors: return 1700
        case .appointment: return 2100
        case .other: return 1700
        case .mealPrep: return 2100
        case .bedHelp: return 2100
        case .medicationReminder: return 2600
        }
    }
}

// MARK: - Task timing

enum TaskTiming: Hashable {
    case now
    case today(hour: Int)
    case scheduled(date: Date)

    var displayName: String {
        switch self {
        case .now: return "Zo snel mogelijk"
        case .today(let h): return String(format: "Vandaag om %02d:00", h)
        case .scheduled(let d):
            let f = DateFormatter()
            f.locale = Locale(identifier: "nl_NL")
            f.dateFormat = "EEEE d MMM 'om' HH:mm"
            return f.string(from: d).capitalized
        }
    }
}

// MARK: - Task status

enum TaskStatus: String, Codable {
    case open
    case accepted
    case arrived
    case inProgress
    case completed
    case cancelled

    var label: String {
        switch self {
        case .open: return "Open"
        case .accepted: return "Buddy onderweg"
        case .arrived: return "Buddy is aangekomen"
        case .inProgress: return "Bezig"
        case .completed: return "Afgerond"
        case .cancelled: return "Geannuleerd"
        }
    }

    var color: Color {
        switch self {
        case .open: return BCColors.warning
        case .accepted: return BCColors.primary
        case .arrived: return BCColors.accent
        case .inProgress: return BCColors.primary
        case .completed: return BCColors.success
        case .cancelled: return BCColors.danger
        }
    }
}

// MARK: - Service Task (avoid name clash with Swift Task)

struct ServiceTask: Identifiable, Hashable {
    let id: UUID
    let elderlyName: String
    let elderlyAddress: String
    let coordinate: CLLocationCoordinate2D
    let category: TaskCategory
    let requiredLevel: ServiceLevel
    let timing: TaskTiming
    let note: String
    let priceCents: Int
    var status: TaskStatus
    let createdAt: Date

    var assignedBuddyName: String?
    var assignedBuddyRating: Double?
    var assignedBuddyEtaMinutes: Int?

    var completionNote: String? = nil
    var completedAt: Date? = nil

    var priceFormatted: String {
        String(format: "€ %.2f", Double(priceCents) / 100).replacingOccurrences(of: ".", with: ",")
    }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: ServiceTask, rhs: ServiceTask) -> Bool { lhs.id == rhs.id }
}

// MARK: - Users

struct ElderlyUser: Identifiable, Hashable {
    let id: UUID
    let firstName: String
    let lastName: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let dateOfBirth: Date
    let phoneNumber: String
    var allergies: [String]
    var medicationNotes: String
    var favoriteBuddyIDs: [UUID]
    var familyMemberIDs: [UUID]
    var creditEuros: Double

    var fullName: String { "\(firstName) \(lastName)" }
    var age: Int { Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0 }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: ElderlyUser, rhs: ElderlyUser) -> Bool { lhs.id == rhs.id }
}

struct BuddyUser: Identifiable, Hashable {
    let id: UUID
    let firstName: String
    let lastName: String
    let avatarSystemName: String
    let level: ServiceLevel
    let certifications: [Certification]
    let ratingAverage: Double
    let totalTasks: Int
    let bio: String
    let study: String
    let kycVerified: Bool
    let vogValid: Bool
    let vogExpiresAt: Date
    var ibanLast4: String = "****"
    var isAvailableNow: Bool = true

    var fullName: String { "\(firstName) \(lastName)" }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: BuddyUser, rhs: BuddyUser) -> Bool { lhs.id == rhs.id }
}

struct FamilyUser: Identifiable, Hashable {
    let id: UUID
    let firstName: String
    let lastName: String
    let relationship: String
    let linkedElderlyIDs: [UUID]

    var fullName: String { "\(firstName) \(lastName)" }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: FamilyUser, rhs: FamilyUser) -> Bool { lhs.id == rhs.id }
}

// MARK: - Reviews & certificates & courses

struct Review: Identifiable, Hashable {
    let id: UUID
    let stars: Int
    let body: String
    let authorName: String
    let date: Date
}

struct Certification: Identifiable, Hashable {
    let id: UUID
    let level: ServiceLevel
    let issuedAt: Date
    let expiresAt: Date
}

// MARK: - Course content types

enum ModuleType: String, Hashable { case video, quiz, reading }

struct QuizQuestionData: Identifiable, Hashable {
    let id: UUID
    let question: String
    let options: [String]
    let correctIndex: Int
    let explanation: String
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct ReadingSection: Identifiable, Hashable {
    let id: UUID
    let heading: String
    let body: String
    let symbol: String
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct CourseModuleData: Identifiable, Hashable {
    let id: UUID
    let title: String
    let type: ModuleType
    let durationMinutes: Int
    let illustrationSymbol: String
    var isCompleted: Bool = false
    var videoDescription: String = ""
    var readingSections: [ReadingSection] = []
    var quizQuestions: [QuizQuestionData] = []
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct Course: Identifiable, Hashable {
    let id: UUID
    let level: ServiceLevel
    let title: String
    let durationMinutes: Int
    var progressPercent: Int
    let unlocked: Bool
    let summary: String
    var requiresPhysicalCertification: Bool = false
    var modules: [CourseModuleData] = []
    var modulesCount: Int { modules.count }
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Earnings

struct EarningEntry: Identifiable, Hashable {
    let id: UUID
    let date: Date
    let elderlyName: String
    let category: TaskCategory
    let amountCents: Int
}

// MARK: - Activity items (family timeline)

struct ActivityItem: Identifiable, Hashable {
    let id: UUID
    let date: Date
    let icon: String
    let color: Color
    let title: String
    let detail: String

    static func == (lhs: ActivityItem, rhs: ActivityItem) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// CLLocationCoordinate2D Hashable conformance
extension CLLocationCoordinate2D: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }

    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
