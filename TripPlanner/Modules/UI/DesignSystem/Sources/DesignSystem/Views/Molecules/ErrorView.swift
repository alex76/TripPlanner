import SwiftUI

// MARK: - ErrorView
public struct ErrorView: View {

    let error: ErrorView.Variant
    let action: (() -> Void)?

    init(error: Variant, action: (() -> Void)? = nil) {
        self.error = error
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 64) {
            ErrorViewContent(
                icon: error.content.icon,
                title: error.content.title,
                description: error.content.description
            )
            .padding(.horizontal, 8)

            action.map { action in
                Button(action: action) {
                    Text(error.content.buttonLabel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: 44)
                .padding(.horizontal, 20)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: -  ErrorViewContent
struct ErrorViewContent: View {
    let icon: Image?
    let title: String
    let description: String?

    init(
        icon: Image? = nil,
        title: String,
        description: String? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
    }

    var body: some View {
        VStack(spacing: 64) {
            icon.map { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 54, height: 50)
            }

            VStack(spacing: 40) {
                Text(title)
                    .fixedSize(horizontal: false, vertical: true)

                description.map {
                    Text($0)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .multilineTextAlignment(TextAlignment.center)
    }
}

// MARK: - ErrorView.Variant
extension ErrorView {
    enum Variant {
        case noConnection
        case noData(String?)
        case general(String?)
    }
}

// MARK: - ErrorView.Variant.Content
extension ErrorView.Variant {
    private typealias Localization = Resource.Text.Error

    struct Content {
        let icon: Image?
        let title: String
        let description: String?
        let buttonLabel: String
    }

    var content: Content {
        switch self {
        case .noConnection:
            return .init(
                icon: nil,
                title: Localization.noConnection.localized,
                description: Localization.noConnectionCheck.localized,
                buttonLabel: Localization.actionRetry.localized
            )
        case let .noData(key):
            return .init(
                icon: nil,
                title: Localization.noData.localized,
                description: key,
                buttonLabel: Localization.actionRetry.localized
            )
        case let .general(key):
            return .init(
                icon: nil,
                title: Localization.general.localized,
                description: key,
                buttonLabel: Localization.actionRetry.localized
            )
        }
    }
}

#if DEBUG
    struct ErrorView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                ErrorView(error: .noData("data processing error")) {}

                ErrorView(error: .noConnection) {}

                ErrorView(error: .general("Unexpected thing occurred")) {}
            }
            .padding(4)
            .previewLayout(.fixed(width: 300, height: 300))
        }
    }
#endif
