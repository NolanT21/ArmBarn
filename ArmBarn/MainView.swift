
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
    
    @AppStorage("BullpenMode") var ASBullpenMode : Bool?
    
    @Environment(Event_String.self) var event
    
    @State private var showBullpenMode : Bool = false
    
    var body: some View {
        
        if !(ASBullpenMode ?? false) {

            VStack{
                //Move to when game charting is active
                ScoreboardView()
                ZStack{
                    MainContainerView()
                        .preferredColorScheme(.dark)
                }
            }
            .background(Color("ScoreboardGreen"))
        
        }
        else {
            VStack{
                BullpenMainView().task{
                    event.recordEvent = false
                }
            }
        }
        
    }
}

#Preview {
    MainView()
        .environment(Scoreboard())
        .environment(Event_String())
        .environment(currentPitcher())
        .environment(PitchTypeConfig())
}
