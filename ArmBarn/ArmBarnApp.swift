//
//  ArmBarnApp.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 11/3/23.
//

import SwiftUI
import SwiftData

@main
struct ArmBarnApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(Scoreboard())
                .environment(Event_String())
                .environment(currentPitcher())
                .environment(PitchTypeConfig())
        }
        .modelContainer(for: [Pitcher.self, Event.self])
    }
}
