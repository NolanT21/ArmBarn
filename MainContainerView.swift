//
//  SelectModeContainerView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 9/12/24.
//

import SwiftUI
import SwiftData
import Observation

struct MainContainerView: View {
    
    @Environment(Event_String.self) var event
    
    @Query var events: [Event]
      
    var body: some View {
        VStack{
            NavigationStack{
                ZStack{
                    PitchLocationView()
                        .preferredColorScheme(.dark)
                }
            }
        }
    }
}

#Preview {
    MainContainerView()
}
