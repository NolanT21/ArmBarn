//
//  MainView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 11/3/23.
//

import SwiftData
import SwiftUI
import Observation


struct MainView: View {
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(Event_String.self) var event
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(GameReport.self) var game_report
    @Environment(currentPitcher.self) var current_pitcher
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @Query var events: [Event]
    @Query var pitchers: [Pitcher]
    
    @State private var showNewGame: Bool = false
    
    var body: some View {
        
        VStack{
            
            ScoreboardView()
            
            ZStack{
               
                MainContainerView()

            }
            
        }
        .background(Color("ScoreboardGreen"))
    }
}

#Preview {
    MainView()
        .environment(Scoreboard())
        .environment(Event_String())
        .environment(currentPitcher())
        .environment(PitchTypeConfig())
}
