import SwiftUI

private struct NavigationAppearanceModifier: ViewModifier {
    init(
        backgroundColor: UIColor,
        foregroundColor: UIColor,
        tintColor: UIColor?,
        hideSeparator: Bool
    ) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        navBarAppearance.titleTextAttributes = [.foregroundColor: foregroundColor]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: foregroundColor]
        navBarAppearance.backgroundColor = backgroundColor
        if hideSeparator {
            navBarAppearance.shadowColor = .clear
        }
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder =
            NSAttributedString(
                string: "search",
                attributes: [.foregroundColor: foregroundColor.withAlphaComponent(0.5)]
            )
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes =
            [.foregroundColor: foregroundColor]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor =
            foregroundColor

        if let tintColor = tintColor {
            UINavigationBar.appearance().tintColor = tintColor
        }
    }

    func body(content: Content) -> some View {
        content
    }
}

extension View {
    public func navigationAppearance(
        backgroundColor: Color,
        foregroundColor: Color,
        tintColor: Color? = nil,
        hideSeparator: Bool = false
    ) -> some View {
        self.modifier(
            NavigationAppearanceModifier(
                backgroundColor: UIColor(backgroundColor),
                foregroundColor: UIColor(foregroundColor),
                tintColor: tintColor != nil ? UIColor(tintColor!) : nil,
                hideSeparator: hideSeparator
            )
        )
    }

    public func blueNavigationAppearance() -> some View {
        navigationAppearance(
            backgroundColor: Color(from: .blueTranslucent),
            foregroundColor: Color(from: .white),
            tintColor: Color(from: .white),
            hideSeparator: true
        )
    }
}
