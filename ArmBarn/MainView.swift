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
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        
        VStack{
            
            Spacer()
                .frame(height: 10)
            ScoreboardView()
            MainContainerView().task {
                do {
                    try context.delete(model: Event.self)
                } catch {
                    print("Failed to delete all events.")
                }
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
