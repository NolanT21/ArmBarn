//
//  SavedGameMainView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 2/17/25.
//

import SwiftUI
import SwiftData
import Foundation

struct SavedGameMainView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var game_data: SavedGames
    
    @State var showSummary: Bool = true
    @State var showGameLog: Bool = false
    
    @State var title_size: CGFloat = 27.0
    @State var caption_size: CGFloat = 13.0
    @State var text_color: Color = .white
    @State var caption_color: Color = .gray
    
    @State var view_padding: CGFloat = 10.0

    @State var side: CGFloat = 112
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
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
                        .frame(width: sbl_width, height: sbl_height)
                        .foregroundColor(text_color)
                        .bold()
                }
                .padding(view_padding)
                
                Spacer()
                
            }
            
            VStack(spacing: 5){
                HStack(alignment: .bottom){
                    HStack(spacing: 2){
                        
                        if game_data.location == "Away" {
                            Text("@")
                                .font(.system(size: title_size))
                                .bold()
                                .foregroundStyle(text_color)
                        }
                        
                        Text(game_data.opponent_name)
                            .font(.system(size: title_size))
                            .bold()
                            .foregroundStyle(text_color)
                    }
                    
                    
                    Spacer()
                    
                    let date = game_data.date.formatted(date: .abbreviated, time: .omitted)
                    let time = game_data.date.formatted(date: .omitted, time: .shortened)
                    
                    VStack(alignment: .trailing){
                        Text(date)
                        Text(time)
                    }
                    .font(.system(size: caption_size))
                    .foregroundStyle(caption_color)
                }
                .padding(.top, view_padding)
                .padding(.horizontal, view_padding)
                
            }
            
            HStack{
                
                Button {
                    showSummary = true
                    showGameLog = false
                } label: {
                    Text("Summary")
                        .foregroundStyle(showSummary ? Color.white : Color.gray)
                        .font(.system(size: 17))
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    showGameLog = true
                    showSummary = false
                } label: {
                    Text("Game Log")
                        .foregroundStyle(showGameLog ? Color.white : Color.gray)
                        .font(.system(size: 17))
                }
                .frame(maxWidth: .infinity)
                
            }
            .padding(.top, 20)
            
            Divider()
                .overlay{
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 100, height: 2)
                        .cornerRadius(30)
                        .offset(x: showSummary ? -side : side)
                        .animation(.default, value: showSummary)
                }
            
            
            Spacer()
            
            if showSummary {
                GameDataSummaryView(game_data: game_data).navigationBarBackButtonHidden(true).preferredColorScheme(.dark)
            }
            else if showGameLog {
                GameDataGameLogView(game_data: game_data).navigationBarBackButtonHidden(true).preferredColorScheme(.dark)
            }
            
        }
        .padding(view_padding)
        .background(Color.black)
        .onAppear{
            side = screenSize.width / 4.1
            //print("Number of Events: \(game_data.game_data.count)")
            //print("Saved Pitcher List: (\(game_data.pitcher_info.count))", game_data.pitcher_info)
        }
    }
}

//#Preview {
//    SavedGameMainView()
//}
