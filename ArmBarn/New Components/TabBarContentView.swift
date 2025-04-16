//
//  TabBarView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 4/16/25.
//

import SwiftUI

struct TabBarContentView: View {
    
    @Environment(Event_String.self) var event
    @Environment(LocationOverlay.self) var location_overlay
    
    @State private var activeTab: TabItems = .home
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            TabView(selection: $activeTab) {
                
                MainDashboardView()
                    .onAppear {
                        event.recordEvent = false
                    }
                    .tag(TabItems.home)
                    .toolbar(.hidden, for: .tabBar)
                
                SelectPitcherView()
                    .tag(TabItems.pitcher_select)
                    .toolbar(.hidden, for: .tabBar)
                
                GameReportView()
                    .tag(TabItems.game_report)
                    .toolbar(.hidden, for: .tabBar)
                
                SavedGamesView()
                    .tag(TabItems.saved_games)
                    .toolbar(.hidden, for: .tabBar)
                
                SettingsView()
                    .tag(TabItems.settings)
                    .toolbar(.hidden, for: .tabBar)

            }
            
            if location_overlay.showTabBar {
                TabBar(activeTab: $activeTab)
                    .transition(.move(edge: .bottom))
            }
            
        }
        .background(Color.clear)
        //.ignoresSafeArea()
        
    }
}

struct TabBar: View{

    @Binding var activeTab: TabItems
    
    @Namespace private var animation
    
    @State private var tabButtonLocations: [CGRect] = Array(repeating: .zero, count: TabItems.allCases.count)
    @State private var activeDraggingTab: TabItems?
    
    var body: some View {
        HStack{
            
            ForEach(TabItems.allCases, id: \.rawValue) { tab in
                TabButton(tab)
            }
            
        }
        .frame(height: 40)
        .background{
            Capsule()
                .fill(Color.black.opacity(0.1).shadow(.drop(color: .black.opacity(0.1), radius: 5)))
                .background(.regularMaterial)
                .clipShape(Capsule())
        }
        .coordinateSpace(name: "TABBAR")
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
        
    }
    
    @ViewBuilder
    func TabButton(_ tab: TabItems) -> some View {
        
        let isActive = (activeDraggingTab ?? activeTab) == tab
        
        VStack(spacing: 6) {
            Image(systemName: tab.symbolImage)
                .foregroundStyle(isActive ? Color.white : Color.gray)
                .bold()
            
        }
        .padding(10)
        .frame(maxWidth: 50)
        .background {
            if isActive {
                Capsule()
                    .fill(Color("ScoreboardGreen").gradient)
                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
            }
        }
        .onGeometryChange(for: CGRect.self, of: {$0.frame(in: .named("TABBAR"))}, action: { newValue in
            tabButtonLocations[tab.index] = newValue
        })
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.snappy){
                activeTab = tab
            }
        }
        .gesture(
            DragGesture(coordinateSpace: .named("TABBAR"))
                .onChanged { value in
                    let location = value.location
                    if let index = tabButtonLocations.firstIndex(where: {$0.contains(location)}) {
                        withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                            activeDraggingTab = TabItems.allCases[index]
                        }
                    }
                } .onEnded { _ in
                    if let activeDraggingTab {
                        activeTab = activeDraggingTab
                        
                    }
                    activeDraggingTab = nil
                },
            
            isEnabled: activeTab == tab
        )
        
    }
        
}

#Preview {
    TabBarContentView()
}

enum TabItems: String, CaseIterable {
    case home = "Home"
    case pitcher_select = "Pitchers"
    case game_report = "Game Report"
    case saved_games = "Saved Games"
    case settings = "Settings"
    
    var symbolImage: String {
        switch self {
        case .home: return "house.fill"
        case .pitcher_select: return "person.fill"
        case .game_report: return "chart.bar.xaxis"
        case .saved_games: return "clock.arrow.trianglehead.counterclockwise.rotate.90"
        case .settings: return "gearshape.fill"
        }
    }
    
    var index: Int {
        return TabItems.allCases.firstIndex(of: self) ?? 0
    }
    
}
