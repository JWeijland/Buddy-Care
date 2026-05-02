import Foundation

enum Config {
    static let platformCommissionPercent: Double = 0.20
    static let maxTaskRadiusKm: Double = 10.0
    static let favoriteBuddyPriorityMinutes: Int = 5
    static let vogRenewalYears: Int = 3
    static let reviewVisibilityDelayHours: Int = 48
    static let certificateValidityYears: Int = 2
    static let certificateExpiryWarningDays: Int = 60

    static let launchCities: [String] = ["Rotterdam", "Amsterdam"]
    static let launchQuarter: String = "Q3 2026"
    static let minimumBuddyAge: Int = 18

    // Pricing (cents per hour, base rate)
    static let priceLevel0CentsPerHour: Int = 1300
    static let priceLevel1CentsPerHour: Int = 1600
    static let priceLevel2CentsPerHour: Int = 2000
    static let priceLevel3CentsPerHour: Int = 2500
    static let travelCostCentsPerKmAfter5: Int = 23

    // Mock contact (replace before TestFlight)
    static let supportPhoneNumber: String = "085-XXX XXXX"
    static let supportEmail: String = "hulp@buddiecare.nl"

    // Feature flags (all false for MVP)
    static let enableRealPayments: Bool = false
    static let enableKYCVerification: Bool = false
    static let enableCameraStream: Bool = false
    static let enableRealPushNotifications: Bool = false
}
