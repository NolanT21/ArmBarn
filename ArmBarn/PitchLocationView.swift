//
//  PitchLocationView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 12/17/23.
//

import SwiftUI
import SwiftData

struct PitchLocationView: View {
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(currentPitcher.self) var current_pitcher
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    @Environment(Event_String.self) var event
    @Environment(GameReport.self) var game_report
    
    @Query var events: [Event]
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State var ver_padding: Double = 35.0

    @State private var hidePitchOverlay = false
    @State private var showEndGame = false
    @State private var showGameReport = false
    @State private var showPitcherSelect = false
    @State private var showTestView = false
    
    @State var location: CGPoint = .zero
    @State var cur_pitch_color = Color.clear
    @State var cur_pitch_outline = Color.clear
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    var backgroundcolor: Color = .black
    
    var tap: some Gesture {
        SpatialTapGesture()
            .onEnded { click in
                location = click.location
                cur_pitch_color = ptconfig.ptcolor
                cur_pitch_outline = .white
                //print("\(click)")
             }
    }
       
    var body: some View {
        
        NavigationStack{
            VStack{
                
                ZStack{
                    
                    ZStack{
                        
                        SaveEventView().task{
                            add_prev_event_string()
                            event.recordEvent = true
                            scoreboard.update_scoreboard = true
                        }
                        
                        Image("PLI_Background")
                            .resizable()
                            .gesture(tap)
                        //.aspectRatio(contentMode: .fit)
                        
                        Circle()
                            .stroke(cur_pitch_outline, lineWidth: 8)
                            .frame(width: 35.0, height: 35.0, alignment: .center)
                            .position(location)
                        
                            NavigationLink(destination: PitchResultView().navigationBarBackButtonHidden(true).onAppear {
                                ptconfig.pitch_x_loc.append(location.x)
                                event.x_cor = Double(location.x)
                                ptconfig.pitch_y_loc.append(location.y)
                                event.y_cor = Double(location.y)
                                ptconfig.ab_pitch_color.append(ptconfig.ptcolor)
                                ptconfig.pitch_cur_ab += 1
                                cur_pitch_color = .clear
                                cur_pitch_outline = .clear
                                
//                                event.x_cor = location.x
//                                event.y_cor = location.y
                                
                                ptconfig.hidePitchOverlay = false
//                                let loc = location
//                                print("Location", loc)
//                                print(ptconfig.pitch_x_loc, ptconfig.pitch_y_loc)
//                                print(ptconfig.ab_pitch_color)
                            }) {
                                Text("")
                                    .frame(width: 35.0, height: 35.0)
                            }
                            .background(cur_pitch_color)
                            .foregroundColor(.white)
                            .cornerRadius(90.0)
                            .position(location)
                        
                    }
                        
                        
                    ZStack{
                        if current_pitcher.pitch_num <= 0 {
                            VStack{
                                Spacer()
                                
                                HStack {
                                    Spacer()
                                    
                                    Text("Select Pitcher")
                                    
                                    Spacer()
                                }
                                
                                Spacer()
                            }
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                        }
                        else {
                            PitchLocationInput()
                        }
                        
                        if scoreboard.baserunners > 0 {
                            VStack {
                                Spacer()
                                    .frame(height: 50)
                                HStack {
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        print("Baserunner Out")
                                        record_baserunner_out()
                                    }) {
                                        Text("Baserunner Out")
                                    }
                                    .padding(12.0)
                                    .foregroundColor(Color.white)
                                    .background(Color.orange)
                                    .cornerRadius(8.0)
                                }
                                Spacer()
                            }
                        }

                    }

                }
                .ignoresSafeArea()
                .background(backgroundcolor)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("ScoreboardGreen"))
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    
                    Button(action: {
                        if events.count > 0 {
                            if events.count != 1 {
                                load_previous_event()
                            }
                            else {
                                if scoreboard.pitches > 0 {
                                    scoreboard.pitches -= 1
                                }
                                new_game_func()
                            }
                            context.delete(events[events.count - 1])
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .frame(width: sbl_width, height: sbl_height)
                            .foregroundColor(.white)
                            .bold()
                        Text("Undo")
                            .bold()
                            .imageScale(.large)
                            .foregroundColor(.white)
                            //.font(weight: .semibold)
                    }
                }
                
                ToolbarItemGroup(placement: .principal) {
                    HStack(alignment: .center){
                        Button(action: {
                            showPitcherSelect = true
                        }) {
                            Text("P")
                                .bold()
                                .foregroundColor(Color.white)
                            Text(current_pitcher.lastName)
                                .imageScale(.large)
                                .foregroundColor(.white)
                                .bold()
                        }
                        .popover(isPresented: $showPitcherSelect) {
                            SelectPitcherView()
                        }
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    HStack{
                
                        Button(action: {
                            showEndGame = true
                        }) {
                            Image(systemName: "flag.checkered")
                                .frame(width: sbl_width, height: sbl_height)
                                .foregroundColor(Color.white)
                        }
                        .popover(isPresented: $showEndGame) {
                            EndGameView()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showGameReport = true
                        }) {
                            Image(systemName: "chart.bar.xaxis")
                                .frame(width: sbl_width, height: sbl_height)
                                .foregroundColor(Color.white)
                                .bold()
                        }
                        .popover(isPresented: $showGameReport) {
                            GameReportView().task{
                                generate_game_report()
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showTestView = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .frame(width: sbl_width, height: sbl_height)
                                .foregroundColor(Color.white)
                        }
                        .popover(isPresented: $showTestView) {
                            TestView().task{
                                generate_game_report()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func generate_game_report(){
        
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
        
        game_report.inn_pitched = (Double(scoreboard.inning) + (Double(scoreboard.outs) * 0.1)) - 1
        
        let arsenal: [String] = [current_pitcher.pitch1, current_pitcher.pitch2, current_pitcher.pitch3, current_pitcher.pitch4]
        
        var inn_cntr = 1
        var p1_cntr = 0
        var p2_cntr = 0
        var p3_cntr = 0
        var p4_cntr = 0
        for evnt in events{
            
            if evnt.inning > inn_cntr{
                game_report.p1_by_inn.append(0)
                game_report.p2_by_inn.append(0)
                game_report.p3_by_inn.append(0)
                game_report.p4_by_inn.append(0)
                p1_cntr = 0
                p2_cntr = 0
                p3_cntr = 0
                p4_cntr = 0
                inn_cntr = evnt.inning
            }
            
            if evnt.pitch_type == "P1" {
                p1_cntr += 1
            }
            else if evnt.pitch_type == "P2" {
                p2_cntr += 1
            }
            else if evnt.pitch_type == "P3" {
                p3_cntr += 1
            }
            else if evnt.pitch_type == "P4" {
                p4_cntr += 1
            }
            
            game_report.p1_by_inn[inn_cntr - 1] = p1_cntr
            game_report.p2_by_inn[inn_cntr - 1] = p2_cntr
            game_report.p3_by_inn[inn_cntr - 1] = p3_cntr
            game_report.p4_by_inn[inn_cntr - 1] = p4_cntr
            game_report.pitches_by_inn = []
            
            game_report.pl_outline = .clear
            
            if evnt.pitch_result != "A" && evnt.result_detail != "R" {
                game_report.strikes += 1
                game_report.pl_color = Color("Gold")
                if evnt.balls == 0 && evnt.strikes == 0 {
                    game_report.first_pitch_strike += 1
                }
                
                if evnt.pitch_result == "H" {
                    game_report.hits += 1
                    game_report.pl_color = Color("Tangerine")
                    
                    game_report.inn_hitlog.append(evnt.inning)
                    game_report.cnt_hitlog.append((balls: evnt.balls, strikes: evnt.strikes))
                    game_report.outs_hitlog.append(evnt.outs)
                    //Add logic for
                    if evnt.pitch_type == "P1" {
                        game_report.pitchtype_hitlog.append(current_pitcher.pitch1)
                    }
                    else if evnt.pitch_type == "P2" {
                        game_report.pitchtype_hitlog.append(current_pitcher.pitch2)
                    }
                    else if evnt.pitch_type == "P3" {
                        game_report.pitchtype_hitlog.append(current_pitcher.pitch3)
                    }
                    else if evnt.pitch_type == "P4" {
                        game_report.pitchtype_hitlog.append(current_pitcher.pitch4)
                    }
                    
                    if evnt.result_detail != "E" {
                        
                        if evnt.result_detail == "S" {
                            game_report.result_hitlog.append("Single")
                            game_report.game_score -= 2
                        }
                        else if evnt.result_detail == "D" {
                            game_report.result_hitlog.append("Double")
                            game_report.game_score -= 3
                        }
                        else if evnt.result_detail == "T" {
                            game_report.result_hitlog.append("Triple")
                            game_report.game_score -= 4
                            
                        }
                        else if evnt.result_detail == "H" {
                            game_report.result_hitlog.append("Homerun")
                            game_report.game_score -= 6
                        }
                        else if evnt.result_detail == "B" {
                            game_report.result_hitlog.append("HBP")
                        }
                        
                    }
                    else {
                        game_report.result_hitlog.append("Error")
                    }
                    
                }
                else if evnt.pitch_result == "O" {
                    game_report.game_score += 2
                    game_report.pl_color = Color("Grey")
                }
                else if evnt.result_detail == "K" || evnt.result_detail == "C" {
                    game_report.pl_outline = .white
                    game_report.strikeouts += 1
                    game_report.game_score += 3
                }
            }
            else if  evnt.pitch_result == "A"{
                game_report.balls += 1
                game_report.pl_color = Color("PowderBlue")
                if evnt.balls == 0 && evnt.strikes == 0 {
                    game_report.first_pitch_ball += 1
                }
                
                else if evnt.result_detail == "W"{
                    game_report.walks += 1
                    game_report.game_score -= 2
                }
            }
            
            game_report.batters_faced = evnt.atbats
            
            game_report.x_coordinate_list.append(evnt.pitch_x_location)
            game_report.y_coordinate_list.append(evnt.pitch_y_location)
            game_report.pl_color_list.append(game_report.pl_color)
            game_report.pl_outline_list.append(game_report.pl_outline)
            
        }
        
//        print(game_report.pl_color_list)
//        print(game_report.pl_outline_list)
//        print(game_report.outs_hitlog)
//        print(game_report.inn_hitlog, game_report.inn_hitlog.count)
        
        game_report.fpb_to_fps.append(game_report.first_pitch_ball)
        game_report.fpb_to_fps.append(game_report.first_pitch_strike)
        
        game_report.balls_to_strikes.append(game_report.balls)
        game_report.balls_to_strikes.append(game_report.strikes)
        
        if game_report.first_pitch_strike > 0 {
            game_report.first_pit_strike_per = (game_report.first_pitch_strike * 100) / game_report.batters_faced
        }
        
        if game_report.strikes > 0 {
            game_report.strikes_per = (game_report.strikes * 100) / game_report.pitches
        }
        
        let temp_inn_pitches = [game_report.p1_by_inn, game_report.p2_by_inn, game_report.p3_by_inn, game_report.p4_by_inn]
        
        for index in 0..<temp_inn_pitches.count {
            if temp_inn_pitches[index].reduce(0, +) > 0 {
                game_report.pitches_by_inn.append(
                    PitchTypeDataset(name: arsenal[index], dataset: temp_inn_pitches[index])
                )
            }
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
    
    func load_previous_event() {
        let previous_event = events[events.count - 1]

        scoreboard.balls = previous_event.balls
        scoreboard.strikes = previous_event.strikes
        scoreboard.outs = previous_event.outs
        scoreboard.atbats = previous_event.atbats
        scoreboard.inning = previous_event.inning
        
        if ptconfig.pitch_x_loc.count > 0{
            ptconfig.pitch_x_loc.removeLast()
            ptconfig.pitch_y_loc.removeLast()
            ptconfig.ab_pitch_color.removeLast()
            ptconfig.pitch_cur_ab -= 1
        }
        
        scoreboard.b1light = .black
        scoreboard.b2light = .black
        scoreboard.b3light = .black
        
        scoreboard.s1light = .black
        scoreboard.s2light = .black
        
        scoreboard.o1light = .black
        scoreboard.o2light = .black
        
        if scoreboard.balls >= 1 {
            scoreboard.b1light = .blue
            if scoreboard.balls >= 2 {
                scoreboard.b2light = .blue
                if scoreboard.balls == 3 {
                    scoreboard.b3light = .blue
                }
            }
        }
        
        if scoreboard.strikes >= 1 {
            scoreboard.s1light = .yellow
            if scoreboard.strikes == 2 {
                scoreboard.s2light = .yellow
            }
        }
        
        if scoreboard.outs >= 1 {
            scoreboard.o1light = .red
            if scoreboard.outs == 2 {
                scoreboard.o2light = .red
            }
        }
        
        if previous_event.result_detail != "R" && scoreboard.pitches > 0 {
            scoreboard.pitches -= 1
        }
        else if previous_event.result_detail == "R" {
            scoreboard.baserunners += 1
        }
        
        //Logic For:
        //logic for loading last at-bats pitches, if at-bat changes
    }
    
    func add_prev_event_string() {
        if event.recordEvent{
            let new_event = Event(pitcher_id: current_pitcher.idcode, pitch_result: event.pitch_result, pitch_type: event.pitch_type, result_detail: event.result_detail, balls: event.balls, strikes: event.strikes, outs: event.outs, inning: event.inning, atbats: event.atbats, pitch_x_location: event.x_cor, pitch_y_location: event.y_cor)
            context.insert(new_event)
            print_Event_String()
        }
    }
    
    func print_Event_String() {
        print(current_pitcher.idcode, event.pitch_result, event.pitch_type, event.result_detail, event.balls, event.strikes, event.outs, event.inning, event.atbats, event.x_cor, event.y_cor)
    }
    func record_baserunner_out() {
        event.pitch_result = "O"
        event.pitch_type = "NP"
        event.result_detail = "R"
        event.balls = scoreboard.balls
        event.strikes = scoreboard.strikes
        event.outs = scoreboard.outs
        event.inning = scoreboard.inning
        event.atbats = scoreboard.atbats
        
        scoreboard.outs += 1
        scoreboard.baserunners -= 1
        
        if scoreboard.outs == 1 {
            scoreboard.o1light = .red
        }
        if scoreboard.outs == 2 {
            scoreboard.o2light = .red
        }
        
        if scoreboard.outs == 3 {
            scoreboard.outs = 0
            scoreboard.inning += 1
            scoreboard.baserunners = 0
            scoreboard.o1light = .black
            scoreboard.o2light = .black
            reset_Count()
        }
        
        add_prev_event_string()
        
    }
    
    func reset_Count() {
        scoreboard.balls = 0
        scoreboard.strikes = 0
        
        ptconfig.pitch_x_loc.removeAll()
        ptconfig.pitch_y_loc.removeAll()
        ptconfig.ab_pitch_color.removeAll()
        ptconfig.pitch_cur_ab = 0
        
        scoreboard.b1light = .black
        scoreboard.b2light = .black
        scoreboard.b3light = .black
        
        scoreboard.s1light = .black
        scoreboard.s2light = .black
    }
    
}


struct PitchLocationInput : View {
    
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(currentPitcher.self) var current_pitcher
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    @Environment(Event_String.self) var event
    
    @Environment(\.modelContext) var context
    
    @State var location: CGPoint = .zero
    @State var cur_pitch_color = Color.clear
    @State var cur_pitch_outline = Color.clear
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    @State var ver_padding: Double = 35.0
    
    var tap: some Gesture {
        SpatialTapGesture()
            .onEnded { click in
                location = click.location
                cur_pitch_color = ptconfig.ptcolor
                cur_pitch_outline = .white
                //print("\(click)")
             }
    }
    var body: some View {
        if !ptconfig.hidePitchOverlay{
            
            PitchOverlayPrevPitches()
                .transition(.opacity)
            
            VStack{
                
                Spacer()
                
                VStack{
                    if current_pitcher.pitch_num < 4 {
                        HStack{
                            ForEach(0..<current_pitcher.pitch_num,  id: \.self) { pt_num in
                                Button(action: {
                                    withAnimation{
                                        ptconfig.hidePitchOverlay.toggle()
                                        event.pitch_type = "P\(pt_num + 1)"
                                        ptconfig.ptcolor = ptconfig.arsenal_colors[pt_num]
                                        }
                                    }) {
                                    //Text(current_pitcher.arsenal[pt_num])
                                        Text("\(current_pitcher.arsenal[pt_num])")
                                        .frame(maxWidth: .infinity)
                                    }
                                .padding(.vertical, ver_padding)
                                .background(ptconfig.arsenal_colors[pt_num])
                                .foregroundColor(Color.white)
                                .cornerRadius(8.0)
                                }
                            }
                        }
                        
                    else if current_pitcher.pitch_num == 4 {
                            HStack{
                                ForEach(0..<2,  id: \.self) { pt_num in
                                    Button(action: {
                                        withAnimation{
                                            ptconfig.hidePitchOverlay.toggle()
                                            event.pitch_type = "P\(pt_num + 1)"
                                            ptconfig.ptcolor = ptconfig.arsenal_colors[pt_num]
                                        }
                                    }) {
                                        //Text(current_pitcher.arsenal[pt_num])
                                            Text("\(current_pitcher.arsenal[pt_num])")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .padding(.vertical, ver_padding / 2)
                                    .background(ptconfig.arsenal_colors[pt_num])
                                    .foregroundColor(Color.white)
                                    .cornerRadius(8.0)
                                }
                            }
                            
                            HStack{
                                ForEach(2..<4,  id: \.self) { pt_num in
                                    Button(action: {
                                        withAnimation{
                                            ptconfig.hidePitchOverlay.toggle()
                                            event.pitch_type = "P\(pt_num + 1)"
                                            ptconfig.ptcolor = ptconfig.arsenal_colors[pt_num]
                                        }
                                    }) {
                                        //Text(current_pitcher.arsenal[pt_num])
                                        Text("\(current_pitcher.arsenal[pt_num])")
                                            .frame(maxWidth: .infinity)
                                    }
                                    .padding(.vertical, ver_padding / 2)
                                    .background(ptconfig.arsenal_colors[pt_num])
                                    .foregroundColor(Color.white)
                                    .cornerRadius(8.0)
                            }
                        }
                    }
                }
                .padding(.vertical, 25.0)
                .padding(.horizontal, 20.0)
                .background(Color.black.opacity(0.8))
                    
            }
            .transition(.move(edge: .bottom))
            .ignoresSafeArea()
                    
        }
    }
    
}

struct PitchOverlayPrevPitches : View {
    
    @Environment(PitchTypeConfig.self) var ptconfig
    
    var body: some View {
        Rectangle()
            .fill(Color.black.opacity(0.01))
                            
        ForEach(ptconfig.pitch_x_loc.indices, id: \.self){ index in
            let xloc = ptconfig.pitch_x_loc[index]
            let yloc = ptconfig.pitch_y_loc[index]
            let point = CGPoint(x: xloc, y: yloc)
            let pitch_color = ptconfig.ab_pitch_color[index]
            Circle()
                .fill(pitch_color)
                .stroke(.white, lineWidth: 4)
                .frame(width: 40, height: 40, alignment: .center)
                .position(point)
                .overlay {
                    Text("\(index + 1)")
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .position(point)
                }
        }
        
    }
}

struct SaveEventView : View {
    var body: some View {
        VStack {
            //View used to save event string; due to timing issues
        }
    }
}
        

#Preview {
    PitchLocationView()
        .environment(Scoreboard())
        .environment(Event_String())
        .environment(PitchTypeConfig())
}

