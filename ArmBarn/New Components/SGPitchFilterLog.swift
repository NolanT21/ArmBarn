//
//  SGPitchFilterLog.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 7/1/25.
//

import SwiftUI
import SwiftData

struct FilteredGameLogData: Hashable {

    var batter_num: Int
    var batter_stance: String
    var inning: Int
    var result: String
    var result_detail: String
    var pitch_type: String
    var velo: Double
    var balls: Int
    var strikes: Int
    var outs: String
    var x_location: Double
    var y_location: Double
    
    var pitch_color: Color
    var pitcher_first_name: String
    var pitcher_last_name: String
}

struct SGPitchFilterLog: View {
    
    @State var filtered_list: [SavedEvent]
    @State var pitch_type_list: [String]
    @State var close_action: () -> ()
    
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    
    @State private var game_log_data: [FilteredGameLogData] = []
    
    @State private var color_list: [Color] = [Color.blue, Color.green, Color.orange, Color.gray, Color.purple, Color.red, Color.yellow, Color.brown, Color.pink]
    
    var body: some View {
        ZStack{
            
            Color.black.opacity(0.5)
            
            VStack(spacing: 0){
                
                VStack{
                    HStack(alignment: .center){
                        
                        Text("Filtered Pitches")
                            .font(.system(size: 17, weight: .semibold))
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color.black.opacity(0.2))
                
                Spacer()
                
                ScrollView{
                    
                    if !game_log_data.isEmpty{
                        Grid() {
                            ForEach(Array(game_log_data.enumerated()), id: \.offset) { index, pitch in
                                
                                //Inning Header
                                if index == 0 || game_log_data[index - 1].inning < game_log_data[index].inning{
                                 
                                    Divider()
                                    
                                    GridRow{
                                        
                                        
                                        Text("INN \(pitch.inning)")
                                            .font(.system(size: 11, weight: .semibold))
                                            .gridCellColumns(5) //Change later once grid has more columns
                                            .gridCellAnchor(.leading)
                                            .padding(.leading, 2)
                                            .padding(.vertical, -2)
                                        
                                    }
                                    
                                    Divider()
                                    
                                }
                                
                                GridRow{
                                    
                                    Text(pitch.pitcher_first_name.prefix(1) + ". " + pitch.pitcher_last_name) //Needs abbreviated
                                        .font(.system(size: 13, weight: .medium))
                                    
                                    VStack(alignment: .leading){
                                        Text("\(pitch.velo)" + " mph" + " " + pitch.pitch_type)
                                            .font(.system(size: 12, weight: .semibold))
                                        Text(pitch.result)
                                            .font(.system(size: 11, weight: .regular))
                                            .foregroundStyle(Color.gray)
                                    }
                                    .gridCellAnchor(.leading)
                                    
                                    
                                    Text("\(pitch.balls) - \(pitch.strikes)")
                                        .font(.system(size: 13, weight: .semibold))
                                    
                                    HStack(spacing: 3){
                                        
                                        Circle()
                                            .fill(pitch.outs == "1 Out" || pitch.outs == "2 Outs" ? Color.red.opacity(0.7) : Color.red.opacity(0.3))
                                            .frame(width: 11, height: 11)
                                            
                                        Circle()
                                            .fill(pitch.outs == "2 Outs" ? Color.red.opacity(0.7) : Color.red.opacity(0.3))
                                            .frame(width: 11, height: 11)
        
                                    }
                                    
                                    strikezone_image()
                                        .overlay{
                                            Circle() //Color with pitch type; not result
                                                .frame(width: 6, height: 6)
                                                .foregroundStyle(pitch.pitch_color)
                                                .shadow(radius: 2)
                                                .position(x: pitch.x_location, y: pitch.y_location)
                                        }
                                    
                                }
                                
                                
                                Divider()
                                
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                    else {
                        
                        Text("No Filtered Results")
                            .font(.system(size: 13, weight: .semibold))
                            .padding(.vertical, 10)
                    }
                }
                
            }
//            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .background(Color.black.opacity(0.2))
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay{
                
                VStack{
                    
                    HStack{
                    
                        Button {
                            
                            close_action()
                            
                        } label: {
                            
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                //.background(.ultraThinMaterial)
                                .frame(width: 24, height: 24)
                                .overlay{
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                        .font(.system(size: 13).bold())
                                        //.padding(5)
                                }
                            
                        }
                        
                        
                        
                        Spacer()
                        
                    }
                    
                    Spacer()
                    
                }
                .padding(.leading, 10)
                .padding(.top, 10)
                
            } //Close Button
            .padding(.top, 50)
            .padding(.horizontal, 10)
            .padding(.bottom, 120)
            
        }
        .onAppear{
            
            generate_filtered_gamelog()
            
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
    
    func generate_filtered_gamelog(){
        
        var pitch_array = filtered_list
        pitch_array.sort(by: {$0.event_num < $1.event_num})
        
        var active_pitched_id: UUID = UUID()
        
        var pitcher_first_name: String = ""
        var pitcher_last_name: String = ""
        var cur_pitch_type: String = ""
        var pitch1: String = ""
        var pitch2: String = ""
        var pitch3: String = ""
        var pitch4: String = ""
        
        var result: String = ""
        var pitch_color: Color = .white
        var outs: String = ""
        
        var x_location: CGFloat = 0
        var y_location: CGFloat = 0
        
        for (index, pitch) in pitch_array.enumerated(){
            
            if active_pitched_id != pitch.pitcher_id {
                active_pitched_id = pitch.pitcher_id
                for pitcher in pitchers {
                    if pitcher.id == active_pitched_id {
                        pitcher_first_name = pitcher.firstName
                        pitcher_last_name = pitcher.lastName
                        pitch1 = pitcher.pitch1
                        pitch2 = pitcher.pitch2
                        pitch3 = pitcher.pitch3
                        pitch4 = pitcher.pitch4
                    }
                }
                
            }
            
            
            
            
            if pitch.result_detail != "R" && pitch.result_detail != "RE" && pitch.pitch_result != "IW" && pitch.pitch_result != "VA" && pitch.pitch_result != "VZ"{ //If a pitch was thrown in pitch

                
                //Pitch type logic
                if pitch.pitch_type == "P1" {
                    cur_pitch_type = pitch1
                }
                if pitch.pitch_type == "P2" {
                    cur_pitch_type = pitch2
                }
                if pitch.pitch_type == "P3" {
                    cur_pitch_type = pitch3
                }
                if pitch.pitch_type == "P4" {
                    cur_pitch_type = pitch4
                }
                
                for (index, pitch_type) in pitch_type_list.enumerated(){
                    
                    if cur_pitch_type == pitch_type{
                        
                        pitch_color = color_list[index]
                        
                    }
                    
                }
                
                //Strikes and strikeouts logic
                if pitch.pitch_result == "Z" { //Swining
                    result = "Swinging Strike"
                    if pitch.result_detail == "K" || pitch.result_detail == "C"{
                        result = "Strikeout Swinging"
                    }
                }
                else if pitch.pitch_result == "L" { //Looking
                    result = "Called Strike"
                    if pitch.result_detail == "M" || pitch.result_detail == "C"{
                        result = "Strikeout Looking"
                    }
                }
                else if pitch.pitch_result == "TO" { //Foul Tip
                    result = "Foul Tip"
                    if pitch.result_detail == "K" || pitch.result_detail == "C"{
                        result = "Strikeout - Foul Tip"
                    }
                }
                else if pitch.pitch_result == "T" { //Foul Ball
                    result = "Foul Ball"
                }
                
                //Ball logic
                else if pitch.pitch_result == "A" { //Ball
                    result = "Ball"
                    if pitch.result_detail == "W" { //Walk
                        result = "Walk"
                    }
                    
                }
                
                //Hit logic
                else if pitch.pitch_result == "H" {
                    if pitch.result_detail == "S" { //Single
                        result = "Single"
                    }
                    else if pitch.result_detail == "D" { //Double
                        result = "Double"
                    }
                    else if pitch.result_detail == "T" { //Triple
                        result = "Triple"
                    }
                    else if pitch.result_detail == "H" { //Homerun
                        result = "Homerun"
                    }
                    else if pitch.result_detail == "E" { //Error
                        result = "Error"
                    }
                    else if pitch.result_detail == "B" { //HBP
                        result = "Hit by Pitch"
                    }
                }
                
                //Out Logic
                else if pitch.pitch_result == "O" {
                    if pitch.result_detail == "F" { //Flyout
                        result = "Flyout"
                    }
                    else if pitch.result_detail == "L" { //Lineout
                        result = "Lineout"
                    }
                    else if pitch.result_detail == "G" { //Groundout
                        result = "Groundout"
                    }
                    else if pitch.result_detail == "P" { //Popup
                        result = "Popup"
                    }
                    else if pitch.result_detail == "Y" { //Sacrifice Bunt
                        result = "Sacrifice Bunt"
                    }
                    else if pitch.result_detail == "O" { //Other out type
                        result = "Out - Other"
                    }
                    
                }
                
            }
            else if pitch.pitch_result == "VZ" { //P.C.V. Strike
                
                result = "Pitch Clock Violation - Strike"
                
                if pitch.result_detail == "K" { //Strikeout
                    result = "Pitch Clock Violation - Strikeout"
                }
            }
            
            else if pitch.pitch_result == "VA" { //P.C.V. Ball
                result = "Pitch Clock Violation - Ball"
                if pitch.result_detail == "W" { //Walk
                    result = "Pitch Clock Violation - Walk"
                }
            }
            
            else if pitch.pitch_result == "IW" { //Intentional Walk
                result = "Intentional Walk"
            }
            
            else if pitch.result_detail == "R" || pitch.result_detail == "RE" { //Baserunner out
                result = "Baserunner Out"
                if pitch.result_detail == "RE" && pitch.balls == 0 && pitch.strikes == 0{
                }
            }
            
            if pitch.outs == 1 {
                outs = "1 Out"
            } else {
                outs = "\(pitch.outs) Outs"
            }
            
            //Logic for pitch location snapshot
            let screenWidth: CGFloat = UIScreen.main.bounds.width
            let screenHeight: CGFloat = UIScreen.main.bounds.height
            
            x_location = pitch.pitch_x_location * (35/screenWidth) - 5
            y_location = pitch.pitch_y_location * (96/screenHeight) - 12
            
            let game_log_datarow = FilteredGameLogData(batter_num: pitch.battersfaced, batter_stance: pitch.batters_stance, inning: pitch.inning, result: result, result_detail: pitch.result_detail, pitch_type: cur_pitch_type, velo: pitch.velocity, balls: pitch.balls, strikes: pitch.strikes, outs: outs, x_location: x_location, y_location: y_location, pitch_color: pitch_color, pitcher_first_name: pitcher_first_name, pitcher_last_name: pitcher_last_name)
            
            game_log_data.append(game_log_datarow)
            
        }
        
    }
    
}

//#Preview {
//    SGPitchFilterLog()
//}
