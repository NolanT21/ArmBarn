//
//  SGStatsView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 6/11/25.
//

import SwiftUI

struct pitcher_game_info: Hashable {
    
    var first_name: String
    var last_name: String
    var innings_pitched: Double
    var batters_faced: Int
    var hits: Int
    var xbhs: Int
    var home_runs: Int
    var strikeouts: Int
    var walks: Int
    var hbps: Int
    var pitch_count: Int
    var strike_count: Int
    
}

struct swings_and_misses_data: Hashable  {
    
    var name: String
    var swings_and_misses: Int
    
}

struct top_velocity_data: Hashable  {
    
    var name: String
    var velocity: Double
    
}

struct pitch_type_data: Hashable  {
    
    var pitch_type: String
    var count: Int
    var max_velo: Double
    var swings: Int
    var whiff: Int
    var whiff_percentage: Double
    var hits: Int
    var fouls: Int
    var balls_in_play: Int
    var color: Color
    
}

struct SGStatsView: View {
    
    @AppStorage("SelectedVelocityUnits") var ASVelocityUnits : String?
    @State var velo_units: String = "mph"
    
    @State var game_data: SavedGames
    
    @State private var section_label_size: CGFloat = 11
    @State private var section_label_color: Color = Color.gray
    
    //Staff displaying variables
    @State private var staff_innings_pitched: Double = 0.0
    @State private var staff_batters_faced: Int = 0
    @State private var staff_hits: Int = 0
    @State private var staff_xbhs: Int = 0
    @State private var staff_homeruns: Int = 0
    @State private var staff_strikeouts: Int = 0
    @State private var staff_walks: Int = 0
    @State private var staff_hbps: Int = 0
    
    @State private var staff_strike_percentage: Double = 0.0
    @State private var staff_fps_percentage: Double = 0.0
    @State private var staff_game_score_number: Double = 0.0
    @State private var staff_game_score_chart_value: Double = 0.0
    
    //Player Detail Variables
    @State private var selected_pitcher_id: UUID = UUID()
    @State private var selected_pitcher_name: String = ""
    
    @State private var pd_innings_pitched: Double = 0.0
    @State private var pd_batters_faced: Int = 0
    @State private var pd_hits: Int = 0
    @State private var pd_xbhs: Int = 0
    @State private var pd_homeruns: Int = 0
    @State private var pd_strikeouts: Int = 0
    @State private var pd_walks: Int = 0
    @State private var pd_hbps: Int = 0
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
    
    @State private var pd_pitch1_stats: pitch_type_data = pitch_type_data(pitch_type: "", count: 0, max_velo: 0.0, swings: 0, whiff: 0, whiff_percentage: 0.0, hits: 0, fouls: 0, balls_in_play: 0, color: Color.blue)
    @State private var pd_pitch2_stats: pitch_type_data = pitch_type_data(pitch_type: "", count: 0, max_velo: 0.0, swings: 0, whiff: 0, whiff_percentage: 0.0, hits: 0, fouls: 0, balls_in_play: 0, color: Color.green)
    @State private var pd_pitch3_stats: pitch_type_data = pitch_type_data(pitch_type: "", count: 0, max_velo: 0.0, swings: 0, whiff: 0, whiff_percentage: 0.0, hits: 0, fouls: 0, balls_in_play: 0, color: Color.orange)
    @State private var pd_pitch4_stats: pitch_type_data = pitch_type_data(pitch_type: "", count: 0, max_velo: 0.0, swings: 0, whiff: 0, whiff_percentage: 0.0, hits: 0, fouls: 0, balls_in_play: 0, color: Color.gray)
//    @State private var pd_all_pitches_stats : pitch_type_data = pitch_type_data(pitch_type: "", count: 0, max_velo: 0.0, swings: 0, whiff: 0, whiff_percentage: 0.0, hits: 0, fouls: 0, balls_in_play: 0, color: Color.clear)
    
    @State private var pd_pitch_type_stats: [pitch_type_data] = []
    
    @State private var pd_pitch_type_colors: [Color] = [Color.blue, Color.green, Color.orange, Color.gray]
    
    //Variavles for player detail velocity component
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
    
    @State private var pdv_component_data: [VeloComponentData] = []
    @State private var pdv_velo_layout: [VeloLayoutData] = []
    
    //Game Data lists
    @State private var pitcher_stats_list: [pitcher_game_info] = []
    @State private var swings_and_misses_list: [swings_and_misses_data] = []
    @State private var velocity_list: [top_velocity_data] = []
    
    var game_score_gradient = Gradient(colors: [Color.orange, Color.green, Color.blue])
    
