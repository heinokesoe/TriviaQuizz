//
//  RandomFactWidget.swift
//  RandomFactWidget
//
//  Created by God on 30/8/24.
//

import WidgetKit
import SwiftUI

struct Fact: Codable {
    let facts: [String]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), fact: "Loading...")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), fact: fetchRandomFact())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [SimpleEntry] = [SimpleEntry(date: Date(), fact: fetchRandomFact())]
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let timeline = Timeline(entries: entries, policy: .after(refreshDate))
        completion(timeline)
    }

    func fetchRandomFact() -> String {
        if let url = Bundle.main.url(forResource: "facts", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let factData = try JSONDecoder().decode(Fact.self, from: data)
                let facts = factData.facts
                return facts.randomElement() ?? "No fact found"
            } catch {
                print("Failed to load facts: \(error.localizedDescription)")
            }
        }
        return "No fact found"
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let fact: String
}

struct RandomFactWidgetEntryView: View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            Text(entry.fact)
                .font(.headline)
                .padding()
        case .systemMedium:
            VStack {
                Text("Did you know?")
                    .font(.headline)
                Text(entry.fact)
                    .font(.body)
            }
            .padding()
        default:
            Text(entry.fact)
                .font(.headline)
                .padding()
        }
    }
}

struct RandomFactWidget: Widget {
    let kind: String = "RandomFactWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RandomFactWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Random Fact")
        .description("Shows a random fact.")
        .supportedFamilies([.systemMedium])
    }
}


#Preview(as: .systemSmall) {
    RandomFactWidget()
} timeline: {
    SimpleEntry(date: .now, fact: "😀")
    SimpleEntry(date: .now, fact: "🤩")
}
