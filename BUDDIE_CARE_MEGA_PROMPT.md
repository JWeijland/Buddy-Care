# BUDDIE CARE — DEFINITIVE MEGA PROMPT v2
> Feed this entire file to Claude Code to autonomously build the Buddie Care iOS app.
> Version: 2.0 | Target: iOS 17+ SwiftUI | Mode: Autonomous execution

---

## PART 0 — HOW TO EXECUTE THIS PROMPT

You are operating as an **autonomous Claude Code agent**. Execute every part of this prompt without pausing for clarification. When you encounter a decision, make the best call and document it with a `// DECISION:` comment. Commit after each numbered build step.

### Ground rules
- **Clean slate**: Delete all existing `.swift` files in the Xcode project except `Buddie_CareApp.swift` and `Assets.xcassets`. Rebuild everything from scratch per this spec.
- **Mock-first**: All external services (payments, KYC, camera, push, backend) are mocked with clearly marked `// TODO[real-integration]:` comments. No network calls, no API keys required.
- **Commit cadence**: One `git commit` per numbered build step. Message format: `[step N] description`.
- **Language**: Code and comments in English. All UI strings in Dutch. Use `String(localized:)` for every user-visible string so i18n works later.
- **No questions**: If something is ambiguous, make a sensible decision and proceed.

### Stack decisions (already made)
- SwiftUI + `@Observable` (iOS 17 Observation framework — no TCA, no Combine overhead)
- SwiftData for local persistence (mock "backend")
- MapKit for maps
- SF Symbols for icons
- No third-party dependencies in MVP

---

## PART 1 — VISION & PRODUCT

**Company:** Buddie Care
**Tagline:** *"Hulp om de hoek, met een hart erbij."*
**Bundle ID:** `com.buddiecare.ios`
**Minimum iOS:** 17.0

### Problem
In the Netherlands, care demand is projected to require ~75% more spending by 2040 to maintain current service levels. There is a shortage of care workers, growing loneliness among the elderly, and overburdened informal carers. Many small care tasks (medication reminders, groceries, company, help getting to bed) do not require a qualified nurse.

### Solution
A marketplace platform — *"Uber Eats for light care"* — connecting elderly people and their families with screened buddies (primarily care students in cities like Rotterdam and Amsterdam) for on-demand small care tasks. Buddies earn money and build certified experience; elderly people get flexible, vetted help.

### Three-year goals
- **Year 1:** Pilot Rotterdam + Amsterdam, 500+ elderly, 1,500+ buddies
- **Year 2:** Partnership with 1 insurer + 2 municipalities (WMO budget)
- **Year 3:** 10,000+ active elderly, certified routes to Level 3

### Target audiences
1. **The Elderly ("Oma/Opa")** — 70+, living independently, possible light mobility/cognitive challenges. Needs simplicity, large text, trust, and a sense of safety.
2. **The Buddy** — 18–30, often a care student (HBO-V, MBO Verzorgende IG, Social Work, Medicine). Wants flexible income + practical experience. Tech-native.
3. **The Family Member** — 40–65, child/grandchild of elderly. Often lives at a distance. Wants oversight, can request tasks on behalf of elderly, wants notifications.

---

## PART 2 — SERVICE LEVELS

> **Legal disclaimer (show in app at onboarding):** Voorbehouden handelingen (Wet BIG art. 36) zoals injecteren en katheteriseren mogen nooit worden uitgevoerd door niet-BIG-geregistreerde personen. Buddie Care biedt deze taken niet aan. Level 4 is niet beschikbaar totdat een partnership met een BIG-geregistreerde organisatie is afgesloten.

### Level 0 — Basis Buddy
*Unlocked by: ID verification + VOG approval*
- Companionship (coffee, walking, reading aloud, watching TV together)
- Light grocery shopping
- Light tidying (no heavy lifting)
- Accompanying to appointments (no medical context)
- Hourly rate: €13

### Level 1 — Huishoud & Mobiliteit Buddy
*Unlocked by: Level 0 + e-learning module 1 (~2 hours)*
- Support stockings on/off
- Help getting up/sitting with mobility aid
- Warming and serving meals
- Laundry, making beds
- Hourly rate: €16

### Level 2 — Zorgondersteuning Buddy
*Unlocked by: Level 1 + e-learning + practical assessment (~8 hours, co-signed by BIG-registered supervisor)*
- Medication reminder + supervised intake (no injectables or high-risk medication)
- Washing assistance at the sink (not full shower/bath)
- Eating/drinking assistance for swallowing difficulties (after specific instruction)
- Toilet assistance
- Hourly rate: €20

### Level 3 — Verzorgende Buddy
*Unlocked by: Official Verzorgende IG diploma or HBO-V student year 2+*
- Full ADL (Activities of Daily Living)
- Stoma care (after practical assessment)
- Non-complex wound care
- Administering oral medication per schedule
- Hourly rate: €25 + travel costs €0.23/km after 5 km

### Level 4 — Verpleegkundig *(NOT IN MVP)*
*BIG-registered nurses only. Blocked until formal partnership established.*

---

## PART 3 — UX RESEARCH SUMMARY

*Based on analysis of Helpling, Care.com, Careship.de, and academic research on elderly smartphone UX (MIT AgeLab, Nielsen Norman Group, Kurniawan & Zaphiris 2005/2020).*

### 3.1 Personas

**Oma Riet** (78, widow, Rotterdam-Zuid, light arthritis, children in Brabant)
- Jobs-to-be-done:
  - "When I need to go to the doctor and my son can't come, I want to book someone reliable, so I feel safe and don't have to cancel."
  - "When I've been alone all day, I want someone to have coffee with, so I don't feel lonely."
  - "When my medication is ready, I want a reminder with someone there, so I don't forget or take the wrong amount."

**Opa Henk** (84, early dementia, lives with partner)
- Jobs-to-be-done:
  - "When my wife is tired, I want someone else to help me get ready for bed, so she can rest."
  - "When I want to go outside, I want someone to walk with me, so I don't get lost."

