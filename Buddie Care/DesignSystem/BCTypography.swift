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
