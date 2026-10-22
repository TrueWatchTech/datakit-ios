import TrueWatchSDK
import TrueWatchSDKSwiftUI
import SwiftUI

@main
struct SwiftUIConsumer: App {
    init() {
        _ = FTSDKAgent.sharedInstance()
        FTRUMSwiftUI.trackTapAction(name: "launch")
    }

    var body: some Scene {
        WindowGroup {
            Text("TrueWatch")
                .ftTrackRUMView(name: "Root")
        }
    }
}
