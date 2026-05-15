import SwiftUI

enum BCColors {
    static let primary = Color(red: 0.082, green: 0.259, blue: 0.451)
    static let primaryDark = Color(red: 0.043, green: 0.176, blue: 0.341)
    static let primaryMuted = Color(red: 0.082, green: 0.259, blue: 0.451).opacity(0.08)

    static let accent = Color(red: 0.945, green: 0.631, blue: 0.380)
    static let accentDark = Color(red: 0.847, green: 0.498, blue: 0.235)

    static let background = Color(red: 0.973, green: 0.969, blue: 0.957)
    static let surface = Color.white
    static let surfaceMuted = Color(red: 0.953, green: 0.949, blue: 0.937)

    static let textPrimary = Color(red: 0.110, green: 0.122, blue: 0.137)
    static let textSecondary = Color(red: 0.353, green: 0.376, blue: 0.412)
    static let textTertiary = Color(red: 0.561, green: 0.580, blue: 0.612)

    static let border = Color(red: 0.890, green: 0.886, blue: 0.871)

    static let success = Color(red: 0.180, green: 0.553, blue: 0.341)
    static let warning = Color(red: 0.882, green: 0.620, blue: 0.067)
    static let danger = Color(red: 0.769, green: 0.196, blue: 0.220)

    static let level0 = Color(red: 0.553, green: 0.612, blue: 0.671)
    static let level1 = Color(red: 0.118, green: 0.510, blue: 0.737)
    static let level2 = Color(red: 0.439, green: 0.275, blue: 0.604)
    static let level3 = Color(red: 0.769, green: 0.196, blue: 0.220)
    static let level4 = Color(red: 0.110, green: 0.122, blue: 0.137)
}

enum BCSpacing {
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

enum BCRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 18
    static let xl: CGFloat = 28
    static let pill: CGFloat = 999
}
