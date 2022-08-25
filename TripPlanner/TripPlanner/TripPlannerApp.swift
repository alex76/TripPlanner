import Core
import Repository
import SwiftUI

@main
struct TripPlannerApp: App {
    private let container: DIContainer

    init() {
        let repositoryService = RepositoryService()

        let elements: [ServiceProtocol] = [
            repositoryService
        ]

        self.container = DIContainer(
            services: .init(elements: elements)
        )
    }

    var body: some Scene {
        WindowGroup {
            if let tripRepository = container.tripRepository {
                ContentView()
                    .environmentObject(container)
            }
        }
    }
}
