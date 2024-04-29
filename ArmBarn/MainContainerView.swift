//
//  MainContainerView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 1/15/24.
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
                }
            }
        }
    }
    
   
}
    
    

#Preview {
    MainContainerView()
}
