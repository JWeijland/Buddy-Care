import Foundation
import CoreLocation

enum MockData {
    static let rotterdamCenter = CLLocationCoordinate2D(latitude: 51.9244, longitude: 4.4777)

    static let omaRiet = ElderlyUser(
        id: UUID(),
        firstName: "Riet",
        lastName: "van der Berg",
        address: "Aelbrechtskade 142, Rotterdam",
        coordinate: CLLocationCoordinate2D(latitude: 51.9183, longitude: 4.4541),
        dateOfBirth: Calendar.current.date(from: DateComponents(year: 1948, month: 3, day: 12))!,
        phoneNumber: "06 12 34 56 78",
        allergies: ["Penicilline"],
        medicationNotes: "2x daags bloeddrukpil — om 08:00 en 20:00",
        favoriteBuddyIDs: [],
        familyMemberIDs: [],
        creditEuros: 10.0
    )

    static let opaHenk = ElderlyUser(
        id: UUID(),
        firstName: "Henk",
        lastName: "de Boer",
        address: "Mathenesserlaan 88, Rotterdam",
        coordinate: CLLocationCoordinate2D(latitude: 51.9131, longitude: 4.4538),
        dateOfBirth: Calendar.current.date(from: DateComponents(year: 1940, month: 7, day: 4))!,
        phoneNumber: "06 98 76 54 32",
        allergies: [],
        medicationNotes: "Bloeddrukmedicatie — ochtend",
        favoriteBuddyIDs: [],
        familyMemberIDs: [],
        creditEuros: 0.0
    )

    static let buddyAiyla = BuddyUser(
        id: UUID(),
        firstName: "Aiyla",
        lastName: "Demir",
        avatarSystemName: "person.crop.circle.fill",
        level: .one,
        certifications: [
            Certification(id: UUID(), level: .zero, issuedAt: Date().addingTimeInterval(-86400 * 90), expiresAt: Date().addingTimeInterval(86400 * 365 * 2)),
            Certification(id: UUID(), level: .one, issuedAt: Date().addingTimeInterval(-86400 * 30), expiresAt: Date().addingTimeInterval(86400 * 365 * 2))
        ],
        ratingAverage: 4.9,
        totalTasks: 47,
        bio: "Hallo! Ik ben Aiyla, 21 jaar en HBO-V student in Rotterdam. Ik help graag met gezelschap en lichte zorgtaken.",
        study: "HBO-V — jaar 2, Hogeschool Rotterdam",
        kycVerified: true,
        vogValid: true,
        vogExpiresAt: Date().addingTimeInterval(86400 * 365 * 3),
        ibanLast4: "2481",
        isAvailableNow: true
    )

    static let buddyMark = BuddyUser(
        id: UUID(),
        firstName: "Mark",
        lastName: "Janssen",
        avatarSystemName: "person.crop.circle.fill",
        level: .two,
        certifications: [],
        ratingAverage: 4.7,
        totalTasks: 112,
        bio: "Ervaren buddy met zorgachtergrond. Beschikbaar in de avonden.",
        study: "Sociale Studies — afgerond",
        kycVerified: true,
        vogValid: true,
        vogExpiresAt: Date().addingTimeInterval(86400 * 365 * 2),
        ibanLast4: "9012",
        isAvailableNow: false
    )

    static let buddySophie = BuddyUser(
        id: UUID(),
        firstName: "Sophie",
        lastName: "de Wit",
        avatarSystemName: "person.crop.circle.fill",
        level: .zero,
        certifications: [],
        ratingAverage: 4.6,
        totalTasks: 8,
        bio: "Geneeskundestudent, hou van koffie drinken en kletsen.",
        study: "Geneeskunde — jaar 1, Erasmus MC",
        kycVerified: true,
        vogValid: true,
        vogExpiresAt: Date().addingTimeInterval(86400 * 365 * 3),
        ibanLast4: "3344",
        isAvailableNow: true
    )

    static var allBuddies: [BuddyUser] { [buddyAiyla, buddyMark, buddySophie] }

    static let familySandra = FamilyUser(
        id: UUID(),
        firstName: "Sandra",
        lastName: "van der Berg",
        relationship: "Dochter van Riet",
        linkedElderlyIDs: [omaRiet.id]
    )

