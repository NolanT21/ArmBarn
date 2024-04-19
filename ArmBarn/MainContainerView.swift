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
        .environment(Event_String())
}
