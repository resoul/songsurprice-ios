import UIKit

public struct TabBarConfiguration {

    // Heights
    public var mainRowHeight: CGFloat
    public var genreRowHeight: CGFloat

    // Colors
    public var backgroundColor: UIColor
    public var separatorColor: UIColor
    public var activeColor: UIColor
    public var inactiveColor: UIColor
    public var focusedBgAlpha: CGFloat

    // Items
    public var items: [TabItem]

    public init(
        items: [TabItem],
        mainRowHeight: CGFloat = 76,
        genreRowHeight: CGFloat = 58,
        backgroundColor: UIColor = UIColor(red: 0.07, green: 0.07, blue: 0.11, alpha: 1),
        separatorColor: UIColor = UIColor(white: 1, alpha: 0.07),
        activeColor: UIColor = .white,
        inactiveColor: UIColor = UIColor(white: 0.45, alpha: 1),
        focusedBgAlpha: CGFloat = 0.18
    ) {
        self.items = items
        self.mainRowHeight = mainRowHeight
        self.genreRowHeight = genreRowHeight
        self.backgroundColor = backgroundColor
        self.separatorColor = separatorColor
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.focusedBgAlpha = focusedBgAlpha
    }
}
