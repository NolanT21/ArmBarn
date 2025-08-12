//
//  ArmBarnApp.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 11/3/23.
//

import SwiftUI
import SwiftData
import TipKit

@main

struct ArmBarnApp: App {
    
    init() {
        
        //try? Tips.resetDatastore()
        try? Tips.configure()
        
        UserDefaults.standard.register(defaults: [
            "BoxScore" : true,
            "StrikePer" : true,
            "SwingPer" : true,
            "Location" : true,
            "HitSummary" : true,
            "GameScore" : true,
            "PitByInn" : true,
            "BullpenMode" : false,
            ])
      }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(Scoreboard())
                .environment(LocationOverlay())
                .environment(GameInfo())
                .environment(Event_String())
                .environment(currentPitcher())
                .environment(PitchTypeConfig())
        }
        .modelContainer(for: [Event.self, Pitcher.self, SavedGames.self])
    }
}
