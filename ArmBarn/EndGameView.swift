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
                    
                    Text("\(evnt.pitcher_id)")
                    
                    HStack{
                        Text(evnt.pitch_result)
                        Text(evnt.pitch_type)
                        Text(evnt.result_detail)
                        Text("\(evnt.balls)")
                        Text("\(evnt.strikes)")
                        Text("\(evnt.outs)")
                        Text("\(evnt.inning)")
                        Text("\(evnt.atbats)")
                        Text("\(evnt.pitch_x_location)")
                        Text("\(evnt.pitch_y_location)")
//                        Text("\(evnt.y_location)")
//                        Text("\(evnt.y_cor)")
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
                .foregroundColor(Color(UIColor.label))
                //.font(weight: .semibold)
        }
        
    }
    func new_game_func() {
        
        clear_game_report()
        
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
        
    }
    
    func clear_game_report() {
        game_report.batters_faced = 0
        game_report.strikes = 0
        game_report.balls = 0
        game_report.hits = 0
        game_report.strikeouts = 0
        game_report.walks = 0
        
        game_report.first_pitch_strike = 0
        game_report.first_pitch_ball = 0
        game_report.first_pit_strike_per = 0
        game_report.fpb_to_fps = []
        
        game_report.strikes_per = 0
        game_report.balls_to_strikes = []
        
        game_report.game_score = 40
        game_report.pitches = scoreboard.pitches
        
        game_report.p1_by_inn = [0]
        game_report.p2_by_inn = [0]
        game_report.p3_by_inn = [0]
        game_report.p4_by_inn = [0]
        
        game_report.x_coordinate_list = []
        game_report.y_coordinate_list = []
        game_report.pl_color_list = []
        game_report.pl_outline_list = []
        game_report.outs_hitlog = []
        
        game_report.inn_hitlog = []
        game_report.result_hitlog = []
        game_report.pitchtype_hitlog = []
        game_report.cnt_hitlog = []
    }
}

#Preview {
    EndGameView()
}
