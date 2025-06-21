//
//  InGameStatsView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 5/22/25.
//

import SwiftUI
import SwiftData

struct VeloComponentData: Hashable{
    var velo: Double
    var color: Color
    var y_offset: CGFloat
}

struct VeloLayoutData: Hashable{
    var velo_category: Int
    var count: Int
}

struct PlayerStatLineData: Hashable{
    var first_char: String = ""
    var last_name: String = ""
    var innings_pitched: Double = 0.0
    var batters_faced: Int = 0
    var strikeouts: Int = 0
    var walks: Int = 0
    var hbp: Int = 0
    var hit_by_pitches: Int = 0
    var hits: Int = 0
    var xbh: Int = 0
    var homeruns: Int = 0
    var pitch_count: Int = 0
    var strike_count: Int = 0
}

struct PitcherAppeared: Hashable{
    var pitcher_id: UUID
    var pitcher_name: String
    var pitch1: String
    var pitch2: String
    var pitch3: String
    var pitch4: String
}

struct LiveStatsView: View {
    
    @Query(sort: \Event.event_number) var events: [Event]
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    @Environment(currentPitcher.self) var current_pitcher
    @Environment(Scoreboard.self) var scoreboard
    
    @State private var selected_pitcher_id: UUID = UUID()
    @State private var selected_pitcher_name: String = ""
//    @State private var selected_pitcher: PitchersAppeared
    @State private var pitcher_uuid_list: [UUID] = []
    @State private var pitcher_appearance_list: [PitcherAppeared] = []
    
    @State private var end_ab_rd: [String] = ["S", "D", "T", "H", "E", "B", "F", "G", "L", "P", "Y", "W", "K", "C", "M", "RE"]
    
    //Variables for player detail box score
    @State private var pd_innings_pitched: Double = 0
    @State private var pd_inning_outs: Int = 0
    @State private var pd_batters_faced: Int = 0
    @State private var pd_hits: Int = 0
    @State private var pd_xbh: Int = 0
    @State private var pd_strikeouts: Int = 0
    @State private var pd_walks: Int = 0
    @State private var pd_hbp: Int = 0
    @State private var pd_pitch_count: Int = 0
    @State private var pd_strike_count: Int = 0
    
    //Variables for player detail gauges
    @State private var pd_swings: Int = 0
    @State private var pd_whiffs: Int = 0
    @State private var pd_strike_per: Double = 0.0
    @State private var pd_fps_per: Double = 0.0
    @State private var pd_first_pitches: Int = 0
    @State private var pd_first_pitch_strikes: Int = 0
    @State private var pd_swing_per: Double = 0.0
    @State private var pd_whiff_per: Double = 0.0
    
    //Variables for player detal velocity component
    @State private var pdv_component_data: [VeloComponentData] = []
    @State private var pdv_velo_layout: [VeloLayoutData] = []
    @State private var pdv_min_velo: Double = 0.0
    @State private var pdv_max_velo: Double = 0.0
    @State private var pdv_start_index: Int = 0
    @State private var pdv_pitch1: String = ""
    @State private var pdv_pitch1_max: Double = 0.0
    @State private var pdv_pitch2: String = ""
    @State private var pdv_pitch2_max: Double = 0.0
    @State private var pdv_pitch3: String = ""
    @State private var pdv_pitch3_max: Double = 0.0
    @State private var pdv_pitch4: String = ""
    @State private var pdv_pitch4_max: Double = 0.0
    
    @State private var staff_lines_component: [PlayerStatLineData] = []
    
    @State private var view_padding: CGFloat = 10
    @State private var gauge_container_height: CGFloat = 100
    
    var body: some View {
        ScrollView{
            VStack{
                
                //Player Detail
                playerDetail()
                    .padding(.horizontal, view_padding)
                    .frame(height: 450) //Could cause problems elsewhere
                
                //Staff Stat Lines
                if pitcher_uuid_list.count >= 2{
                    staffStatLines()
                        .padding(.horizontal, view_padding)
                }

                
            }
            .onAppear {
                selected_pitcher_id = current_pitcher.idcode
                
                //Store pitch types per pitch type to pdv_variables on intialization
                
                generate_player_detail_stats()
                
                pdv_pitch1 = current_pitcher.pitch1
                pdv_pitch2 = current_pitcher.pitch2
                pdv_pitch3 = current_pitcher.pitch3
                pdv_pitch4 = current_pitcher.pitch4
                
                generate_pitcher_appearance_list()
                generate_staff_stat_lines()
                
            }
            
            //Spacer()
            
        }
        

    }
    
