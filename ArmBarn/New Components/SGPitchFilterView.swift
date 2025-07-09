//
//  SGPitchFilterView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 6/11/25.
//

import SwiftUI

struct pitch_overlay_datapoint: Hashable {
    
    var x_pos: Double
    var y_pos: Double
    var color: Color
    
}

struct result_filter_datapoint: Hashable {
    
    var description: String
    var pitch_result: String
    var result_detail : String
    
}

struct pitcher_filter_datapoint: Hashable {
    
    var name: String
    var pitcher_id: UUID
    var pitch1: String
    var pitch2: String
    var pitch3: String
    var pitch4: String
}

class result_filter {
    
    let filter_list: [result_filter_datapoint] = [
        
        result_filter_datapoint(description: "Ball", pitch_result: "A", result_detail: "N"),
        result_filter_datapoint(description: "Strike", pitch_result: "", result_detail: ""), //Nested Menu
        result_filter_datapoint(description: "Foul Ball", pitch_result: "T", result_detail: "N"),
        result_filter_datapoint(description: "Hit", pitch_result: "", result_detail: ""), //Nested Menu
        result_filter_datapoint(description: "Out", pitch_result: "", result_detail: ""), //Nested Menu
        result_filter_datapoint(description: "Error", pitch_result: "H", result_detail: "E"),
        result_filter_datapoint(description: "Hit By Pitch", pitch_result: "H", result_detail: "B"),
        result_filter_datapoint(description: "Strikeout", pitch_result: "", result_detail: ""), //Nested Menu
        
    ]
    
    let strike_list: [result_filter_datapoint] = [
        
        result_filter_datapoint(description: "All", pitch_result: "Z", result_detail: "XXX"),
        result_filter_datapoint(description: "Called", pitch_result: "L", result_detail: "N"), //Need logic for strikeouts
        result_filter_datapoint(description: "Swinging", pitch_result: "Z", result_detail: "N"),
        result_filter_datapoint(description: "Foul Tip", pitch_result: "TO", result_detail: "N"),
    
    ]
    
    let hit_list: [result_filter_datapoint] = [
        
        result_filter_datapoint(description: "All", pitch_result: "H", result_detail: "XXX"),
        result_filter_datapoint(description: "XBHs", pitch_result: "H", result_detail: "XBH"),
        result_filter_datapoint(description: "Single", pitch_result: "H", result_detail: "S"),
        result_filter_datapoint(description: "Double", pitch_result: "H", result_detail: "D"),
        result_filter_datapoint(description: "Triple", pitch_result: "H", result_detail: "T"),
        result_filter_datapoint(description: "Homerun", pitch_result: "H", result_detail: "H"),
    
    ]
    
    let out_list: [result_filter_datapoint] = [
        
        result_filter_datapoint(description: "All", pitch_result: "O", result_detail: "XXX"),
        result_filter_datapoint(description: "Flyout", pitch_result: "O", result_detail: "F"),
        result_filter_datapoint(description: "Groundout", pitch_result: "O", result_detail: "G"),
        result_filter_datapoint(description: "Lineout", pitch_result: "O", result_detail: "L"),
        result_filter_datapoint(description: "Popout", pitch_result: "O", result_detail: "P"),
        result_filter_datapoint(description: "Sacrifice Bunt", pitch_result: "O", result_detail: "Y"),
        result_filter_datapoint(description: "Other", pitch_result: "O", result_detail: "O"),
    
    ]
    
    let strikeout_list: [result_filter_datapoint] = [
        
        result_filter_datapoint(description: "All", pitch_result: "K", result_detail: "XXX"),
        result_filter_datapoint(description: "Called", pitch_result: "L", result_detail: "M"),
        result_filter_datapoint(description: "Swinging", pitch_result: "Z", result_detail: "K"),
        result_filter_datapoint(description: "Foul Tip", pitch_result: "TO", result_detail: "K"),
    
    ]
    
}

struct SGPitchFilterView: View {
    
    @State var game_data: SavedGames
    