    // Open tasks visible on the buddy map
    static let openTasks: [ServiceTask] = [
        ServiceTask(
            id: UUID(),
            elderlyName: "Riet",
            elderlyAddress: "Aelbrechtskade 142",
            coordinate: CLLocationCoordinate2D(latitude: 51.9183, longitude: 4.4541),
            category: .companionship,
            requiredLevel: .zero,
            timing: .now,
            note: "Een uurtje koffie en kletsen, ze voelt zich wat alleen vandaag.",
            priceCents: 1300,
            status: .open,
            createdAt: Date().addingTimeInterval(-300),
            assignedBuddyName: nil,
            assignedBuddyRating: nil,
            assignedBuddyEtaMinutes: nil
        ),
        ServiceTask(
            id: UUID(),
            elderlyName: "Henk",
            elderlyAddress: "Mathenesserlaan 88",
            coordinate: CLLocationCoordinate2D(latitude: 51.9131, longitude: 4.4538),
            category: .groceries,
            requiredLevel: .zero,
            timing: .today(hour: 16),
            note: "Boodschappenlijstje ligt op de keukentafel.",
            priceCents: 1500,
            status: .open,
            createdAt: Date().addingTimeInterval(-1800),
            assignedBuddyName: nil,
            assignedBuddyRating: nil,
            assignedBuddyEtaMinutes: nil
        ),
        ServiceTask(
            id: UUID(),
            elderlyName: "Truus",
            elderlyAddress: "Heemraadssingel 21",
            coordinate: CLLocationCoordinate2D(latitude: 51.9139, longitude: 4.4499),
            category: .mealPrep,
            requiredLevel: .one,
            timing: .today(hour: 18),
            note: "Maaltijd opwarmen en samen eten.",
            priceCents: 1800,
            status: .open,
            createdAt: Date().addingTimeInterval(-2400),
            assignedBuddyName: nil,
            assignedBuddyRating: nil,
            assignedBuddyEtaMinutes: nil
        ),
        ServiceTask(
            id: UUID(),
            elderlyName: "Kees",
            elderlyAddress: "Schiedamseweg 412",
            coordinate: CLLocationCoordinate2D(latitude: 51.9072, longitude: 4.4338),
            category: .walkOutdoors,
            requiredLevel: .zero,
            timing: .now,
            note: "Een kort rondje langs het park, ongeveer 30 minuten.",
            priceCents: 1300,
            status: .open,
            createdAt: Date().addingTimeInterval(-600),
            assignedBuddyName: nil,
            assignedBuddyRating: nil,
            assignedBuddyEtaMinutes: nil
        ),
        ServiceTask(
            id: UUID(),
            elderlyName: "Beatrix",
            elderlyAddress: "Vasteland 14",
            coordinate: CLLocationCoordinate2D(latitude: 51.9099, longitude: 4.4823),
            category: .lightCleaning,
            requiredLevel: .zero,
            timing: .scheduled(date: Date().addingTimeInterval(86400)),
            note: "Stofzuigen en de afwas wegzetten.",
            priceCents: 1500,
            status: .open,
            createdAt: Date().addingTimeInterval(-3600),
            assignedBuddyName: nil,
            assignedBuddyRating: nil,
            assignedBuddyEtaMinutes: nil
        ),
        ServiceTask(
            id: UUID(),
            elderlyName: "Wim",
            elderlyAddress: "Coolsingel 76",
            coordinate: CLLocationCoordinate2D(latitude: 51.9217, longitude: 4.4794),
            category: .medicationReminder,
            requiredLevel: .two,
            timing: .today(hour: 20),
            note: "Toezicht houden bij avondmedicatie volgens schema.",
            priceCents: 2200,
            status: .open,
            createdAt: Date().addingTimeInterval(-900),
            assignedBuddyName: nil,
            assignedBuddyRating: nil,
            assignedBuddyEtaMinutes: nil
        )
    ]

