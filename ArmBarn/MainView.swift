
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
    
    @State private var router = Router()
    @Environment(Event_String.self) var event
    
    var body: some View {
         
        //Tab View
        TabView(selection: $router.selectedTab){
            ForEach(TabViewEnum.allCases){ tab in
                let tabItem = tab.tabItem
                Tab(
                    tabItem.name,
                    systemImage: tabItem.systemName,
                    value: tab) {
                        tab
                    }
            }
        }
        .environment(router)
        .preferredColorScheme(.dark)
        .edgesIgnoringSafeArea(.top)
        .accentColor(Color.white)
        
//        ZStack{
//            VStack{
//                
//                Spacer()
//                
//                TabBarContentView()
//                    .preferredColorScheme(.dark)
//                
//            }
//            
//        }
//        .edgesIgnoringSafeArea(.top)
    }

}

@Observable
class Router {
    var selectedTab: TabViewEnum = .home
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