    @State var filter_lists = result_filter()
    
    @State private var showFilteredGameLog: Bool = false
    
    @State private var pitch_overlay_list: [pitch_overlay_datapoint] = []
    
    @State private var pitcher_name_list: [pitcher_filter_datapoint] = []
    @State private var generated_pitch_type_list: [String] = []
    @State private var pitch_type_list: [String] = []
    @State private var result_list: [String] = ["Ball", "Strike", "Foul Ball", "Hit", "Out", "Error", "Hit By Pitch", "Strikeout"]
    @State private var strike_list: [String] = ["Called", "Swinging", "Foul Tip"]
    @State private var hit_list: [String] = ["Single", "Double", "Triple", "Home Run"]
    @State private var out_list: [String] = ["Flyout", "Groundout", "Lineout", "Popout", "Sacrifice Bunt", "Other"]
    @State private var strikeout_list: [String] = ["Called", "Swinging", "Foul Tip"]
    @State private var count_list: [[Int]] = [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2], [3, 0], [3, 1], [3, 2]]
    @State private var batter_hand_list: [String] = ["All", "Right", "Left"]
    @State var filtered_game_log: [SavedEvent] = []
    
    @State private var selected_pitcher_list: [UUID] = []
    @State private var selected_pitch_type_list: [String] = []
    @State private var selected_pitch_result_list: [String] = []
    @State private var selected_result_detail_list: [String] = []
    @State private var selected_count_list: [[Int]] = []
    @State private var selected_batter_hand_list: [String] = []
    
    @State private var all_pitcher_uuid_filter: UUID = UUID()
    
    @State private var pitcher_label: String = "Pitcher"
    @State private var result_label: String = "Result"
    @State private var pitch_type_label: String = "Pitch Type"
    @State private var count_label: String = "Count"
    @State private var batter_hand_label: String = "Batter Hand"
    
    @State private var button_font_size: CGFloat = 15
    @State private var dropdown_size: CGFloat = 13
    @State private var button_height: CGFloat = 40
    
    @State private var color_list: [Color] = [Color.blue, Color.green, Color.orange, Color.gray, Color.purple, Color.red, Color.yellow, Color.brown, Color.pink]
    
    @State var reset_button_gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color("Scarlet"), Color("DarkScarlet")]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    @State var menu_button_gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color("ScoreboardGreen"), Color("DarkScoreboardGreen")]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    var body: some View {
        
        ZStack{
            
            GeometryReader{ geometry in
                
                ZStack{
                    
                    VStack{
                        
                        strikeZoneBackground(geometry: geometry)
                        
                        Spacer()
                        
                        HStack{
                            ForEach(Array(pitch_type_list.enumerated()), id: \.offset) { index, pitch_type in
                                
                                HStack(spacing: 2){
                                    
                                    Circle()
                                        .fill(color_list[index])
                                        .frame(width: 8, height: 8)
                                    
                                    Text(pitch_type)
                                        .font(.system(size: 11))
                                        .foregroundStyle(Color.white)
                                    
                                }
                            }
                        }
                        
                        
                        VStack{
                            
                            HStack{
                                
                                Menu{
                                    ForEach(Array(pitcher_name_list.enumerated()), id: \.offset) { index, pitcher in
                                        
                                        Button {
                                            
                                            pitcher_label = pitcher.name
                                            selected_pitcher_list.removeAll()
                                            selected_pitcher_list.append(pitcher.pitcher_id)
                                            
                                            if pitcher.name != "All Pitchers"{
                                                pitch_type_list = [pitcher.pitch1, pitcher.pitch2, pitcher.pitch3, pitcher.pitch4]
                                                
                                                for (index, pitch) in pitch_type_list.enumerated(){
                                                    
                                                    if pitch == "None" {
                                                        pitch_type_list.remove(at: index)
                                                    }
                                                    
                                                }
                                                
                                            }
                                            else {
                                                pitch_type_list = generated_pitch_type_list
                                            }
                                            
                                            
                                            query_events()
                                            
                                        } label: {
                                            
                                            Text(pitcher.name)
                                            
                                        }
                                        
                                    }
                                    
                                } label: {
                                    HStack{
                                        
                                        Text(pitcher_label)
                                            .font(.system(size: button_font_size, weight: .medium))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: dropdown_size, weight: .medium))
                                        
                                    }
                                    .padding(.horizontal, 10)
                                    .frame(maxWidth: .infinity, maxHeight: button_height)
                                    .background(.regularMaterial)
                                    .cornerRadius(8)
                                    
                                }
                                
                                Menu{
                                    ForEach(Array(pitch_type_list.enumerated()), id: \.offset) { index, pitch_type in
                                        
                                        if pitch_type != "None" {
                                            Button {
                                                
                                                selected_pitch_type_list.removeAll()
                                                pitch_type_label = pitch_type
                                                selected_pitch_type_list.append(pitch_type)
                                                
                                                query_events()
                                                 
                                            } label: {
                                                
                                                Text(pitch_type)
                                                
                                            }
                                        }
                                        
                                    }
                                
                                } label: {
                                    HStack{
                                        
                                        Text(pitch_type_label)
                                            .font(.system(size: button_font_size, weight: .medium))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: dropdown_size, weight: .medium))
                                        
                                    }
                                    .padding(.horizontal, 10)
                                    .frame(maxWidth: 165, maxHeight: button_height)
                                    .background(.regularMaterial)
                                    .cornerRadius(8)
                                }
                                
                            }
                            
                            HStack{
                                
                                Menu{
                                    ForEach(Array(filter_lists.filter_list.enumerated()), id: \.offset) { index, result in
                                        
                                        if index == 1 { //Strike
                                            Menu{
                                                ForEach(Array(filter_lists.strike_list.enumerated()), id: \.offset) { index, strike in
                                                    
                                                    Button {
                                                        
                                                        result_label = strike.description
                                                        
                                                        selected_pitch_result_list.removeAll()
                                                        selected_result_detail_list.removeAll()
                                                        
                                                        selected_pitch_result_list.append(strike.pitch_result)
                                                        selected_result_detail_list.append(strike.result_detail)
                                                         
                                                        query_events()
                                                        
                                                    } label: {
                                                        
                                                        Text(strike.description)
                                                        
                                                    }
                                                }
                                            } label: {
                                                Text(result.description)
                                            }
                                        }
                                        else if index == 3 { //Hit
                                            Menu{
                                                ForEach(Array(filter_lists.hit_list.enumerated()), id: \.offset) { index, hit in
                                                    
                                                    Button {
                                                        
                                                        result_label = hit.description
                                                        
                                                        selected_pitch_result_list.removeAll()
                                                        selected_result_detail_list.removeAll()
                                                        
                                                        selected_pitch_result_list.append(hit.pitch_result)
                                                        selected_result_detail_list.append(hit.result_detail)
                                                        
                                                        query_events()
                                                         
                                                    } label: {
                                                        
                                                        Text(hit.description)
                                                        
                                                    }
                                                }
                                            } label: {
                                                Text(result.description)
                                            }
                                            
                                        }
                                        else if index == 4 { //Out
                                            Menu{
                                                ForEach(Array(filter_lists.out_list.enumerated()), id: \.offset) { index, out in
                                                    
                                                    Button {
                                                        
                                                        result_label = out.description
                                                        
                                                        selected_pitch_result_list.removeAll()
                                                        selected_result_detail_list.removeAll()
                                                        
                                                        selected_pitch_result_list.append(out.pitch_result)
                                                        selected_result_detail_list.append(out.result_detail)
                                                        
                                                        query_events()
                                                         
                                                    } label: {
                                                        
                                                        Text(out.description)
                                                        
                                                    }
                                                }
                                            } label: {
                                                Text(result.description)
                                            }
                                            
                                        }
                                        else if index == 7 { //Strikeout
                                            
                                            Menu{
                                                ForEach(Array(filter_lists.strikeout_list.enumerated()), id: \.offset) { index, strikeout in
                                                    
                                                    Button {
                                                        
                                                        result_label = "K - " + strikeout.description
                                                        
                                                        selected_pitch_result_list.removeAll()
                                                        selected_result_detail_list.removeAll()
                                                        selected_pitch_result_list.append(strikeout.pitch_result)
                                                        selected_result_detail_list.append(strikeout.result_detail)
                                                        
                                                        query_events()
                                                         
                                                    } label: {
                                                        
                                                        Text(strikeout.description)
                                                        
                                                    }
                                                }
                                            } label: {
                                                Text(result.description)
                                            }
                                            
                                        }
                                        else {
                                            
                                            Button {
                                                
                                                selected_pitch_result_list.removeAll()
                                                selected_result_detail_list.removeAll()
                                                
                                                result_label = result.description
                                                selected_pitch_result_list.append(result.pitch_result)
                                                selected_result_detail_list.append(result.result_detail)
                                                
                                                query_events()
                                                
                                            } label: {
                                                
                                                Text(result.description)
                                                
                                            }
                                        }
                                        
                                    }
                                    
                                } label: {
                                    HStack{
                                        
                                        Text(result_label)
                                            .font(.system(size: button_font_size, weight: .medium))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: dropdown_size, weight: .medium))
                                        
                                    }
                                    .padding(.horizontal, 10)
                                    .frame(maxWidth: .infinity, maxHeight: button_height)
                                    .background(.regularMaterial)
                                    .cornerRadius(8)
                                }
                                
                                Menu {
                                    ForEach(Array(count_list.enumerated()), id: \.offset) { count in
                                        
                                        Button {
                                            
                                            selected_count_list.removeAll()
                                            
                                            count_label = "\(count.element[0]) - \(count.element[1])"
                                            selected_count_list.append(count.element)
                                            
                                            query_events()
                                            
                                        } label: {
                                            
                                            Text("\(count.element[0]) - \(count.element[1])")
                                            
                                        }
                                        
                                    }
                                    
                                } label: {
                                    HStack{
                                        
                                        Text(count_label)
                                            .font(.system(size: button_font_size, weight: .medium))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: dropdown_size, weight: .medium))
                                        
                                    }
                                    .padding(.horizontal, 10)
                                    .frame(maxWidth: 90, maxHeight: button_height)
                                    .background(.regularMaterial)
                                    .cornerRadius(8)
                                }
                                
                                Menu {
                                    ForEach(Array(batter_hand_list.enumerated()), id: \.offset) { index, hand in
                                        
                                        Button {
                                            
                                            batter_hand_label = hand
                                            
                                            if index == 0 {
                                                selected_batter_hand_list.removeAll()
                                            }
                                            else if index == 1 || index == 2{
                                                selected_batter_hand_list.removeAll()
                                                selected_batter_hand_list.append(String(hand.prefix(1)))
                                            }
                                            
                                            query_events()
                                                
                                        } label: {
                                            
                                            Text(hand)
                                            
                                        }
                                        
                                    }
                                    
                                } label: {
                                    HStack{
                                        
                                        Text(batter_hand_label)
                                            .font(.system(size: button_font_size, weight: .medium))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: dropdown_size, weight: .medium))
                                        
                                    }
                                    .padding(.horizontal, 10)
                                    .frame(maxWidth: .infinity, maxHeight: button_height)
                                    .background(.regularMaterial)
                                    .cornerRadius(8)
                                }
                                
                            }
                            
                        }
                        .padding(10)
                        .background(.regularMaterial)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(15)
                        
                    }
                    .padding(.bottom, 5)
                    
                }
                
                pitchOverlayView(geometry: geometry)
                
                //Reset all fields button
                HStack{
                    
                    Button{
                        
                        withAnimation(.easeIn(duration: 0.2)){
                            showFilteredGameLog = true
                        }
                        
                        
                    } label: {
                        
                        VStack{
                            
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 21, weight: .heavy))
                            
                        }
                        .frame(width: 35, height: 35)
                        
                    }
                    .background(menu_button_gradient)
                    .cornerRadius(8)
                    
                    Spacer()
                    
                    Button{
                        
                        reset_filter_labels()
                        
                    } label: {
                        
                        VStack{
                            
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 21, weight: .heavy))
                            
                        }
                        .frame(width: 35, height: 35)
                        
                    }
                    .background(reset_button_gradient)
                    .cornerRadius(8)
                }
                
                
            }
            .onAppear{
                
                reset_filter_labels()
                
                //Generate pitcher name list and pitch type list for filter fields
                
                for pitcher in game_data.pitcher_info {
                    
                    if !pitcher_name_list.contains(where: { $0.name == pitcher.first_name + " " + pitcher.last_name }) {
                        
                        pitcher_name_list.append(pitcher_filter_datapoint(name: pitcher.first_name + " " + pitcher.last_name, pitcher_id: pitcher.pitcher_id, pitch1: pitcher.pitch1, pitch2: pitcher.pitch2, pitch3: pitcher.pitch3, pitch4: pitcher.pitch4))
                        
                    }
                    
                    
                    let pitcher_pitch_list = [pitcher.pitch1, pitcher.pitch2, pitcher.pitch3, pitcher.pitch4]
                    
                    for pitch_type in pitcher_pitch_list {
                        
                        if !generated_pitch_type_list.contains(pitch_type) && pitch_type != "None" {
                            generated_pitch_type_list.append(pitch_type)
                        }
                        
                    }
                    
                }
                
                if pitcher_name_list.count > 1 && !pitcher_name_list.contains(where: { $0.name == "All Pitchers" }){
                    
                    let all_pitcher_id: UUID = UUID()
                    
                    pitcher_name_list.insert(pitcher_filter_datapoint(name: "All Pitchers", pitcher_id: all_pitcher_id, pitch1: "", pitch2: "", pitch3: "", pitch4: ""), at: 0)
                    
                    all_pitcher_uuid_filter = all_pitcher_id
                    
                }
                
                pitch_type_list = generated_pitch_type_list
                
            }
            
            
            if showFilteredGameLog == true {
                
                SGPitchFilterLog(filtered_list: filtered_game_log, pitch_type_list: pitch_type_list, close_action: {withAnimation(.easeOut(duration: 0.2)){showFilteredGameLog = false}})
                
            }
            
        } //Here?
        
    }
    
    @ViewBuilder
    func pitchOverlayView(geometry: GeometryProxy) -> some View {
        
        ForEach(Array(pitch_overlay_list.enumerated()), id: \.offset) { index, pitch in
            
            Circle()
                .fill(pitch.color)
                .frame(width: geometry.size.width * 0.055, height: geometry.size.width * 0.055)
                .position(x: pitch.x_pos, y: pitch.y_pos)
                .shadow(radius: 2)
            
        }
        
    }
    
    @ViewBuilder
    func strikeZoneBackground(geometry: GeometryProxy) -> some View {
            
        VStack(alignment: .center){
            
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            
            Spacer()
                .frame(height: screenHeight / 4) //140
            
            ZStack{
                
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .border(Color.white, width: 2)
                    .frame(width: screenWidth / 3.275, height: screenHeight / 4) // 120 x 140
                    .overlay{
                        
                        Rectangle()
                            .fill(Color.clear)
                            .border(Color.white, width: 1)
                            .frame(width: screenWidth / 9.825, height: screenHeight / 4) // 40 x 140
                        
                        Rectangle()
                            .fill(Color.clear)
                            .border(Color.white, width: 1)
                            .frame(width: screenWidth / 3.275, height: screenHeight / 11.89) // 120 x 47
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: screenWidth / 2.382, height: screenHeight / 3.042) // 165 x 190
                        
                    }
                
            }
            
            
            Spacer()
                .frame(height: screenHeight / 4.658) //120
            
            Image("HomeplateFromBehind")
                .resizable()
                .frame(width: screenWidth / 3.275, height: screenHeight / 18.63) //120 x 30
            
        }
            
    }
    
    func query_events() {
        
        var saved_game = game_data.game_data
        saved_game.sort{$0.event_num < $1.event_num}
        
        var temp_pitch_type_list: [String] = []
        var current_pitch_type: String = ""
        
        pitch_overlay_list.removeAll()
        filtered_game_log.removeAll()
        
        for event in saved_game{
            
            let valid_pitcher = validate_pitcher_filter(event_pitcher_id: event.pitcher_id, pitch_type: event.pitch_type)
            
            let valid_result = validate_result_filter(pitch_result: event.pitch_result, result_detail: event.result_detail)
            
            let valid_count = validate_count_filter(balls: event.balls, strikes: event.strikes)
            
            let valid_hand = validate_batter_hand_filter(batter_hand: event.batters_stance)
            
            if valid_pitcher == true && valid_result == true && valid_count == true && valid_hand == true{
                
                var pitch_color = Color.white
                
                for pitcher in game_data.pitcher_info{
                    
                    if pitcher.pitcher_id == event.pitcher_id{
                        
                        temp_pitch_type_list = [pitcher.pitch1, pitcher.pitch2, pitcher.pitch3, pitcher.pitch4]
                        
                    }
                    
                }
                
                if event.pitch_type == "P1" {
                    current_pitch_type = temp_pitch_type_list[0]
                }
                if event.pitch_type == "P2" {
                    current_pitch_type = temp_pitch_type_list[1]
                }
                if event.pitch_type == "P3" {
                    current_pitch_type = temp_pitch_type_list[2]
                }
                if event.pitch_type == "P4" {
                    current_pitch_type = temp_pitch_type_list[3]
                }
                
                for (index, pitch_type) in pitch_type_list.enumerated(){
                    
                    if current_pitch_type == pitch_type{
                        
                        pitch_color = color_list[index]
                        
                    }
                    
                }
                
                pitch_overlay_list.append(pitch_overlay_datapoint(x_pos: event.pitch_x_location, y_pos: event.pitch_y_location, color: pitch_color))
                
                //add event to event list
                filtered_game_log.append(SavedEvent(event_num: event.event_num, pitcher_id: event.pitcher_id, pitch_result: event.pitch_result, pitch_type: event.pitch_type, result_detail: event.result_detail, balls: event.balls, strikes: event.strikes, outs: event.outs, inning: event.inning, battersfaced: event.battersfaced, pitch_x_location: event.pitch_x_location, pitch_y_location: event.pitch_y_location, batters_stance: event.batters_stance, velocity: event.velocity))
                
            }
            
        }
        
    }
    
    func validate_count_filter(balls: Int, strikes: Int) -> Bool{
        
        var valid_count = false
        
        if selected_count_list.isEmpty || (selected_count_list[0][0] == balls && selected_count_list[0][1] == strikes){
            
            valid_count = true
            
        }
        
        return valid_count
        
    }
    
    func validate_batter_hand_filter(batter_hand: String) -> Bool{
        
        var valid_hand = false
        
        if selected_batter_hand_list.isEmpty || selected_batter_hand_list.contains(batter_hand){
            
            valid_hand = true
            
        }
        
        return valid_hand
    }
    
    func validate_result_filter(pitch_result: String, result_detail: String) -> Bool{
        
        let strike_pitch_result_list: [String] = ["L", "Z", "TO"]
        let strikeout_result_detail_list: [String] = ["K", "M"]
        
        var valid_result = false
        
        if (selected_pitch_result_list.contains(pitch_result) && selected_result_detail_list.contains(result_detail)) || selected_pitch_result_list.isEmpty {
            
            valid_result = true
            
        }
        else if selected_pitch_result_list.contains("K") && selected_result_detail_list.contains("XXX") { //All Strikeouts
            
            if strikeout_result_detail_list.contains(result_detail) { valid_result = true }
            
        }
//        else if strike_pitch_result_list.contains(pitch_result) && selected_result_detail_list.contains("N"){ //Logic for including strikeouts w/ strike filter
//                
//            if selected_pitch_result_list.contains(pitch_result) {
//                valid_result = true
//            }
//            
//        }
        else if selected_pitch_result_list.contains("Z") && selected_result_detail_list.contains("XXX") { //All Strikes
            
            if strike_pitch_result_list.contains(pitch_result) {
                
                valid_result = true
                
            }
            else if pitch_result == "H" {
                
                if result_detail != "B" || result_detail != "E" { valid_result = true }
                
            }
            else if pitch_result == "O" {
                
                if result_detail != "R" || result_detail != "RE" { valid_result = true }
                
            }
            else if pitch_result == "T" { valid_result = true }
            
        }
        else if selected_pitch_result_list.contains("Z") && selected_result_detail_list.contains("N") { //All Strikes
            
            if pitch_result == "Z" { valid_result = true }
            
            else if pitch_result == "H" {
                
                if result_detail != "B" || result_detail != "E" { valid_result = true }
                
            }
            else if pitch_result == "O" {
                
                if result_detail != "R" || result_detail != "RE" { valid_result = true }
                
            }
            else if pitch_result == "T" { valid_result = true }
            
        }
        else if selected_pitch_result_list.contains(pitch_result) && selected_result_detail_list.contains("XXX") {
            
            if selected_pitch_result_list.contains("H") {
                
                if result_detail != "B" || result_detail != "E" { valid_result = true }
                
            }
            else if selected_pitch_result_list.contains("O") {
                
                if result_detail != "R" || result_detail != "RE" { valid_result = true }
                
            }
            
        }
        
        else if selected_pitch_result_list.contains(pitch_result) && selected_result_detail_list.contains("XBH") {
            
            if selected_pitch_result_list.contains("H") {
                
                if result_detail != "S" || result_detail != "B" || result_detail != "E" { valid_result = true }
                
            }
            
        }
        
        return valid_result
        
    }
    
    func validate_pitcher_filter(event_pitcher_id: UUID, pitch_type: String) -> Bool{
        
        var valid_pitcher = false
        
        if selected_pitcher_list.contains(event_pitcher_id) || selected_pitcher_list.contains(all_pitcher_uuid_filter) || selected_pitcher_list.isEmpty{
            
            //logic for pitch type
            if selected_pitch_type_list.isEmpty {
                
                valid_pitcher = true
                
            }
            else {
                
                for pitcher in game_data.pitcher_info{
                    
                    if pitcher.pitcher_id == event_pitcher_id {
                        
                        if selected_pitch_type_list.contains(pitcher.pitch1) && pitch_type == "P1" { valid_pitcher = true }
                        
                        else if selected_pitch_type_list.contains(pitcher.pitch2) && pitch_type == "P2" { valid_pitcher = true }
                        
                        else if selected_pitch_type_list.contains(pitcher.pitch3) && pitch_type == "P3" { valid_pitcher = true }
                        
                        else if selected_pitch_type_list.contains(pitcher.pitch4) && pitch_type == "P4" { valid_pitcher = true }
                        
                        print("Selected Pitch Type:", selected_pitch_type_list, " Valid Pitch", valid_pitcher)
                        
                    }
                    
                }
                
            }
            
        }
        
        return valid_pitcher
        
    }
    
    func reset_filter_labels(){
        
        pitcher_label = "Pitcher"
        result_label = "Result"
        pitch_type_label = "Pitch Type"
        count_label = "Count"
        batter_hand_label = "Batter Hand"
        
        pitch_overlay_list.removeAll()
        selected_pitch_result_list.removeAll()
        selected_pitch_type_list.removeAll()
        selected_result_detail_list.removeAll()
        selected_pitcher_list.removeAll()
        selected_count_list.removeAll()
        selected_batter_hand_list.removeAll()
        
        filtered_game_log.removeAll()
        
        pitch_type_list = generated_pitch_type_list
        
    }
    
}

//#Preview {
//    SGPitchFilterView()
//}
