//
//  TabBarMKIIView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 5/12/25.
//

import SwiftUI

struct TabItem {
    let name: String
    let systemName: String
}

enum TabViewEnum: Identifiable, CaseIterable, View {
    
    case home, pitcher_select, game_stats, saved_games, profile
    var id: Self { self }
    
    var tabItem: TabItem {
        switch self {
            case .home:
                .init(name: "Home", systemName: "house")
            case .pitcher_select:
                .init(name: "Pitchers", systemName: "person")
            case .game_stats:
                .init(name: "Game Stats", systemName: "chart.bar.xaxis")
            case .saved_games:
                .init(name: "Saved Games", systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
            case .profile:
                .init(name: "Account", systemName: "person.crop.circle.fill")
        }
    }
    
    var body: some View {
        switch self {
            case .home:
                MainDashboardView()
            //Need to add logic from recording event upon switching
            case .pitcher_select:
                SelectPitcherView()
            case .game_stats:
                LiveStatsContainer()
            case .saved_games:
                SavedGamesView()
            case .profile:
                AccountView()
        }
    }
}

//#Preview {
//    TabBarMKIIView()
//}
