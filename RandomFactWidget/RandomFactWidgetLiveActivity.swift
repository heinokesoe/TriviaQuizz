//
//  RandomFactWidgetLiveActivity.swift
//  RandomFactWidget
//
//  Created by God on 30/8/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct RandomFactWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct RandomFactWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RandomFactWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension RandomFactWidgetAttributes {
    fileprivate static var preview: RandomFactWidgetAttributes {
        RandomFactWidgetAttributes(name: "World")
    }
}

extension RandomFactWidgetAttributes.ContentState {
    fileprivate static var smiley: RandomFactWidgetAttributes.ContentState {
        RandomFactWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: RandomFactWidgetAttributes.ContentState {
         RandomFactWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: RandomFactWidgetAttributes.preview) {
   RandomFactWidgetLiveActivity()
} contentStates: {
    RandomFactWidgetAttributes.ContentState.smiley
    RandomFactWidgetAttributes.ContentState.starEyes
}
