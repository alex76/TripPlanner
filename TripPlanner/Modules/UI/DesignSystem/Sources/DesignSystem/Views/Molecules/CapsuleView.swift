import SwiftUI
import Utilities

public struct CapsuleView<Label: View>: View {

    private let radius: CGFloat
    private let borderWidth: CGFloat
    private let borderColor: SwiftUI.Color?
    private let borderGradient: SwiftUI.LinearGradient?
    @ViewBuilder private let labelBuilder: () -> Label

    public init(
        radius: CGFloat,
        borderWidth: CGFloat = 0,
        borderColor: SwiftUI.Color? = nil,
        borderGradient: SwiftUI.LinearGradient? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.radius = radius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.borderGradient = borderGradient
        self.labelBuilder = label
    }

    public var body: some View {
        labelBuilder()
            .clipShape(
                RoundedCornersShape(
                    radius: radius,
                    corners: [.allCorners]
                )
            )
            .if(borderWidth > 0) { view -> AnyView in
                let overlay: AnyView
                if let gradient = borderGradient {
                    overlay = RoundedRectangle(cornerRadius: radius)
                        .stroke(gradient, lineWidth: borderWidth)
                        .eraseToAnyView()
                } else if let color = borderColor {
                    overlay = RoundedRectangle(cornerRadius: radius)
                        .stroke(color, lineWidth: borderWidth)
                        .eraseToAnyView()
                } else {
                    overlay = EmptyView().eraseToAnyView()
                }
                return view.overlay(overlay).eraseToAnyView()
            }
    }
}

#if DEBUG
    struct CapsuleTextView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                CapsuleView(
                    radius: Theme.radii.r3,
                    borderWidth: 2
                ) {
                    TextView(verbatim: "text example")
                        .padding()
                }
                CapsuleView(
                    radius: Theme.radii.r5,
                    borderWidth: 0
                ) {
                    TextView(verbatim: "text example 2")
                        .padding()
                        .background(Color.blue)
                }
            }
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }
#endif
