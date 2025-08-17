import SwiftUI

/// Utility initialiser to create Color from hex string.
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

/// App colour palette.
extension Color {
    static let background = Color(hex: "#0B0B0D")
    static let surface = Color(hex: "#121214")
    static let accentPrimary = Color(hex: "#FF5A00")
    static let accentSecondary = Color(hex: "#FF8A33")
    static let textPrimary = Color(hex: "#FFFFFF")
    static let textMuted = Color(hex: "#BDBDBD")
}
