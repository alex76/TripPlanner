import Core
import DesignSystem
import SwiftUI

struct TripListCell<DisclosureIndicator: View>: View {
    private typealias Localization = Resource.Text.TripList

    private let departure: String
    private let arrival: String
    private let stops: Int
    private let price: Double
    private let backgroundColor: Color
    private let borderColor: Color
    private let showBadge: Bool
    private let didSelect: () -> Void

    @ViewBuilder private let disclosureIndicator: () -> DisclosureIndicator

    init(
        departure: String,
        arrival: String,
        stops: Int,
        price: Double,
        backgroundColor: Color = Color(from: .white),
        borderColor: Color = Color(from: .grayBorder),
        showBadge: Bool = true,
        didSelect: @escaping () -> Void,
        @ViewBuilder disclosureIndicator: @escaping () -> DisclosureIndicator
    ) {
        self.departure = departure
        self.arrival = arrival
        self.stops = stops
        self.price = price
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.showBadge = showBadge
        self.didSelect = didSelect
        self.disclosureIndicator = disclosureIndicator
    }

    var body: some View {
        CapsuleView(radius: Theme.radii.r3, borderWidth: 1, borderColor: borderColor) {
            ClearButton(action: didSelect) {
                content()
            }
        }
    }

    @ViewBuilder
    private func content() -> some View {
        HStack {
            connectionView()
            Spacer()
            VStack {
                TextView(
                    verbatim: Constant.Formatter.price.string(from: NSNumber(value: price)) ?? "",
                    .headline
                )
                .foregroundColor(Color(from: .black))
            }
            disclosureIndicator()
        }
        .padding(Theme.space.s2)
        .background(backgroundColor)
    }

    @ViewBuilder
    private func connectionView() -> some View {
        VStack(alignment: .leading, spacing: Theme.space.s0) {
            HStack {
                ConnectionLine(
                    position: .start,
                    lineWidth: Theme.borderWidths.b3,
                    background: Color(from: .black)
                )
                .frame(width: 30, height: 36)

                TextView(verbatim: departure, .caption1).fontWeight(.bold)
                    .padding(.vertical, Theme.space.s2)
            }
            if showBadge {
                HStack {
                    ConnectionLine(
                        position: stops == 0 ? .middle : .middleGap,
                        lineWidth: Theme.borderWidths.b3,
                        background: Color(from: .black)
                    )
                    .frame(width: 30, height: 36)

                    CapsuleView(radius: Theme.radii.r3) {
                        TextView(verbatim: badge(stops), .caption2)
                            .foregroundColor(Color(from: .white))
                            .padding(.vertical, Theme.space.s1)
                            .padding(.horizontal, Theme.space.s2)
                            .background(Color(from: .blueTranslucent))
                    }
                }
            }
            HStack {
                ConnectionLine(
                    position: .end,
                    lineWidth: Theme.borderWidths.b3,
                    background: Color(from: .black)
                )
                .frame(width: 30, height: 36)

                TextView(verbatim: arrival, .caption1).fontWeight(.bold)
                    .padding(.vertical, Theme.space.s2)
            }
        }
    }

    private func badge(_ stops: Int) -> String {
        switch stops {
        case 0: return Localization.direct.localized
        case 1: return String(format: Localization.stop.localized, 1)
        default: return String(format: Localization.stops.localized, stops)
        }
    }
}

#if DEBUG
    struct TripListCell_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                TripListCell(
                    departure: "London",
                    arrival: "Porto",
                    stops: 0,
                    price: 120,
                    didSelect: {},
                    disclosureIndicator: { EmptyView() }
                )
                TripListCell(
                    departure: "London",
                    arrival: "Porto",
                    stops: 1,
                    price: 120,
                    backgroundColor: .yellow,
                    borderColor: Color(from: .blue),
                    didSelect: {},
                    disclosureIndicator: {
                        Image(systemName: "chevron.forward")
                            .font(.system(size: 15))
                            .foregroundColor(Color(from: .black))
                    }
                )
                TripListCell(
                    departure: "London",
                    arrival: "Porto",
                    stops: 3,
                    price: 120,
                    backgroundColor: .pink,
                    didSelect: {},
                    disclosureIndicator: {
                        Image(systemName: "map")
                            .font(.system(size: 15))
                            .foregroundColor(Color(from: .black))
                    }
                )
            }
            .padding()
            .background(Color.white)
            .previewLayout(.sizeThatFits)
        }
    }
#endif
