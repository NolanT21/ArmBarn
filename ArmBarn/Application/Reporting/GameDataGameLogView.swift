//
//  GameDataGameLogView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 2/18/25.
//

import SwiftUI

struct AtBatSummary: Codable, Hashable {
    var pitcher_name: String
    var pitcher_id: UUID
    var pitcher_id_list: [UUID]
    var ab_num: Int
    var ab_counter: Int
    var ab_summary: String
    var pitch_number: Int
    var outs: Int
    var balls: Int
    var strikes: Int
    var inning: Int
}

struct PopUpData {
//    var pitch_num_list: [Int]
    var pitch_info_list: [pitch_info_ab]
//    var result_list: [String]
//    var x_coor_list: [CGFloat]
//    var y_coor_list: [CGFloat]
//    var pitch_type_list: [String]
//    var pitcher_name: String
}

struct popup_pitch_info {
    var pitch_num: Int = 0
    var result: String = ""
    var result_color: Color = .clear //Text placeholder
    var pitch_type: String = ""
    var x_loc: CGFloat = 0
    var y_loc: CGFloat = 0
    var velocity: Double = 0
    var balls: Int = 0
    var strikes: Int = 0
    var units: String = ""
    var batter_stance: String = ""
}

struct GameDataGameLogView: View {
    
    @AppStorage("BatterStance") var ASBatterStance : Bool?
    @AppStorage("VelocityInput") var ASVeloInput : Bool?
    @AppStorage("StrikeType") var ASStrikeType : Bool?
    @AppStorage("VelocityUnits") var ASVeloUnits : String?
    
    @Environment(Event_String.self) var event
    
    var game_data: SavedGames
    @State var at_bat_list: [AtBatSummary] = []
    
    @State var result_detail_abr: [String] = []
    @State var result_detail_description: [String] = ["Single", "Double", "Triple", "Homerun", "Error", "Hit by Pitch", "Flyout", "Groundout", "Lineout",
    "Popout", "Sac Bunt", "Walk", "Strikeout", "K - Runner Reached", "K - Looking", "Runner Out - End of Inning"]
    
    @State var showPopup: Bool = false
    
    @State var pitcher_names: [String] = []
    @State var ab_pitchers: [String] = []
    @State var ab_num: Int = 0
    @State var outs: Int = 0
    @State var inning: Int = 1
    @State var pitch_type1: String = ""
    @State var pitch_type2: String = ""
    @State var pitch_type3: String = ""
    @State var pitch_type4: String = ""
    @State var batter_stance: String = ""
    
//    ["S", "D", "T", "H", "E", "B", "F", "G", "L", "P", "Y", "W", "K", "C", "M", "RE"]
    
    @State var ab_data_list: [popup_pitch_info] = []
    
