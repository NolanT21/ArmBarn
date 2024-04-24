//
//  MainView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 11/3/23.
//

import SwiftData
import SwiftUI
import Observation


struct MainView: View {
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(Event_String.self) var event
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(GameReport.self) var game_report
    @Environment(currentPitcher.self) var current_pitcher
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @Query var events: [Event]
    @Query var pitchers: [Pitcher]
    
    @State private var showNewGame: Bool = false
    
    var body: some View {
        
        VStack{
            
            ScoreboardView()
            
            ZStack{
               
                MainContainerView().task{
                    if events.count > 0 && (scoreboard.balls == 0 && scoreboard.strikes == 0 && scoreboard.pitches == 0 && scoreboard.atbats == 1) {
                        showNewGame = true
                    }
                }
                
                if showNewGame == true {
                    PopupAlertView(isActive: $showNewGame, title: "Resume Game?", message: "A previous game was being recorded. Do you want to resume?", leftButtonAction: {load_recent_event(); load_recent_ab_pitches(); set_pitcher(); showNewGame = false}, rightButtonAction: {new_game_func(); showNewGame = false})
                }
                
            }
            
//                .task {
//                do {
//                    try context.delete(model: Event.self)
//                } catch {
//                    print("Failed to delete all events.")
//                }
            
        }
        .background(Color("ScoreboardGreen"))
    }
    
    func set_pitcher() {
        let pitcher_id = events[events.count - 1].pitcher_id
        for pitcher in pitchers {
            if pitcher.id == pitcher_id {
                current_pitcher.pitch_num = 0
                current_pitcher.firstName = pitcher.firstName
                current_pitcher.lastName = pitcher.lastName
                current_pitcher.pitch1 = pitcher.pitch1
                current_pitcher.idcode = pitcher.id
                if current_pitcher.pitch1 != "None" {
                    current_pitcher.pitch_num += 1
                    current_pitcher.arsenal[0] = pitcher.pitch1
                }
                
                current_pitcher.pitch2 = pitcher.pitch2
                if current_pitcher.pitch2 != "None" {
                    current_pitcher.pitch_num += 1
                    current_pitcher.arsenal[1] = pitcher.pitch2
                }
                
                current_pitcher.pitch3 = pitcher.pitch3
                if current_pitcher.pitch3 != "None" {
                    current_pitcher.pitch_num += 1
                    current_pitcher.arsenal[2] = pitcher.pitch3
                }
                
                current_pitcher.pitch4 = pitcher.pitch4
                if current_pitcher.pitch4 != "None" {
                    current_pitcher.pitch_num += 1
                    current_pitcher.arsenal[3] = pitcher.pitch4
                }
                break
            }
        }
    }
    
    func load_recent_event() {
        let recent_event = events[events.count - 1]
        let end_ab_br = ["S", "D", "T", "H", "E", "B", "C", "W"]
        let end_ab_out = ["F", "G", "L", "P", "Y", "K", "M", "R"]
        
        scoreboard.balls = recent_event.balls
        scoreboard.strikes = recent_event.strikes
        scoreboard.outs = recent_event.outs
        scoreboard.atbats = recent_event.atbats
        scoreboard.inning = recent_event.inning
        
        if end_ab_br.contains(recent_event.result_detail) {
            scoreboard.balls = 0
            scoreboard.strikes = 0
        }
        else if end_ab_out.contains(recent_event.result_detail) {
            scoreboard.balls = 0
            scoreboard.strikes = 0
            scoreboard.outs += 1
            if scoreboard.outs >= 3 {
                scoreboard.inning += 1
                scoreboard.outs = 0
            }
        }
        else if recent_event.pitch_result == "A" {
            scoreboard.balls += 1
        }
        else {
            scoreboard.strikes += 1
        }
        
        if ptconfig.pitch_x_loc.count > 0 && recent_event.result_detail != "R"{
            ptconfig.pitch_x_loc.removeLast()
            ptconfig.pitch_y_loc.removeLast()
            ptconfig.ab_pitch_color.removeLast()
            ptconfig.pitch_cur_ab -= 1
        }
        
        scoreboard.b1light = false
        scoreboard.b2light = false
        scoreboard.b3light = false
        
        scoreboard.s1light = false
        scoreboard.s2light = false
        
        scoreboard.o1light = false
        scoreboard.o2light = false
        
        if scoreboard.balls >= 1 {
            scoreboard.b1light = true
            if scoreboard.balls >= 2 {
                scoreboard.b2light = true
                if scoreboard.balls == 3 {
                    scoreboard.b3light = true
                }
            }
        }
        
        if scoreboard.strikes >= 1 {
            scoreboard.s1light = true
            if scoreboard.strikes == 2 {
                scoreboard.s2light = true
            }
        }
        
        if scoreboard.outs >= 1 {
            scoreboard.o1light = true
            if scoreboard.outs == 2 {
                scoreboard.o2light = true
            }
        }

        for evnt in events{
            if evnt.result_detail != "R" {
                scoreboard.pitches += 1
            }
            else {
                if scoreboard.baserunners > 0{
                    scoreboard.baserunners -= 1
                }
            }
            if end_ab_br.contains(evnt.result_detail) {
                if scoreboard.baserunners < 3 {
                    scoreboard.baserunners += 1
                }
                if evnt.result_detail == "T" {
                    scoreboard.baserunners = 1
                }
                else if evnt.result_detail == "H" {
                    scoreboard.baserunners = 0
                }
            }
        }
    }
    
    func load_recent_ab_pitches() {
        var cur_ab_index = events.count - 1
        let cur_event = events[events.count - 1] //Previous event (t)
        
        if !event.end_ab_rd.contains(cur_event.result_detail) {
            while cur_event.atbats == events[cur_ab_index].atbats {
                let prev_evnt = events[cur_ab_index]
                if prev_evnt.pitch_type != "NP" {
                    ptconfig.pitch_x_loc.insert(prev_evnt.pitch_x_location, at: 0)
                    ptconfig.pitch_y_loc.insert(prev_evnt.pitch_y_location, at: 0)

                    if prev_evnt.pitch_type == "P1"{
                        ptconfig.ab_pitch_color.insert(ptconfig.arsenal_colors[0], at: 0)
                    }
                    else if prev_evnt.pitch_type == "P2"{
                        ptconfig.ab_pitch_color.insert(ptconfig.arsenal_colors[1], at: 0)
                    }
                    else if prev_evnt.pitch_type == "P3"{
                        ptconfig.ab_pitch_color.insert(ptconfig.arsenal_colors[2], at: 0)
                    }
                    else if prev_evnt.pitch_type == "P4"{
                        ptconfig.ab_pitch_color.insert(ptconfig.arsenal_colors[3], at: 0)
                    }

                    ptconfig.pitch_cur_ab += 1
                }
                if cur_ab_index > 0 {
                    cur_ab_index -= 1
                }
                else {
                    break
                }
            }
            PitchOverlayPrevPitches()
        }
    }
    
    func new_game_func() {
        do {
            try context.delete(model: Event.self)
        } catch {
            print("Failed to delete all events.")
        }
        
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
        
        scoreboard.b1light = false
        scoreboard.b2light = false
        scoreboard.b3light = false
        
        scoreboard.s1light = false
        scoreboard.s2light = false
        
        scoreboard.o1light = false
        scoreboard.o2light = false
        
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
    }
}

#Preview {
    MainView()
        .environment(Scoreboard())
        .environment(Event_String())
        .environment(currentPitcher())
        .environment(PitchTypeConfig())
}