    @ViewBuilder
    func playerDetail() -> some View {
        VStack(spacing: 20){
            
            Spacer()
            
            HStack{
                
                Menu {
                    ForEach(pitcher_appearance_list, id: \.self) { pitcher in
                        Button{
                            
                            selected_pitcher_id = pitcher.pitcher_id
                            
                            generate_player_detail_stats()
                            generate_pitcher_appearance_list()
                            
                            selected_pitcher_name = pitcher.pitcher_name
                            
                            //Store pitch types to pdv_variables on change
                            pdv_pitch1 = pitcher.pitch1
                            pdv_pitch2 = pitcher.pitch2
                            pdv_pitch3 = pitcher.pitch3
                            pdv_pitch4 = pitcher.pitch4
                            
                        } label: {
                            Text(pitcher.pitcher_name)
                        }
                    }
                    //Button{} label: { Text("Test") }
                        
                } label: {
                    HStack{
                        Text(selected_pitcher_name)
                            .font(.system(size: 19, weight: .semibold))
                            .padding(.leading, 25)
    
                        Image(systemName: "chevron.down")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .frame(width: 300, height: 30, alignment: .leading)
                }

                Spacer()
                
            }
            
            //Box Score
            Grid{
                GridRow{
                    Text("IP")
                    Text("BF")
                    Text("H")
                    Text("XBH")
                    Text("SO")
                    Text("BB")
                    Text("HBP")
                    Text("PC-ST")
                }
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .font(.system(size: 13))
                .padding(.bottom, -5)
                
                Divider()
                
                GridRow{
                    Text("\(pd_innings_pitched, specifier: "%.1f")")
                    Text("\(pd_batters_faced)")
                    Text("\(pd_hits)")
                    Text("\(pd_xbh)")
                    Text("\(pd_strikeouts)")
                    Text("\(pd_walks)")
                    Text("\(pd_hbp)")
                    Text("\(pd_pitch_count)-\(pd_strike_count)")
                }
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .font(.system(size: 15))
                
            }
            .padding(.horizontal, 20)
            
            //Gauge Row
            HStack{
                
                //Strike Percentage Gauge
                VStack(spacing: 0){
                    
                    HStack{
                        Text("Strike %")
                            .font(.system(size: 11, weight: .medium))
                            .padding(.top, 10)
                            .padding(.leading, 10)
                        
                        Spacer()
                        
                    }
                    
                    ZStack{
                        Gauge(value: pd_strike_per) {}
                            .gaugeStyle(.accessoryCircularCapacity)
                            .tint(Color.blue)
                            .padding(view_padding)
                        Text("\(pd_strike_per * 100, specifier: "%.0f")") //Strike Percentage
                            .font(.system(size: 21, weight: .bold))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: gauge_container_height)
                .background(.regularMaterial)
                .cornerRadius(12)
                .shadow(radius: 5, x: 2, y: 2)
                
                //First Pitch Strike Percentage Gauge
                VStack(spacing: 0){
                    
                    HStack{
                        Text("FPS %")
                            .font(.system(size: 11, weight: .medium))
                            .padding(.top, 10)
                            .padding(.leading, 10)
                        
                        Spacer()
                        
                    }
                    
                    ZStack{
                        Gauge(value: pd_fps_per) {}
                            .gaugeStyle(.accessoryCircularCapacity)
                            .tint(Color.green)
                            .padding(view_padding)
                        Text("\(pd_fps_per * 100, specifier: "%.0f")") //First Pitch Strike Percentage
                            .font(.system(size: 21, weight: .bold))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: gauge_container_height)
                .background(.regularMaterial)
                .cornerRadius(12)
                .shadow(radius: 5, x: 2, y: 2)
                
                //Swing Percentage Gauge
                VStack(spacing: 0){
                    
                    HStack{
                        Text("Swing %")
                            .font(.system(size: 11, weight: .medium))
                            .padding(.top, 10)
                            .padding(.leading, 10)
                        
                        Spacer()
                        
                    }
                    
                    ZStack{
                        Gauge(value: pd_swing_per) {}
                            .gaugeStyle(.accessoryCircularCapacity)
                            .tint(Color.orange)
                            .padding(view_padding)
                        Text("\(pd_swing_per * 100, specifier: "%.0f")") //Swing Percentage
                            .font(.system(size: 21, weight: .bold))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: gauge_container_height)
                .background(.regularMaterial)
                .cornerRadius(12)
                .shadow(radius: 5, x: 2, y: 2)
                
                //Whiff Percentage Gauge
                VStack(spacing: 0){
                    
                    HStack{
                        Text("Whiff %")
                            .font(.system(size: 11, weight: .medium))
                            .padding(.top, 10)
                            .padding(.leading, 10)
                        
                        Spacer()
                        
                    }
                    
                    ZStack{
                        Gauge(value: pd_whiff_per) {}
                            .gaugeStyle(.accessoryCircularCapacity)
                            .tint(Color.gray)
                            .padding(view_padding)
                        Text("\(pd_whiff_per * 100, specifier: "%.0f")") //Whiff Percentage
                            .font(.system(size: 21, weight: .bold))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: gauge_container_height)
                .background(.regularMaterial)
                .cornerRadius(12)
                .shadow(radius: 5, x: 2, y: 2)
                
            }
            .padding(.horizontal, 20)
            
            //Pitch Velocity Component
            veloComponent()
                .padding(.top, 10)
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: 450)
        .background(.regularMaterial)
        .cornerRadius(20)
    }
    
    @ViewBuilder
    func veloComponent() -> some View {
        ZStack{
            
            GeometryReader{ geometry in
                
                let width = geometry.size.width
                
                VStack{
                    
                    //Background for Velo Component, shows x-axis w/ velos
                    ZStack{
                        
                        HStack{
                            
                            Path { path in
                                path.move(to: CGPoint(x: (width * (1/5)), y: 0))
                                path.addLine(to: CGPoint(x: (width * (1/5)), y: 100))
                                path.move(to: CGPoint(x: (width * (2/5)), y: 0))
                                path.addLine(to: CGPoint(x: (width * (2/5)), y: 100))
                                path.move(to: CGPoint(x: (width * (3/5)), y: 0))
                                path.addLine(to: CGPoint(x: (width * (3/5)), y: 100))
                                path.move(to: CGPoint(x: (width * (4/5)), y: 0))
                                path.addLine(to: CGPoint(x: (width * (4/5)), y: 100))
                            }
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                            .foregroundStyle(Color.gray)
                        }
                        
                        Text("\(pdv_start_index + 5)")
                            .position(x: (width * (1/5)), y: 110)
                            .font(.system(size: 11))
                            .foregroundStyle(Color.gray)
                        
                        Text("\(pdv_start_index + 10)")
                            .position(x: (width * (2/5)), y: 110)
                            .font(.system(size: 11))
                            .foregroundStyle(Color.gray)
                        
                        Text("\(pdv_start_index + 15)")
                            .position(x: (width * (3/5)), y: 110)
                            .font(.system(size: 11))
                            .foregroundStyle(Color.gray)
                        
                        Text("\(pdv_start_index + 20)mph")
                            .position(x: (width * (4/5)) + 10, y: 110)
                            .font(.system(size: 11))
                            .foregroundStyle(Color.gray)
                        
                        HStack{
                            
                            Spacer()
                            
                            VStack(spacing: 2){
                                HStack{
                                    Circle()
                                        .frame(width: 12, height: 12)
                                        .foregroundStyle(Color.blue)
                                    
                                    Text(pdv_pitch1)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(Color.white)
                                }
                                Text("Max: \(pdv_pitch1_max, specifier: "%.1f")")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color.gray)
                            }
                            
                            
                            if pdv_pitch2 != "None" && pdv_pitch2_max > 0{
                                
                                Spacer()
                                
                                VStack(spacing: 2){
                                    HStack{
                                        Circle()
                                            .frame(width: 12, height: 12)
                                            .foregroundStyle(Color.green)
                                        
                                        Text(pdv_pitch2)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(Color.white)
                                    }
                                    Text("Max: \(pdv_pitch2_max, specifier: "%.1f")")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.gray)
                                }
                            }
                            
                            if pdv_pitch3 != "None" && pdv_pitch3_max > 0{
                                
                                Spacer()
                                
                                VStack(spacing: 2){
                                    HStack{
                                        Circle()
                                            .frame(width: 12, height: 12)
                                            .foregroundStyle(Color.orange)
                                        
                                        Text(pdv_pitch3)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(Color.white)
                                    }
                                    Text("Max: \(pdv_pitch3_max, specifier: "%.1f")")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.gray)
                                }
                            }
                            
                            if pdv_pitch4 != "None" && pdv_pitch4_max > 0{
                                
                                Spacer()
                                
                                VStack(spacing: 2){
                                    HStack{
                                        Circle()
                                            .frame(width: 12, height: 12)
                                            .foregroundStyle(Color.gray)
                                        
                                        Text(pdv_pitch4)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(Color.white)
                                    }
                                    Text("Max: \(pdv_pitch4_max, specifier: "%.1f")")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.gray)
                                }
                            }
                            
                            Spacer()
                            
                        }
                        .position(x: width/2, y: 145)
                        .frame(maxWidth: 400)
                        
                    }
                    
                }
                
                
                ZStack {
                    
                    ForEach(Array(pdv_component_data.enumerated()), id: \.offset) { index, pitch in
                        
                        Circle()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(pitch.color)
                            .shadow(radius: 2)
                            .position(x: (pitch.velo - CGFloat(pdv_start_index)) * (width / 25.3), y: pitch.y_offset)
                        
                    }

                }
                
            }
        }
    }
    
    @ViewBuilder
    func staffStatLines() -> some View {
        VStack{
            
            Grid{
                ForEach(Array(staff_lines_component.enumerated()), id: \.offset){ index, statline in
                    if index == 0 {
                        GridRow{
                            Text("Pitcher")
                            Text("IP")
                            Text("BF")
                            Text("H")
                            Text("XBH")
                            Text("HR")
                            Text("SO")
                            Text("BB")
                            Text("HBP")
                            Text("PC-ST")
                        }
                        .font(.system(size: 11))
                        .foregroundStyle(Color.gray)
                        .padding(.bottom, -5)
                        
                        Divider()
                    }
                        
                    GridRow{
                        Text(statline.first_char + ". " + statline.last_name)
                            .gridCellAnchor(.leading)
                        Text("\(statline.innings_pitched, specifier: "%.1f")")
                        Text("\(statline.batters_faced)")
                        Text("\(statline.hits)")
                        Text("\(statline.xbh)")
                        Text("\(statline.homeruns)")
                        Text("\(statline.strikeouts)")
                        Text("\(statline.walks)")
                        Text("\(statline.hbp)")
                        Text("\(statline.pitch_count)-\(statline.strike_count)")
                    }
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color.white)
                    .frame(height: 15)

                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .cornerRadius(20)

    }
    
    func generate_player_detail_stats() {
        
        reset_player_detail_stats()
        
        for event in events {
            
            if event.pitcher_id == selected_pitcher_id { //If event belongs to selected pitcher
                
                //Check if pitch event ended, calculates batters faced
                if end_ab_rd.contains(event.result_detail) {
                    pd_batters_faced += 1
                }
                
                if event.result_detail != "R" && event.result_detail != "RE" && event.pitch_result != "IW" && event.pitch_result != "VA" && event.pitch_result != "VZ"{ //If a pitch was thrown in event
                    
                    pd_pitch_count += 1
                    generate_velo_component_datapoint(velo: event.velocity, pitch_type: event.pitch_type)
                    
                    if event.pitch_result != "A" && event.result_detail != "B"{ //Ball was not recorded (Strike or BIP)
                        
                        if (event.balls == 0 && event.strikes == 0) || pd_pitch_count == 1{ //First pitch strike was recorded (first pitch and fps)
                            pd_first_pitch_strikes += 1
                            pd_first_pitches += 1
                        }
                        
                        pd_strike_count += 1
                        
                        if event.pitch_result == "Z" || event.pitch_result == "T" || event.pitch_result == "TO" { //If strike was recorded as swinging (Swinging, Foul Ball, Foul Tip)
                            
                            pd_swings += 1
                            
                            if event.pitch_result == "Z" { //If strike was recorded as a swing and miss
                                pd_whiffs += 1
                            }
                        }
                            
                        if event.result_detail == "K" || event.result_detail == "C" || event.result_detail == "M"{ //If strikeout was recorded
                            
                            pd_strikeouts += 1
                            
                            if event.result_detail == "K" || event.result_detail == "M"{//Out was recorded on strikeout
                                
                                pd_inning_outs += 1
                                
                            }

                        }

                        else if event.pitch_result == "H" && event.result_detail != "E" { //Hit was recorded, but not an error
                            
                            pd_hits += 1
                            pd_swings += 1
                            
                            if event.result_detail == "D" || event.result_detail == "T" || event.result_detail == "H" { //XBH was recorded
                                
                                pd_xbh += 1
                                
                            }
                            
                        }
                        else if event.pitch_result == "O"{ //BIP Out was recorded
                            pd_inning_outs += 1
                            pd_swings += 1
                        }
                    }
                    else if event.pitch_result == "A" || event.result_detail == "B" { //Ball was recorded
                        
                        if (event.balls == 0 && event.strikes == 0) || pd_pitch_count == 1 { //First pitch ball was recorded
                            pd_first_pitches += 1
                        }
                        
                        if event.result_detail == "W" { //Walk was recorded
                            pd_walks += 1
                        }
                        else if event.result_detail == "B" { //HBP was recorded
                            pd_hbp += 1
                        }
                        
                    }

                }
                else if event.pitch_result == "VA" { //Pitch Clock Violation - Ball
                    
                    if event.result_detail == "W" { //Walk was recorded
                        pd_walks += 1
                    }
                }
                else if event.pitch_result == "VZ" { //Pitch Clock Violation - Strike
                    if event.result_detail == "K" { //Strikeout was recorded
                        pd_strikeouts += 1
                        pd_inning_outs += 1
                    }
                }
                else if event.result_detail == "R" || event.result_detail == "RE" { //Runner out was recorded
                    pd_inning_outs += 1
                }
                else if event.pitch_result == "IW" { //Intentional walk was recorded
                    pd_walks += 1
                }
            }
            
            //Resets outs if three outs are recorded, converts to innings pitched
            if pd_inning_outs == 3 {
                pd_inning_outs = 0
                pd_innings_pitched += 1
            }
            
        }
        
        //Calculate total innings pitched after iterating through events
        pd_innings_pitched = pd_innings_pitched + Double(pd_inning_outs) / 10
        
        
        //Calculate gauge values
        if pd_pitch_count > 0 { //Divison by zero handling
            pd_strike_per = Double(pd_strike_count) / Double(pd_pitch_count) //Strike Percentage
        }
        
        if pd_first_pitches > 0 { //Divison by zero handling
            pd_fps_per = Double(pd_first_pitch_strikes) / Double(pd_first_pitches) //First Pitch Strike Percentage
        }
        
        if pd_pitch_count > 0 { //Divison by zero handling
            pd_swing_per = Double(pd_swings) / Double(pd_pitch_count) //Swing Percentage
        }

        if pd_swings > 0 { //Divison by zero handling
            pd_whiff_per = Double(pd_whiffs) / Double(pd_swings) //Whiff Percentage
        }
        
        //Velo Component x-axis label logic
        pdv_start_index = (10 * Int((pdv_max_velo / 10.0).rounded(.down))) + 10
        
        //Sort Velo Component List by Velo
        var sorted_velo_list = pdv_component_data
        sorted_velo_list.sort { $0.velo < $1.velo }
        pdv_component_data.sort { $0.velo < $1.velo }
        print("Sorted Velo List: ", sorted_velo_list)
        
        //Calculating y_offset for Velo Component
        let min_velo_round_down = Int(pdv_min_velo.rounded(.down))
        let max_velo_round_down = Int(pdv_max_velo.rounded(.down))
        
        print("Max: \(min_velo_round_down), Min: \(max_velo_round_down)")
        
        var velo_cat = min_velo_round_down
        var velo_cat_num: Int = 0
        for pitch in sorted_velo_list {
            
            print(Int(pitch.velo.rounded(.down)))
            if Int(pitch.velo.rounded(.down)) != velo_cat {
                
                pdv_velo_layout.append(VeloLayoutData(velo_category: velo_cat, count: velo_cat_num))
                //Reset variables
                velo_cat_num = 0
                velo_cat = Int(pitch.velo.rounded(.down))
                
            }
            
            if Int(pitch.velo.rounded(.down)) == velo_cat {
                velo_cat_num += 1
            }
            
        }
        
        //Append last iteration of data if not already
        if velo_cat_num > 0 {
            pdv_velo_layout.append(VeloLayoutData(velo_category: velo_cat, count: velo_cat_num))
        }
        
        print("Velo Layout Data: \(pdv_velo_layout)")
        //print(sorted_velos.count)
        
        pdv_start_index = Int(pdv_max_velo) - 20
        print("Low Velo Value: ", pdv_start_index)
        
        var cur_velo_cat_count: Int = 0
        var velo_cat_count: Int = 0
        var velo_category: Int = 0
        var velo_index: Int = 0
        var start_of_velo_cat = true
        if !pdv_velo_layout.isEmpty {
            velo_cat_count = pdv_velo_layout[velo_index].count
            velo_category = pdv_velo_layout[velo_index].velo_category
        }
        
        var offset: CGFloat = 0
        for (index, pitch) in sorted_velo_list.enumerated(){
            
            //Current pitch is not in current velo category
            if pitch.velo.rounded(.down) != Double(velo_category){
                velo_index += 1
                velo_cat_count = pdv_velo_layout[velo_index].count
                velo_category = pdv_velo_layout[velo_index].velo_category
                cur_velo_cat_count = 0
                start_of_velo_cat = true
            }
            
            print(velo_cat_count == pdv_velo_layout[velo_index].count, velo_category)
            //
            if start_of_velo_cat == true {
                if velo_cat_count <= 5 {
                    offset = CGFloat(50 - (velo_cat_count * 5) + 5)

                }
                else {
                    cur_velo_cat_count = velo_cat_count - 5
                    velo_cat_count = 5
                    offset = CGFloat(50 - (velo_cat_count * 5) + 5)
                }
                
                start_of_velo_cat = false
                
                print("New Offset: \(offset)")
            }
            else {
                offset += 10
                print("Offset: \(offset)")
                if offset == 70 {
                    start_of_velo_cat = true
                    velo_cat_count = cur_velo_cat_count + 1
                }
            }
            
            velo_cat_count -= 1
            
            pdv_component_data[index].y_offset = offset
            
        }
        
        print(pdv_component_data)
        
        
        
        //var y_offset: CGFloat = 0
//        var offset_flip: CGFloat = 1
//        var index_velo = 0.0
//
//        for (index, pitch) in sorted_velo_list.enumerated() {
//            if index > 0 && sorted_velo_list[index].velo - index_velo <= 2{ //If previous velocity was too close
//                y_offset = abs(y_offset) + 13 * offset_flip
//                if y_offset > 1{
//                    offset_flip = -1
//                }
//                else if y_offset < -1{
//                    offset_flip = 1
//                }
//            }
//            else { // Previous velocity is now far enough away, reset variables
//                y_offset = 0
//                offset_flip = 1
//                index_velo = pitch.velo
//                //print("Index Velo:", index_velo)
//            }
//            
//            //Save y_offset to current iteration
//            pdv_component_data[index].y_offset = y_offset
//            
//        }

    }
    
    func generate_pitcher_appearance_list() {
        
        selected_pitcher_name = current_pitcher.firstName + " " + current_pitcher.lastName
        
        for event in events {
            if !pitcher_uuid_list.contains(event.pitcher_id) {
                pitcher_uuid_list.append(event.pitcher_id)
            }
        }
        
        for id in pitcher_uuid_list {
            for pitcher in pitchers {
                if id == pitcher.id {
                    let pitcher_name = pitcher.firstName + " " + pitcher.lastName
                    pitcher_appearance_list.append(PitcherAppeared(pitcher_id: pitcher.id, pitcher_name: pitcher_name, pitch1: pitcher.pitch1, pitch2: pitcher.pitch2, pitch3: pitcher.pitch3, pitch4: pitcher.pitch4))
                }
            }
        }
        
    }
    
    func generate_velo_component_datapoint(velo: Double, pitch_type: String) {
        
        var pitch_type_color: Color = Color.clear
        
        //Set pitch color according to pitch type
        if pitch_type == "P1" {
            pitch_type_color = Color.blue
            if velo > pdv_pitch1_max {
                pdv_pitch1_max = velo
            }
        }
        else if pitch_type == "P2" {
            pitch_type_color = Color.green
            if velo > pdv_pitch2_max {
                pdv_pitch2_max = velo
            }
        }
        else if pitch_type == "P3" {
            pitch_type_color = Color.orange
            if velo > pdv_pitch3_max {
                pdv_pitch3_max = velo
            }
        }
        else if pitch_type == "P4" {
            pitch_type_color = Color.gray
            if velo > pdv_pitch4_max {
                pdv_pitch4_max = velo
            }
        }
        
        if velo < pdv_min_velo || pdv_min_velo == 0.0{ //If current velo is less than minimum velo store or no value stored
            pdv_min_velo = velo
        }
        
        if velo > pdv_max_velo { //If current velo is greater than minimum velo store
            pdv_max_velo = velo
            //print("Max Velo: " + String(pdv_max_velo))
        }
        
        pdv_component_data.append(VeloComponentData(velo: velo, color: pitch_type_color, y_offset: 0.0))
        
    }
    
    func reset_player_detail_stats() {
        pd_innings_pitched = 0.0
        pd_inning_outs = 0
        pd_batters_faced = 0
        pd_hits = 0
        pd_xbh = 0
        pd_strikeouts = 0
        pd_walks = 0
        pd_hbp = 0
        pd_pitch_count = 0
        pd_strike_count = 0
        pd_swings = 0
        pd_whiffs = 0
        
        pd_strike_per = 0.0
        pd_fps_per = 0.0
        pd_first_pitch_strikes = 0
        pd_first_pitches = 0
        pd_swing_per = 0.0
        pd_whiff_per = 0.0
        
        pdv_component_data.removeAll()
        pdv_velo_layout.removeAll()
        pdv_min_velo = 0.0
        pdv_max_velo = 0.0
        pdv_start_index = 0
        pdv_pitch1 = ""
        pdv_pitch1_max = 0.0
        pdv_pitch2 = ""
        pdv_pitch2_max = 0.0
        pdv_pitch3 = ""
        pdv_pitch3_max = 0.0
        pdv_pitch4 = ""
        pdv_pitch4_max = 0.0
        
        pitcher_uuid_list.removeAll()
        pitcher_appearance_list.removeAll()
        
    }
    
    func generate_staff_stat_lines() {
        
        var first_char: String = ""
        var last_name: String = ""
        var innings_pitched: Double = 0.0
        var outs: Int = 0
        var batters_faced: Int = 0
        var strikeouts: Int = 0
        var walks: Int = 0
        var hbp: Int = 0
        var hits: Int = 0
        var xbh: Int = 0
        var homeruns: Int = 0
        var pitch_count: Int = 0
        var strike_count: Int = 0
        
        var current_pitcher_id: UUID = UUID()
        
        staff_lines_component.removeAll()
        
        if !events.isEmpty {  //Keeps error from being thrown w/o an event
            current_pitcher_id = events[0].pitcher_id
        }
        
        for event in events {
            if event.pitcher_id != current_pitcher_id { //Different pitcher than current selected pitcher
                //Generate First char and last name
                for pitcher in pitchers {
                    if pitcher.id == current_pitcher_id {
                        first_char = String(pitcher.firstName.prefix(1).uppercased())
                        last_name = pitcher.lastName
                        
                        break
                        
                    }
                }
                
                //Calculate partial innings pitched
                print("Outs: \(Double(outs/10))")
                innings_pitched = innings_pitched + Double(outs) / 10
                
                //Append instance to StaffStatLineComponent
                let stat_line = PlayerStatLineData(first_char: first_char, last_name: last_name, innings_pitched: innings_pitched, batters_faced: batters_faced, strikeouts: strikeouts, walks: walks, hbp: hbp, hits: hits, xbh: xbh, homeruns: homeruns, pitch_count: pitch_count, strike_count: strike_count)
                
                staff_lines_component.append(stat_line)
                //print("Staff Component: ", staff_lines_component)
                
                current_pitcher_id = event.pitcher_id
                
                first_char = ""
                last_name = ""
                innings_pitched = 0.0
                outs = 0
                batters_faced = 0
                strikeouts = 0
                walks = 0
                hbp = 0
                hits = 0
                xbh = 0
                homeruns = 0
                pitch_count = 0
                strike_count = 0
            }
                
            if end_ab_rd.contains(event.result_detail) { //If result detail matches a value in the end at bat list
                batters_faced += 1
            }
            
            if event.result_detail != "R" && event.result_detail != "RE" && event.pitch_result != "IW" && event.pitch_result != "VA" && event.pitch_result != "VZ"{ //If a pitch was thrown in event
                
                pitch_count += 1
         
                if event.pitch_result != "A" && event.result_detail != "B"{ //Ball was not recorded (Strike or BIP)
                 
                    strike_count += 1
                    
                    if event.pitch_result == "H" { //Hit was recorded
                        
                        hits += 1
                        
                        if event.result_detail == "D" || event.result_detail == "T"  || event.result_detail == "H" { //XBH was recorded
                            
                            xbh += 1
                            
                            if event.result_detail == "H" { //Homerun was recorded
                                
                                homeruns += 1
                                
                            }
                            
                        }
                        
                    }
                    else if event.pitch_result == "O" { //Out was recorded
                        
                        outs += 1
                        
                    }
                    else if event.result_detail == "K" || event.result_detail == "M" || event.result_detail == "C" { //Strikeout was recorded
                        
                        strikeouts += 1
                        
                        if event.result_detail == "K" || event.result_detail == "M" {//Out was recorded on strikeout
                            
                            outs += 1
                            
                        }
                        
                    }

                }
                else if event.pitch_result == "A" || event.result_detail == "B" { //Ball was recorded
                    
                    if event.result_detail == "B" { //HBP was recorded
                        
                            hbp += 1
                        
                    }
                    else if event.result_detail == "W" { //Walk was recorded
                        
                        walks += 1
                        
                    }
                    
                }
                
            }
            else if event.result_detail == "R" || event.result_detail == "RE" { //Runner out was recorded
            
                outs += 1
                
            }
            else if event.pitch_result == "VZ" { //Pitch Clock Violation - Strike
                if event.result_detail == "K" { //Strikeout was recorded
                    strikeouts += 1
                    outs += 1
                }
            }
            else if event.pitch_result == "VA" { //Pitch Clock Violation - Ball
                if event.result_detail == "W" { //Walk was recorded
                    walks += 1
                }
            }
            else if event.pitch_result == "IW" { //Intentional walk was recorded
                walks += 1
            }
            
            //Logic for converting outs into innings pitched
            
            if outs == 3 {
                innings_pitched += 1.0
                outs = 0
            }
   
        }
        
        for pitcher in pitchers {
            if pitcher.id == current_pitcher_id {
                first_char = String(pitcher.firstName.prefix(1).uppercased())
                last_name = pitcher.lastName
                
                break
                
            }
        }
        
        let stat_line = PlayerStatLineData(first_char: first_char, last_name: last_name, innings_pitched: innings_pitched, batters_faced: batters_faced, strikeouts: strikeouts, walks: walks, hbp: hbp, hits: hits, xbh: xbh, homeruns: homeruns, pitch_count: pitch_count, strike_count: strike_count)
        
        if !events.isEmpty {
            staff_lines_component.append(stat_line)
        }
        
        //print("Staff Component: ", staff_lines_component)
        
    }
    
}

//#Preview {
//    InGameStatsView()
//}
