import SwiftUI

public struct CapsuleButton: View {

    private let textViewContent: TextViewContent
    private let radius: CGFloat
    private let textColor: SwiftUI.Color
    private let backgroundColor: SwiftUI.Color
    private let backgroundGradient: SwiftUI.LinearGradient?
    private let borderWidth: CGFloat
    private let borderColor: SwiftUI.Color?
    private let borderGradient: SwiftUI.LinearGradient?
    private let action: () -> Void

    public init(
        verbatim: String,
        radius: CGFloat = Theme.radii.r3,
        textColor: SwiftUI.Color = .systemBackground,
        backgroundColor: SwiftUI.Color = .primary,
        backgroundGradient: SwiftUI.LinearGradient? = nil,
        borderWidth: CGFloat = 0,
        borderColor: SwiftUI.Color? = nil,
        borderGradient: SwiftUI.LinearGradient? = nil,
        action: @escaping () -> Void
    ) {
        self.init(
            .verbatim(verbatim),
            radius: radius,
            textColor: textColor,
            backgroundColor: backgroundColor,
            backgroundGradient: backgroundGradient,
            borderWidth: borderWidth,
            borderColor: borderColor,
            borderGradient: borderGradient,
            action: action
        )
    }

    public init(
        _ content: TextViewContent,
        radius: CGFloat = Theme.radii.r3,
        textColor: SwiftUI.Color = .systemBackground,
        backgroundColor: SwiftUI.Color = .primary,
        backgroundGradient: SwiftUI.LinearGradient? = nil,
        borderWidth: CGFloat = 0,
        borderColor: SwiftUI.Color? = nil,
        borderGradient: SwiftUI.LinearGradient? = nil,
        action: @escaping () -> Void
    ) {
        self.textViewContent = content
        self.radius = radius
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.backgroundGradient = backgroundGradient
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.borderGradient = borderGradient
        self.action = action
    }

    public init<T: LocalizedEnum>(
        localizedEnum: T,
        radius: CGFloat = Theme.radii.r3,
        textColor: SwiftUI.Color = .systemBackground,
        backgroundColor: SwiftUI.Color = .primary,
        backgroundGradient: SwiftUI.LinearGradient? = nil,
        borderWidth: CGFloat = 0,
        borderColor: SwiftUI.Color? = nil,
        borderGradient: SwiftUI.LinearGradient? = nil,
        action: @escaping () -> Void
    ) {
        self.init(
            verbatim: localizedEnum.localized,
            radius: radius,
            textColor: textColor,
            backgroundColor: backgroundColor,
            backgroundGradient: backgroundGradient,
            borderWidth: borderWidth,
            borderColor: borderColor,
            borderGradient: borderGradient,
            action: action
        )
    }

    public var body: some View {
        CapsuleView(
            radius: radius,
            borderWidth: borderWidth,
            borderColor: borderColor,
            borderGradient: borderGradient
        ) {
            ClearButton(action: action) {
                HStack {
                    Spacer()
                    TextView(textViewContent)
                        .foregroundColor(textColor)
                    Spacer()
                }
                .padding(.vertical, Theme.space.s2)
                .background(
                    backgroundGradient?.eraseToAnyView()
                        ?? backgroundColor.eraseToAnyView()
                )
            }
        }
    }

}

#if DEBUG
    struct CapsuleButton_Previews: PreviewProvider {
        static var previews: some View {
            CapsuleButton(verbatim: "example text", action: {})
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
#endif
