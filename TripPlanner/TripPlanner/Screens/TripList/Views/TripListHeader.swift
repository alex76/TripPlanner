import DesignSystem
import SwiftUI
import Utilities

struct TripListHeader: View {
    private typealias Localization = Resource.Text.TripList

    let departureName: String?
    let arrivalName: String?

    let onSelectDeparture: () -> Void
    let onSelectArrival: () -> Void
    let onSwapDestinations: () -> Void

    var body: some View {
        HStack {
            VStack {
                InputView(
                    icon: Image(systemName: "airplane.departure"),
                    placeholder: Localization.selectCity.localized,
                    placeholderPrefix: Localization.from.localized,
                    selection: departureName,
                    action: onSelectDeparture
                )
                InputView(
                    icon: Image(systemName: "airplane.arrival"),
                    placeholder: Localization.selectCity.localized,
                    placeholderPrefix: Localization.to.localized,
                    selection: arrivalName,
                    action: onSelectArrival
                )
            }
            ClearButton(action: onSwapDestinations) {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 17))
                    .foregroundColor(Color(from: .white))
            }
        }
    }
}

extension TripListHeader {
    private struct InputView: View {

        let icon: Image
        let placeholder: String
        let placeholderPrefix: String
        let selection: String?
        let action: () -> Void

        var body: some View {
            CapsuleView(
                radius: Theme.radii.r2,
                borderWidth: Theme.borderWidths.b1,
                borderColor: Color(from: .white)
            ) {
                ClearButton(action: action) {
                    HStack {
                        icon
                            .font(.system(size: 15))
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(from: .white))

                        TextView(verbatim: placeholderPrefix, .caption1)
                            .foregroundColor(Color(from: .white).opacity(0.5))

                        TextView(verbatim: selection ?? placeholder, .headline)
                            .foregroundColor(
                                selection != nil
                                    ? Color(from: .white) : Color(from: .white).opacity(0.75)
                            )

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(Theme.space.s2)
                    .background(Color.white.opacity(0.001))
                }
            }
        }
    }
}

#if DEBUG
    struct TripListHeader_Previews: PreviewProvider {
        static var previews: some View {
            TripListHeader(
                departureName: nil,
                arrivalName: nil,
                onSelectDeparture: {},
                onSelectArrival: {},
                onSwapDestinations: {}
            )
            .padding()
            .background(Color.black)
            .previewLayout(.sizeThatFits)
        }
    }
#endif