**Familielid Sandra** (52, Riet's daughter, busy job, guilt about distance)
- Jobs-to-be-done:
  - "When I'm at work and mom needs help, I want to book a buddy from my phone, so I don't have to leave my desk."
  - "When a buddy visits mom, I want a notification when they arrive and leave, so I feel reassured."
  - "When something goes wrong, I want an instant SOS alert, so I can act immediately."

**Buddy Aiyla** (21, HBO-V year 2, Rotterdam, wants experience + income)
- Jobs-to-be-done:
  - "When I have a free afternoon, I want to see tasks near me on a map, so I can pick up work spontaneously."
  - "When I help the same elderly person weekly, I want to become their fixed buddy, so I build a relationship and get priority alerts."
  - "When I complete Level 1 e-learning, I want a certified badge on my profile, so elderly families trust me more."

**Buddy Mark** (28, care background, wants to transition to freelance)
- Jobs-to-be-done:
  - "When I do a Level 3 task, I want my diploma automatically visible on my profile, so I get higher-paying work without explaining myself."
  - "When I've done 50 tasks, I want a clear earnings summary for my tax return, so I can manage my ZZP finances easily."

### 3.2 Key User Journeys

**Journey 1: Family member books help on behalf of elderly**
1. Sandra opens app → Family tab → "Hulp aanvragen voor Riet"
2. Selects task category (large icon tiles, one per screen)
3. Picks timing: Now / Today / Schedule
4. Sees price + confirmation
5. Buddy accepts → Sandra gets push + SMS: "Aiyla komt over 12 minuten"
6. Buddy arrives → Sandra gets: "Aiyla is aangekomen bij Riet"
7. Task complete → Sandra gets summary with duration + buddy's note

**Journey 2: Buddy accepts and completes a task**
1. Aiyla sees map pin near her (orange, Level 0)
2. Taps pin → task detail sheet (elderly first name, task, distance, pay)
3. One-tap accept → navigates via Apple Maps deeplink
4. QR check-in on arrival (mocked in MVP)
5. Checklist during task (marked off, visible to family)
6. Completes → writes short note → rates elderly → earnings updated

**Journey 3: Elderly person uses SOS**
1. Riet taps the persistent SOS button (bottom right, always visible)
2. Confirmation modal: "Weet u zeker dat u hulp nodig heeft?"
3. On confirm: calls 112 (deeplink) + sends push to all family + favorite buddies
4. Family receives: "🚨 SOS van Riet — bel direct"

**Journey 4: Buddy advances from Level 0 to Level 1**
1. Aiyla sees "Level 1 beschikbaar" banner in Courses tab
2. Opens module: video + quiz (mocked video player, real quiz logic)
3. Passes quiz (≥80%) → certificate generated → badge appears on profile
4. Map now shows Level 1 tasks (previously grayed out)

### 3.3 Accessibility Requirements (Research-backed)

**Tap targets:** Minimum **60×60pt** for all interactive elements (MIT AgeLab research; Apple HIG minimum is 44pt but is insufficient for 70+ users). Primary CTAs must be at least **72pt tall**.

**Typography:** Default to Dynamic Type **XL** (20pt body). Floor at 16pt for any visible label. Use `Font.Weight.regular` or `.medium` minimum — never `.light` or `.thin`. Line height: 1.45×.

**Color contrast:** WCAG 2.2 **AAA** (7:1) for all body text. AA (4.5:1) minimum for decorative text.

**VoiceOver:** Every interactive element must have an `.accessibilityLabel`. Every icon-only button must have a descriptive label (not the SF Symbol name).

**Dynamic Type:** All layouts must support up to `accessibility5` size class without truncation. Use `minimumScaleFactor` only as a last resort.

**Language:** B1 level Dutch. No jargon. "Medicatie-toezicht" is explained as "Wij zorgen dat u uw medicijnen op tijd inneemt."

**No dark mode as default** for elderly mode. System dark mode can be honored for buddy/family modes.

**SMS fallback:** All critical push notifications (buddy accepted, arrived, SOS) must also trigger an SMS (mocked; `// TODO[real-integration]: Twilio SMS`).

**Phone escape hatch:** Every onboarding screen must show a persistent "Hulp nodig? Bel ons: 085-XXX XXXX" footer (mock number). This reduces drop-off for elderly users who get stuck.

### 3.4 Anti-patterns (never do these)
- No dark default theme in elderly mode
- No swipe-only gestures — always provide tap alternatives
- No carousels without visible forward/back buttons
- No time-limited notifications that disappear before the elderly user reads them
- No map view in "buddy is coming" screen for elderly — use a simple progress bar instead
- No bundled privacy wall — show one AVG consent screen per data category
- No icon-only buttons — always pair with a text label in elderly mode

---

## PART 4 — DESIGN SYSTEM (BuddieKit)

Build the entire design system as a single file `DesignSystem/BuddieKit.swift` that other files import via struct namespacing.

### 4.1 Color Palette

```swift
// Primary — deep navy (trust, "rijksoverheid-adjacent")
primary      = Color(red: 0.082, green: 0.259, blue: 0.451)   // #154273
primaryDark  = Color(red: 0.043, green: 0.176, blue: 0.341)
primaryMuted = primary.opacity(0.08)

// Accent — warm coral/orange (human warmth)
accent     = Color(red: 0.945, green: 0.490, blue: 0.310)   // #F17D4F
accentDark = Color(red: 0.820, green: 0.380, blue: 0.200)

// Backgrounds
background   = Color(red: 0.973, green: 0.969, blue: 0.957)  // warm off-white
surface      = Color.white
surfaceMuted = Color(red: 0.953, green: 0.949, blue: 0.937)

// Text — AAA contrast on background
textPrimary   = Color(red: 0.110, green: 0.122, blue: 0.137)  // near-black
textSecondary = Color(red: 0.353, green: 0.376, blue: 0.412)
textTertiary  = Color(red: 0.561, green: 0.580, blue: 0.612)

// Semantic
border  = Color(red: 0.890, green: 0.886, blue: 0.871)
success = Color(red: 0.180, green: 0.553, blue: 0.341)
warning = Color(red: 0.882, green: 0.620, blue: 0.067)
danger  = Color(red: 0.769, green: 0.196, blue: 0.220)

// Level colors (map pin + badge colors)
level0 = Color(red: 0.553, green: 0.612, blue: 0.671)  // slate
level1 = Color(red: 0.118, green: 0.510, blue: 0.737)  // blue
level2 = Color(red: 0.439, green: 0.275, blue: 0.604)  // purple
level3 = Color(red: 0.820, green: 0.300, blue: 0.200)  // red-orange
level4 = Color(red: 0.110, green: 0.122, blue: 0.137)  // dark
```

### 4.2 Typography

```swift
// Elderly mode — larger sizes
elderlyTitle    = Font.system(size: 28, weight: .bold, design: .rounded)
elderlyHeading  = Font.system(size: 22, weight: .semibold, design: .rounded)
elderlyBody     = Font.system(size: 20, weight: .regular, design: .rounded)
elderlyCaption  = Font.system(size: 17, weight: .regular, design: .rounded)

// Standard mode (buddy/family)
largeTitle  = Font.system(.largeTitle, design: .rounded).weight(.bold)
title2      = Font.system(.title2, design: .rounded).weight(.bold)
title3      = Font.system(.title3, design: .rounded).weight(.semibold)
headline    = Font.system(.headline, design: .rounded)
body        = Font.system(.body, design: .rounded)
subheadline = Font.system(.subheadline, design: .rounded)
caption     = Font.system(.caption, design: .rounded)
captionEmphasized = Font.system(.caption, design: .rounded).weight(.semibold)
```

All fonts use `.rounded` design for friendliness. Use `@ScaledMetric` for all spacing/size values to support Dynamic Type.

### 4.3 Spacing & Radius

```swift
Spacing: xxs=2, xs=4, sm=8, md=16, lg=24, xl=32, xxl=48
Radius:  sm=8, md=12, lg=18, xl=28, pill=999
```

### 4.4 Component Catalog

Build each as a separate struct in `BuddieKit.swift`:

**BCPrimaryButton** — full-width, 72pt height, rounded corners, haptic feedback on tap. `.accessibilityLabel` required param.

**BCSecondaryButton** — outlined variant, same height.

**BCBigTile** — large tappable card (120pt+ height) with icon, title, subtitle, color accent strip on left. For elderly home screen.

**BCCard** — white rounded card with shadow, accepts `@ViewBuilder` content.

**BCNavBar** — custom top nav with title, optional subtitle, optional back button. Avoids NavigationView title truncation issues.

**BCStatusPill** — small colored capsule label (e.g., "Buddy onderweg").

**BCRatingStars** — 1–5 star display with half-star support.

**BCBadgeLevel** — level badge (number + color + title). Used on buddy profiles.

**BCProgressBar** — labeled progress bar for course completion.

**BCMapPin** — custom map annotation: colored circle + SF Symbol icon + triangle pointer. Color = task's required level color.

**BCVOGBadge** — blue shield icon + "VOG geverifieerd" + expiry date + "Wat is een VOG?" info button that shows a modal explanation.

**BCToast** — bottom-anchored transient message with icon, auto-dismisses after 3 seconds.

**BCOnboardingPhoneFooter** — persistent footer view showing "Hulp nodig? Bel ons: 085-XXX XXXX" for use on all onboarding screens.

---

## PART 5 — DATA MODELS

All models in `Models/Models.swift`. All mock data in `Models/MockData.swift`.

### 5.1 Enums

```swift
enum UserRole: String, CaseIterable     // elderly, buddy, family
enum ServiceLevel: Int, CaseIterable    // 0–4
enum TaskCategory: String, CaseIterable // companionship, groceries, medicationReminder,
                                        // bedHelp, lightCleaning, mealPrep,
                                        // walkOutdoors, appointment, other
enum TaskTiming: Hashable               // now, today(hour:), scheduled(date:)
enum TaskStatus: String                 // open, accepted, arrived, inProgress,
                                        // completed, cancelled
enum KYCStatus: String                  // pending, approved, rejected
enum VOGStatus: String                  // pending, submitted, approved, expired
enum CourseStatus: String               // locked, available, inProgress, completed
```

### 5.2 Core Structs

```swift
struct ElderlyUser: Identifiable        // id, firstName, lastName, address,
                                        // coordinate, dateOfBirth, phoneNumber,
                                        // allergies, medicationNotes,
                                        // favoriteBuddyIDs, familyMemberIDs,
                                        // creditEuros, prefersFormal: Bool

struct BuddyUser: Identifiable          // id, firstName, lastName, photoName,
                                        // level, certifications, ratingAverage,
                                        // totalTasksCompleted, bio, study,
                                        // kycStatus, vogStatus, vogExpiresAt,
                                        // ibanLast4, isAvailableNow

struct FamilyUser: Identifiable         // id, firstName, lastName, relationship,
                                        // linkedElderlyIDs, notificationPrefs

struct ServiceTask: Identifiable        // id, elderlyName, elderlyAddress,
                                        // coordinate, category, requiredLevel,
                                        // timing, note, priceCents, status,
                                        // createdAt, assignedBuddyID?,
                                        // assignedBuddyName?, assignedBuddyRating?,
                                        // assignedBuddyEtaMinutes?,
                                        // checklistItems: [ChecklistItem],
                                        // completionNote?, completedAt?

struct ChecklistItem: Identifiable      // id, label, isCompleted

struct Review: Identifiable             // id, taskID, stars, body, authorName,
                                        // date, isVisible

struct Certification: Identifiable      // id, level, issuedAt, expiresAt,
                                        // certificateHash (mock UUID)

struct Course: Identifiable             // id, level, title, durationMinutes,
                                        // modulesCount, modules: [CourseModule],
                                        // status, progressPercent

struct CourseModule: Identifiable       // id, title, type (video/quiz/reading),
                                        // durationMinutes, isCompleted

struct EarningEntry: Identifiable       // id, date, elderlyName, category,
                                        // grossCents, netCents (after 20% commission)

struct ActivityItem: Identifiable       // id, date, icon, color, title, detail
                                        // (for family timeline)

struct Favorite: Identifiable           // id, elderlyID, buddyUser,
                                        // priorityMinutes (default 5)
```

### 5.3 AppState (@Observable)

`App/AppState.swift` — single source of truth for the entire app.

```swift
@Observable final class AppState {
    // Auth
    var currentRole: UserRole? = nil
    var isOnboardingComplete: Bool = false

    // User data
    var elderlyUser: ElderlyUser
    var buddyUser: BuddyUser
    var familyUser: FamilyUser

    // Tasks
    var openTasks: [ServiceTask]
    var activeTaskForElderly: ServiceTask?
    var activeTaskForBuddy: ServiceTask?
    var taskHistory: [ServiceTask]

    // UI state
    var showSOS: Bool = false
    var toastMessage: ToastMessage?

    // Actions
    func requestHelp(category:timing:note:) -> ServiceTask
    func simulateBuddyAccepts(taskID:)
    func buddyAcceptsTask(_:)
    func buddyArrives()
    func buddyCompletes(notes:)
    func triggerSOS()
    func resetToRoleSelection()
}
```

### 5.4 Mock Data

`MockData.swift` must include:
- `omaRiet` — ElderlyUser, Rotterdam-Zuid, 78 years old
- `opaHenk` — ElderlyUser, Rotterdam-Noord, 84 years old
- `buddyAiyla` — BuddyUser, Level 1, 4.9 stars, 22 tasks, HBO-V student
- `buddyMark` — BuddyUser, Level 2, 4.7 stars, 87 tasks
- `familySandra` — FamilyUser, linked to omaRiet
- `openTasks` — 6 tasks spread around Rotterdam/Amsterdam coordinates, various levels and categories
- `completedTasks` — 5 completed tasks with notes and ratings
- `availableCourses` — all 4 level-up courses (Level 0→1, 1→2, 2→3, 3→4)
- `earningHistory` — 8 entries over the past 2 months
- `activityFeed` — 6 activity items for Sandra's timeline
- `rotterdamCenter` — CLLocationCoordinate2D(latitude: 51.9225, longitude: 4.4792)

---

## PART 6 — APP FLOWS (Screen by Screen)

The app has one Xcode target. After login, a `RoleSelectionView` routes to one of three tab-based flows. Each flow is a `TabView` with its own `NavigationStack` per tab.

### A. ELDERLY MODE

All text in elderly mode uses `BCTypography.elderlyBody` or larger. All buttons minimum 72pt height. No map in elderly mode (replaced by simple status displays).

**A1. SplashView**
- Buddie Care logo (centered, large)
- Tagline: "Hulp om de hoek, met een hart erbij."
- "Aan de slag" button
- Fades into RoleSelectionView

**A2. RoleSelectionView**
- Three large BCBigTile cards (full-width, stacked):
  - "Ik ben oudere" — icon: figure.wave
  - "Ik ben buddy" — icon: person.2.fill
  - "Ik ben familielid" — icon: house.and.flag.fill
- Each tile is 110pt tall minimum
- Tapping routes to respective onboarding or home flow
- "Hulp nodig? Bel ons" footer always visible

**A3. ElderlyTabView** — 3 tabs:
1. Home (house.fill)
2. Mijn Buddies (person.2.fill)
3. Profiel (gearshape.fill)

**A4. ElderlyHomeView** (tab 1)
- BCNavBar: "Hallo [Voornaam]" + "Buddy Care"
- If active task: `ActiveTaskBanner` (prominent card showing status, buddy name, ETA as text "komt om 14:32" not a map)
- Three BCBigTile buttons:
  1. "Hulp vragen" → RequestHelpFlow (sheet)
  2. "Mijn vaste buddies" → switches to Buddies tab
  3. "Bezoek aan de deur" → MockCameraView (placeholder: grey rectangle + "Camera wordt binnenkort geactiveerd")
- Recent visits list (last 3 completed tasks)
- **Persistent floating SOS button** (bottom-right, 72×72pt red circle, always on top of all content)

**A5. RequestHelpFlow** (modal sheet, 3 steps)

*Step 1 — Wat heeft u nodig?*
- Title: "Wat heeft u nodig?" (elderlyTitle size)
- Grid of large icon tiles (2 columns), one per TaskCategory
- Each tile: 90pt height, SF Symbol icon (32pt) + category name
- "Anders" tile at end

*Step 2 — Wanneer?*
- Three large option cards:
  - "Nu" (clock.fill) — green accent
  - "Later vandaag" (calendar) — shows hour picker when selected
  - "Een andere dag" (calendar.badge.plus) — shows date + time picker
- Selected card gets primary color border

*Step 3 — Bevestigen*
- Summary card: task name, timing, estimated price
- "VOG geverifieerd buddy" trust badge
- "Hulp aanvragen" primary button (72pt)
- "Annuleren" ghost button
- On confirm: calls `appState.requestHelp(...)`, shows BCToast "Wij zoeken een buddy voor u!", dismisses sheet
- After 3 seconds: simulate buddy acceptance with `simulateBuddyAccepts()`

**A6. BuddyEnRouteView** (shown when task.status == .accepted)
- Shown as `ActiveTaskBanner` on home + as full detail on tap
- Animated progress bar: "Op weg" → "Onderweg" → "Bijna er!"
- Buddy name, photo placeholder (circle with initials), star rating
- ETA as human text: "Aiyla komt om ± 14:32"
- Call buddy button (mock — shows BCToast "Bellen is binnenkort beschikbaar")
- **No map view** (research shows maps are cognitively complex for 70+ users)

**A7. BuddyArrivedView** (shown when task.status == .arrived)
- Full-screen green background confirmation
- Large checkmark animation
- "[Naam] staat voor de deur!"
- "Open de deur" instructional text (not a button — just guidance)
- Camera placeholder card

**A8. ReviewView** (after task completion)
- "Hoe was het bezoek van [Naam]?"
- 5 large star buttons (minimum 60×60pt each)
- Optional: "Vertel er iets meer over" text field
- "Verstuur beoordeling" button
- Skip option: "Misschien later"

**A9. MyBuddiesView** (tab 2)
- List of favorite buddies with:
  - Large photo circle (60pt diameter) with initials placeholder
  - Name, level badge, star rating, session count
  - BCVOGBadge component
  - "Hulp aanvragen" quick action button
- Empty state: "U heeft nog geen vaste buddies. Na uw eerste bezoek kunt u een buddy als favoriet markeren."

**A10. ElderlyProfileView** (tab 3)
- Name, address, phone
- "Grote letters" toggle (increases app font one size)
- "Formeel/Informeel" toggle (U vs jij) — stored in `prefersFormal`
- Linked family members list
- "Uitloggen" button (returns to RoleSelectionView)
- App version + "AVG conform | VOG-gescreend | WMO-erkend (in aanvraag)" trust row at bottom

---

### B. BUDDY MODE

**B1. BuddyTabView** — 4 tabs:
1. Kaart (map.fill)
2. Verdiensten (eurosign.circle.fill)
3. Cursussen (graduationcap.fill)
4. Profiel (person.crop.circle)

**B2. BuddyMapView** (tab 1)
- Full-screen MapKit map, Rotterdam/Amsterdam starting region
- BCMapPin annotations for each open task (color = required level color, icon = category icon)
- Floating top bar: "Buddy Care" branding + open task count pill
- Filter strip: level filter pills (Niv. 0 / Niv. 1 / Niv. 2 / Niv. 3) — shows tasks at or below selected level
- Tapping a pin → `TaskDetailSheet` (`.presentationDetents([.medium, .large])`)
- When `activeTaskForBuddy` is not nil → full-screen `TaskInProgressView`

**B3. TaskDetailSheet**
- Elderly first name + neighborhood (never full address until accepted)
- Task category icon + name (large)
- Required level badge
- Distance: "1.2 km van u"
- Estimated pay: "€ 13,00 – 19,50" (1–1.5 hours)
- Session count for this elderly: "Eerste bezoek" or "Eerder 3× geholpen"
- "Accepteer taak" primary button (72pt)
- On accept: `appState.buddyAcceptsTask(task)` → triggers `TaskInProgressView`

**B4. TaskInProgressView** (full-screen modal)
*Sub-states driven by `task.status`:*

- **Accepted (onderweg):** Navigation deeplink button "Open in Kaarten" (Apple Maps), task summary, mock QR check-in button "Ik ben er — scan QR code" (shows mock QR scanner with "QR-code gesimuleerd ✓" after 1s)
- **Arrived:** Checklist of task-specific items (all unchecked initially). Buddy can check off items. Timer counting up. Chat button (mock). Panic button (red, "Hulp nodig").
- **Completing:** "Taak afronden" button → notes field + optional "voeg foto toe" placeholder + "Beoordeel oudere" (1–5 stars) → confirm

**B5. EarningsView** (tab 2)
- This week / This month toggle
- Total earnings card (large number, green)
- Breakdown: gross, platform commission (20%), net
- Scrollable list of `EarningEntry` rows: date, elderly name (first name only), task type, net amount
- "Fiscale export" button (mock: shows BCToast "Export wordt binnenkort beschikbaar — TODO[fiscal-export]")

**B6. CoursesView** (tab 3)
*This is part of the Training Institute workstream — see Part 7 for full spec.*
- Current level badge (large, prominent)
- Progress to next level: `BCProgressBar`
- List of courses:
  - Locked courses: grey, lock icon
  - Available: primary color, "Starten" button
  - In progress: progress bar + "Doorgaan"
  - Completed: green checkmark + certificate button
- Tapping available/in-progress course → `CourseDetailView`

**B7. CourseDetailView**
- Course title + level badge
- Duration + module count
- Module list (each row: icon for type, title, duration, completion status)
- "Start Module 1" or "Doorgaan met Module X" button
- On starting a module → `CourseModuleView`

**B8. CourseModuleView**
*For `type == .video`:*
- Grey placeholder rectangle with play button overlay + duration text
- "Video wordt binnenkort toegevoegd" label
- "Markeer als bekeken" button → marks module complete

*For `type == .quiz`:*
- 5 multiple-choice questions displayed one at a time
- Large radio button options (60pt tap targets)
- Progress indicator: "Vraag 3 van 5"
- On all answered: show score + pass/fail (≥80% = pass)
- On pass: mark module complete + trigger certificate generation if final module

*For `type == .reading`:*
- ScrollView with formatted text content (use lorem ipsum as mock content with `// TODO[real-content]`)
- "Klaar met lezen" button at bottom

**B9. CertificateView**
- Shown after passing final module quiz
- Certificate card (styled like a formal document):
  - Buddie Care logo
  - "Hierbij verklaren wij dat [Naam] succesvol het niveau [X] certificaat heeft behaald"
  - Date of issue + expiry (2 years)
  - Mock certificate hash (UUID string, truncated)
- "Deel certificaat" button (mock share sheet)
- "Terug naar cursussen" button
- Badge now appears on buddy profile

**B10. BuddyProfileView** (tab 4)
- Photo circle (initials placeholder)
- Name, study, bio
- Level badge row (all earned levels highlighted, future ones dimmed)
- Certifications list with `BCVOGBadge` + course certificates
- Rating + total tasks
- KYC status indicator (mock: "Identiteit geverifieerd ✓")
- VOG status indicator with BCVOGBadge
- IBAN last 4 digits (mock)
- "Beschikbaarheid instellen" toggle row (Beschikbaar / Niet beschikbaar)
- "Uitloggen" button

**B11. BuddyOnboardingFlow** (shown when `isOnboardingComplete == false`)
8 steps, one decision per screen, always show `BCOnboardingPhoneFooter`:

1. "Welkom bij Buddie Care" — value prop, "Begin aanmelding" button
2. Personal info — name, date of birth, city (large text fields, each on own line)
3. Photo — circular placeholder, "Kies foto" button (mock: shows placeholder avatar), skip option
4. ID verification — "Upload uw identiteitsbewijs" + selfie placeholder. Mock: "ID ontvangen ✓ — wij verifiëren binnen 24 uur" `// TODO[real-integration]: Onfido KYC`
5. VOG — "Upload uw VOG of vraag er één aan" + "Aanvragen via Justis" button (external link). Mock: "VOG ingediend ✓" `// TODO[real-integration]: VOG tracking`
6. Bank account — IBAN field + explanation text about payment timing `// TODO[real-integration]: SEPA mandate`
7. Availability — day/time picker (simplified: morning/afternoon/evening per day)
8. House rules + privacy agreement — scrollable text, "Ik ga akkoord" checkbox (required) + "Maak account aan" button

After step 8 → `VerificationPendingView`: "Uw aanvraag wordt beoordeeld. Dit duurt maximaal 2 werkdagen." + contact info + animated pending indicator.

---

### C. FAMILY MODE

**C1. FamilyTabView** — 3 tabs:
1. Overzicht (house.fill)
2. Activiteit (list.bullet.rectangle.fill)
3. Instellingen (gearshape.fill)

**C2. FamilyDashboardView** (tab 1)
- BCNavBar: "Hallo [Naam]" + subtitle: "Voor [Oudere voornaam]"
- Linked elderly card: photo placeholder, name, address, quick-call button
- "Hulp aanvragen" — large BCBigTile (primary color, hand.raised.fill icon)
- Active task card (if one exists): buddy name + ETA + status
- Quick action row: "Bel Riet" / "Stuur bericht" / "SOS check" (all mock with BCToast)

**C3. FamilyRequestHelpFlow**
- Same 3-step flow as elderly mode (`RequestHelpFlow` reused)
- Confirmation step shows: "U vraagt hulp namens [Oudere naam]"
- Price displayed, mock payment: "Betaling via automatische incasso — binnenkort in te stellen `// TODO[real-integration]: Mollie`"

**C4. ActivityTimelineView** (tab 2)
- Scrollable timeline of `ActivityItem` entries
- Each row: date/time, icon, title, detail (buddy name, task type, duration)
- Color-coded by event type (buddy arrived = primary blue, completed = success green, SOS = danger red)
- Filter: "Alle" / "Bezoeken" / "Meldingen"
- Pull-to-refresh (mock: shuffles order after delay)

**C5. FamilySettingsView** (tab 3)
- Linked elderly section: show Riet's account, "Koppeling beheren" (mock)
- Notifications section:
  - Toggle: Buddy accepted
  - Toggle: Buddy arrived
  - Toggle: Task completed
  - Toggle: SOS alerts (always on, non-toggleable, shows info tooltip)
- Payment section: "Betaalmethode toevoegen" (mock) `// TODO[real-integration]: Mollie`
- "Maandelijks rapport" toggle (mock)
- "Uitloggen"

**C6. FamilyLinkingView** (first-time flow)
- "Koppel met een oudere" screen
- 6-digit code entry (large digits, numeric keyboard)
- "Of scan de QR-code op de welkomstkaart" (mock QR scanner)
- On entry: mock validation → success → shows elderly user's name for confirmation

---

## PART 7 — BUSINESS WORKSTREAM: BUDDIE CARE OPLEIDINGSINSTITUUT

*This is a separate product workstream that runs in parallel with the marketplace. The long-term vision is for Buddie Care to become an Erkend Leerbedrijf (SBB) and eventually an accredited training institute. In MVP this is mocked; the structure is designed to be filled with real content.*

> **NOTE TO DEVELOPER:** The training program content should be co-developed with a domain expert (the founder's mother, who has a care background). Flag all `// TODO[course-content]:` markers for her review. The e-learning structure is built; only the actual content (videos, quiz questions, reading materials) needs to be added.

### 7.1 Certificate Levels mapped to Training

| App Level | Training path | Delivered by |
|-----------|--------------|--------------|
| Level 0 → 1 | E-learning module 1: Huishoudelijke ondersteuning & mobiliteit (~2u) | In-app video + quiz |
| Level 1 → 2 | E-learning module 2 + practical assessment (~8u) | In-app + Buddie Care trainer |
| Level 2 → 3 | Formal Verzorgende IG diploma or HBO-V year 2 | External institution |
| Level 3 → 4 | BIG registration | Not in MVP |

### 7.2 Practical Assessment Flow (Level 2 only)

After completing the Level 2 e-learning, buddies must schedule a practical assessment:

- `PracticalAssessmentView`: show available assessment dates (mock calendar with 3 upcoming slots)
- "Schrijf je in" button → mock confirmation → assessment booked
- Status shown on profile: "Praktijktoets ingepland op [datum]"
- After passing (admin marks in admin panel): certificate generated automatically
- `// TODO[real-integration]: Calendar booking system (Calendly or custom)`

### 7.3 Certificate Data Model

```swift
struct Certificate {
    let id: UUID
    let buddyID: UUID
    let level: ServiceLevel
    let issuedAt: Date
    let expiresAt: Date       // 2 years from issue
    let assessorName: String  // for Level 2
    let certificateHash: String // SHA-256 mock UUID
    let isValid: Bool         // computed from expiresAt
}
```

Certificate display: formal card design (see B9. CertificateView above).

Expiry reminder: BCToast + push when 60 days before expiry. `// TODO[real-integration]: push scheduling`

### 7.4 Admin Panel Note *(not iOS — web only)*

The admin panel (not built in this iOS project) must handle:
- Reviewing and approving buddy applications (KYC + VOG)
- Marking practical assessments as passed/failed
- Managing course content (video upload, quiz questions)
- Financial payouts
- Incident log
- Level/task configuration

`// TODO[admin-panel]: Build as separate web app (Next.js + Supabase)`

---

## PART 8 — MOCK SERVICES

Create `Services/MockServices.swift` containing all mock service objects. Each service has a protocol so it can be swapped for a real implementation later.

```swift
// MockPaymentService
// TODO[real-integration]: Replace with Mollie SDK
// - processPayment(taskID:amount:) async -> PaymentResult
// - Simulate 1.5s delay, always return .success
// - Show BCToast "Betaling verwerkt (gesimuleerd)"

// MockKYCService
// TODO[real-integration]: Replace with Onfido/Veriff SDK
// - submitIDVerification(userID:idImageData:selfieData:) async -> KYCResult
// - Simulate 2s delay, always return .pending
// - After 3s more: simulate .approved

// MockCameraService
// TODO[real-integration]: Replace with Ring/Aqara RTSP or WebRTC stream
// - getStreamURL(deviceID:) -> URL?
// - Returns nil, shows "Camera wordt binnenkort geactiveerd" placeholder

// MockSMSService
// TODO[real-integration]: Replace with Twilio SMS API
// - sendSMS(to:message:) — prints to console only
// - Called alongside all push notifications for critical events

// MockPushService
// TODO[real-integration]: Replace with APNs/OneSignal
// - send(notification:) — shows BCToast in-app instead of real push
// - Supports all notification types from Part 9
```

---

## PART 9 — PUSH NOTIFICATIONS

Define all notification types as an enum in `Models/NotificationModels.swift`:

| Type | Target | Message |
|------|--------|---------|
| `task.new_in_area` | Buddy | "[Naam] zoekt hulp — 1.2 km, Level 0, €13" |
| `task.priority_favorite` | Favorite buddy (5 min before open) | "[Naam] vraagt hulp! Jij hebt 5 min voorrang." |
| `task.accepted` | Elderly + family | "[Buddy naam] komt over [X] min." |
| `task.arrived` | Elderly + family | "[Buddy naam] staat voor de deur." |
| `task.completed` | Family | "Bezoek afgerond. Bekijk het verslag." |
| `sos.triggered` | All family + all favorites | "🚨 SOS van [Naam] — bel direct." |
| `kyc.approved` | Buddy | "Uw identiteit is geverifieerd. Welkom!" |
| `kyc.rejected` | Buddy | "Verificatie niet gelukt — neem contact op." |
| `payout.sent` | Buddy | "€[bedrag] is onderweg naar uw rekening." |
| `course.exam_available` | Buddy | "Niveau [X] examen is klaar voor u." |
| `certificate.expiring_soon` | Buddy | "Uw Level [X] certificaat verloopt over 60 dagen." |

All notifications in MVP are shown as in-app `BCToast` via `MockPushService`.

---

## PART 10 — COMPLIANCE MARKERS

Place these `// COMPLIANCE:` comments at the relevant code locations:

- Login/signup: `// COMPLIANCE: AVG art. 13 — privacy notice must be shown`
- Medical notes field: `// COMPLIANCE: WGBO — encrypted storage required, access logged`
- Task Level 2+: `// COMPLIANCE: Wkkgz — incident reporting required`
- VOG upload: `// COMPLIANCE: VOG required every 3 years, track expiry`
- BIG-level tasks: `// COMPLIANCE: Wet BIG art. 36 — blocked until BIG partnership`
- Chat messages: `// COMPLIANCE: AVG — auto-delete after 30 days`
- Analytics events: `// COMPLIANCE: No PII in analytics payloads`

---

## PART 11 — STEP-BY-STEP EXECUTION ORDER

Execute these steps in order. Commit after each step.

### Step 1 — Clean Slate + Project Structure
- Delete all existing `.swift` files except `Buddie_CareApp.swift`
- Create folder structure:
  ```
  Buddie Care/
  ├── App/
  │   ├── Buddie_CareApp.swift (keep, modify)
  │   ├── AppState.swift
  │   └── RootView.swift
  ├── DesignSystem/
  │   └── BuddieKit.swift
  ├── Models/
  │   ├── Models.swift
  │   ├── MockData.swift
  │   └── NotificationModels.swift
  ├── Services/
  │   └── MockServices.swift
  ├── Shared/
  │   ├── SplashView.swift
  │   └── RoleSelectionView.swift
  ├── Elderly/
  │   ├── ElderlyTabView.swift
  │   ├── ElderlyHomeView.swift
  │   ├── RequestHelpFlow.swift
  │   ├── MyBuddiesView.swift
  │   ├── ElderlyProfileView.swift
  │   └── SOSView.swift
  ├── Buddy/
  │   ├── BuddyTabView.swift
  │   ├── BuddyMapView.swift
  │   ├── TaskDetailSheet.swift
  │   ├── TaskInProgressView.swift
  │   ├── EarningsView.swift
  │   ├── CoursesView.swift
  │   ├── CourseDetailView.swift
  │   ├── CourseModuleView.swift
  │   ├── CertificateView.swift
  │   ├── BuddyProfileView.swift
  │   └── BuddyOnboardingFlow.swift
  └── Family/
      ├── FamilyTabView.swift
      ├── FamilyDashboardView.swift
      ├── ActivityTimelineView.swift
      ├── FamilySettingsView.swift
      └── FamilyLinkingView.swift
  ```
- Commit: `[step 1] clean slate + project structure`

### Step 2 — Design System
- Build all of `BuddieKit.swift` (colors, typography, spacing, all 14 components)
- Every component must have a `#Preview`
- Commit: `[step 2] BuddieKit design system`

### Step 3 — Models + Mock Data
- Build `Models.swift` (all enums + structs per Part 5)
- Build `MockData.swift` (all mock instances per Part 5.4)
- Build `NotificationModels.swift`
- Build `MockServices.swift`
- Build `AppState.swift`
- Commit: `[step 3] data models + mock data + app state`

### Step 4 — Navigation Shell
- Build `Buddie_CareApp.swift` (injects AppState, shows SplashView)
- Build `SplashView.swift` (logo, tagline, CTA)
- Build `RoleSelectionView.swift` (three large tiles)
- Build `RootView.swift` (switches between three TabViews based on `appState.currentRole`)
- Ensure full navigation works: tap role → correct tab view appears
- Commit: `[step 4] navigation shell + role selection`

### Step 5 — Elderly Mode (complete)
- Build all views in `Elderly/` per Part 6A spec
- Full flow: home → request help (3 steps) → active task banner → buddy en route → arrived → review
- SOS button functional (triggers `appState.triggerSOS()`, shows SOSView modal with 112 deeplink)
- Accessibility: all tap targets ≥60pt, elderly typography throughout, VoiceOver labels on every interactive element
- Commit: `[step 5] elderly mode complete`

### Step 6 — Buddy Map + Task Flow
- Build `BuddyMapView.swift` + `TaskDetailSheet.swift`
- Build `TaskInProgressView.swift` (all 3 sub-states)
- Map shows open tasks with `BCMapPin` annotations
- Level filter strip works
- Full flow: see task → accept → QR mock check-in → checklist → complete
- Commit: `[step 6] buddy map + task flow`

### Step 7 — Buddy Earnings + Profile
- Build `EarningsView.swift` (weekly/monthly toggle, earnings list)
- Build `BuddyProfileView.swift` (level badges, certifications, VOG badge, settings)
- Build `BuddyOnboardingFlow.swift` (8 steps with BCOnboardingPhoneFooter)
- Commit: `[step 7] buddy earnings + profile + onboarding`

### Step 8 — Training Institute (Courses)
- Build `CoursesView.swift`, `CourseDetailView.swift`, `CourseModuleView.swift`, `CertificateView.swift`
- Full flow: browse locked/available courses → open course → complete modules → pass quiz → receive certificate → badge on profile
- Level unlock mechanics: completing a course makes the next level's tasks visible on the map
- Commit: `[step 8] training institute — courses + certifications`

### Step 9 — Family Mode (complete)
- Build all views in `Family/` per Part 6C spec
- Full flow: link to elderly → dashboard → request help → activity timeline → settings
- Commit: `[step 9] family mode complete`

### Step 10 — Polish + Accessibility Audit
- Audit every view for:
  - All interactive elements have `.accessibilityLabel`
  - Tap targets ≥60pt in elderly mode
  - Contrast ratios (verify visually)
  - Dynamic Type support (test at XL size)
- Add `BCOnboardingPhoneFooter` to all onboarding screens
- Add `// COMPLIANCE:` markers per Part 10
- Smooth all navigation transitions
- Add haptic feedback to all primary button taps: `UIImpactFeedbackGenerator(style: .medium).impactOccurred()`
- Commit: `[step 10] accessibility audit + compliance markers`

### Step 11 — Final Integration Check
- Full end-to-end test of each flow:
  - Elderly: request → buddy arrives → review
  - Buddy: map → accept → check-in → complete → earnings updated
  - Family: link → request → timeline updated → SOS received
- Fix any navigation issues or state bugs
- Update `Buddie_CareApp.swift` app metadata (display name, bundle ID `com.buddiecare.ios`)
- Commit: `[step 11] integration + final fixes`

### Step 12 — README
- Write `README.md` with:
  - What is built (complete)
  - What is mocked (list of all `// TODO[real-integration]:` items)
  - What still needs a real developer (backend, Mollie, Onfido, camera, admin panel)
  - How to run: Xcode 15+, iOS 17 simulator or device
  - TestFlight submission checklist
  - Rough cost estimate per real integration
- Commit: `[step 12] README + project summary`

---

## PART 12 — QUALITY STANDARDS

### Code style
- Naming: descriptive over terse (`requestHelpButtonTapped()` not `btnAction()`)
- No comments that explain what the code does — only `// DECISION:`, `// TODO[x]:`, `// COMPLIANCE:` markers
- Each file owns one primary view or type — no mega-files
- `#Preview` macro on every view file

### Accessibility
- Every `Button`, `NavigationLink`, toggle, and text field: `.accessibilityLabel` set
- Every icon-only element: descriptive label (e.g., "SOS alarmknop" not "phone.fill.arrow.up.right")
- Elderly mode: all body text uses `BCTypography.elderlyBody` or larger
- Test with VoiceOver by running through the main flows mentally and ensuring labels make sense when read aloud

### Localization
- Every user-visible string: `String(localized: "key", defaultValue: "Nederlandse tekst")`
- No hardcoded Dutch strings outside of `String(localized:)` calls
- Localizable.strings file for `nl` locale

### No premature abstraction
- Do not create generic helpers for things used only once
- Do not add error handling for mock flows — mocks always succeed
- Do not add loading states unless they serve the UX (e.g., simulated buddy-finding delay)

---

## PART 13 — CONFIGURABLE VARIABLES

```swift
// Config.swift — single constants file
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
```

---

## PART 14 — WHAT A REAL DEVELOPER STILL NEEDS TO DO

Document this in README.md after building:

| Item | Effort | Cost estimate |
|------|--------|---------------|
| Supabase backend (auth, DB, realtime) | 3–4 weeks | €0 (free tier) + dev time |
| Mollie payment integration | 1 week | €0 + 1.8% per transaction |
| Onfido/iDIN KYC | 1 week | ~€2–5 per verification |
| VOG tracking integration (Justis) | 3 days | Free (manual process) |
| Real push notifications (APNs) | 3 days | Free |
| Twilio SMS | 2 days | ~€0.05 per SMS |
| Camera integration (Ring/Aqara API) | 2 weeks | Hardware cost ~€80/unit |
| Admin web panel (Next.js) | 4–6 weeks | Dev time |
| E-learning content (videos + quizzes) | Ongoing | Content production budget |
| App Store submission + review | 1 week | €99/year Apple developer |
| Legal review (privacy, compliance) | 2–3 weeks | €2,000–5,000 legal fees |
| Accessibility audit (external) | 1 week | €1,500–3,000 |

---

*End of Buddie Care Mega Prompt v2. Begin execution at Part 0, Step 1.*
