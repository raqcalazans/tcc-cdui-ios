import SwiftUI

@main
struct AmantesDoFutebolApp: App {
    var body: some Scene {
        WindowGroup {
            let service: NetworkServiceProtocol = ProcessInfo.processInfo.arguments.contains("--screenshot-tests")
                ? ScreenshotPreviewNetworkService()
                : NetworkService()
            FanListView(networkService: service)
        }
    }
}