    @State private var view_padding: CGFloat = 10
    @State private var gauge_container_height: CGFloat = 100
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                //Staff Box Score
                VStack{
                    
                    HStack{
                        
                        Text("Staff Box Score")
                            .font(.system(size: section_label_size, weight: .regular))
                            .foregroundStyle(section_label_color)
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                            .padding(.leading, 15)
                        
                        Spacer()
                        
                    }
                    
                    Grid{
                        GridRow{
                            Text("IP")
                            Text("BF")
                            Text("H")
                            Text("XBH")
                            Text("HR")
                            Text("SO")
                            Text("BB")
                            Text("HBP")
                        }
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .font(.system(size: 13))
                        .padding(.bottom, -5)
                        
                        Divider()
                        
                        GridRow{
                            Text("\(staff_innings_pitched, specifier: "%.1f")")
                            Text("\(staff_batters_faced)")
                            Text("\(staff_hits)")
                            Text("\(staff_xbhs)")
                            Text("\(staff_homeruns)")
                            Text("\(staff_strikeouts)")
                            Text("\(staff_walks)")
                            Text("\(staff_hbps)")
                        }
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .font(.system(size: 15))
                        
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 5)
                .padding(.bottom, 5)
                .background(.regularMaterial)
                .cornerRadius(20)
                
                //Gauge Row
                HStack{
                    
                    VStack(spacing: 0){
                        
                        HStack{
                            Text("Staff Strike %")
                                .font(.system(size: section_label_size, weight: .regular))
                                .foregroundStyle(section_label_color)
                                .padding(.top, 10)
                                .padding(.leading, 15)
                            
                            Spacer()
                            
                        }
                        
                        VStack{
                            Gauge(value: staff_strike_percentage) {}
                                .scaleEffect(2.2)
                                .gaugeStyle(.accessoryCircularCapacity)
                                .tint(Color.blue)
                                .padding(10)
                                .overlay{
                                    Text("\(staff_strike_percentage * 100, specifier: "%.0f")") //Strike Percentage
                                        .font(.system(size: 40, weight: .bold))
                                }
                        }
                        .frame(height: 160)
                            
                    }
                    .background(.regularMaterial)
                    .cornerRadius(20)
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        
                        HStack{
                            Text("Staff FPS %")
                                .font(.system(size: section_label_size, weight: .regular))
                                .foregroundStyle(section_label_color)
                                .padding(.top, 10)
                                .padding(.leading, 15)
                            
                            Spacer()
                            
                        }
                        
                        VStack{
                            Gauge(value: staff_fps_percentage) {}
                                .scaleEffect(2.2)
                                .gaugeStyle(.accessoryCircularCapacity)
                                .tint(Color.green)
                                .padding(10)
                                .overlay {
                                    Text("\(staff_fps_percentage * 100, specifier: "%.0f")") //Strike Percentage
                                        .font(.system(size: 40, weight: .bold))
                                }
                            
                        }
                        .frame(height: 160)
                        
                    }
                    .background(.regularMaterial)
                    .cornerRadius(20)
                        
                }
                
