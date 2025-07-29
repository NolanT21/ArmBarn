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

struct TestEntry: Encodable {
    var id: UUID
    var status: String
}

struct InsertError : Error {
    
    let message: String
    
    static var notAuthenticated: Self {
        
        return InsertError(message: "User is not authenticated")
    }
}

@MainActor
final class SupabaseViewModel: ObservableObject {
    
    @Published var db_games = [GameDBEntry]()
    @Published var isAuthenticated: Bool = false
    
    func isAuthenticated() async {
        
        do {
            
            _ = try await supabase.auth.session.user
            isAuthenticated = true
            
        } catch {
            
            isAuthenticated = false
            
        }
        
    }
    
    func fetchGames() async throws {
        
        do {
            
            let games: [GameDBEntry] = try await supabase
                .from("games")
                .select()
                .execute()
                .value
            
            DispatchQueue.main.async {
                
                self.db_games = games
                
            }
            
            print(games)
            
        } catch {
            
            print("Fetch Error: \(error)")
            
        }
        
    }
    
    func insertGame(game_id: UUID, opponent: String, location: String, startTime: Date, event_list: [SavedEvent], pitcher_list: [SavedPitcherInfo], screenWidth: CGFloat, screenHeight: CGFloat) async throws {
        
        do {
            
            let user = try await supabase.auth.session.user
            
            let db_entry = GameDBEntry(game_id: game_id, user_id: user.id, start_time: startTime, location: location, opponent: opponent, game_data: event_list, pitcher_list: pitcher_list, screen_width: screenWidth, screen_height: screenHeight)

            try await supabase
                .from("games")
                .insert(db_entry)
                .execute()
            
        } catch {
            
            print("Insertion Error: \(error)")
            
        }
        
    
    }
    
    func userAuthentication() async throws {
        
        do{
            _ = try await supabase.auth.session.user
            isAuthenticated = true
        
        }
        catch {
            isAuthenticated = false
            
        }
        
        print("Authenitcated: ", isAuthenticated)
        
    }
    
    func signOut() async throws {
        try await supabase.auth.signOut()
        isAuthenticated = false
    }
    
    func testInsert() async throws {
        
        do {
            
            if let session = supabase.auth.currentSession {
                    
                print("Current User ID: \(session.user.id)")
                
            }else{
                    
                print("No active session")
                throw InsertError.notAuthenticated
                
            }
            
            let user = try await supabase.auth.session.user
            
            let test_entry = TestEntry(id: user.id, status: "test")
            
            let response = try await supabase
                .from("Test")
                .insert(test_entry)
                .execute()
            
            print("Insert response: \(response)")
            
        } catch {
            
            print("Insertion Error: \(error)")
            
        }
        
    }
    
}
