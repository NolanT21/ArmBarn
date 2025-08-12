//
//  LiveStatsContainer.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 5/26/25.
//

import SwiftUI

struct LiveStatsContainer: View {
    
    @AppStorage("CurrentOpponentName") var ASCurOpponentName : String?
    @AppStorage("CurrentGameLocation") var ASGameLocation : String?
    @AppStorage("CurrentGameStartTime") var ASStartTime : Date?
    
    @Environment(currentPitcher.self) var current_pitcher
    @Environment(Scoreboard.self) var scoreboard
    @Environment(LocationOverlay.self) var location_overlay
    
    @State private var opponent_team_name: String = "Opponent Name"
    @State private var date: Date = Date()
    @State private var game_location: String = "Home"
    
    @State var selected_index: Int = 1
    
    @State var side: CGFloat = 112
    
    var body: some View {
        
        let screenSize = UIScreen.main.bounds.size
        
        VStack{
            
            //Mini Scoreboard
            VStack{
                
                Divider()
                
                HStack{
                    Text("P: " + current_pitcher.firstName.prefix(1).uppercased() + ". " + current_pitcher.lastName)
                    
                    Spacer()
                    
                    Text("INN \(scoreboard.inning)")
//
                    Text("\(scoreboard.balls)-\(scoreboard.strikes)")
                    
                    HStack(spacing: 4){
                        
                        Circle()
                            .stroke(scoreboard.o1light ? Color.red : Color.white, lineWidth: 1.5)
                            .fill(scoreboard.o1light ? Color.red : Color.clear)
                            .frame(width: 12, height: 12)

                        
                        Circle()
                            .stroke(scoreboard.o2light ? Color.red : Color.white, lineWidth: 1.5)
                            .fill(scoreboard.o2light ? Color.red : Color.clear)
                            .frame(width: 12, height: 12)
                    }

                    
                }
                .font(.system(size: 13, weight: .medium))
                .padding(.horizontal, 10)
                
                Divider()
                
            }
            
            //Team, time and location labels
            HStack{
                
                if game_location == "Away"{
                    Text("@")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundStyle(.white)
                }
                
                Text(opponent_team_name)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 0){
                    
                    Text(date, format: .dateTime.day().month().year())
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.gray)
                    
                    Text(date, format: .dateTime.hour().minute())
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.gray)
                    
                }

            }
            .padding(.horizontal, 20)
            .frame(height: 60, alignment: .bottom)
            
            HStack{
                
                Button {
                    selected_index = 1
                } label: {
                    Text("Stats")
                        .font(.system(size: 15))
                        .fontWeight(selected_index == 1 ? .medium : .regular)
                        .foregroundStyle(selected_index == 1 ? .white : .gray)
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    selected_index = 2
                } label: {
                    Text("Game Log")
                        .font(.system(size: 15))
                        .fontWeight(selected_index == 2 ? .medium : .regular)
                        .foregroundStyle(selected_index == 2 ? .white : .gray)
                }
                .frame(maxWidth: .infinity)
                
            }
            .frame(height: 40, alignment: .bottom)
            
            Divider()
                .overlay{
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 90, height: 2)
                        .cornerRadius(30)
                        .offset(x: selected_index == 1 ? -side : side)
                        .animation(.default, value: selected_index)
                }
                .padding(.bottom, 5)
            
            VStack{
                TabView(selection: $selected_index){

                    LiveStatsView()
                        .tag(1)
                    
                    LiveGameLogView()
                        .tag(2)
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
            }
            
            
        }
        .onAppear{
            side = screenSize.width / 3.9
            
            if location_overlay.game_info_entered == true {
                opponent_team_name = ASCurOpponentName ?? "Opponent Name"
                game_location = ASGameLocation ?? "Home"
                date = ASStartTime ?? Date()
            }
    
        }
    }
}

#Preview {
    LiveStatsContainer()
}
