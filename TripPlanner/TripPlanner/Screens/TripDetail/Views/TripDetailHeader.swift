import Core
import DesignSystem
import SwiftUI

struct TripDetailHeader: View {

    let departureName: String
    let arrivalName: String
    let price: Double

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
            TextView(
                verbatim: Constant.Formatter.price.string(from: .init(value: price)) ?? "",
                .headline
            )
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
                price: 1200
            )
            .background(Color.blue)
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }
#endif
