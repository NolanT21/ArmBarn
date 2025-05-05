
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
    
    var body: some View {
         
        ZStack{
            VStack{
                
                Spacer()
                
                TabBarContentView()
                    .preferredColorScheme(.dark)
                
            }
            
        }
        .edgesIgnoringSafeArea(.top)
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
