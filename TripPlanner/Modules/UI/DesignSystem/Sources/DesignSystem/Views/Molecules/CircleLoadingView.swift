import SwiftUI

public struct CircleLoadingView: View {
    @State private var shouldAnimate = false

    public init() {}

    public var body: some View {
        HStack {
            Circle()
                .fill(Color(from: .blue))
                .frame(width: 20, height: 20)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(.easeInOut(duration: 0.5).repeatForever(), value: shouldAnimate)
            Circle()
                .fill(Color(from: .blue))
                .frame(width: 20, height: 20)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(
                    .easeInOut(duration: 0.5).repeatForever().delay(0.3),
                    value: shouldAnimate
                )
            Circle()
                .fill(Color(from: .blue))
                .frame(width: 20, height: 20)
                .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                .animation(
                    .easeInOut(duration: 0.5).repeatForever().delay(0.6),
                    value: shouldAnimate
                )
        }
        .onAppear {
            self.shouldAnimate = true
        }
    }

}

#if DEBUG
    struct CircleLoadingView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                CircleLoadingView()
            }
            .padding(4)
            .previewLayout(.sizeThatFits)
        }
    }
#endif
