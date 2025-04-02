//
//  GameDataSummaryView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 2/10/25.
//

import Foundation
import SwiftUI
import SwiftData
import Charts

struct PlayerBoxScore: Codable, Hashable{
    var pitcher_id: UUID
    var first_name: String
    var last_name: String
    var innings_pitched: Double
    var batters_faced: Int
    var number_of_pitches: Int
    var hits: Int
    var walks: Int
    var strikeouts: Int
    var hit_by_pitches: Int
    var homeruns: Int
}

struct GameDataSummaryView: View {
    
    @Environment(Event_String.self) var event
    
    var game_data: SavedGames
    @State var box_score_list: [PlayerBoxScore] = []
    
    @State var innings_scored: Double = 0.0
    @State var batters_faced: Int = 0
    @State var hits: Int = 0
    @State var extra_base_hits: Int = 0
    @State var strikeouts: Int = 0
    @State var walks: Int = 0
    @State var hit_by_pitches: Int = 0
    @State var outs: Int = 0
    
    @State var pitches: Int = 0
    @State var strikes: Int = 0
    @State var first_pitch_strikes: Int = 0
    @State var strike_percentage: Double = 0.0
    @State var fps_percentage: Double = 0.0
    
    @State var game_score: Double = 40.0
    var gs_gradient = Gradient(colors: [Color("PowderBlue"), Color("Gold"), Color("Tangerine")])
    
    @State var title_size: CGFloat = 27.0
    @State var _default: CGFloat = 17.0
    @State var subheadline_size: CGFloat = 15.0
    @State var caption_size: CGFloat = 13.0
    @State var text_color: Color = .white
    @State var caption_color: Color = .gray
    
    @State var view_padding: CGFloat = 10.0
    @State var view_crnr_radius: CGFloat = 12
    
