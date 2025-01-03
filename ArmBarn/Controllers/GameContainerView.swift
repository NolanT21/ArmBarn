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
    
    @AppStorage("BullpenMode") var ASBullpenMode : Bool?
    
    @Environment(Event_String.self) var event
    @Environment(\.dismiss) var dismiss
    
    @Query(sort: \Event.event_number) var events: [Event]
    
    @State private var showBullpenMode : Bool = false
      
    var body: some View {
        VStack{
            NavigationStack{
                ZStack{
//                    if !(ASBullpenMode ?? false) {
//                        PitchLocationView()
//                            .preferredColorScheme(.dark)
//                            .ignoresSafeArea()
//                    }
//                    else {
//                        VStack{
//                            BullpenMainView().task{
//                                event.recordEvent = false
//                            }
//                        }
//                    }
                    PitchLocationView()
                        .preferredColorScheme(.dark)
                        .ignoresSafeArea()
                }
            }
        }
    }
    
}

#Preview {
    MainContainerView()
}
