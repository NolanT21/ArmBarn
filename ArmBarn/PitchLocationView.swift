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
                                ptconfig.pitch_y_loc.append(location.y)
                                ptconfig.ab_pitch_color.append(ptconfig.ptcolor)
                                ptconfig.pitch_cur_ab += 1
                                cur_pitch_color = .clear
                                cur_pitch_outline = .clear
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
            .toolbarBackground(.green)
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
                                reset_Count()
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
                    
                    Spacer()
                    
                    HStack{
                        
                        HStack{
                            
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
                        
                        Spacer()
                        
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
                            TestView()
                        }
                    }
                }
            }
        }
    }
    
    func generate_game_report(){
        
        game_report.batters_faced = 0
        game_report.strikes = 0
        game_report.hits = 0
        game_report.strikeouts = 0
        game_report.walks = 0
        
        game_report.first_pitch_strike = 0
        game_report.first_pit_strike_per = 0
        game_report.strikes_per = 0
        
        game_report.game_score = 40
        game_report.pitches = scoreboard.pitches
        
        game_report.inn_pitched = (Double(scoreboard.inning) + (Double(scoreboard.outs) * 0.1)) - 1
        
        for evnt in events{
            if evnt.pitch_result != "A" && evnt.result_detail != "R" {
                game_report.strikes += 1
                if evnt.balls == 0 && evnt.strikes == 0 {
                    game_report.first_pitch_strike += 1
                }
                
                if evnt.pitch_result == "H" {
                    game_report.hits += 1
                    if evnt.result_detail == "S" {
                        game_report.game_score -= 2
                    }
                    else if evnt.result_detail == "D" {
                        game_report.game_score -= 3
                        
                    }
                    else if evnt.result_detail == "T" {
                        game_report.game_score -= 4
                        
                    }
                    else if evnt.result_detail == "H" {
                        game_report.game_score -= 6
                        
                    }
                }
                else if evnt.pitch_result == "O" {
                    game_report.game_score += 2
                }
                else if evnt.result_detail == "K" || evnt.result_detail == "C" {
                    game_report.strikeouts += 1
                    game_report.game_score += 3
                }
            }
            else if evnt.result_detail == "W" {
                game_report.walks += 1
                game_report.game_score -= 2
            }
            
            game_report.batters_faced = evnt.atbats
            
        }
        
        if game_report.first_pitch_strike > 0 {
            game_report.first_pit_strike_per = (game_report.first_pitch_strike * 100) / game_report.batters_faced
        }
        
        if game_report.strikes > 0 {
            game_report.strikes_per = (game_report.strikes * 100) / game_report.pitches
        }
        
        game_report.game_score_min = game_report.game_score_inn_data.min() ?? 0
        game_report.game_score_max = game_report.game_score_inn_data.max() ?? 10

    }
    
    func load_previous_event() {
        let previous_event = events[events.count - 1]
        
        scoreboard.balls = previous_event.balls
        scoreboard.strikes = previous_event.strikes
        scoreboard.outs = previous_event.outs
        scoreboard.atbats = previous_event.atbats
        scoreboard.inning = previous_event.inning
        
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
        
        if previous_event.result_detail != "R"  && scoreboard.pitches > 0 {
            scoreboard.pitches -= 1
        }
        
        //Logic For:
        //logic for loading last at-bats pitches, if at-bat changes
    }
    
    func add_prev_event_string() {
        if event.recordEvent{
            let new_event = Event(pitch_result: event.pitch_result, pitch_type: event.pitch_type, result_detail: event.result_detail, balls: event.balls, strikes: event.strikes, outs: event.outs, inning: event.inning, atbats: event.atbats)
            context.insert(new_event)
            print_Event_String()
        }
            
    }
    
    func print_Event_String() {
        print(event.pitch_result, event.pitch_type, event.result_detail, event.balls, event.strikes, event.outs, event.inning, event.atbats)
    }
    func record_baserunner_out() {
        event.pitch_result = "O"
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
            var xloc = ptconfig.pitch_x_loc[index]
            var yloc = ptconfig.pitch_y_loc[index]
            var point = CGPoint(x: xloc, y: yloc)
            var pitch_color = ptconfig.ab_pitch_color[index]
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

