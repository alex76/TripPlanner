import Core
import DesignSystem
import SwiftUI

struct TripDetailHeader: View {

    let departureName: String
    let arrivalName: String
    let price: Double
    let onOpenMap: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                TextView(verbatim: departureName, .largeTitle)
                HStack {
                    Image(systemName: "arrow.forward")
                        .font(.system(size: 24))

                    TextView(verbatim: arrivalName, .largeTitle)
                }
            }
            Spacer()
            VStack(alignment: .trailing, spacing: Theme.space.s3) {
                TextView(
                    verbatim: Constant.Formatter.price.string(from: .init(value: price)) ?? "",
                    .headline
                )
                CapsuleView(
                    radius: Theme.radii.r2,
                    borderWidth: Theme.borderWidths.b1,
                    borderColor: Color(from: .white)
                ) {
                    ClearButton(action: onOpenMap) {
                        Image(systemName: "map")
                            .font(.system(size: 15))
                            .foregroundColor(Color(from: .white))
                            .padding(Theme.space.s2)
                    }
                    .background(Color.black.opacity(0.05))
                }
            }
        }
        .foregroundColor(Color(from: .white))
    }
}

#if DEBUG
    struct TripDetailHeader_Previews: PreviewProvider {
        static var previews: some View {
            TripDetailHeader(
                departureName: "London",
                arrivalName: "Porto",
                price: 1200,
                onOpenMap: {}
            )
            .background(Color.blue)
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }
#endif