    var body: some View {
        ZStack{
            VStack{
                
                ScrollView{
                    Grid(alignment: .center){
                        ForEach(Array(at_bat_list.enumerated()), id: \.offset){ index, at_bat in
                            
                            if index == 0 || at_bat_list[index].inning > at_bat_list[index-1].inning {
                                GridRow {
                                    VStack{
                                        HStack{
                                            
                                            Text("INN \(at_bat.inning)")
                                                .bold()
                                                .padding(.top, 20)
                                                .padding(.bottom, -10)
                                            
                                            Spacer()
                                            
                                            
                                        }
                                        
                                        Divider()
                                            .frame(height: 1)
                                            .background(Color.white)
                                            .padding(.bottom, -4)
                                    }
                                }
                                .gridCellColumns(5)
                            }
                            
                            if at_bat.ab_summary == "Runner Out - End of Inning" {
                                GridRow{
                                    HStack{
                                        Spacer()
                                        
                                        Text(at_bat.ab_summary)
                                            .foregroundStyle(Color.red.opacity(2))
                                            .font(.system(size: 17))
                                            .bold()
                                            .padding(.vertical, 7)
                                        
                                        Spacer()
                                    }
                    
                                }
                                .gridCellColumns(5)
                                .contentShape(Rectangle())
                                //.padding(.vertical, 10)
                                .background(Color.red.opacity(0.07))
                                
                            }
                            else {
                                GridRow{
                                    
                                    Text("\(at_bat.ab_counter)")
                                    
                                    //Text("INN \(at_bat.inning)")
                                    
                                    Text("\(at_bat.pitcher_name)")
                                    
                                    Text("\(at_bat.ab_summary)")
                                    //Text("\(at_bat.pitch_number)")
                                    Text("\(at_bat.balls)-\(at_bat.strikes)")
                                    
                                    if at_bat.outs == 1 {
                                        Text("\(at_bat.outs) Out")
                                    }
                                    else {
                                        Text("\(at_bat.outs) Outs")
                                    }

                                }
                                .gridColumnAlignment(.center)
                                .contentShape(Rectangle())
                                .padding(.vertical, 10)
                                .font(.system(size: 17))
                                .onTapGesture {
                                    showPopup = true
                                    
                                    print("Generated Pitcher ID List: ", at_bat.pitcher_id_list)
                                    
                                    generate_ab_list(ab_data: at_bat, pitcher_ids: at_bat.pitcher_id_list)
                                    
                                    //print("tapped")
                                }
                            }

                            Divider()
                        }
                        
                    }
                }
            }
            
            if showPopup == true{
                ABSummaryPopUp(pitch_list_data: ab_data_list, close_action: {
                    showPopup = false}, inning: inning, outs: outs, ab_number: ab_num, pitcher_name: ab_pitchers, batter_stance: batter_stance)
            }
            
        }
        
        .onAppear{
            
            result_detail_abr = event.end_ab_rd
            let pitcher_info_list = game_data.pitcher_info
            
            var ab_cnt = 0
            var pitcher_name = ""
            var pitches = 0
            var inning = 0
            var pitcher_id = UUID()
            var pitcher_id_list = [UUID()]
            for event in game_data.game_data {
                
                //print(event.pitch_result, event.result_detail, event.battersfaced)
                //Adds id of every pitcher for every AtBat
                if pitcher_id != event.pitcher_id {
                    pitcher_id = event.pitcher_id
                    pitcher_id_list.append(event.pitcher_id)
                    print(pitcher_id_list)
                    //If AtBat is over then cur_ab = 1
                    //cur_at_bat = 1
                }
                
                if event.pitch_result != "VA" && event.pitch_result != "VZ" && event.pitch_result != "IW" && event.result_detail != "R" && event.result_detail != "RE" {
                    
                    pitches += 1
                    
                }
                if event.result_detail == "RE" {
                    ab_cnt -= 1
                }
                
                if result_detail_abr.contains(event.result_detail) {
                    //print("Entered")
                    ab_cnt += 1
                    inning = event.inning
                    
                    for pitcher in pitcher_info_list {
                        if pitcher.pitcher_id == event.pitcher_id {
                            pitcher_name = pitcher.first_name.prefix(1) + ". " + pitcher.last_name
                            if !pitcher_names.contains(pitcher_name) {
                                pitcher_names.append(pitcher_name)
                            }
                        }
                    }
                    
                    let summary_index = result_detail_abr.firstIndex(of: event.result_detail)
                    let summary = result_detail_description[summary_index!]
                    
                    print("AB Number: ", event.battersfaced)
                    
                    at_bat_list.append(AtBatSummary(pitcher_name: pitcher_name, pitcher_id: event.pitcher_id, pitcher_id_list: pitcher_id_list, ab_num: event.battersfaced, ab_counter: ab_cnt, ab_summary: summary, pitch_number: pitches, outs: event.outs, balls: event.balls, strikes: event.strikes, inning: inning))
                    
                    //Reset Variables
                    pitches = 0
                    pitcher_id_list.removeAll()
                    pitcher_id = UUID()
                }
                //print("event")
            }
            
        }
    }
    
