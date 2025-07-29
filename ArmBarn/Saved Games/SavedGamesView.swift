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
    
    @StateObject private var supabaseVM = SupabaseViewModel()
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var selection: String? = nil
    
    @State private var edit_info: SavedGames?
    @State var showEditGameInfo: Bool = false
    
    @State private var text_color = Color.white
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    @State var show_sync_animation: Bool = false
    @State var sync_animation: Bool = false
    @State var isRotating = 0.0
    
    var body: some View {
        
        GeometryReader{ geometry in
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
                        .toolbar{
                            
                            HStack{
                                Spacer()
                                
                                Button{
                                    
                                    SyncGameData(screenWidth: geometry.size.width , screenHeight: geometry.size.height)
                                    withAnimation{
                                        show_sync_animation = true
                                    }
                                    print("Width: \(geometry.size.width) Height: \(geometry.size.height)")
                                    
                                } label: {
                                    
                                       Image(systemName: "arrow.trianglehead.2.clockwise")
                                        .imageScale(.medium)
                                        .font(.system(size: 15))
                                        .foregroundColor(.white)
                                        .bold()
                                    
                                }
                            }
                            
                        }
                    }
                }
                
                if showEditGameInfo == true {
                    
                    EditGameInfoPopUp(gameInfo: edit_info!, close_action: {withAnimation{showEditGameInfo = false}})
                        .preferredColorScheme(.dark)
                    
                }
                
                SyncGamesPopUp()
                
            }
        }
    }
    
    @ViewBuilder
    func SyncGamesPopUp() -> some View {
        
        VStack{
            if show_sync_animation == true{
                ZStack{
                    
                    Color.black.opacity(0.5)
                    
                    VStack{
                        
                        HStack{
                            Text("Syncing Games")
                        }
                        
                        VStack{
                            if sync_animation == false{
                                Circle()
                                    .trim(from: 0.0, to: 0.70)
                                    .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                                    .fill(AngularGradient(gradient: Gradient(colors: [.black, .white]), center: .center, endAngle: .degrees(250)))
                                    .frame(width: 50, height: 50)
                                    .rotationEffect(.degrees(isRotating))
                                    .onAppear {
                                        withAnimation(.linear(duration: 1).speed(0.9).repeatForever(autoreverses: false)) {
                                            isRotating = 360
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                            sync_animation = true
                                        }
                                    }
                            }
                            else {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 21, weight: .bold))
                                    .imageScale(.large)
                                    .bold()
                                    .onAppear{

                                        //successHaptic()
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                            sync_animation = false
                                            isRotating = 0
                                        }
                                    }
                            }
                        }
                        .frame(height: 60)
                        
                    }
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.black.opacity(0.2))
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 20)
                }
                .transition(.opacity)
                .padding(.top, 10)
//                .onAppear{
//                    if show_sync_animation == true {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            withAnimation{
//                                show_sync_animation.toggle()
//                            }
//                        }
//                    }
//                }
            }
                
        }
        
    }
    
    func SyncGameData(screenWidth: CGFloat, screenHeight: CGFloat) {
        
        Task{
            try await supabaseVM.fetchGames()
        }
        
        for db_game in supabaseVM.db_games {
            
            var game_stored_locally: Bool = false
            
            for s_game in saved_games {
                
                if db_game.game_id == s_game.game_id {
                    
                    game_stored_locally = true
                    
                }
                
            }
            
            print("Stored locally: \(game_stored_locally)")
            if game_stored_locally == false {
                
                //Logic for storing game locally
                let new_saved_game = SavedGames(game_id: db_game.game_id, opponent_name: db_game.opponent, date: db_game.start_time, location: db_game.location, game_data: db_game.game_data, pitcher_info: db_game.pitcher_list)
                
                //Need Logic for applying screen dimensions to pitch location data
                if db_game.screen_width != screenWidth || db_game.screen_height != screenHeight {
                    
                    var screen_width_factor = screenWidth / db_game.screen_width
                    var screen_height_factor = screenHeight / db_game.screen_height
                    
                    for (index, event) in new_saved_game.game_data.enumerated() {
                        new_saved_game.game_data[index].pitch_x_location *= screen_width_factor
                        new_saved_game.game_data[index].pitch_y_location *= screen_height_factor
                    }
                }
                
                //Saves SavedGame data object
                context.insert(new_saved_game)
            }
            
        }
        
        for s_game in saved_games {
            
            var game_stored_in_db: Bool = false
            
            for db_game in supabaseVM.db_games {
                
                if s_game.game_id == db_game.game_id {
                 
                    game_stored_in_db = true
                    
                }
                
            }
            
            print("Stored in DB: \(game_stored_in_db)")
            if game_stored_in_db == false {
                
                //Logic for storing game in database
                Task{
                    try await supabaseVM.insertGame(game_id: s_game.game_id, opponent: s_game.opponent_name, location: s_game.location, startTime: s_game.date, event_list: [], pitcher_list: s_game.pitcher_info, screenWidth: screenWidth, screenHeight: screenHeight)
                }
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation{
                show_sync_animation.toggle()
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
