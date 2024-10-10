
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
    @Environment(BullpenConfig.self) var bullpen
    
    var body: some View {
        
        ZStack{
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
                    BullpenMainView().preferredColorScheme(.dark).task{
                        event.recordEvent = false
                    }
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
        .environment(GameReport())
        .environment(BullpenConfig())
}