    func generate_ab_list(ab_data: AtBatSummary, pitcher_ids: [UUID]) {
        print("Entered", ab_data)
        print("Passed IDs List: ", pitcher_ids)
        ab_data_list.removeAll()
        
        //print("At-Bat Data: ", ab_data)
        print("At-Bat Count: ", ab_data.ab_counter)
        print("At-Bat Number: ", ab_data.ab_num)
        let ab_number = ab_data.ab_num
        ab_num = ab_number
        //print(ab_num)
        
        var saved_data = game_data.game_data
        saved_data.sort{$0.event_num < $1.event_num}
        //print(saved_data)
        
        let cur_at_bat = saved_data.filter {ab_number == $0.battersfaced /*&& pitcher_id == $0.pitcher_id*/}
        print("Data by AB Number: ", cur_at_bat)
        
        var ab_pitcher_events: [SavedEvent] = []
        
        print("Pitcher ID List: ", pitcher_ids)
        for event in cur_at_bat {
            print("Current Pitcher ID: ", event.pitcher_id)
            if pitcher_ids.contains(event.pitcher_id) {
                ab_pitcher_events.append(event)
            }
        }
        
        print("AB Data: ", ab_pitcher_events)
        
        //print("AtBat data: ", cur_at_bat)
        
        var pitch_number = 0
        var result = ""
        var velocity = 0.0
        var x_loc = 0.0
        var y_loc = 0.0
        var pitch_type = ""
        var balls = 0
        var strikes = 0
        var pitch_color: Color = .clear
        var cur_pit_id: UUID = UUID()
        
        ab_pitchers.removeAll()
        
        for (index,p) in ab_pitcher_events.enumerated() {
            //print("Gen AbText: \(index) \t \(p.event_number) \t \(p.pitch_result) \t \(p.balls) - \(p.strikes) ")
            //print("Iteration: ", index)
            
            //print("PopUp Header: \(p.inning), \(p.outs), \(p.batters_stance)")
            print("Current Iteration: ", p)
            
            if cur_pit_id != p.pitcher_id {
                //print("Add Pitcher")
                cur_pit_id = p.pitcher_id
                for p_er in game_data.pitcher_info {
                    if p_er.pitcher_id == cur_pit_id {
                        let temp_pitcher_name = p_er.first_name.prefix(1) + ". " + p_er.last_name
                        ab_pitchers.append(temp_pitcher_name)
                        //print("Added Pitcher: \(temp_pitcher_name)")
                        pitch_type1 = p_er.pitch1
                        pitch_type2 = p_er.pitch2
                        pitch_type3 = p_er.pitch3
                        pitch_type4 = p_er.pitch4
                    }
                }
            }
            
            if p.pitch_type == "P1" {
                pitch_type = pitch_type1
            }
            else if p.pitch_type == "P2" {
                pitch_type = pitch_type2
            }
            else if p.pitch_type == "P3" {
                pitch_type = pitch_type3
            }
            else if p.pitch_type == "P4" {
                pitch_type = pitch_type4
            }
            else {
                pitch_type = "No Pitch"
            }
            
            if p.pitch_result != "VA" && p.pitch_result != "VZ" && p.pitch_result != "IW" && p.result_detail != "R" && p.result_detail != "RE" {
                
                pitch_number += 1
                
                if p.pitch_result == "A" {
                    result = "Ball"
                    pitch_color = Color("PowderBlue")
                    
                    if p.result_detail == "W" {
                        result = "Walk"
                        pitch_color = Color("Tangerine")
                    }
                }
                else if p.pitch_result == "Z" || p.pitch_result == "L" {
                    
                    pitch_color = Color("Gold")
                    result = "Strike"
                    
                    if ASStrikeType == true{
                        if p.pitch_result == "L" {
                            result = "Strike - Called"
                        }
                        else if p.pitch_result == "Z" {
                            result = "Strike - Swinging"
                        }
                    }
                    
                    if p.result_detail == "K" || p.result_detail == "C" || p.result_detail == "M"{
                        result = "Strikeout"
                        pitch_color = Color("Grey")
                        if ASStrikeType == true {
                            if p.result_detail == "M" {
                                result = "Strikeout - Looking"
                            }
                            else if p.result_detail == "K" {
                                result = "Strikeout - Swinging"
                            }
                            else if p.result_detail == "C" {
                                //Change to baserunner color
                            }
                        }
                    }
                    
                }
                else if p.pitch_result == "T" {
                    result = "Foul Ball"
                    pitch_color = Color("Gold")
                }
                else if p.pitch_result == "O" {
                    pitch_color = Color("Grey")
                    if p.result_detail == "F" {
                        result = "Flyout"
                    }
                    else if p.result_detail == "G" {
                        result = "Groundout"
                    }
                    else if p.result_detail == "L" {
                        result = "Lineout"
                    }
                    else if p.result_detail == "P" {
                        result = "Popout"
                    }
                    else if p.result_detail == "Y" {
                        result = "Sac Bunt"
                    }
                    else {
                        result = "Out"
                    }
                }
                else if p.pitch_result == "H" {
                    pitch_color = Color("Tangerine")
                    if p.result_detail == "S" {
                        result = "Single"
                    }
                    else if p.result_detail == "D" {
                        result = "Double"
                    }
                    else if p.result_detail == "T" {
                        result = "Triple"
                    }
                    else if p.result_detail == "H" {
                        result = "Homerun"
                    }
                    else if p.result_detail == "E" {
                        result = "Error"
                    }
                    else if p.result_detail == "B" {
                        result = "Hit by Pitch"
                    }
                }
            }
            else if p.pitch_result == "VA" {
                pitch_type = "NPE"
                result = "PITCH CLOCK VIOLATION - BALL"
                if p.result_detail == "W" {
                    result = "PITCH CLOCK VIOLATION - WALK"
                }
            }
            else if p.pitch_result == "VZ" {
                pitch_type = "NPE"
                result = "PITCH CLOCK VIOLATION - STRIKE"
                if p.result_detail == "K" {
                    result = "PITCH CLOCK VIOLATION - STRIKEOUT"
                }
            }
            else if p.pitch_result == "IW" {
                pitch_type = "NPE"
                result = "INTENTIONAL WALK"
            }
            else if p.result_detail == "R" {
                pitch_type = "RO"
                result = "RUNNER OUT"
            }
            else if p.result_detail == "RE" {
                pitch_type = "ROE"
                result = "RUNNER OUT - END OF INNING"
            }
            

            
            let ab_line_data = popup_pitch_info(pitch_num: pitch_number, result: result, result_color: pitch_color, pitch_type: pitch_type, x_loc: p.pitch_x_location, y_loc: p.pitch_y_location, velocity: p.velocity, balls: p.balls, strikes: p.strikes, units: "MPH")
            
            //print(ab_line_text)
            
            ab_data_list.append(ab_line_data)
            
//            Error Here, Conditional Logic Problem?
            //print("Index vs Count: \(index), \(ab_pitcher_events.count - 1)")
            if index == ab_pitcher_events.count - 1 {
                //print(p.inning, p.outs, p.batters_stance)
                inning = p.inning
                outs = p.outs
                batter_stance = p.batters_stance
            }
            
            
            
        }
        
    }
    
}

//#Preview {
//    GameDataGameLogView()
//}