    var body: some View {

        VStack{
            
            ScrollView{
                
                HStack{
                    VStack{
                        
                        HStack{
                            Text("Box Score")
                                .font(.system(size: subheadline_size))
                                .foregroundStyle(text_color)
                            Spacer()
                        }
                        
                        Grid(){
                            GridRow{
                                Text("IP")
                                Text("BF")
                                Text("H")
                                Text("XBH")
                                Text("SO")
                                Text("BB")
                                Text("HBP")
                            }
                            .foregroundStyle(text_color)
                            .padding(.vertical, -5)
                            .bold()
                            
                            Divider()
                            
                            GridRow{
                                Text("\(innings_scored, specifier: "%.1f")")
                                Text("\(batters_faced)")
                                Text("\(hits)")
                                Text("\(extra_base_hits)")
                                Text("\(strikeouts)")
                                Text("\(walks)")
                                Text("\(hit_by_pitches)")
                            }
                            .foregroundStyle(text_color)
                        }
                        .font(.system(size: _default))
                    }
                    .padding(view_padding)
                    .frame(maxWidth: .infinity)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                }
                .padding(.bottom, view_padding/2)
                    
                VStack{
                    HStack{
                        VStack{
                            HStack{
                                Text("Strike %")
                                    .font(.system(size: subheadline_size))
                                    .foregroundStyle(text_color)
                                    .padding(.top, view_padding)
                                
                                Spacer()
                            }
                            .padding(.leading, view_padding)
                            .padding(.bottom, view_padding)
                            
                            VStack{
                                ZStack{
                                    Gauge(value: Double(strike_percentage) * 0.01) {}
                                        .scaleEffect(2.5)
                                        .gaugeStyle(.accessoryCircularCapacity)
                                        .tint(Color("Gold"))
                                        //.padding(view_padding)
                                    VStack{
                                        
                                        Text("\(strike_percentage, specifier: "%.0f")%")
                                            .font(.system(size: 40))
                                            .foregroundStyle(text_color)
                                            .bold()
                                        Text("\(strikes)/\(pitches)")
                                            .font(.system(size: subheadline_size))
                                            .foregroundStyle(text_color)
                                    }
                                    .padding(.top, view_padding)
                                }
                                .padding(view_padding)
                                
                                Spacer()
                                
                            }
                            .padding(view_padding)
                            
                            Spacer()
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color("DarkGrey"))
                        .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                        .padding(.bottom, view_padding/2)
                        .padding(.trailing, view_padding/4)
                        
                        VStack{
                            
                            HStack{
                                Text("First Pitch Strike %")
                                    .font(.system(size: subheadline_size))
                                    .foregroundStyle(text_color) 
                                    .padding(.top, view_padding)
                                
                                Spacer()
                            }
                            .padding(.leading, view_padding)
                            .padding(.bottom, view_padding)
                            
                            VStack{
                                ZStack{
                                    Gauge(value: Double(fps_percentage) * 0.01) {}
                                        .scaleEffect(2.5)
                                        .gaugeStyle(.accessoryCircularCapacity)
                                        .tint(Color("PowderBlue"))
                                        .padding(view_padding)
                                    VStack{
                                        Text("\(fps_percentage, specifier: "%.0f")%")
                                            .font(.system(size: 40))
                                            .foregroundStyle(text_color)
                                            .bold()
                                        Text("\(first_pitch_strikes)/\(batters_faced)")
                                            .font(.system(size: subheadline_size))
                                            .foregroundStyle(text_color)
                                    }
                                    .padding(.top, view_padding)
                                }
                                .padding(view_padding)
                                
                                Spacer()
                                
                            }
                            .padding(view_padding)
                            
                            Spacer()
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color("DarkGrey"))
                        .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                        .padding(.bottom, view_padding/2)
                        .padding(.trailing, view_padding/4)
                    }
                }
                
                VStack{
                    VStack{
                        HStack{
                            Text("Game Score")
                                .font(.system(size: subheadline_size))
                                .foregroundStyle(text_color)
                            
                            Spacer()
                        }
                        .padding(.leading, view_padding)
                        .padding(.top, view_padding - 3)
                        
                        VStack{
                            HStack{
                                Text("\(game_score, specifier: "%.0f")")
                                
                                    .font(.system(size: 40))
                                    .foregroundStyle(text_color)
                                    .padding(.horizontal, view_padding)
                                    .padding(.bottom, -20)
                                    .bold()
                                
                                Spacer()
                            }
                            
                            VStack{
                                Gauge(value: Double(game_score) * 0.01) {
                                    Text("Game Score")
                                        .font(.system(size: subheadline_size))
                                        .foregroundStyle(text_color)
                                }
                                .gaugeStyle(.accessoryLinear)
                                .tint(gs_gradient)
                                .frame(height: 10)
                            }
                            .padding(view_padding)
                            
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    
                    HStack{
                        Text("*")
                            .baselineOffset(3.0)
                            .foregroundStyle(.gray)
                            .font(.system(size: 10))
                        
                        + Text("Calculated using Tango's formula excluding runs, every hit has value added based on a run expectancy matrix")
                            .foregroundStyle(.gray)
                            .font(.system(size: 10))
                        
                        Spacer()
                        
                    }
                    .padding(.top, view_padding * -0.8)
                    .padding(.bottom, view_padding)
                    .padding(.leading, view_padding * 0.8)
                    
                }
                
                VStack{
                    
                    HStack{
                        Text("Player Stats")
                            .font(.system(size: subheadline_size))
                            .foregroundStyle(text_color)
                        
                        Spacer()
                    }
                    
                    VStack{
                        Grid(alignment: .center) {
                            ForEach(Array(box_score_list.enumerated()), id: \.offset) { index, pitcher in

                                if index == 0 {
                                    GridRow{
                                        Text("")
                                        Text("IP")
                                        Text("BF")
                                        Text("NP")
                                        Text("H")
                                        Text("BB")
                                        Text("SO")
                                        Text("HBP")
                                        Text("HR")
                                    }
                                    .foregroundStyle(text_color)
                                    .bold()
                                    .padding(.vertical, -5)
                                    .gridColumnAlignment(.center)
                                    
                                }
                                
                                Divider()
                                    
                                GridRow{
                                    Text(pitcher.first_name.prefix(1) + ". " + pitcher.last_name.prefix(7))
                                    Text("\(pitcher.innings_pitched, specifier: "%.1f")")
                                    Text("\(pitcher.batters_faced)")
                                    Text("\(pitcher.number_of_pitches)")
                                    Text("\(pitcher.hits)")
                                    Text("\(pitcher.walks)")
                                    Text("\(pitcher.strikeouts)")
                                    Text("\(pitcher.hit_by_pitches)")
                                    Text("\(pitcher.homeruns)")
                                }
                                .gridColumnAlignment(.center)
                                
                            }
                            
                        }
                        .font(.system(size: 17))
    //                    .border(Color.blue)
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding(view_padding)
                .background(Color("DarkGrey"))
                .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))

            }
            
            Spacer()
            
        }
        .background(Color.black)
        .onAppear{

            let add_out_list = ["F", "G", "L", "P", "Y", "K", "M", "RE", "R"]
            let end_ab_list = event.end_ab_rd

            var saved_data = game_data.game_data
            saved_data.sort{ $0.event_num < $1.event_num}
            
            let first_base_run_matrix = [0.42, 0.27, 0.13]
            let second_base_run_matrix = [0.62, 0.41, 0.22]
            let third_base_run_matrix = [0.84, 0.66, 0.27]
            
            var pitcher_order_list = [UUID()]
            
            for (index, event) in saved_data.enumerated() {
                if event.pitch_result != "VA" && event.pitch_result != "VZ" && event.pitch_result != "IW" && event.result_detail != "R" && event.result_detail != "RE" {
                    
                    pitches += 1
                    
                    if event.pitch_result != "A" && event.pitch_result != "B"{
                        
                        strikes += 1
                        
                        if (event.balls == 0 && event.strikes == 0) || pitches == 1{
                            //print(pitches)
                            first_pitch_strikes += 1
                        }
                        
                        if event.pitch_result == "H" {
                            hits += 1
                            batters_faced += 1
                            
                            if event.result_detail == "S" {
                                game_score -= 2
                                game_score -= first_base_run_matrix[event.outs] * 3
                            }
                            else if event.result_detail == "D" {
                                extra_base_hits += 1
                                game_score -= 2
                                game_score -= second_base_run_matrix[event.outs] * 3
                            }
                            else if event.result_detail == "T" {
                                extra_base_hits += 1
                                game_score -= 2
                                game_score -= third_base_run_matrix[event.outs] * 3
                            }
                            else if event.result_detail == "H" {
                                extra_base_hits += 1
                                game_score -= 6
                            }
                            else if event.result_detail == "B" {
                                hit_by_pitches += 1
                                game_score -= 2
                                game_score -= first_base_run_matrix[event.outs] * 3
                            }
                            
                        }
                        else if event.pitch_result == "O" {
                            outs += 1
                            batters_faced += 1
                            game_score += 2
                        }
                            
                        else if event.result_detail == "K" || event.result_detail == "C" || event.result_detail == "M"{
                            strikeouts += 1
                            game_score += 3
                            batters_faced += 1
                            if event.result_detail != "C" {
                                outs += 1
                            }
                        }
                    }
                    
                    else if event.result_detail == "W" {
                        walks += 1
                        batters_faced += 1
                        game_score -= 2
                        game_score -= first_base_run_matrix[event.outs] * 3
                    }

                }
                else if event.pitch_result == "VA" {
                    if event.result_detail == "W" {
                        walks += 1
                        batters_faced += 1
                        game_score -= 2
                        game_score -= first_base_run_matrix[event.outs] * 3
                    }
                }
                else if event.pitch_result == "VZ" {
                    if event.result_detail == "K" {
                        strikeouts += 1
                        batters_faced += 1
                        game_score += 3
                        outs += 1
                    }
                }
                else if event.result_detail == "R" || event.result_detail == "RE" {
                    game_score += 2
                    outs += 1
                }
                else if event.result_detail == "W"{
                    walks += 1
                    batters_faced += 1
                    game_score -= 2
                    game_score -= first_base_run_matrix[event.outs] * 3
                }
                else if event.pitch_result == "IW" {
                    walks += 1
                    if event.balls > 0 || event.strikes > 0 {
                        batters_faced += 1
                    }
                    
                }
                
                if outs >= 3 {
                    outs = 0
                    innings_scored += 1
                }
                
                if index == saved_data.endIndex - 1 && !end_ab_list.contains(event.result_detail){
                    batters_faced += 1
                }
                
                //Logic to order pitchers by entry for box score appearance
                if !pitcher_order_list.contains(event.pitcher_id) {
                    pitcher_order_list.append(event.pitcher_id)
                }
                
            } //End of game for-loop
            
            pitcher_order_list.remove(at: 0)
            
            if strikes > 0 { strike_percentage = Double(strikes * 100 / pitches) }
            if first_pitch_strikes > 0 { fps_percentage = Double(first_pitch_strikes * 100 / batters_faced) }
            innings_scored = Double(innings_scored + (Double(outs) * 0.1))
            
            //Logic to sort game_data.pitcher_info by appearance
            var sorted_pitcher_info: [SavedPitcherInfo] = []
            for order_id in pitcher_order_list {
                for id in game_data.pitcher_info {
                    if id.pitcher_id == order_id {
                        sorted_pitcher_info.append(id)
                    }
                }
            }
            //print("Sorted List: ", sorted_pitcher_info)
            
            //
            for pitcher_info in sorted_pitcher_info {
                var inn_pitched = 0.0
                var bat_faced = 0
                var pitch_num = 0
                var hit_num = 0
                var walk_num = 0
                var strikeout_num = 0
                var hit_by_pitch_num = 0
                var homerun_num = 0
                var pit_outs = 0
                
                saved_data.sort{$0.event_num < $1.event_num}
                var saved_pitcher_data = saved_data.filter { $0.pitcher_id == pitcher_info.pitcher_id}
                
                for (index, evnt) in saved_pitcher_data.enumerated() {
                    if evnt.pitch_result != "VA" && evnt.pitch_result != "VZ" && evnt.pitch_result != "IW" && evnt.result_detail != "R" && evnt.result_detail != "RE" {
                        
                        pitch_num += 1
                        
                        if evnt.pitch_result == "H" {
                            hit_num += 1
                            bat_faced += 1
                            
                            if evnt.result_detail == "H" {
                                homerun_num += 1
                            }
                            else if evnt.result_detail == "B" {
                                hit_by_pitch_num += 1
                            }
                            
                        }
                        else if evnt.pitch_result == "O" {
                            bat_faced += 1
                            pit_outs += 1
                        }
                        
                    }
                    
                    if evnt.result_detail == "K" || evnt.result_detail == "C" || evnt.result_detail == "M" {
                        strikeout_num += 1
                        bat_faced += 1
                        pit_outs += 1
                    }
                    else if evnt.result_detail == "W" {
                        walk_num += 1
                        bat_faced += 1
                    }
                    else if evnt.result_detail == "R" || evnt.result_detail == "RE" {
                        pit_outs += 1
                    }
                    else if evnt.pitch_result == "IW" {
                        walk_num += 1
                        if evnt.balls > 0 || evnt.strikes > 0 {
                            bat_faced += 1
                        }
                    }
                    else if evnt.pitch_result == "VA" {
                        if evnt.result_detail == "W" {
                            walk_num += 1
                            bat_faced += 1
                        }
                    }
                    else if evnt.pitch_result == "VZ" {
                        if evnt.result_detail == "K" {
                            strikeout_num += 1
                            bat_faced += 1
                            pit_outs += 1
                        }
                    }
                    
                    if pit_outs >= 3 {
                        pit_outs = 0
                        inn_pitched += 1
                    }
                    
                    if index == saved_pitcher_data.endIndex - 1 && !end_ab_list.contains(evnt.result_detail){
                        bat_faced += 1
                    }
                        
                }
                
                inn_pitched = Double(inn_pitched + (Double(pit_outs) * 0.1))
                
                box_score_list.append(PlayerBoxScore(pitcher_id: pitcher_info.pitcher_id, first_name: pitcher_info.first_name, last_name: pitcher_info.last_name, innings_pitched: inn_pitched, batters_faced: bat_faced, number_of_pitches: pitch_num, hits: hit_num, walks: walk_num, strikeouts: strikeout_num, hit_by_pitches: hit_by_pitch_num, homeruns: homerun_num))
                
            }
        }
    }
}

//#Preview {
//    GameDataSummaryView()
//}
