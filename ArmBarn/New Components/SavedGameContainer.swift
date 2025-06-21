//
//  SavedGameContainer.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 6/10/25.
//


import SwiftUI
import SwiftData
import Foundation

struct SavedGameContainer: View {

    @Environment(\.dismiss) private var dismiss
    
    @State var game_data: SavedGames
    
    @State var selected_index: Int = 1
    
    var body: some View {
        
        let screenSize = UIScreen.main.bounds.size

        VStack{
            
            HStack{
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.medium)
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .bold()
                }
                .padding(10)
                
                Spacer()
                
            }
            
            VStack(spacing: 5){
                HStack(alignment: .bottom){
                    HStack(spacing: 2){
                        
                        if game_data.location == "Away" {
                            Text("@")
                                .font(.system(size: 30))
                                .bold()
                                .foregroundStyle(.white)
                        }
                        
                        Text(game_data.opponent_name)
                            .font(.system(size: 30))
                            .bold()
                            .foregroundStyle(.white)
                    }
                    
                    
                    Spacer()
                    
                    let date = game_data.date.formatted(date: .abbreviated, time: .omitted)
                    let time = game_data.date.formatted(date: .omitted, time: .shortened)
                    
                    VStack(alignment: .trailing){
                        Text(date)
                        Text(time)
                    }
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.gray)
                }
                .padding(.top, 10)
                .padding(.horizontal, 10)
                
            }
            
            HStack{
                
                Button {
                    selected_index = 1
                } label: {
                    Text("Stats")
                        .foregroundStyle(selected_index == 1 ? Color.white : Color.gray)
                        .fontWeight(selected_index == 1 ? .medium : .regular)
                        .font(.system(size: 15))
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    selected_index = 2
                } label: {
                    Text("Pitch Filter")
                        .foregroundStyle(selected_index == 2 ? Color.white : Color.gray)
                        .fontWeight(selected_index == 2 ? .medium : .regular)
                        .font(.system(size: 15))
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    selected_index = 3
                } label: {
                    Text("Game Log")
                        .foregroundStyle(selected_index == 3 ? Color.white : Color.gray)
                        .fontWeight(selected_index == 3 ? .medium : .regular)
                        .font(.system(size: 15))
                }
                .frame(maxWidth: .infinity)
                
            }
            .padding(.top, 20)
            
            Divider()
                .overlay{
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 85, height: 2)
                        .cornerRadius(30)
                        .position(x: screenSize.width * 0.333 * CGFloat(selected_index) - 63)
                        .animation(.default, value: selected_index)
                }
            
            
            VStack{
                TabView(selection: $selected_index){

                    SGStatsView(game_data: game_data)
                        .tag(1)
                    
                    SGPitchFilterView(game_data: game_data)
                        .tag(2)
                    
                    SGGameLogView(game_data: game_data)
                        .tag(3)
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
            }

        }
        .background(Color.black)
        .onAppear{
            //side = screenSize.width / 4.1
            
            //print("Number of Events: \(game_data.game_data.count)")
            //print("Saved Pitcher List: (\(game_data.pitcher_info.count))", game_data.pitcher_info)
        }
    }
    
    
}

