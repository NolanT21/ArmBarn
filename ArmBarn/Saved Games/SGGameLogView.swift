//
//  SGGameLogView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 6/11/25.
//

import SwiftUI
import SwiftData

struct SGGameLogView: View {
    
    @AppStorage("SelectedVelocityUnits") var ASVelocityUnits : String?
    @State var velo_units: String = "mph"
    
    @State var game_data: SavedGames
    
    @State private var game_log_data: [LiveGameLogData] = []
    @State private var inn_summary_data: [InningSummaryData] = []
    
    @State private var end_ab_rd: [String] = ["S", "D", "T", "H", "E", "B", "F", "G", "L", "P", "Y", "W", "K", "C", "M", "RE"]
    @State private var  end_ab_out: [String] = ["F", "G", "L", "P", "Y", "O", "K", "M", "RE"]
    
    var body: some View {
        ScrollView{
            VStack{
                Grid(alignment: .leading){
                    
                    ForEach(Array(game_log_data.enumerated()), id: \.offset) { index, datarow in
                        
                        if index == 0 { //Sticky headers
                            
                            Divider()
                                .padding(.top, 5)
                            
                                GridRow{
                                    
                                    Text("Pitch Type")
                                        .gridCellColumns(2)
                                    Text(velo_units)
                                    Text("Result")
                                    Text("Count")

                                }
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(Color.gray)
                                
                            Divider()

                        }
                        
                        //Displays inning header
                        if index == 0 || game_log_data[index - 1].inning < game_log_data[index].inning{
                            GridRow{
                                Text("INNING \(datarow.inning)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .padding(.top, 5)
                                    .gridCellColumns(6) //Change later once grid has more columns
                                    .gridCellAnchor(.center)
                                
                            }
                            
                            Divider()
                                .gridCellUnsizedAxes(.horizontal)

                        }
                        
                        if index == 0 || game_log_data[index - 1].pitcher_name != datarow.pitcher_name{
                            
                            GridRow{
                                HStack{
                                    
                                    Spacer()
                                    
                                    Text(datarow.pitcher_name + " Pitching")
                                        .font(.system(size: 13, weight: .medium))
                                        .padding(.vertical, 5)
                                    
                                    Spacer()
                                    
                                }
                                .gridCellAnchor(.center)
                                .gridCellColumns(6)
                                
                            }
                            .background(Color.green.opacity(0.3))
                            
                            Divider()
                                .gridCellUnsizedAxes(.horizontal)
                            
                        }
                        
                        //Displays Batter Number header
                        if (index == 0 || end_ab_rd.contains(game_log_data[index - 1].result_detail)) && datarow.result_detail != "RE"{
                            GridRow{
                                VStack{
                                    HStack{
                                        Text("Batter \(datarow.batter_num) (" + datarow.batter_stance + ")")
                                        
                                        Spacer()
                                        
                                        Text(datarow.outs)
                                    }
                                    .font(.system(size: 13, weight: .medium))
                                        
                                    Divider()
                                        .gridCellUnsizedAxes(.horizontal)
                                }
                                .padding(.top, 5)
                            }
                            .gridCellColumns(6) //Change later once grid has more columns
                            //.padding(.horizontal, 10)
                        }
                        
                        if datarow.pitch_color != Color.yellow{
                            GridRow{
                                
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(datarow.pitch_color)
                                    .overlay{
                                        Text("\(datarow.pitch_num)")
                                            .fontWeight(.semibold)
                                    }
                                    .gridCellAnchor(.center)
                                
                                Text(datarow.pitch_type)
                                
                                Text("\(datarow.velo, specifier: "%.1f")")
                                Text("\(datarow.result)")
                                Text("\(datarow.balls)-\(datarow.strikes)")
                                
                                strikezone_image()
                                    .overlay{
                                        Circle()
                                            .frame(width: 6, height: 6)
                                            .foregroundStyle(datarow.pitch_color)
                                            .shadow(radius: 2)
                                            //.position(x: 12.5, y: 12.5)
                                            .position(x: datarow.x_location, y: datarow.y_location)
                                    }
                                    //.gridCellAnchor(.center)
                                
                            }
                            .font(.system(size: 13))
                            //.padding(.horizontal, 25)
                        }
                        else if datarow.pitch_color == Color.yellow{
                            
                            GridRow{
                                HStack{
                                    
                                    Spacer()
                                
                                    Text(datarow.result)
                                        .font(.system(size: 13, weight: .medium))
                                        .padding(.vertical, 5)
                                    
                                    Spacer()
                                    
                                }
                                .gridCellColumns(6)
                                .gridCellAnchor(.center)
                            }
                            .background(Color.orange.opacity(0.3))
                        }
                        
                        
                        Divider()
                            //.padding(.horizontal, 25)
                            .gridCellUnsizedAxes(.horizontal)
                        
                        //Logic here for inning summary
                        if end_ab_out.contains(datarow.result_detail) && datarow.outs == "2 Outs"{
                            
                            HStack(spacing: 5){
                                
                                let inn_summary = inn_summary_data[datarow.inning - 1]
                                
                                Spacer()
                                
                                Text("PC: \(inn_summary.pitches),")
                                Text("BF: \(inn_summary.batters_faced),")
                                Text("H: \(inn_summary.hits),")
                                Text("SO: \(inn_summary.strikeouts),")
                                Text("BB: \(inn_summary.walks)")
                                
                            }
                            .gridCellColumns(6)
                            .padding(.trailing, 10)
                            .font(.system(size: 11, weight: .bold))
                            
                            Divider()
                            
                        }

                    }
                }
                .padding(.horizontal, 10)
                .background(.regularMaterial)
                
                Spacer()
    
            }
        }
        .onAppear{
            
            game_log_data.removeAll()
            
            generate_saved_game_log()
            
            if ASVelocityUnits != nil {
                velo_units = ASVelocityUnits ?? "MPH"
            }
            
        }
    }
    
    @ViewBuilder
    func strikezone_image() -> some View {
        ZStack{
            Rectangle()
                .frame(width: 14, height: 18)
                .foregroundStyle(Color.clear)
                .border(Color.gray.opacity(0.75), width: 1.5)
            
            Path { path in
                path.move(to: CGPoint(x: 10, y: 1))
                path.addLine(to: CGPoint(x: 10, y: 24))

                path.move(to: CGPoint(x: 15, y: 1))
                path.addLine(to: CGPoint(x: 15, y: 24))
                
                path.move(to: CGPoint(x: 2, y: 9))
                path.addLine(to: CGPoint(x: 22, y: 9))

                path.move(to: CGPoint(x: 2, y: 16))
                path.addLine(to: CGPoint(x: 22, y: 16))

            }
            .stroke(style: StrokeStyle(lineWidth: 1))
            .foregroundStyle(Color.gray.opacity(0.75))
        }
        .frame(width: 25, height: 25)
    }
    
    func generate_saved_game_log(){
        var saved_game_data = game_data.game_data
        var pitcher_list = game_data.pitcher_info
        saved_game_data.sort{$0.event_num < $1.event_num}
        
        var active_pitched_id: UUID = UUID()
        
        var pitch_num: Int = 0
        var result: String = ""
        var result_color: Color = .green
        var outs: String = ""
        
        var pitcher_name: String = ""
        var cur_pitch_type: String = ""
        var pitch1: String = ""
        var pitch2: String = ""
        var pitch3: String = ""
        var pitch4: String = ""
        
        var x_location: CGFloat = 0
        var y_location: CGFloat = 0
        
        var inn_pitches : Int = 0
        var inn_batters_faced: Int = 0
        var inn_hits: Int = 0
        var inn_strikeouts: Int = 0
        var inn_walks: Int = 0
        
        for (index, event) in saved_game_data.enumerated() {
            if active_pitched_id != event.pitcher_id {
                active_pitched_id = event.pitcher_id
                for pitcher in pitcher_list {
                    if pitcher.pitcher_id == active_pitched_id {
                        pitcher_name = pitcher.first_name + " " + pitcher.last_name
                        pitch1 = pitcher.pitch1
                        pitch2 = pitcher.pitch2
                        pitch3 = pitcher.pitch3
                        pitch4 = pitcher.pitch4
                    }
                }
                
            }
            
            if event.result_detail != "R" && event.result_detail != "RE" && event.pitch_result != "IW" && event.pitch_result != "VA" && event.pitch_result != "VZ"{ //If a pitch was thrown in event
                
                pitch_num += 1
                inn_pitches += 1
                
                //Pitch type logic
                if event.pitch_type == "P1" {
                    cur_pitch_type = pitch1
                }
                if event.pitch_type == "P2" {
                    cur_pitch_type = pitch2
                }
                if event.pitch_type == "P3" {
                    cur_pitch_type = pitch3
                }
                if event.pitch_type == "P4" {
                    cur_pitch_type = pitch4
                }
                
                //Strikes and strikeouts logic
                if event.pitch_result == "Z" { //Swining
                    result = "Swinging Strike"
                    result_color = .green
                    if event.result_detail == "K" || event.result_detail == "C"{
                        result = "Strikeout Swinging"
                        inn_strikeouts += 1
                    }
                }
                else if event.pitch_result == "L" { //Looking
                    result = "Called Strike"
                    result_color = .green
                    if event.result_detail == "M" || event.result_detail == "C"{
                        result = "Strikeout Looking"
                        inn_strikeouts += 1
                    }
                }
                else if event.pitch_result == "TO" { //Foul Tip
                    result = "Foul Tip"
                    result_color = .green
                    if event.result_detail == "K" || event.result_detail == "C"{
                        result = "Strikeout - Foul Tip"
                        inn_strikeouts += 1
                    }
                }
                else if event.pitch_result == "T" { //Foul Ball
                    result = "Foul Ball"
                    result_color = Color.gray
                }
                
                //Ball logic
                else if event.pitch_result == "A" { //Ball
                    result = "Ball"
                    result_color = Color.blue
                    if event.result_detail == "W" { //Walk
                        result = "Walk"
                        inn_walks += 1
                    }
                    
                }
                
                //Hit logic
                else if event.pitch_result == "H" {
                    result_color = Color.orange
                    if event.result_detail == "S" { //Single
                        result = "Single"
                        inn_hits += 1
                    }
                    else if event.result_detail == "D" { //Double
                        result = "Double"
                        inn_hits += 1
                    }
                    else if event.result_detail == "T" { //Triple
                        result = "Triple"
                        inn_hits += 1
                    }
                    else if event.result_detail == "H" { //Homerun
                        result = "Homerun"
                        inn_hits += 1
                    }
                    else if event.result_detail == "E" { //Error
                        result = "Error"
                    }
                    else if event.result_detail == "B" { //HBP
                        result = "Hit by Pitch"
                    }
                }
                
                //Out Logic
                else if event.pitch_result == "O" {
                    result_color = Color.orange
                    if event.result_detail == "F" { //Flyout
                        result = "Flyout"
                    }
                    else if event.result_detail == "L" { //Lineout
                        result = "Lineout"
                    }
                    else if event.result_detail == "G" { //Groundout
                        result = "Groundout"
                    }
                    else if event.result_detail == "P" { //Popup
                        result = "Popup"
                    }
                    else if event.result_detail == "Y" { //Sacrifice Bunt
                        result = "Sacrifice Bunt"
                    }
                    else if event.result_detail == "O" { //Other out type
                        result = "Out - Other"
                    }
                    
                }
                
            }
            else if event.pitch_result == "VZ" { //P.C.V. Strike
                
                result = "Pitch Clock Violation - Strike"
                result_color = Color.yellow
                
                if event.result_detail == "K" { //Strikeout
                    result = "Pitch Clock Violation - Strikeout"
                    inn_strikeouts += 1
                }
            }
            
            else if event.pitch_result == "VA" { //P.C.V. Ball
                result = "Pitch Clock Violation - Ball"
                result_color = Color.yellow
                if event.result_detail == "W" { //Walk
                    result = "Pitch Clock Violation - Walk"
                    inn_walks += 1
                }
            }
            
            else if event.pitch_result == "IW" { //Intentional Walk
                result = "Intentional Walk"
                result_color = Color.yellow
                inn_walks += 1
            }
            
            else if event.result_detail == "R" || event.result_detail == "RE" { //Baserunner out
                result = "Baserunner Out"
                result_color = Color.yellow
                if event.result_detail == "RE" && event.balls == 0 && event.strikes == 0{
                    inn_batters_faced -= 1
                }
            }
            
            if end_ab_rd.contains(event.result_detail) {
                inn_batters_faced += 1
            }
            
            //Logic for resetting inn variables
            if event.outs == 2 && end_ab_out.contains(event.result_detail) {
                
                print("Inning: \(event.inning), Outs: \(event.outs), Result_detail: ", event.result_detail)
                print("EventString: Inning: \(event.inning), Outs: \(event.outs), Result_detail: ", event.result_detail, "\n")
                //Record variables to struct
                inn_summary_data.append(InningSummaryData(pitches: inn_pitches, batters_faced: inn_batters_faced, hits: inn_hits, strikeouts: inn_strikeouts, walks: inn_walks))
                
                //Reset variables
                inn_pitches = 0
                inn_batters_faced = 0
                inn_hits = 0
                inn_strikeouts = 0
                inn_walks = 0
            }
            
            if event.outs == 1 {
                outs = "1 Out"
            } else {
                outs = "\(event.outs) Outs"
            }
            
            //Logic for pitch location snapshot
            let screenWidth: CGFloat = UIScreen.main.bounds.width
            let screenHeight: CGFloat = UIScreen.main.bounds.height
            
            x_location = event.pitch_x_location * (35/screenWidth) - 5
            y_location = event.pitch_y_location * (96/screenHeight) - 12
            
            let game_log_datarow = LiveGameLogData(pitch_num: pitch_num, batter_num: event.battersfaced, batter_stance: event.batters_stance, inning: event.inning, result: result, result_detail: event.result_detail, pitch_type: cur_pitch_type, velo: event.velocity, balls: event.balls, strikes: event.strikes, outs: outs, x_location: x_location, y_location: y_location, pitch_color: result_color, pitcher_name: pitcher_name)
            
            game_log_data.append(game_log_datarow)
            
            if end_ab_rd.contains(event.result_detail) { //If at-bat ends, reset pitch count
                pitch_num = 0
            }
            
        }
        
    }
    
}

//#Preview {
//    SGGameLogView()
//}