                //Game Score
                VStack{
                    VStack{
                        
                        HStack{
                            
                            Text("Staff Game Score")
                                .font(.system(size: section_label_size, weight: .regular))
                                .foregroundStyle(section_label_color)
                            
                            Spacer()
                            
                        }
                        
                        VStack{
                            
                            HStack{
                                
                                Text("\(staff_game_score_number, specifier: "%0.f")")
                                    .font(.system(size: 36, weight: .semibold))
                                
                                Spacer()
                                
                            }
                            .padding(.top, 2)
                            
                            Gauge(value: Double(staff_game_score_chart_value) * 0.01) {}
                                .gaugeStyle(.accessoryLinear)
                                .tint(game_score_gradient)
                                .padding(.top, -20)
                            //.padding(.bottom, 5)
                            
                        }
                        
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 15)
                    .background(.regularMaterial)
                    .cornerRadius(20)
                    
                    HStack{
                        
                        Text("*")
                            .baselineOffset(3.0)
                            .foregroundStyle(.gray)
                            .font(.system(size: 10))
                        
                        + Text("Calculated using Tango's formula excluding runs, every baserunner has value added based on a run expectancy matrix")
                            .foregroundStyle(.gray)
                            .font(.system(size: 10))
                        
                        Spacer()
                        
                    }
                    .padding(.top, view_padding * -0.8)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 3)
                    
                }
                
                //Player Detail
                playerDetail()
                
                //Individual stat lines
                VStack{
                    
                    Grid{
                        ForEach(Array(pitcher_stats_list.enumerated()), id: \.offset){ index, statline in
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
                                Text(statline.first_name.prefix(1) + ". " + statline.last_name)
                                    .gridCellAnchor(.leading)
                                Text("\(statline.innings_pitched, specifier: "%.1f")")
                                Text("\(statline.batters_faced)")
                                Text("\(statline.hits)")
                                Text("\(statline.xbhs)")
                                Text("\(statline.home_runs)")
                                Text("\(statline.strikeouts)")
                                Text("\(statline.walks)")
                                Text("\(statline.hbps)")
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
                
                //Velocity & Swing and Misses Row
                HStack(alignment: .top) {
                    VStack { //Top 5 Pitch Velos
                        Grid{
                            ForEach(Array(velocity_list.enumerated()), id: \.offset) { index, data_row in
                                
                                if index < 5 {
                                    
                                    //Text("Top Pitch Velocity")
                                    if index == 0 {
                                        GridRow {
                                            Text("Top Pitch Velocity")
                                                .gridCellAnchor(.leading)
                                                .font(.system(size: 11, weight: .regular))
                                                .foregroundStyle(Color.gray)
                                            Text(velo_units.uppercased())
                                                .gridCellAnchor(.trailing)
                                                .font(.system(size: 11, weight: .regular))
                                                .foregroundStyle(Color.gray)
                                        }
                                        
                                        Divider()
                                            //.padding(.top, -5)
                                        
                                    }
                                    
                                    GridRow {
                                        Text(data_row.name)
                                            .gridCellAnchor(.leading)
                                            .font(.system(size: 13, weight: .semibold))
                                        HStack{
                                            
                                            Spacer()
                                            
                                            Text("\(data_row.velocity, specifier: "%.1f")")
                                                
                                                .font(.system(size: 13, weight: .semibold))
                                        }
                                        .gridCellAnchor(.trailing)
                                        .frame(width: 50)
                                    }
                                    .padding(.bottom, 0.1)
                                    
                                }
                                
                            }
                                
                        }

                    }
                    .frame(height: 125, alignment: .top)
                    .padding(10)
                    .background(.regularMaterial)
                    .cornerRadius(20)
                    
                    VStack { //Top 5 Swings and misses
                        Grid{
                            ForEach(Array(swings_and_misses_list.enumerated()), id: \.offset) { index, data_row in
                                
                                if index < 5 {
                                    if index == 0 {
                                        GridRow {
                                            Text("Swings & Misses")
                                                .gridCellAnchor(.leading)
                                                .font(.system(size: 11, weight: .regular))
                                                .foregroundStyle(Color.gray)
                                            Text("#")
                                                .gridCellAnchor(.trailing)
                                                .font(.system(size: 11, weight: .regular))
                                                .foregroundStyle(Color.gray)
                                        }
                                        
                                        Divider()
                                            //.padding(.top, -5)
                                        
                                    }
                                    
                                    GridRow {
                                        Text(data_row.name)
                                            .gridCellAnchor(.leading)
                                            .font(.system(size: 13, weight: .semibold))
                                        Text("\(data_row.swings_and_misses)")
                                            .gridCellAnchor(.trailing)
                                            .font(.system(size: 13, weight: .semibold))
                                    }
                                    .padding(.bottom, 2)
                                }
                                
                                
                            }
                        }
                    }
                    .frame(height: 125, alignment: .top)
                    .padding(10)
                    .background(.regularMaterial)
                    .cornerRadius(20)

                    
                }
                .padding(.top, 0.5)
                
            }
            .padding(.horizontal, 10)
            
        }
        .onAppear {
            
            selected_pitcher_id = game_data.pitcher_info[0].pitcher_id
            
            pdv_pitch1 = game_data.pitcher_info[0].pitch1
            pdv_pitch2 = game_data.pitcher_info[0].pitch2
            pdv_pitch3 = game_data.pitcher_info[0].pitch3
            pdv_pitch4 = game_data.pitcher_info[0].pitch4
            
            //Reset player detail pitch type structs
            reset_player_detail_pitch_type_data()
            
            pd_pitch1_stats.pitch_type = pdv_pitch1
            pd_pitch2_stats.pitch_type = pdv_pitch2
            pd_pitch3_stats.pitch_type = pdv_pitch3
            pd_pitch4_stats.pitch_type = pdv_pitch4
            
            pdv_component_data.removeAll()
            pd_pitch_type_stats.removeAll()
            pitcher_stats_list.removeAll()
            swings_and_misses_list.removeAll()
            velocity_list.removeAll()
            
            generate_saved_games_stats()
            generate_player_detail_stats()
            
            if ASVelocityUnits != nil {
                velo_units = ASVelocityUnits?.lowercased() ?? "mph"
            }
            
        }
        
    }
    
    @ViewBuilder
    func playerDetail() -> some View {
        VStack{
            
            HStack{
                
                Menu{
                    ForEach(Array(game_data.pitcher_info.enumerated()), id: \.offset) { index, pitcher_info in
                        Button(action: {
                            
                            selected_pitcher_id = pitcher_info.pitcher_id
                            selected_pitcher_name = pitcher_info.first_name + " " + pitcher_info.last_name
                            
                            reset_player_detail_pitch_type_data()
                            
                            pd_pitch1_stats.pitch_type = pitcher_info.pitch1
                            pd_pitch2_stats.pitch_type = pitcher_info.pitch2
                            pd_pitch3_stats.pitch_type = pitcher_info.pitch3
                            pd_pitch4_stats.pitch_type = pitcher_info.pitch4
                            
                            generate_player_detail_stats()
                            
                        }) {
                            Text(pitcher_info.first_name + " " + pitcher_info.last_name)
                        }
                    }
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
            .padding(.top, 20)
            .padding(.bottom, 15)
            
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
                    Text("\(pd_xbhs)")
                    Text("\(pd_strikeouts)")
                    Text("\(pd_walks)")
                    Text("\(pd_hbps)")
                    Text("\(pd_pitch_count)-\(pd_strike_count)")
                }
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .font(.system(size: 15))
                
            }
            .padding(.horizontal, 20)
            
            //Gauges Components
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
            .padding(.vertical, 15)
            
            veloComponent()
                .padding(.vertical, 10)
            
            //Pitch Type Detail w/ Legend for velo component
            HStack{
                Grid() {
                    ForEach(Array(pd_pitch_type_stats.enumerated()), id: \.offset) { index, pitch_type in
                        if index == 0 {
                            
                            GridRow {
                                Text("Pitch Type")
                                    .gridCellAnchor(.leading)
                                Text("#")
                                Text("Max")
                                Text("Swings")
                                Text("Whiffs")
                                //Text("%")
                                Text("H")
                                Text("Foul")
                                Text("BIP")
                            }
                            .foregroundStyle(.gray)
                            .font(.system(size: 13, weight: .regular))
                            .padding(.bottom, -3)
                            
                            Divider()
                            
                        }
                        
                        if pitch_type.color == .clear {
                            Divider()
                                //.padding(.top, -3)
                        }
                        
                        if pitch_type.count != 0 {
                            GridRow {
                                HStack{
                                    if pitch_type.color != .clear {
                                        Circle()
                                            .frame(width: 12, height: 12)
                                            .foregroundColor(pitch_type.color)
                                    }
                
                                    Text(pitch_type.pitch_type)
                                }
                                .gridCellAnchor(.leading)
                                .frame(height: 3)
                                
                                Text("\(pitch_type.count)")
                                Text("\(pitch_type.max_velo, specifier: "%.1f")")
                                Text("\(pitch_type.swings)")
                                Text("\(pitch_type.whiff)")
                                //Text("\(pitch_type.whiff_percentage, specifier: "%.1f")")
                                Text("\(pitch_type.hits)")
                                Text("\(pitch_type.fouls)")
                                Text("\(pitch_type.balls_in_play)")
                            }
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(pitch_type.color != .clear ? Color.white : Color.gray)
                            .padding(.top, pitch_type.color != .clear ? 0 : -3)
                        }
                        
                    }
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 5)
                
            }
            .padding(.bottom, 10)
            
        }
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
                        
                        Text("\(pdv_start_index + 20)" + velo_units)
                            .position(x: (width * (4/5)) + 10, y: 110)
                            .font(.system(size: 11))
                            .foregroundStyle(Color.gray)
                        
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
        .frame(height: 120)
    }
    
    //MARK: Pitch Max Velo Written
    
    func generate_pitch_detail_key(pitch_type: String, pitch_result: String, result_detail: String, velocity: Double, data_set: pitch_type_data) -> pitch_type_data {
        
        //Logic for calculating
        var pitch_data_set: pitch_type_data = data_set
        var max_velo = 0.0
        var swings = 0
        var whiffs = 0
        var hits = 0
        var fouls = 0
        var bips = 0
        
        if pitch_result == "H" && (result_detail != "E" && result_detail != "B") { //Hit

            hits += 1
            swings += 1
            bips += 1
        }
        
        if pitch_result == "O" { //Out
            
            bips += 1
            
            if result_detail != "Y" {
                
                swings += 1
                
            }
        
        }
        
        if pitch_result == "Z" { //Strike
            
            whiffs += 1
            
        }
        
        if pitch_result == "T" || pitch_result == "TO"{ //Foul Ball
            
            swings += 1
            fouls += 1
            
        }
        
        if pitch_data_set.max_velo < velocity {
            pitch_data_set.max_velo = velocity
        }
        
        pitch_data_set.count += 1
        pitch_data_set.swings += swings
        pitch_data_set.whiff += whiffs
        pitch_data_set.hits += hits
        pitch_data_set.fouls += fouls
        pitch_data_set.balls_in_play += bips
        
        return pitch_data_set
        
    }
    
    func generate_player_detail_stats() {
        
        var saved_game_data = game_data.game_data
        saved_game_data.sort{$0.event_num < $1.event_num}
        
        let end_ab_rd: [String] = ["S", "D", "T", "H", "E", "B", "F", "G", "L", "P", "Y", "W", "K", "C", "M", "RE"]
        
        var innings_pitched = 0.0
        var inning_outs = 0
        var outs = 0
        var batters_faced = 0
        var pitch_count = 0
        var first_pitches = 0
        var first_pitch_strikes = 0
        var strike_count = 0
        var swings = 0
        var whiffs = 0
        var hits = 0
        var xbh = 0
        var homeruns = 0
        var strikeouts = 0
        var walks = 0
        var hbp = 0
        
        for (index, event) in saved_game_data.enumerated() {
         
            if event.pitcher_id == selected_pitcher_id {
                
                if end_ab_rd.contains(event.result_detail) {
                    batters_faced += 1
                }
                
                if event.result_detail != "R" && event.result_detail != "RE" && event.pitch_result != "IW" && event.pitch_result != "VA" && event.pitch_result != "VZ"{ //If a pitch was thrown in event
                    
                    pitch_count += 1
                    generate_velo_component_datapoint(velo: event.velocity, pitch_type: event.pitch_type)
                    
                    if event.pitch_type == "P1" {
                        pd_pitch1_stats = generate_pitch_detail_key(pitch_type: event.pitch_type, pitch_result: event.pitch_result, result_detail: event.result_detail, velocity: event.velocity, data_set: pd_pitch1_stats)
                    }
                    else if event.pitch_type == "P2" {
                        pd_pitch2_stats = generate_pitch_detail_key(pitch_type: event.pitch_type, pitch_result: event.pitch_result, result_detail: event.result_detail, velocity: event.velocity, data_set: pd_pitch2_stats)
                    }
                    else if event.pitch_type == "P3" {
                        pd_pitch3_stats = generate_pitch_detail_key(pitch_type: event.pitch_type, pitch_result: event.pitch_result, result_detail: event.result_detail, velocity: event.velocity, data_set: pd_pitch3_stats)
                    }
                    else if event.pitch_type == "P4" {
                        pd_pitch4_stats = generate_pitch_detail_key(pitch_type: event.pitch_type, pitch_result: event.pitch_result, result_detail: event.result_detail, velocity: event.velocity, data_set: pd_pitch4_stats)
                    }
                    
                    
                    if event.pitch_result != "A" && event.result_detail != "B"{ //Ball was not recorded (Strike or BIP)
                        
                        if (event.balls == 0 && event.strikes == 0) || pitch_count == 1{ //First pitch strike was recorded (first pitch and fps)
                            first_pitch_strikes += 1
                            first_pitches += 1
                        }
                        
                        strike_count += 1
                        
                        if event.pitch_result == "Z" || event.pitch_result == "T" || event.pitch_result == "TO" { //If strike was recorded as swinging (Swinging, Foul Ball, Foul Tip)
                            
                            swings += 1
                            
                            if event.pitch_result == "Z" { //If strike was recorded as a swing and miss
                                whiffs += 1
                            }
                        }
                            
                        if event.result_detail == "K" || event.result_detail == "C" || event.result_detail == "M"{ //If strikeout was recorded
                            
                            strikeouts += 1
                            
                            if event.result_detail == "K" || event.result_detail == "M"{//Out was recorded on strikeout
                                
                                inning_outs += 1
                                
                            }

                        }

                        else if event.pitch_result == "H" && event.result_detail != "E" { //Hit was recorded, but not an error
                            
                            hits += 1
                            swings += 1
                            
                            if event.result_detail == "D" || event.result_detail == "T" || event.result_detail == "H" { //XBH was recorded
                                
                                xbh += 1
                                
                            }
                            
                        }
                        else if event.pitch_result == "O"{ //BIP Out was recorded
                            inning_outs += 1
                            swings += 1
                        }
                    }
                    else if event.pitch_result == "A" || event.result_detail == "B" { //Ball was recorded
                        
                        if (event.balls == 0 && event.strikes == 0) || pitch_count == 1 { //First pitch ball was recorded
                            first_pitches += 1
                        }
                        
                        if event.result_detail == "W" { //Walk was recorded
                            walks += 1
                        }
                        else if event.result_detail == "B" { //HBP was recorded
                            hbp += 1
                        }
                        
                    }

                }
                else if event.pitch_result == "VA" { //Pitch Clock Violation - Ball
                    
                    if event.result_detail == "W" { //Walk was recorded
                        walks += 1
                    }
                }
                else if event.pitch_result == "VZ" { //Pitch Clock Violation - Strike
                    if event.result_detail == "K" { //Strikeout was recorded
                        strikeouts += 1
                        inning_outs += 1
                    }
                }
                else if event.result_detail == "R" || event.result_detail == "RE" { //Runner out was recorded
                    inning_outs += 1
                }
                else if event.pitch_result == "IW" { //Intentional walk was recorded
                    walks += 1
                }
                
                //Resets outs if three outs are recorded, converts to innings pitched
                if inning_outs == 3 {
                    inning_outs = 0
                    innings_pitched += 1
                }
                
            }
            
        } //End of For Loop
        
        pd_innings_pitched = Double(innings_pitched) + (Double(inning_outs) / 10)
        pd_batters_faced = batters_faced
        pd_hits = hits
        pd_xbhs = xbh
        pd_strikeouts = strikeouts
        pd_walks = walks
        pd_hbps = hbp
        pd_pitch_count = pitch_count
        pd_strike_count = strike_count
        
        pd_strike_per = Double(strike_count) / Double(pitch_count) //Strike Percentage
        pd_fps_per = Double(first_pitch_strikes) / Double(first_pitches) //First Pitch Strike Percentage
        pd_swing_per = Double(swings) / Double(pitch_count) //Swing Percentage
        pd_whiff_per = Double(whiffs) / Double(swings) //Whiff Percentage
        
        //Total row for pitch_type_detail
        let total_count = pd_pitch1_stats.count + pd_pitch2_stats.count + pd_pitch3_stats.count + pd_pitch4_stats.count
        let total_swings = pd_pitch1_stats.swings + pd_pitch2_stats.swings + pd_pitch3_stats.swings + pd_pitch4_stats.swings
        let total_whiffs = pd_pitch1_stats.whiff + pd_pitch2_stats.whiff + pd_pitch3_stats.whiff + pd_pitch4_stats.whiff
        let total_hits = pd_pitch1_stats.hits + pd_pitch2_stats.hits + pd_pitch3_stats.hits + pd_pitch4_stats.hits
        let total_fouls = pd_pitch1_stats.fouls + pd_pitch2_stats.fouls + pd_pitch3_stats.fouls + pd_pitch4_stats.fouls
        let total_balls_in_play = pd_pitch1_stats.balls_in_play + pd_pitch2_stats.balls_in_play + pd_pitch3_stats.balls_in_play + pd_pitch4_stats.balls_in_play
        
        let total_max_velo_list = [pd_pitch1_stats.max_velo, pd_pitch2_stats.max_velo, pd_pitch3_stats.max_velo, pd_pitch4_stats.max_velo]
        var max_velo: Double = pd_pitch1_stats.max_velo
        for velo in total_max_velo_list {
            if velo > max_velo {
                max_velo = velo
            }
        }
        
        let pd_all_pitches_stats: pitch_type_data = pitch_type_data(pitch_type: "Totals", count: total_count, max_velo: max_velo, swings: total_swings, whiff: total_whiffs, whiff_percentage: 0.0, hits: total_hits, fouls: total_fouls, balls_in_play: total_balls_in_play, color: Color.clear)
        
        pd_pitch_type_stats.append(pd_pitch1_stats)
        pd_pitch_type_stats.append(pd_pitch2_stats)
        pd_pitch_type_stats.append(pd_pitch3_stats)
        pd_pitch_type_stats.append(pd_pitch4_stats)
        pd_pitch_type_stats.append(pd_all_pitches_stats)
        
        //Sort Velo Component List by Velo
        var sorted_velo_list = pdv_component_data
        sorted_velo_list.sort { $0.velo < $1.velo }
        pdv_component_data.sort { $0.velo < $1.velo }
        //print("Sorted Velo List: ", sorted_velo_list)
        
        //Calculating y_offset for Velo Component
        let min_velo_round_down = Int(pdv_min_velo.rounded(.down))
        let max_velo_round_down = Int(pdv_max_velo.rounded(.down))
        
        //print("Max: \(min_velo_round_down), Min: \(max_velo_round_down)")
        
        var velo_cat = min_velo_round_down
        var velo_cat_num: Int = 0
        for pitch in sorted_velo_list {
            
            //print(Int(pitch.velo.rounded(.down)))
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
        
        //print("Velo Layout Data: \(pdv_velo_layout)")
        //print(sorted_velos.count)
        
        pdv_start_index = Int(pdv_max_velo) - 20
        //print("Low Velo Value: ", pdv_start_index)
        
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
            
            //print(velo_cat_count == pdv_velo_layout[velo_index].count, velo_category)
            
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
                
                //print("New Offset: \(offset)")
            }
            else {
                offset += 10
                //print("Offset: \(offset)")
                if offset == 70 {
                    start_of_velo_cat = true
                    velo_cat_count = cur_velo_cat_count + 1
                }
            }
            
            velo_cat_count -= 1
            
            pdv_component_data[index].y_offset = offset
            
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
    
    func generate_saved_games_stats() {
        
        var saved_game_data = game_data.game_data
        saved_game_data.sort{$0.event_num < $1.event_num}
        
        let end_ab_rd: [String] = ["S", "D", "T", "H", "E", "B", "F", "G", "L", "P", "Y", "W", "K", "C", "M", "RE"]
        
        var total_innings_pitched = 0.0
        var total_outs = 0
        var total_batters_faced = 0
        var total_hits = 0
        var total_xbhs = 0
        var total_homeruns = 0
        var total_strikeouts = 0
        var total_walks = 0
        var total_hbps = 0
        
        var total_strikes = 0
        var total_pitches = 0
        var total_first_pitches = 0
        var total_fps = 0
        
        var game_score = 40.0
        
        //Need pitcher_id to start
        //Switch on change, reset stats and push datapoint to list
        let pitcher_data = game_data.pitcher_info[0]
        var cur_pitcher_id = pitcher_data.pitcher_id
        //var cp_name: String = pitcher_data.first_name + " " + pitcher_data.last_name
        var cp_first_name: String = pitcher_data.first_name
        var cp_last_name: String = pitcher_data.last_name
        var cp_innings_pitched: Double = 0.0
        var cp_outs: Double = 0.0
        var cp_batters_faced: Int = 0
        var cp_hits: Int = 0
        var cp_xbhs: Int = 0
        var cp_homeruns: Int = 0
        var cp_strikeouts: Int = 0
        var cp_walks: Int = 0
        var cp_hbps: Int = 0
        var cp_pitch_count: Int = 0
        var cp_strike_count: Int = 0
        
        var cp_swings_and_misses: Int = 0
        
        //Player Detail Variables
        let starting_pitcher = pitcher_data.first_name + " " + pitcher_data.last_name
        
        for (index, event) in saved_game_data.enumerated() {
            
            //if id does not equal event id
            //reset player variables
            //switch id to current id

            if event.pitcher_id != cur_pitcher_id {
                
                //Store cur pitcher info to struct
                pitcher_stats_list.append(pitcher_game_info(first_name: cp_first_name, last_name: cp_last_name, innings_pitched: Double(cp_innings_pitched) + Double(cp_outs / 10), batters_faced: cp_batters_faced, hits: cp_hits, xbhs: cp_xbhs, home_runs: cp_homeruns, strikeouts: cp_strikeouts, walks: cp_walks, hbps: cp_hbps, pitch_count: cp_pitch_count, strike_count: cp_strike_count))
                
                swings_and_misses_list.append(swings_and_misses_data(name: cp_first_name + " " + cp_last_name, swings_and_misses: cp_swings_and_misses))
                
                for pitcher in game_data.pitcher_info {
                    
                    if pitcher.pitcher_id == event.pitcher_id {
                        
                        cur_pitcher_id = event.pitcher_id
                        
                        cp_first_name = pitcher.first_name
                        cp_last_name = pitcher.last_name
                        cp_innings_pitched = 0.0
                        cp_outs = 0
                        cp_batters_faced = 0
                        cp_hits = 0
                        cp_xbhs = 0
                        cp_homeruns = 0
                        cp_strikeouts = 0
                        cp_walks = 0
                        cp_hbps = 0
                        cp_pitch_count = 0
                        cp_strike_count = 0
                        
                        cp_swings_and_misses = 0
                        
                        //break
                        
                    }
                    
                }
            }
            
            if event.pitch_result != "VA" && event.pitch_result != "VZ" && event.pitch_result != "IW" && event.result_detail != "R" && event.result_detail != "RE" {
                
                total_pitches += 1
                cp_pitch_count += 1
                
                if event.balls == 0 && event.strikes == 0 { total_first_pitches += 1 } //Total first pitches

                if event.pitch_result != "A" && event.result_detail != "B"{
                    
                    total_strikes += 1
                    cp_strike_count += 1
                    
                    if event.balls == 0 && event.strikes == 0 { total_fps += 1 } //Total first pitch strikes
                    
                    if event.pitch_result == "Z" { cp_swings_and_misses += 1 } //Total swing and misses for current pitcher
                    
                    if event.pitch_result == "H" { //Hit was recorded
                        
                        if event.result_detail == "S" {
                            
                            game_score -= 2
                            total_hits += 1
                            cp_hits += 1
                            
                        }
                        else if event.result_detail == "D" {
                            
                            game_score -= 2
                            total_hits += 1
                            total_xbhs += 1
                            
                            cp_hits += 1
                            cp_xbhs += 1
                            
                        }
                        else if event.result_detail == "T" {
                            
                            game_score -= 2
                            total_hits += 1
                            total_xbhs += 1
                            
                            cp_hits += 1
                            cp_xbhs += 1
                            
                        }
                        else if event.result_detail == "H" {
                            
                            game_score -= 8
                            total_hits += 1
                            total_xbhs += 1
                            total_homeruns += 1
                            
                            cp_hits += 1
                            cp_xbhs += 1
                            cp_homeruns += 1
                            
                        }
                        
                    }
                    
                    else if event.pitch_result == "O" { //Out was recorded
                         
                        game_score += 2
                        total_outs += 1
                        cp_outs += 1
                        
                    }
                    
                    else if event.result_detail == "K" || event.result_detail == "C" || event.result_detail == "M"{
                        
                        game_score += 3
                        total_strikeouts += 1
                        cp_strikeouts += 1
                        
                        if event.result_detail != "C" {
                            
                            total_outs += 1
                            cp_outs += 1
                            
                        }
                        
                    }
                    
                }
                else if event.pitch_result == "B" {
                    
                    total_hbps += 1
                    cp_hbps += 1
                    
                }
                else if event.result_detail == "W" {
                    
                    game_score -= 2
                    total_walks += 1
                    cp_walks += 1
                    
                }
                
            }
            else if event.pitch_result == "VZ" {
                
                if event.result_detail == "K" {
                    
                    game_score += 3
                    total_outs += 1
                    cp_outs += 1
                    
                }
                
            }
            else if event.pitch_result == "VA" {
                
                if event.result_detail == "W" {
                    
                    game_score -= 2
                    total_walks += 1
                    cp_walks += 1
                    
                }
                
            }
            else if event.result_detail == "R" || event.result_detail == "RE" {
                
                game_score += 2
                total_outs += 1
                cp_outs += 1
                
            }
            
            if end_ab_rd.contains(event.result_detail) { //Logic for calculating batters faced
                
                total_batters_faced += 1
                cp_batters_faced += 1
                
            }
            
            if total_outs == 3 { //Logic for calculating total innings pitched
                
                total_outs = 0
                total_innings_pitched += 1
                
            }
            
            if cp_outs == 3 { //Logic for calculating total innings pitched for current pitcher
                
                cp_outs = 0
                cp_innings_pitched += 1
                
            }
            
            //Logic for recording top 5 velos of game
            velocity_list.append(top_velocity_data(name: cp_first_name + " " + cp_last_name, velocity: event.velocity))

        }
        //End of Event Loop
        
        staff_innings_pitched = Double(total_innings_pitched) + Double(total_outs / 10)
        staff_batters_faced = total_batters_faced
        staff_hits = total_hits
        staff_xbhs = total_xbhs
        staff_homeruns = total_homeruns
        staff_strikeouts = total_strikeouts
        staff_walks = total_walks
        staff_hbps = total_hbps
        
        staff_strike_percentage = Double(total_strikes) / Double(total_pitches)

        staff_fps_percentage = Double(total_fps) / Double(total_first_pitches)
        
        staff_game_score_number = game_score
        staff_game_score_chart_value = game_score
        if staff_game_score_chart_value > 100 {
            staff_game_score_chart_value = 100
        }
        else if staff_game_score_chart_value < 0 {
            staff_game_score_chart_value = 0
        }
        
        pitcher_stats_list.append(pitcher_game_info(first_name: cp_first_name, last_name: cp_last_name, innings_pitched: cp_innings_pitched + Double(cp_outs / 10), batters_faced: cp_batters_faced, hits: cp_hits, xbhs: cp_xbhs, home_runs: cp_homeruns, strikeouts: cp_strikeouts, walks: cp_walks, hbps: cp_hbps, pitch_count: cp_pitch_count, strike_count: cp_strike_count))
        
        swings_and_misses_list.append(swings_and_misses_data(name: cp_first_name + " " + cp_last_name, swings_and_misses: cp_swings_and_misses))
        
        velocity_list.sort{ $0.velocity > $1.velocity }
        
        selected_pitcher_name = starting_pitcher
        
    }
    
    func reset_player_detail_pitch_type_data(){
        
        pdv_component_data.removeAll()
        pdv_pitch1_max = 0.0
        pdv_pitch2_max = 0.0
        pdv_pitch3_max = 0.0
        pdv_pitch4_max = 0.0
        pdv_max_velo = 0.0
        pdv_min_velo = 0.0
        
        pd_pitch_type_stats.removeAll()
        
        pd_pitch1_stats.pitch_type = ""
        pd_pitch1_stats.count = 0
        pd_pitch1_stats.max_velo = 0.0
        pd_pitch1_stats.swings = 0
        pd_pitch1_stats.whiff = 0
        pd_pitch1_stats.hits = 0
        pd_pitch1_stats.fouls = 0
        pd_pitch1_stats.balls_in_play = 0
        
        pd_pitch2_stats.pitch_type = ""
        pd_pitch2_stats.count = 0
        pd_pitch2_stats.max_velo = 0.0
        pd_pitch2_stats.swings = 0
        pd_pitch2_stats.whiff = 0
        pd_pitch2_stats.hits = 0
        pd_pitch2_stats.fouls = 0
        pd_pitch2_stats.balls_in_play = 0
        
        pd_pitch3_stats.pitch_type = ""
        pd_pitch3_stats.count = 0
        pd_pitch3_stats.max_velo = 0.0
        pd_pitch3_stats.swings = 0
        pd_pitch3_stats.whiff = 0
        pd_pitch3_stats.hits = 0
        pd_pitch3_stats.fouls = 0
        pd_pitch3_stats.balls_in_play = 0
        
        pd_pitch4_stats.pitch_type = ""
        pd_pitch4_stats.count = 0
        pd_pitch4_stats.max_velo = 0.0
        pd_pitch4_stats.swings = 0
        pd_pitch4_stats.whiff = 0
        pd_pitch4_stats.hits = 0
        pd_pitch4_stats.fouls = 0
        pd_pitch4_stats.balls_in_play = 0
        
    }
    
}

//#Preview {
//    SGStatsView()
//}
