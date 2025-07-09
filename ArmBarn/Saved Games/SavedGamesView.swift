//
//  SavedGamesView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 2/7/25.
//

import SwiftUI
import SwiftData

struct SavedGamesView: View {
    
    @Query var saved_games: [SavedGames]
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var selection: String? = nil
    
    @State private var edit_info: SavedGames?
    @State var showEditGameInfo: Bool = false
    
    @State private var text_color = Color.white
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    var body: some View {
        
        ZStack{
            VStack{
                
                NavigationStack{
                    List{
                        ForEach(saved_games.sorted(by: {$0.date > $1.date}), id: \.id) { games in
                            HStack{
                                
    //                            let pitcher_info = games.pitcher_info
                                NavigationLink{
                                    //GameDataSummaryView(game_data: games)
                                    SavedGameContainer(game_data: games).navigationBarBackButtonHidden(true).preferredColorScheme(.dark)
                                } label : {
                                    VStack(alignment: .leading){
                                        HStack(spacing: 2){
                                            if games.location == "Away" {
                                                Text("@")
                                                    .font(.system(size: 17, weight: .semibold))
                                            }
                                            Text(games.opponent_name)
                                                .font(.system(size: 17, weight: .semibold))
                                        }
                                        
                                        let date = games.date.formatted(date: .abbreviated, time: .omitted)
                                        let time = games.date.formatted(date: .omitted, time: .shortened)
                                        
                                        Text(date + " " + time)
                                            .font(.footnote)
                                            .foregroundStyle(Color.gray)
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button(action: {
                                        showEditGameInfo = true
                                        edit_info = games
                                    }, label: {
                                        Text("Edit")
                                    })
                                }
                                
                                Spacer()
                                
                            }
                        }
                        .onDelete(perform: removeSavedGame)
                        
                    }
                    .navigationTitle(Text("Saved Games"))
                    .navigationBarTitleDisplayMode(.large)
                }
            }
            
            if showEditGameInfo == true {
                
                EditGameInfoPopUp(gameInfo: edit_info!, close_action: {withAnimation{showEditGameInfo = false}})
                    .preferredColorScheme(.dark)
                
            }
            
        }
        
        
    }
    
    func removeSavedGame(at indexSet: IndexSet) {
        for index in indexSet {
            context.delete(saved_games[index])
        }
    }
    
}

//#Preview {
//    SavedGamesView()
//}
