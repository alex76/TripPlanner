import SwiftUI

public struct BackButton: View {

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    public init() {}

    public var body: some View {
        Button(
            action: { self.presentationMode.wrappedValue.dismiss() }
        ) {
            Image(systemName: "chevron.backward")
                .font(.system(size: 18))
                .frame(width: 35, height: 35)
                .foregroundColor(.primary)
        }
        .padding(.all, Theme.space.s1)
    }
}

#if DEBUG
    struct BackButton_Previews: PreviewProvider {
        static var previews: some View {
            BackButton()
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
#endif
