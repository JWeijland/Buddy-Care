import SwiftUI

enum BCTypography {
    // Standard mode (buddy/family) — all use .rounded per spec
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let title = Font.system(size: 28, weight: .bold, design: .rounded)
    static let titleEmphasized = Font.system(size: 22, weight: .heavy, design: .rounded)
    static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let headline = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 17, weight: .regular, design: .rounded)
    static let bodyEmphasized = Font.system(size: 17, weight: .semibold, design: .rounded)
    static let subheadline = Font.system(size: 15, weight: .regular, design: .rounded)
    static let callout = Font.system(size: 16, weight: .regular, design: .rounded)
    static let caption = Font.system(size: 13, weight: .regular, design: .rounded)
    static let captionEmphasized = Font.system(size: 13, weight: .semibold, design: .rounded)

    // Elderly mode — larger sizes, minimum 20pt body per accessibility spec
    static let elderlyTitle = Font.system(size: 28, weight: .bold, design: .rounded)
    static let elderlyHeading = Font.system(size: 24, weight: .bold, design: .rounded)
    static let elderlyBody = Font.system(size: 20, weight: .regular, design: .rounded)
    static let elderlyCaption = Font.system(size: 17, weight: .regular, design: .rounded)
    static let elderlyButton = Font.system(size: 22, weight: .semibold, design: .rounded)
}

// MARK: - Elderly large-text scale

struct BCElderlyType {
    let large: Bool
    // Normal → Large: each step adds ~6pt
    var title:   Font { .system(size: large ? 36 : 28, weight: .bold,     design: .rounded) }
    var heading: Font { .system(size: large ? 30 : 24, weight: .bold,     design: .rounded) }
    var body:    Font { .system(size: large ? 26 : 20, weight: .regular,  design: .rounded) }
    var caption: Font { .system(size: large ? 21 : 17, weight: .regular,  design: .rounded) }
    var button:  Font { .system(size: large ? 28 : 22, weight: .semibold, design: .rounded) }
    var iconBoxSize: CGFloat { large ? 88 : 72 }
    var iconSize:    CGFloat { large ? 40 : 32 }
    var tileHeight:  CGFloat { large ? 148 : 120 }
}

// MARK: - EnvironmentKey so every elderly view inherits the flag

private struct LargeTextEnabledKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var largeTextEnabled: Bool {
        get { self[LargeTextEnabledKey.self] }
        set { self[LargeTextEnabledKey.self] = newValue }
    }
}
