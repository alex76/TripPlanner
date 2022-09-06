import DesignSystem
import SwiftUI

struct TripStopListHeader: View {

    let departureName: String
    let arrivalName: String
    let price: Double

    private let priceFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        return currencyFormatter
    }()

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
            TextView(verbatim: priceFormatter.string(from: .init(value: price)) ?? "", .headline)
        }
        .foregroundColor(Color(from: .white))
    }
}

#if DEBUG
    struct TripStopListHeader_Previews: PreviewProvider {
        static var previews: some View {
            TripStopListHeader(
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
