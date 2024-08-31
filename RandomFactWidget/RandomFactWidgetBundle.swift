//
//  RandomFactWidgetBundle.swift
//  RandomFactWidget
//
//  Created by God on 30/8/24.
//

import WidgetKit
import SwiftUI

@main
struct RandomFactWidgetBundle: WidgetBundle {
    var body: some Widget {
        RandomFactWidget()
        RandomFactWidgetLiveActivity()
    }
}