    static let completedTasks: [ServiceTask] = [
        {
            var t = ServiceTask(
                id: UUID(),
                elderlyName: "Riet",
                elderlyAddress: "Aelbrechtskade 142",
                coordinate: CLLocationCoordinate2D(latitude: 51.9183, longitude: 4.4541),
                category: .companionship,
                requiredLevel: .zero,
                timing: .scheduled(date: Date().addingTimeInterval(-86400 * 2)),
                note: "Koffie drinken en samen kruiswoordpuzzel.",
                priceCents: 1300,
                status: .completed,
                createdAt: Date().addingTimeInterval(-86400 * 2),
                assignedBuddyName: "Aiyla",
                assignedBuddyRating: 4.9,
                assignedBuddyEtaMinutes: 0
            )
            t.completedAt = Date().addingTimeInterval(-86400 * 2 + 3600)
            t.completionNote = "Riet was vrolijk, samen koffie gedronken en wat over haar kleinkinderen gepraat."
            return t
        }(),
        {
            var t = ServiceTask(
                id: UUID(),
                elderlyName: "Riet",
                elderlyAddress: "Aelbrechtskade 142",
                coordinate: CLLocationCoordinate2D(latitude: 51.9183, longitude: 4.4541),
                category: .groceries,
                requiredLevel: .zero,
                timing: .scheduled(date: Date().addingTimeInterval(-86400 * 5)),
                note: "Boodschappenlijstje van AH halen.",
                priceCents: 1500,
                status: .completed,
                createdAt: Date().addingTimeInterval(-86400 * 5),
                assignedBuddyName: "Sophie",
                assignedBuddyRating: 4.6,
                assignedBuddyEtaMinutes: 0
            )
            t.completedAt = Date().addingTimeInterval(-86400 * 5 + 5400)
            t.completionNote = "Boodschappen gedaan, alles netjes opgeruimd in de keuken."
            return t
        }(),
        {
            var t = ServiceTask(
                id: UUID(),
                elderlyName: "Riet",
                elderlyAddress: "Aelbrechtskade 142",
                coordinate: CLLocationCoordinate2D(latitude: 51.9183, longitude: 4.4541),
                category: .walkOutdoors,
                requiredLevel: .zero,
                timing: .scheduled(date: Date().addingTimeInterval(-86400 * 9)),
                note: "Een ommetje langs het park.",
                priceCents: 1300,
                status: .completed,
                createdAt: Date().addingTimeInterval(-86400 * 9),
                assignedBuddyName: "Aiyla",
                assignedBuddyRating: 4.9,
                assignedBuddyEtaMinutes: 0
            )
            t.completedAt = Date().addingTimeInterval(-86400 * 9 + 2700)
            t.completionNote = "Mooi weer, lekker gewandeld langs het Heemraadssingel."
            return t
        }()
    ]

    static let courses: [Course] = CourseContent.allCourses

    static let earnings: [EarningEntry] = [
        EarningEntry(id: UUID(), date: Date().addingTimeInterval(-86400), elderlyName: "Riet", category: .companionship, amountCents: 1040),
        EarningEntry(id: UUID(), date: Date().addingTimeInterval(-86400 * 2), elderlyName: "Wim", category: .groceries, amountCents: 1200),
        EarningEntry(id: UUID(), date: Date().addingTimeInterval(-86400 * 3), elderlyName: "Truus", category: .mealPrep, amountCents: 1440),
        EarningEntry(id: UUID(), date: Date().addingTimeInterval(-86400 * 4), elderlyName: "Beatrix", category: .lightCleaning, amountCents: 1200),
        EarningEntry(id: UUID(), date: Date().addingTimeInterval(-86400 * 6), elderlyName: "Henk", category: .walkOutdoors, amountCents: 1040),
        EarningEntry(id: UUID(), date: Date().addingTimeInterval(-86400 * 7), elderlyName: "Riet", category: .companionship, amountCents: 1040),
        EarningEntry(id: UUID(), date: Date().addingTimeInterval(-86400 * 9), elderlyName: "Kees", category: .walkOutdoors, amountCents: 1040)
    ]

    static let reviewsForBuddy: [Review] = [
        Review(id: UUID(), stars: 5, body: "Aiyla was zo lief voor mijn moeder. Ze maakt echt verbinding.", authorName: "Sandra (familielid van Riet)", date: Date().addingTimeInterval(-86400 * 2)),
        Review(id: UUID(), stars: 5, body: "Op tijd, vriendelijk en goed gewerkt.", authorName: "Wim, 81", date: Date().addingTimeInterval(-86400 * 5)),
        Review(id: UUID(), stars: 4, body: "Prima bezoek, kwam wel iets later dan afgesproken.", authorName: "Truus, 76", date: Date().addingTimeInterval(-86400 * 12))
    ]

    static var familyActivity: [ActivityItem] {
        [
            ActivityItem(id: UUID(), date: Date().addingTimeInterval(-3600 * 2), icon: "checkmark.circle.fill", color: BCColors.success, title: "Bezoek voltooid", detail: "Aiyla bracht een uur door met Riet. Notitie: Riet was vrolijk."),
            ActivityItem(id: UUID(), date: Date().addingTimeInterval(-86400 * 2), icon: "bag.fill", color: BCColors.primary, title: "Boodschappen gedaan", detail: "Sophie deed boodschappen bij AH (€ 23,40 contant gegeven)."),
            ActivityItem(id: UUID(), date: Date().addingTimeInterval(-86400 * 4), icon: "figure.walk", color: BCColors.accent, title: "Wandeling", detail: "Aiyla wandelde 30 min met Riet in het Heemraadspark."),
            ActivityItem(id: UUID(), date: Date().addingTimeInterval(-86400 * 5), icon: "star.fill", color: BCColors.warning, title: "Beoordeling toegevoegd", detail: "Riet gaf Aiyla 5 sterren."),
            ActivityItem(id: UUID(), date: Date().addingTimeInterval(-86400 * 8), icon: "pills.fill", color: BCColors.level2, title: "Medicatie-reminder", detail: "Mark was aanwezig bij de avondmedicatie.")
        ]
    }
}
