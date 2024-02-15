//
//  EndGameView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 1/20/24.
//

import SwiftUI
import SwiftData

struct EndGameView: View {
    
    @Query var events: [Event]
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(Event_String.self) var event
    @Environment(GameReport.self) var game_report
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        List {
            ForEach(events) {evnt in
                VStack{
                    HStack{
                        Text(evnt.pitch_result)
                        Text(evnt.pitch_type)
                        Text(evnt.result_detail)
                        Text("\(evnt.balls)")
                        Text("\(evnt.strikes)")
                        Text("\(evnt.outs)")
                        Text("\(evnt.inning)")
                        Text("\(evnt.atbats)")

                    }
                }
            }
        }
        
        Button(action: {
            do {
                try context.delete(model: Event.self)
            } catch {
                print("Failed to delete all events.")
            }
            new_game_func()
            dismiss()
        }) {
            Text("New Game")
                .imageScale(.large)
                .foregroundColor(.black)
                //.font(weight: .semibold)
        }
        
    }
    func new_game_func() {
        scoreboard.balls = 0
        scoreboard.strikes = 0
        scoreboard.outs = 0
        scoreboard.pitches = 0
        scoreboard.atbats = 1
        scoreboard.inning = 1
        scoreboard.baserunners = 0
        
        ptconfig.pitch_x_loc.removeAll()
        ptconfig.pitch_y_loc.removeAll()
        ptconfig.ab_pitch_color.removeAll()
        ptconfig.pitch_cur_ab = 0

        
        scoreboard.b1light = .black
        scoreboard.b2light = .black
        scoreboard.b3light = .black
        
        scoreboard.s1light = .black
        scoreboard.s2light = .black
        
        scoreboard.o1light = .black
        scoreboard.o2light = .black
        
        game_report.inn_pitched = 0
        game_report.pitches = 0
        game_report.batters_faced = 0
        game_report.hits = 0
        game_report.strikeouts = 0
        game_report.walks = 0
        
    }
}

#Preview {
    EndGameView()
}
