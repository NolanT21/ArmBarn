//
//  GameReportView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 2/4/24.
//

import SwiftUI
import SwiftData
import Charts
import TipKit

struct GameReportView: View {
    
    @AppStorage("BatterStance") var ASBatterStance : Bool?
    @AppStorage("VelocityInput") var ASVeloInput : Bool?
    @AppStorage("StrikeType") var ASStrikeType : Bool?
    
    @AppStorage("BoxScore") var ASBoxScore : Bool?
    @AppStorage("StrikePer") var ASStrikePer : Bool?
    @AppStorage("Location") var ASLocation : Bool?
    @AppStorage("HitSummary") var ASHitSummary : Bool?
    @AppStorage("GameScore") var ASGameScore : Bool?
    @AppStorage("PitByInn") var ASPitByInn : Bool?
    
    @Environment(GameReport.self) var game_report
    @Environment(currentPitcher.self) var current_pitcher
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(Event_String.self) var event
    
    @Query var events: [Event]
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var showPBPLog = false
    @State private var showExportPR = false
    
    var gradient = Gradient(colors: [Color("PowderBlue"), Color("Gold"), Color("Tangerine")])
    var colorset = [Color("PowderBlue"), Color("Gold"), Color("Tangerine"), Color("Grey")]
    
    var view_padding: CGFloat = 10
    var view_crnr_radius: CGFloat = 12
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    @State var _default: CGFloat = 17.0
    @State var title_size: CGFloat = 28.0
    @State var headbody_size: CGFloat = 17
    @State var callout_size: CGFloat = 16
    @State var subheadline_size: CGFloat = 15
    @State var caption_size: CGFloat = 12
    @State var caption2_size: CGFloat = 11
    
    var background: Color = .black
    var component_background: UIColor = .darkGray
    var text_color: Color = .white
    var legend_color: Color = .gray
    
    let background_gradient = Gradient(colors: [Color("ScoreboardGreen"), .black, .black, .black, .black, .black])
    let header_gradient = Gradient(colors: [Color("ScoreboardGreen"), Color("ScoreboardGreen"), Color("ScoreboardGreen"), .black])
    
