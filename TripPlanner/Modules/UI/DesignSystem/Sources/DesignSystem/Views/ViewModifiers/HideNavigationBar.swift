import SwiftUI
import Utilities

public struct HiddenNavigationBar: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .navigationTitle("")
            .navigationBarHidden(true)
    }
}

extension View {
    @ViewBuilder
    public func hiddenNavigationBar(
        showBackButton: Bool = false
    ) -> some View {
        if showBackButton {
            ZStack {
                modifier(HiddenNavigationBar())
                VStack {
                    if showBackButton {
                        BackButton().leadingAligned()
                    }
                    Spacer()
                }
            }
        } else {
            modifier(HiddenNavigationBar())
        }
    }
}
