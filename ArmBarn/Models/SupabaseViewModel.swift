//
//  SupabaseViewModel.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 7/20/25.
//

import Foundation
import Supabase

struct GameDBEntry: Encodable, Decodable {
    var game_id: UUID
    var user_id: UUID
    var start_time: Date
    var location: String
    var opponent: String
    var game_data: [SavedEvent]
    var pitcher_list: [SavedPitcherInfo]
    
    var screen_width: CGFloat
    var screen_height: CGFloat
}

@MainActor
final class SupabaseViewModel: ObservableObject {
    
    @Published var db_games = [GameDBEntry]()
    @Published var isAuthenticated: Bool = false
    
    func signOut() async throws {
        try await supabase.auth.signOut()
        isAuthenticated = false
    }
    
    func isAuthenticated() async {
        
        do {
            
            _ = try await supabase.auth.session.user
            isAuthenticated = true
            
        } catch {
            
            isAuthenticated = false
            
        }
        
    }
    
    func fetchGames() async throws {
            
        let games: [GameDBEntry] = try await supabase
            .from("games")
            .select()
            .execute()
            .value
        
        DispatchQueue.main.async {
            
            self.db_games = games
            
        }
        
        //print(games)

    }
    
    func insertGame(game_id: UUID, opponent: String, location: String, startTime: Date, event_list: [SavedEvent], pitcher_list: [SavedPitcherInfo], screenWidth: CGFloat, screenHeight: CGFloat) async throws {
            
        let user = try await supabase.auth.session.user
        
        let db_entry = GameDBEntry(game_id: game_id, user_id: user.id, start_time: startTime, location: location, opponent: opponent, game_data: event_list, pitcher_list: pitcher_list, screen_width: screenWidth, screen_height: screenHeight)

        try await supabase
            .from("games")
            .insert(db_entry)
            .execute()

    }
    
    func update_game_info(game_id: UUID, opponent: String, location: String, startTime: String) async throws {
            
        do {
            
            try await supabase
                .from("games")
                .update(["opponent": opponent, "location": location, "start_time": startTime]) //Error with trying to change dates
                .eq("game_id", value: game_id)
                .execute()
            
        } catch {
            
            print("Error updating game info: \(error)")
            
        }

    }
    
    func delete_game(game_id: UUID) async throws {
        
        try await supabase
            .from("games")
            .delete()
            .eq("game_id", value: game_id)
            .execute()
        
    }
    
}