    var body: some View {
        
        ZStack{
            
            GeometryReader { proxy in
                
                let viewsize = proxy.size
                
                VStack{
                    HStack{
                        
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .imageScale(.medium)
                                .font(.system(size: 17))
                                .frame(width: sbl_width, height: sbl_height)
                                .foregroundColor(text_color)
                                .bold()
                        })
                        
                        Spacer()
                        
                        HStack(alignment: .center){
                            
                            Button(action: {
                                showPBPLog.toggle()
                            }) {
                                if showPBPLog == false {
                                    Image(systemName: "note.text")
                                        .imageScale(.large)
                                        .font(.system(size: 17))
                                        .frame(width: sbl_width, height: sbl_height)
                                        .foregroundColor(Color.white)
                                }
                                else {
                                    Image(systemName: "chart.bar.xaxis")
                                        .imageScale(.large)
                                        .font(.system(size: 17))
                                        .frame(width: sbl_width, height: sbl_height)
                                        .foregroundColor(Color.white)
                                }
                                
                            }
                            .padding(.leading, view_padding/2)
                            
                            if showPBPLog == false {
                                
                                ShareLink("", item: renderGR(viewSize: viewsize))
                                    .imageScale(.large)
                                    .font(.system(size: 16))
                                    .foregroundStyle(text_color)
                                    .fontWeight(.bold)
//                                    .padding(.leading, view_padding/2)
                                
                            }
                            else {
                                ShareLink("", item: renderPBP(viewSize: viewsize))
                                    .imageScale(.large)
                                    .font(.system(size: 16))
                                    .foregroundStyle(text_color)
                                    .fontWeight(.bold)
//                                    .padding(.leading, view_padding/2)
                            }
                            
                        }
                        
                    }
                    .padding(.top, view_padding)
                    .padding(.leading, view_padding * 1.5)
                    .padding(.trailing, view_padding)
                    
                    ZStack {
                        ScrollView{
                            if showPBPLog == false {
                                reportView
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            else {
                                pbplogView
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    }
                    
                }
                .background(LinearGradient(gradient: header_gradient, startPoint: .top, endPoint: .bottom))
                
                if showExportPR == true{
                    FileNamePopUpView(action: {})
                }
                
            }
            
        }
        
    }
    
    var pbplogView: some View {
            
            HStack{
                
                Spacer()
                
                VStack(alignment: .center){
                    
                    HStack{
                        Spacer()
                        
                        Text("Pitch-by-Pitch Log")
                            .font(.system(size: headbody_size))
                            .bold()
                            .padding(.top, 10)
                        
                        Spacer()
                    }
                    
                    if game_report.pbp_event_list.count > 0 {
                        let screenSize = UIScreen.main.bounds.size
                        
                        Grid(horizontalSpacing: (ASVeloInput == true) ? screenSize.width * 0.048 : screenSize.width * 0.085){
                                ForEach(Array(game_report.pbp_event_list.enumerated()), id: \.offset){ index, evnt in
                                    
                                    if index == 0 || game_report.pbp_event_list[index].inning > game_report.pbp_event_list[index - 1].inning{
                                        GridRow {
                                            VStack{
                                                HStack{
                                                    
                                                    Text("INN \(evnt.inning)")
                                                        .bold()
                                                        .padding(.top, 20)
                                                        .padding(.bottom, -10)
                                                    
                                                    Spacer()
                                                    
                                                    
                                                }
                                                
                                                Divider()
                                                    .background(Color.black)
                                                    .frame(height: 10)
                                                    .padding(.bottom, -4)
                                            }
                                        }
                                        .gridCellColumns((ASVeloInput == true) ? 6 : 5)
                                        
                                    }
                                    
                                    if index == 0 || game_report.pbp_event_list[index].pitcher != game_report.pbp_event_list[index - 1].pitcher{
                                        GridRow{
                                            VStack{
                                                HStack{
                                                    Spacer()
                                                    Text(evnt.pitcher + " Entered")
                                                        .padding(.vertical, 5)
                                                        .foregroundStyle(Color.green.opacity(2))
                                                    Spacer()
                                                }
                                                .background(Color.green.opacity(0.1))
                                                
                                                Divider()
                                                
                                            }
                                        }
                                        .gridCellColumns((ASVeloInput == true) ? 6 : 5)
                                        
                                    }
                                    
                                    if evnt.result == "RUNNER OUT" {
                                       GridRow{
                                           VStack{
                                               HStack{
                                                   Spacer()
                                                   Text("Baserunner Out")
                                                       .padding(.vertical, 5)
                                                       .foregroundStyle(Color.red.opacity(2))
                                                   Spacer()
                                               }
                                               .background(Color.red.opacity(0.1))
                                               
                                               Divider()
                                                   .background((event.end_ab_rd.contains(evnt.result_detail)) ? Color.black : Color.clear)
                                               
                                           }
                                            
                                        }
                                       .gridCellColumns((ASVeloInput == true) ? 6 : 5)
                                        
                                    }
                                    else if evnt.result == "PCVBALL" {
                                        GridRow{
                                            VStack{
                                                HStack{
                                                    Spacer()
                                                    Text("Pitch Clock Violation - Ball")
                                                        .padding(.vertical, 5)
                                                        .foregroundStyle(Color.yellow.opacity(2))
                                                    Spacer()
                                                }
                                                .background(Color.yellow.opacity(0.07))
                                                
                                                Divider()
                                                    .background((event.end_ab_rd.contains(evnt.result_detail)) ? Color.black : Color.clear)
                                                
                                            }
                                             
                                         }
                                        .gridCellColumns((ASVeloInput == true) ? 6 : 5)
                                    }
                                    else if evnt.result == "PCVWALK" {
                                        GridRow{
                                            VStack{
                                                HStack{
                                                    Spacer()
                                                    Text("Pitch Clock Violation - Walk")
                                                        .padding(.vertical, 5)
                                                        .foregroundStyle(Color.yellow.opacity(2))
                                                    Spacer()
                                                }
                                                .background(Color.yellow.opacity(0.07))
                                                
                                                Divider()
                                                    .background((event.end_ab_rd.contains(evnt.result_detail)) ? Color.black : Color.clear)
                                                
                                            }
                                             
                                         }
                                        .gridCellColumns((ASVeloInput == true) ? 6 : 5)
                                    }
                                    else if evnt.result == "PCVSTRIKE" {
                                        GridRow{
                                            VStack{
                                                HStack{
                                                    Spacer()
                                                    Text("Pitch Clock Violation - Strike")
                                                        .padding(.vertical, 5)
                                                        .foregroundStyle(Color.yellow.opacity(2))
                                                    Spacer()
                                                }
                                                .background(Color.yellow.opacity(0.07))
                                                
                                                Divider()
                                                    .background((event.end_ab_rd.contains(evnt.result_detail)) ? Color.black : Color.clear)
                                                
                                            }
                                             
                                         }
                                        .gridCellColumns((ASVeloInput == true) ? 6 : 5)
                                    }
                                    else if evnt.result == "PCVSTRIKEOUT" {
                                        GridRow{
                                            VStack{
                                                HStack{
                                                    Spacer()
                                                    Text("Pitch Clock Violation - Strikeout")
                                                        .padding(.vertical, 5)
                                                        .foregroundStyle(Color.yellow.opacity(2))
                                                    Spacer()
                                                }
                                                .background(Color.yellow.opacity(0.07))
                                                
                                                Divider()
                                                    .background((event.end_ab_rd.contains(evnt.result_detail)) ? Color.black : Color.clear)
                                                
                                            }
                                             
                                         }
                                        .gridCellColumns((ASVeloInput == true) ? 6 : 5)
                                    }
                                    //Four Pitch Clock Violation Results Handling
                                    else {
                                        GridRow{
                                            Text("\(evnt.pitch_num)")
                                            
                                            Text(evnt.pitch_type)
                                            
                                            if ASVeloInput == true {
                                                Text("\(evnt.velo, specifier: "%.1f")")
                                            }
                                            
                                            Text(evnt.result)
                                            Text("\(evnt.balls) - \(evnt.strikes)")
                                            Text("\(evnt.outs) " + evnt.out_label)
                                                
                                        }
                                        
                                        Divider()
                                            .background((event.end_ab_rd.contains(evnt.result_detail)) ? Color.black : Color.clear)
                                    }
                                }
                                .font(.system(size: 15))
                            }
                        
                        
                            
                            Spacer()
                    }
                    
                    else {
                        
                        VStack {
                            
                            Spacer()
                            
                            HStack{
                                
                                Spacer()
                                
                                Text("No Pitches Recorded")
                                    .font(.system(size: headbody_size))
                                
                                Spacer()
                                
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        
                    }
                        
                    }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity)
            .padding(view_padding)
            .background(Color.white)
            .foregroundStyle(Color.black)

    }
    
    var reportView: some View {

        VStack{
            HStack{
                VStack (alignment: .leading){
                    Text(current_pitcher.firstName + " " + current_pitcher.lastName)
                        .font(.system(size: title_size))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(text_color)
                    
                    Text(Date().formatted(.dateTime.day().month().year()))
                        .font(.system(size: subheadline_size))
                        .foregroundStyle(text_color)
                }
            }
            .padding(.horizontal, view_padding)
            .padding(.top, view_padding)
            
            
            if ASBoxScore == true {
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
                                Text("Pit")
                                Text("BF")
                                Text("H")
                                Text("SO")
                                Text("BB")
                            }
                            .foregroundStyle(text_color)
                            .padding(.vertical, -5)
                            .bold()
                            
                            Divider()
                            
                            GridRow{
                                Text("\(game_report.inn_pitched, specifier: "%.1f")")
                                Text("\(game_report.pitches)")
                                Text("\(game_report.batters_faced)")
                                Text("\(game_report.hits)")
                                Text("\(game_report.strikeouts)")
                                Text("\(game_report.walks)")
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
                .padding(.horizontal, view_padding)
                .padding(.bottom, view_padding)
            }
            
            if ASStrikePer == true {
                
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
                                    Gauge(value: Double(game_report.strikes_per) * 0.01) {}
                                        .scaleEffect(2.5)
                                        .gaugeStyle(.accessoryCircularCapacity)
                                        .tint(Color("Gold"))
                                        .padding(view_padding)
                                    VStack{
                                        Text("\(game_report.strikes_per)%")
                                            .font(.system(size: 40))
                                            .foregroundStyle(text_color)
                                            .bold()
                                        Text("\(game_report.strikes)/\(game_report.pitches)")
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color("DarkGrey"))
                        .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                        .padding(.bottom, view_padding/2)
                        .padding(.leading, view_padding)
                        .padding(.trailing, view_padding/4)
                        
                        VStack{
                            
                            HStack{
                                Text("1st Pitch Strike %")
                                    .font(.system(size: subheadline_size))
                                    .padding(.top, view_padding)
                                    .foregroundStyle(text_color)
                                
                                Spacer()
                            }
                            .padding(.leading, view_padding)
                            .padding(.bottom, view_padding)
                            
                            VStack{
                                ZStack{
                                    Gauge(value: Double(game_report.first_pit_strike_per) * 0.01) {}
                                        .scaleEffect(2.5)
                                        .gaugeStyle(.accessoryCircularCapacity)
                                        .tint(Color("PowderBlue"))
                                        .padding(view_padding)
                                    VStack{
                                        Text("\(game_report.first_pit_strike_per)%")
                                            .font(.system(size: 40))
                                            .foregroundStyle(text_color)
                                            .bold()
                                        Text("\(game_report.first_pitch_strike)/\(game_report.batters_faced)")
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color("DarkGrey"))
                        .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                        .padding(.bottom, view_padding/2)
                        .padding(.leading, view_padding/4)
                        .padding(.trailing, view_padding)
                        
                    }
                    
                    if ASStrikeType == true {
                        HStack{
                            
                            VStack{
                                HStack{
                                    Text("Swing %")
                                        .font(.system(size: subheadline_size))
                                        .foregroundStyle(text_color)
                                        .padding(.top, view_padding)
                                    
                                    Spacer()
                                }
                                .padding(.leading, view_padding)
                                .padding(.bottom, view_padding)
                                
                                VStack{
                                    
                                    ZStack{
                                        Gauge(value: Double(game_report.swing_per) * 0.01) {}
                                            .scaleEffect(2.5)
                                            .gaugeStyle(.accessoryCircularCapacity)
                                            .tint(Color("Tangerine"))
                                            .padding(view_padding)
                                        VStack{
                                            Text("\(game_report.swing_per)%")
                                                .font(.system(size: 40))
                                                .foregroundStyle(text_color)
                                                .bold()
                                            Text("\(game_report.swings)/\(game_report.strikes)")
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
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color("DarkGrey"))
                            .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                            .padding(.bottom, view_padding/2)
                            .padding(.leading, view_padding)
                            .padding(.trailing, view_padding/4)
                            
                            VStack{
                                
                                HStack{
                                    Text("Whiff %")
                                        .font(.system(size: subheadline_size))
                                        .padding(.top, view_padding)
                                        .foregroundStyle(text_color)
                                    
                                    Spacer()
                                }
                                .padding(.leading, view_padding)
                                .padding(.bottom, view_padding)
                                
                                VStack{
                                    ZStack{
                                        Gauge(value: Double(game_report.whiff_per) * 0.01) {}
                                            .scaleEffect(2.5)
                                            .gaugeStyle(.accessoryCircularCapacity)
                                            .tint(Color("Grey"))
                                            .padding(view_padding)
                                        VStack{
                                            Text("\(game_report.whiff_per)%")
                                                .font(.system(size: 40))
                                                .foregroundStyle(text_color)
                                                .bold()
                                            Text("\(game_report.whiffs)/\(game_report.swings)")
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
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color("DarkGrey"))
                            .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                            .padding(.leading, view_padding/4)
                            .padding(.bottom, view_padding/2)
                            .padding(.trailing, view_padding)
                        }
                    }
                    
                }
                .padding(.bottom, view_padding/2)
                
            }
            
            if ASVeloInput == true && game_report.velo_set_list.count > 0{
                HStack{
                    
                    VStack{
                        
                        HStack{
                            Text("Pitch Velocity")
                                .font(.system(size: subheadline_size))
                                .foregroundStyle(text_color)
                            Spacer()
                        }
                        
                        VStack{
                            
                            Grid(alignment: .trailing){
                                ForEach(Array(game_report.velo_set_list.enumerated()), id: \.offset){ index, pitch in
                                    GridRow{
                                        VStack(alignment: .trailing){
                                            Text(pitch.pitch_type)
                                                .font(.system(size: headbody_size))
                                                .bold()
                                                .foregroundStyle(text_color)
                                            Text("Max: \(pitch.max_velo, specifier: "%.1f")")
                                                .font(.system(size: caption2_size))
                                                .foregroundStyle(.grey)
                                        }
                                        
                                        ZStack{
                                            Rectangle()
                                                .fill(.grey)
                                                .frame(maxWidth: .infinity, maxHeight: 1)
                                                .padding(.trailing, 18)
                                            
                                            GeometryReader{ geometry in
                                                
                                                HStack(spacing: 0){
                                                    Rectangle()
                                                        .fill(.clear)
                                                        .frame(width: geometry.size.width * pitch.velo_factor)
                                                    
                                                    ZStack{
                                                        Rectangle()
                                                            .fill(LinearGradient(colors: [.clear, colorset[index], colorset[index], .clear], startPoint: .leading, endPoint: .trailing).opacity(0.7))
                                                            .frame(width: 20, height: 15)
                                                        
                                                        Rectangle()
                                                            .fill(.black)
                                                            .frame(width: 2, height: 17)
                                                        
                                                        Text("\(pitch.avg_velo, specifier: "%.1f")")
                                                            .foregroundStyle(text_color)
                                                            .font(.system(size: 13))
                                                            .padding(.top, -25)
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        .padding(.leading, view_padding)
                                        
                                    }
                                }
                            }
                            
                        }
                        
                    }
                    .padding(view_padding)
                    .frame(maxWidth: .infinity)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    
                }
                .padding(.horizontal, view_padding)
                .padding(.bottom, view_padding)
            }
            
            
            if ASLocation == true {
                HStack{
                    
                    VStack{
                        
                        HStack{
                            Text("Pitch Location Map")
                                .font(.system(size: subheadline_size))
                                .foregroundStyle(text_color)
                                .padding(.leading, view_padding)
                                .padding(.top, view_padding)
                            Spacer()
                        }
                        
                        ZStack{
                            
                            let screenSize = UIScreen.main.bounds.size
                            
                            Image("PLO_Background")
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .padding(.horizontal, 6)
                                .padding(.bottom, 6)
                                .overlay(alignment: .center){
                                    ForEach(game_report.x_coordinate_list.indices, id: \.self){ index in
                                        let xloc = game_report.x_coordinate_list[index] * (202/screenSize.width) + 75
                                        let yloc = game_report.y_coordinate_list[index] * (415/screenSize.height) + 39
                                        let point = CGPoint(x: xloc, y: yloc)
                                        let pitch_color = game_report.pl_color_list[index]
                                        let outline = game_report.pl_outline_list[index]
                                        
                                        Circle()
                                            .fill(pitch_color)
                                            .stroke(outline, lineWidth: 4)
                                            .frame(width: 20, height: 20, alignment: .center)
                                            .position(point)
                                    }
                                }
                        }
                        
                        HStack(spacing: 5){
                            
                            Spacer()
                            
                            Circle()
                                .fill(Color("PowderBlue"))
                                .frame(width: 8, height: 8, alignment: .center)
                            
                            Text(current_pitcher.pitch1 + " ")
                                .font(.system(size: caption_size))
                                .foregroundStyle(legend_color)
                            
                            if current_pitcher.pitch2 != "None" {
                                Circle()
                                    .fill(Color("Gold"))
                                    .frame(width: 8, height: 8, alignment: .center)
                                
                                Text(current_pitcher.pitch2 + " ")
                                    .font(.system(size: caption2_size))
                                    .foregroundStyle(legend_color)
                            }
                            
                            if current_pitcher.pitch3 != "None" {
                                Circle()
                                    .fill(Color("Tangerine"))
                                    .frame(width: 8, height: 8, alignment: .center)
                                
                                Text(current_pitcher.pitch3 + " ")
                                    .font(.system(size: caption2_size))
                                    .foregroundStyle(legend_color)
                            }
                            
                            if current_pitcher.pitch4 != "None" {
                                Circle()
                                    .fill(Color("Grey"))
                                    .frame(width: 8, height: 8, alignment: .center)
                                
                                Text(current_pitcher.pitch4 + " ")
                                    .font(.system(size: caption2_size))
                                    .foregroundStyle(legend_color)
                            }
                            
                            Spacer()
                            
                        }
                        .padding(.bottom, view_padding)
                        
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    .padding(.bottom, view_padding)
                    .padding(.leading, view_padding)
                    .padding(.trailing, view_padding)
                }
                
                Spacer()
            }
            
            if ASHitSummary == true {
                HStack{
                    
                    VStack{
                        
                        HStack{
                            Text("Hit Summary")
                                .font(.system(size: subheadline_size))
                                .foregroundStyle(text_color)
                            Spacer()
                        }
                        
                        Grid(){
                            GridRow{
                                Text("1B")
                                Text("2B")
                                Text("3B")
                                Text("HR")
                                Text("E")
                            }
                            .foregroundStyle(text_color)
                            .padding(.vertical, -5)
                            .bold()
                            
                            Divider()
                            
                            GridRow{
                                Text("\(game_report.singles)")
                                Text("\(game_report.doubles)")
                                Text("\(game_report.triples)")
                                Text("\(game_report.homeruns)")
                                Text("\(game_report.errors)")
                            }
                            .foregroundStyle(text_color)
                        }
                        .font(.system(size: _default))
                        
                        Spacer()
                        
                        VStack{
                            HStack{
                                VStack{
                                    HStack{
                                        Text("Most Hit Pitch:")
                                            .font(.system(size: _default))
                                            .foregroundStyle(text_color)
                                        
                                        Text(game_report.most_hit_pit)
                                            .font(.system(size: _default))
                                            .foregroundStyle(text_color)
                                            .bold()
                                    }
                                    .padding(.top, view_padding/4)
                                    HStack{
                                        
                                        Text("Hits:")
                                            .font(.system(size: _default))
                                        //.foregroundStyle(text_color)
                                        
                                        Text("\(game_report.mhp_hits)")
                                            .font(.system(size: _default))
                                        //.foregroundStyle(text_color)
                                        
                                        Divider()
                                        
                                        Text("Pitches:")
                                            .font(.system(size: _default))
                                        //.foregroundStyle(text_color)
                                        
                                        Text("\(game_report.mhp_pitches)")
                                            .font(.system(size: _default))
                                        //.foregroundStyle(text_color)
                                        
                                        
                                        
                                    }
                                    .padding(.top, view_padding * -1)
                                    .font(.system(size: 13))
                                    .foregroundStyle(legend_color)
                                }
                                .padding(.leading, view_padding)
                                
                                Spacer()
                                
                            }
                        }
                    }
                    .padding(view_padding)
                    .frame(maxWidth: .infinity)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    
                }
                .padding(.horizontal, view_padding)
                .padding(.bottom, view_padding)
                
                Spacer()
            }
            
            if ASGameScore == true {
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
                                Text("\(game_report.game_score)")
                                    .font(.system(size: 40))
                                    .foregroundStyle(text_color)
                                    .padding(.horizontal, view_padding)
                                    .padding(.bottom, -20)
                                    .bold()
                                
                                Spacer()
                            }
                            
                            VStack{
                                Gauge(value: Double(game_report.game_score) * 0.01) {
                                    Text("Game Score")
                                        .font(.system(size: _default))
                                        .foregroundStyle(text_color)
                                }
                                .gaugeStyle(.accessoryLinear)
                                .tint(gradient)
                                .frame(height: 10)
                            }
                            .padding(view_padding)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    .padding(.leading, view_padding)
                    .padding(.trailing, view_padding)
                    HStack{
                        Text("*")
                            .baselineOffset(3.0)
                            .foregroundStyle(.gray)
                            .font(.system(size: 10))
                        
                        + Text("Calculated using Tango's formula without runs, with extra weight placed on XBHs")
                            .foregroundStyle(.gray)
                            .font(.system(size: 10))
                        
                        Spacer()
                        
                    }
                    .padding(.top, view_padding * -0.8)
                    .padding(.bottom, view_padding)
                    .padding(.leading, view_padding * 1.8)
                    .padding(.trailing, view_padding)
                    
                }
                
                Spacer()
            }
            
            if ASBatterStance == true {
                
                HStack{
                    
                    VStack{
                        
                        HStack{
                            Text("Batter Stance Splits")
                                .font(.system(size: subheadline_size))
                                .foregroundStyle(text_color)
                            Spacer()
                        }
                        .padding(.bottom, view_padding)
                        
                        if game_report.rh_batters_faced == 0 && game_report.lh_batters_faced != 0{
                            Text("No Right Handed Batters Faced")
                                .font(.system(size: _default))
                        }
                        else if game_report.lh_batters_faced == 0 && game_report.rh_batters_faced != 0{
                            Text("No Left Handed Batters Faced")
                                .font(.system(size: _default))
                        }
                        else {
                            
                            VStack{
                                
                                HStack{
                                    Text("RHH")
                                        .font(.system(size: _default))
                                        .bold()
                                        .overlay(
                                            Rectangle()
                                                .fill(Color("PowderBlue"))
                                                .frame(width: 35, height: 2),
                                            alignment: .bottom)
                                    
                                    Spacer()
                                    
                                    Text("LHH")
                                        .font(.system(size: _default))
                                        .bold()
                                        .overlay(
                                            Rectangle()
                                                .fill(Color("Gold"))
                                                .frame(width: 35, height: 2),
                                            alignment: .bottom)
                                }
                                
                                GeometryReader{ geometry in
                                    VStack{
                                        
                                        VStack{
                                            HStack{
                                                Text("\(game_report.rh_batters_faced)")
                                                    .font(.system(size: headbody_size))
                                                    .bold()
                                                    .foregroundStyle(text_color)
                                                
                                                Spacer()
                                                
                                                Text("Batters Faced")
                                                    .font(.system(size: headbody_size))
                                                    .bold()
                                                    .foregroundStyle(text_color)
                                                
                                                Spacer()
                                                
                                                Text("\(game_report.lh_batters_faced)")
                                                    .font(.system(size: headbody_size))
                                                    .bold()
                                                    .foregroundStyle(text_color)
                                            }
                                            .padding(.bottom, view_padding * -0.3)
                                            HStack(spacing: 3){
                                                Rectangle()
                                                    .fill(Color("PowderBlue"))
                                                    .frame(width: geometry.size.width * game_report.bs_faced_factor, height: 7)
                                                    .cornerRadius(10)
                                                
                                                
                                                Rectangle()
                                                    .fill(Color("Gold"))
                                                    .frame(height: 7)
                                                    .cornerRadius(10)
                                            }
                                        }
                                        .padding(.bottom, view_padding * 0.3)
                                        
                                        VStack{
                                            HStack{
                                                Text("\(game_report.rh_hits)")
                                                    .font(.system(size: headbody_size))
                                                    .bold()
                                                    .foregroundStyle(text_color)
                                                
                                                Spacer()
                                                
                                                Text("Hits")
                                                    .font(.system(size: headbody_size))
                                                    .bold()
                                                    .foregroundStyle(text_color)
                                                
                                                Spacer()
                                                
                                                Text("\(game_report.lh_hits)")
                                                    .font(.system(size: headbody_size))
                                                    .bold()
                                                    .foregroundStyle(text_color)
                                            }
                                            .padding(.bottom, view_padding * -0.3)
                                            HStack(spacing: 3){
                                                Rectangle()
                                                    .fill(Color("PowderBlue"))
                                                    .frame(width: geometry.size.width * game_report.bs_hits_factor, height: 7)
                                                    .cornerRadius(10)
                                                
                                                
                                                Rectangle()
                                                    .fill(Color("Gold"))
                                                    .frame(height: 7)
                                                    .cornerRadius(10)
                                            }
                                        }
                                        .padding(.bottom, view_padding * 0.3)
                                        
                                        VStack{
                                            HStack{
                                                Text("\(game_report.rh_xbhs)")
                                                    .font(.system(size: headbody_size))
                                                    .bold()
                                                    .foregroundStyle(text_color)
                                                
                                                Spacer()
                                                
                                                Text("XBHs")
                                                    .font(.system(size: headbody_size))
                                                    .bold()
                                                    .foregroundStyle(text_color)
                                                
                                                Spacer()
                                                
                                                Text("\(game_report.lh_xbhs)")
                                                    .font(.system(size: headbody_size))
                                                    .bold()
                                                    .foregroundStyle(text_color)
                                            }
                                            .padding(.bottom, view_padding * -0.3)
                                            HStack(spacing: 3){
                                                Rectangle()
                                                    .fill(Color("PowderBlue"))
                                                    .frame(width: geometry.size.width * game_report.bs_xbhs_factor, height: 7)
                                                    .cornerRadius(10)
                                                
                                                
                                                Rectangle()
                                                    .fill(Color("Gold"))
                                                    .frame(height: 7)
                                                    .cornerRadius(10)
                                            }
                                        }
                                        .padding(.bottom, view_padding * 0.3)
                                        
                                        VStack{
                                            HStack{
                                                Text("\(game_report.rh_strikeouts)")
                                                    .font(.system(size: headbody_size))
                                                    .bold()
                                                    .foregroundStyle(text_color)
                                                
                                                Spacer()
                                                
                                                Text("Strikeouts")
                                                    .font(.system(size: headbody_size))
                                                    .bold()
                                                    .foregroundStyle(text_color)
                                                
                                                Spacer()
                                                
                                                Text("\(game_report.lh_strikeouts)")
                                                    .font(.system(size: headbody_size))
                                                    .bold()
                                                    .foregroundStyle(text_color)
                                            }
                                            .padding(.bottom, view_padding * -0.3)
                                            HStack(spacing: 3){
                                                Rectangle()
                                                    .fill(Color("PowderBlue"))
                                                    .frame(width: geometry.size.width * game_report.bs_strikeouts_factor, height: 7)
                                                    .cornerRadius(10)
                                                
                                                
                                                Rectangle()
                                                    .fill(Color("Gold"))
                                                    .frame(height: 7)
                                                    .cornerRadius(10)
                                            }
                                        }
                                        .padding(.bottom, view_padding * 0.3)
                                        
                                        VStack{
                                            HStack{
                                                Text("\(game_report.rh_walks)")
                                                    .font(.system(size: headbody_size))
                                                    .bold()
                                                    .foregroundStyle(text_color)
                                                
                                                Spacer()
                                                
                                                Text("Walks")
                                                    .font(.system(size: headbody_size))
                                                    .bold()
                                                    .foregroundStyle(text_color)
                                                
                                                Spacer()
                                                
                                                Text("\(game_report.lh_walks)")
                                                    .font(.system(size: headbody_size))
                                                    .bold()
                                                    .foregroundStyle(text_color)
                                            }
                                            .padding(.bottom, view_padding * -0.3)
                                            HStack(spacing: 3){
                                                Rectangle()
                                                    .fill(Color("PowderBlue"))
                                                    .frame(width: geometry.size.width * game_report.bs_walks_factor, height: 7)
                                                    .cornerRadius(10)
                                                
                                                
                                                Rectangle()
                                                    .fill(Color("Gold"))
                                                    .frame(height: 7)
                                                    .cornerRadius(10)
                                            }
                                        }
                                        .padding(.bottom, view_padding * 0.3)
                                        
                                    }
                                    
                                }
                                .frame(height: 210)
                                
                            }
                            
                        }
                    }
                    .padding(view_padding)
                    .frame(maxWidth: .infinity)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    
                }
                .padding(.horizontal, view_padding)
                .padding(.bottom, view_padding)
            }
                
                if game_report.p1_by_inn.count > 1 && ASPitByInn == true{
                    HStack{
                        VStack{
                            HStack{
                                Text("Pitch Usage by Inning")
                                    .font(.system(size: subheadline_size))
                                    .foregroundStyle(text_color)
                                    .padding(.leading, view_padding)
                                    .padding(.top, view_padding)
                                
                                Spacer()
                            }
                            
                            VStack{
                                Chart{
                                    ForEach(game_report.pitches_by_inn) { pit_dataset in
                                        ForEach(Array(pit_dataset.dataset.enumerated()), id: \.offset){ index, value in
                                            LineMark(x: .value("Inning", index + 1),
                                                     y: .value("# of Pitches", value))
                                            PointMark(x: .value("Inning", index + 1),
                                                     y: .value("# of Pitches", value))
                                        }
                                        .foregroundStyle(by: .value("Pitch Type", pit_dataset.name))
                                    }
                                }
                                .chartForegroundStyleScale([
                                    current_pitcher.pitch1: Color("PowderBlue"), current_pitcher.pitch2: Color("Gold"), current_pitcher.pitch3: Color("Tangerine"), current_pitcher.pitch4: Color("Grey")
                                ])
                               .frame(height: 200)
                               .padding(.horizontal, view_padding)
                               .padding(.top, view_padding)
                               .chartLegend(.hidden)
                               .chartXScale(domain: [0, game_report.p1_by_inn.count + 1])
                                .chartXAxis {
                                    AxisMarks(values: .automatic(desiredCount: game_report.p1_by_inn.count + 1)){
                                        
                                        AxisValueLabel()
                                            .foregroundStyle(legend_color)
                                        
                                        AxisGridLine()
                                            .foregroundStyle(legend_color)
                                    }
                                }
                                .chartYAxis {
                                    AxisMarks(position: .leading) {
                                        
                                        AxisValueLabel()
                                            .foregroundStyle(legend_color)
                                        
                                        AxisGridLine()
                                            .foregroundStyle(legend_color)
                                        
                                    }
                                }
                                
                                HStack(spacing: 5){
                                    
                                    Spacer()
                                    
                                    Circle()
                                        .fill(Color("PowderBlue"))
                                        .frame(width: 8, height: 8, alignment: .center)
                                                                
                                    Text(current_pitcher.pitch1 + " ")
                                        .font(.system(size: caption_size))
                                        .foregroundStyle(legend_color)
                                
                                    if current_pitcher.pitch2 != "None" {
                                        Circle()
                                            .fill(Color("Gold"))
                                            .frame(width: 8, height: 8, alignment: .center)
                                        
                                        Text(current_pitcher.pitch2 + " ")
                                            .font(.system(size: caption2_size))
                                            .foregroundStyle(legend_color)
                                    }
                                    
                                    if current_pitcher.pitch3 != "None" {
                                        Circle()
                                            .fill(Color("Tangerine"))
                                            .frame(width: 8, height: 8, alignment: .center)
                                        
                                        Text(current_pitcher.pitch3 + " ")
                                            .font(.system(size: caption2_size))
                                            .foregroundStyle(legend_color)
                                    }
                                    
                                    if current_pitcher.pitch4 != "None" {
                                        Circle()
                                            .fill(Color("Grey"))
                                            .frame(width: 8, height: 8, alignment: .center)
                                        
                                        Text(current_pitcher.pitch4 + " ")
                                            .font(.system(size: caption2_size))
                                            .foregroundStyle(legend_color)
                                    }
                                
                                    Spacer()
                                    
                                }
                                
                                Spacer()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color("DarkGrey"))
                        .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                        .padding(.bottom, view_padding)
                        .padding(.leading, view_padding)
                        .padding(.trailing, view_padding)
                    }
                }
                
                
                Spacer()
                
            }
            
            .background(LinearGradient(gradient: background_gradient, startPoint: .top, endPoint: .bottom))
    }
    
    @MainActor
    func renderPBP(viewSize: CGSize) -> URL {
        
        let renderer = ImageRenderer(content: pbplogView)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M.d.yy"

        let formattedDate = dateFormatter.string(from: Date())
        
        let opponent = game_report.opponent_name.prefix(7)
        var location = game_report.game_location
        
        if location == "" {
            location = "Home"
        }

        let path_string = opponent + "-" + location + "-" + formattedDate + ".pdf"
        
        let url = URL.documentsDirectory.appending(path: path_string)
        
        renderer.render { size, context in
            var box = CGRect(x: 0, y: 0, width: viewSize.width, height: size.height)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }
            
            pdf.beginPDFPage(nil)
            
            pdf.translateBy(x: box.size.width / 2 - size.width / 2,
                            y: box.size.height / 2 - size.height / 2)
            
            context(pdf)
            
            pdf.endPDFPage()
            pdf.closePDF()
        }
        
        return url
        
    }
    
    @MainActor
    func renderGR(viewSize: CGSize) -> URL {
        
        let renderer = ImageRenderer(content: reportView)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M.d.yy"

        let formattedDate = dateFormatter.string(from: Date())
        
        let first_name = current_pitcher.firstName.prefix(1)
        let last_name = current_pitcher.lastName.prefix(5)
        
        let path_string = first_name + "-" + last_name + "-" + formattedDate + ".pdf"
        
        let url = URL.documentsDirectory.appending(path: path_string)
        
        renderer.render { size, context in
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }
            
            pdf.beginPDFPage(nil)
            
            context(pdf)
            
            pdf.endPDFPage()
            pdf.closePDF()
        }
        
        return url
        
    }
    

    
}

//#Preview {
//    GameReportView()
//}
