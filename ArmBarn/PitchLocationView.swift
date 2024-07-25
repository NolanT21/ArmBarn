//
//  PitchLocationView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 12/17/23.
//

import SwiftUI
import SwiftData
import TipKit

struct PitchLocationView: View {
    
    @AppStorage("BatterStance") var ASBatterStance: Bool?
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(currentPitcher.self) var current_pitcher
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    @Environment(Event_String.self) var event
    @Environment(GameReport.self) var game_report
    
    @Query var events: [Event]
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    private let selectpitchertip = SelectPitcherTip()
    private let locationinputtip = LocationInputTip()
    
    @State private var balls: Int = 0
    @State private var strikes: Int = 0
    
    @State private var hidePitchOverlay = false
    @State private var showGameReport = false
    @State private var showPitcherSelect = false
    @State private var showSettingsView = false
    @State private var newAtBat = false
    @State private var showEndGame = false
    @State private var showResumeGame = false
    @State private var showFileNameInfo = false
    
    @State private var showUndoToast = false
    
    @State var location: CGPoint = .zero
    @State var cur_pitch_color = Color.clear
    @State var cur_pitch_outline = Color.clear
    
    @State var ver_padding: Double = 35.0
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
                            
                            balls = scoreboard.balls
                            strikes = scoreboard.strikes
                            
                            if events.count > 0 && (scoreboard.balls == 0 && scoreboard.strikes == 0 && scoreboard.pitches == 0 && scoreboard.atbats == 1) {
                                showResumeGame = true
                            }
                            else if game_report.game_location == "" && game_report.opponent_name == "" {
                                showFileNameInfo = true
                            }
                            
                            if event.end_ab_rd.contains(event.result_detail) {
                                newAtBat = true
                            }
                            else if balls == 0 && strikes == 0 && scoreboard.pitches > 0 && current_pitcher.lastName != "Change Me"{
                                newAtBat = true
                            }
                        }
                        
                        Image("PLI_Background")
                            .resizable()
                            .gesture(tap)
                        
                        Circle()
                            .stroke(cur_pitch_outline, lineWidth: 8)
                            .frame(width: 35.0, height: 35.0, alignment: .center)
                            .position(location)
                        
                            NavigationLink(destination: PitchResultView().navigationBarBackButtonHidden(true).preferredColorScheme(.dark).task {
                                ptconfig.pitch_x_loc.append(location.x)
                                event.x_cor = Double(location.x)
                                ptconfig.pitch_y_loc.append(location.y)
                                event.y_cor = Double(location.y)
                                ptconfig.ab_pitch_color.append(ptconfig.ptcolor)
                                ptconfig.pitch_cur_ab += 1
                                cur_pitch_color = .clear
                                cur_pitch_outline = .clear
                                
                                ptconfig.hidePitchOverlay = false
                                
                                locationinputtip.invalidate(reason: .actionPerformed)
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
                        if  current_pitcher.pitch_num > 0{
                            PitchLocationInput()
                        }
                        
                        VStack{
                            TipView(locationinputtip)
                                .tipBackground(Color("DarkGrey"))
                                .tint(Color("ScoreboardGreen"))
                                .padding(.horizontal, 10)
                                .padding(.top, 60)
                                .preferredColorScheme(.dark)
                            
                            Spacer()
                            
                        }
                        
                        
                        if scoreboard.baserunners > 0 && ptconfig.hidePitchOverlay == false{
                            VStack {
                                Spacer()
                                    .frame(height: 50)
                                HStack {
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        record_baserunner_out()
                                    }) {
                                        Text("RUNNER OUT")
                                            .font(.system(size: 16))
                                            .fontWeight(.black)
                                            .padding(.vertical, 8.0)
                                            .padding(.horizontal, 5.0)
                                    }
                                    .foregroundColor(Color.white)
                                    .background(Color("ScoreboardGreen"))
                                    .cornerRadius(8.0)
                                    .padding(.trailing, 5)
                                }
                                Spacer()
                            }
                        }
                        
                        VStack{
                            
                            if ASBatterStance == true{
                                Button {
                                    newAtBat = true
                                    
                                } label: {
                                    HStack(alignment: .center){
                                        
                                        Spacer()
                                        
                                        if event.batter_stance == "R" {
                                            Image(systemName: "chevron.left")
                                                .imageScale(.small)
                                                .foregroundStyle(.white)
                                                .padding(.trailing, -5)
                                        }
                                        else {
                                            Image(systemName: "chevron.left")
                                                .imageScale(.small)
                                                .foregroundStyle(.clear)
                                                .padding(.trailing, -5)
                                        }
                                        
                                        Text("Batter Stance")
                                            .font(.system(size: 16))
                                            .foregroundStyle(.white)
                                        
                                        if event.batter_stance == "L" {
                                            Image(systemName: "chevron.right")
                                                .imageScale(.small)
                                                .foregroundStyle(.white)
                                                .padding(.leading, -5)
                                        }
                                        else {
                                            Image(systemName: "chevron.right")
                                                .imageScale(.small)
                                                .foregroundStyle(.clear)
                                                .padding(.leading, -5)
                                        }

                                        Spacer()
                                        
                                    }
                                    
                                }
                                .padding(.top, 58)
                            }

                            Spacer()
                        }
                        
                        if newAtBat == true  && ASBatterStance == true{
                            BatterPositionView(isActive: $newAtBat, close_action: {DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {newAtBat = false}})
                        }
                        
                        if current_pitcher.pitch_num <= 0 {
                            ZStack {
                                Color(.black)
                                    .opacity(0.2)
                                
                                Spacer()
                                
                                VStack{
                                    
                                    Spacer()
                                    
                                    VStack{
                                        Button{
                                            showPitcherSelect = true
//                                            showFileNameInfo = true
                                            selectpitchertip.invalidate(reason: .actionPerformed)
                                            
                                        } label: {
                                            Text("Select Pitcher")
                                                .textCase(.uppercase)
                                                .fontWeight(.black)
                                                .font(.system(size: 22))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, ver_padding)
                                        }
                                        .background(Color("ScoreboardGreen"))
                                        .foregroundColor(Color.white)
                                        .cornerRadius(8.0)
                                        
                                    }
                                    .padding(50)
                                    .background(Color.black.opacity(0.8))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
                                }
                            }
                        }
                        
                        if showUndoToast == true {
                            VStack{
                                ZStack{
                                    
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(Color.black)
                                        .frame(width: 175, height: 32)
                                    
                                    Text("Previous Event Removed")
                                        .font(.system(size: 13))
                                        .bold()
                                    
                                }
                                
                                Spacer()
                                
                            }
                            .padding(.top, 50)
                        }
                        
                        VStack{
                            
                            TipView(selectpitchertip, arrowEdge: .top)
                                .tipBackground(Color("DarkGrey"))
                                .tint(Color("ScoreboardGreen"))
                                .padding(.horizontal, 20)
                                .preferredColorScheme(.dark)
                            
                            Spacer()
                            
                        }
                        .padding(.top, 50)
                        
                        //HERE for welcome screen
                        if showFileNameInfo == true {
                            FileNamePopUpView(action: {showFileNameInfo = false; newAtBat = true})
                        }
                        
                        if showEndGame == true{
                            PopupAlertView(isActive: $showEndGame, title: "End Game", message: "This game and its data will not be saved!", leftButtonAction: {new_game_func(); newAtBat = false; showFileNameInfo = true; showEndGame = false}, rightButtonAction: {showEndGame = false})
                        }
                        
                        if showResumeGame == true {
                            PopupAlertView(isActive: $showResumeGame, title: "Resume Game", message: "A previous game was being recorded. Do you want to continue?", leftButtonAction: {set_pitcher(); load_recent_event(); load_recent_ab_pitches(); showFileNameInfo = true; showResumeGame = false}, rightButtonAction: {new_game_func(); showFileNameInfo = true; showResumeGame = false})
                        }
                        
                    }
                }
                .ignoresSafeArea()
                .background(backgroundcolor)
                .onChange(of: showUndoToast) {
                    if showUndoToast == true {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation{
                                showUndoToast = false
                            }
                        }
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("ScoreboardGreen"))
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    
                    Button(action: {
                        if ptconfig.hidePitchOverlay == true {
                            cur_pitch_color = .clear
                            cur_pitch_outline = .clear
                        }
                        else if events.count > 0 {
                            
                            showUndoToast = true
                            
                            if events.count != 1 {
                                load_previous_event()
                                load_previous_ab_pitches()
                                context.delete(events[events.count - 1])
                            }
                            else {
                                if scoreboard.pitches > 0 {
                                    scoreboard.pitches -= 1
                                }
                                newAtBat = true
                                new_game_func()
                                do {
                                    try context.delete(model: Event.self)
                                } catch {
                                    print("Did not clear event data")
                                }
                                
                            }
                            
                        }
                        ptconfig.hidePitchOverlay = false
                        ptconfig.ptcolor = .clear
                        
                    }) {
                        if ptconfig.hidePitchOverlay == true{
                            Image(systemName: "chevron.left")
                                .imageScale(.medium)
                                .foregroundColor(.white)
                                .bold()
                            Text("BACK")
                                .font(.system(size: 17))
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .padding(.leading, -5)
                        }
                        else {
                            Image(systemName: "arrow.counterclockwise")
                                .imageScale(.medium)
                                .font(.system(size: 17))
                                .foregroundColor(.white)
                                .padding(.leading, -5)
                                .bold()
                            Text("UNDO")
                                .font(.system(size: 17))
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .padding(.leading, -5)
                        }
                    }
                    .padding(.leading, -5)
                }
                
                ToolbarItemGroup(placement: .principal) {
                    HStack(alignment: .center){
                        Text("P")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        ZStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 4) 
                                .foregroundStyle(
                                    Color("ScoreboardGreen").shadow(.inner(color: .black.opacity(0.4), radius: 2, x: 1, y: 1))
                                )
                                .frame(width: 170, height: 30)
                            
                            let pitcher_lname = String(current_pitcher.lastName.prefix(11))

                            Button(action: {
                                showPitcherSelect = true
                                if current_pitcher.lastName == "Change Me" {
                                    selectpitchertip.invalidate(reason: .actionPerformed)
                                }
                            }) {
                                Text(pitcher_lname)
                                    .textCase(.uppercase)
                                    .font(.system(size: 20))
                                    .fontWeight(.black)
                                    .foregroundColor(.white)
                                    .padding(.leading, -3)
                            }
                            .popover(isPresented: $showPitcherSelect) {
                                SelectPitcherView()
                                    .preferredColorScheme(.dark)
                            }
                        }
                    }
                    .padding(.leading, -10)
                    
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    HStack(spacing: 5){
                        
                        Button(action: {
                            showGameReport = true
                        }) {
                            Image(systemName: "chart.bar.xaxis")
                                .imageScale(.large)
                                .font(.system(size: 17))
                                .frame(width: sbl_width, height: sbl_height)
                                .foregroundColor(Color.white)
                                .bold()
                        }
                        .popover(isPresented: $showGameReport) {
                            GameReportView().preferredColorScheme(.dark).task{
                                generate_game_report()
                                generate_pbp_array()
                            }
                        }
                        
                        Button(action: {
                            showEndGame = true
                        }) {
                            Image(systemName: "flag.checkered")
                                .imageScale(.large)
                                .font(.system(size: 17))
                                .frame(width: sbl_width, height: sbl_height)
                                .foregroundColor(Color.white)
                        }
                        
                        Button(action: {
                            showSettingsView = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .imageScale(.large)
                                .font(.system(size: 17))
                                .frame(width: sbl_width, height: sbl_height)
                                .foregroundColor(Color.white)
                        }
                        .popover(isPresented: $showSettingsView) {
                            SettingsView()
                                .preferredColorScheme(.dark)
                        }
                    }
                    .padding(.trailing, -5)
                }
            }
        }
    }
    func generate_pbp_array(){
        var pitch_num = 0
        let pitch_abbreviations = ["FB" : "Fastball", "CU" : "Curveball", "SL" : "Slider", "CH" : "Change-Up", "FS" : "Splitter", "Cutter" : "FC", "Sinker" : "SI", "OT" : "Other"]
        game_report.pbp_event_list = []
        for evnt in events {
            
            var result = ""
            let pitch_result = evnt.pitch_result
            let result_detail = evnt.result_detail
            let balls = evnt.balls
            let strikes = evnt.strikes
            let outs = evnt.outs
            var outs_label = ""
            let inning = evnt.inning
            let pitcher_id = evnt.pitcher_id
            var pitcher_name = ""
            let velo = evnt.velocity
            
            for pitcher in pitchers {
                if pitcher.id == pitcher_id {
                    pitcher_name = pitcher.firstName + " " + pitcher.lastName
                    if pitcher_id != game_report.cur_pitcher_id {
                        game_report.cur_pitcher_id = pitcher_id
                        pitch_num = 0
                    }
                }
            }
            
            if outs != 1 {
                outs_label = "Outs"
            }
            else {
                outs_label = "Out"
            }

            var pitch_type = evnt.pitch_type
            
            if pitch_type == "P1" {
                pitch_type = current_pitcher.pitch1
            }
            else if pitch_type == "P2" {
                pitch_type = current_pitcher.pitch2
            }
            else if pitch_type == "P3" {
                pitch_type = current_pitcher.pitch3
            }
            else if pitch_type == "P4" {
                pitch_type = current_pitcher.pitch4
            }
            
            for abbr in pitch_abbreviations {
                if abbr.value == pitch_type {
                    pitch_type = abbr.key
                }
            }
            
            if result_detail != "R"{
                
                pitch_num += 1
                
                if pitch_result == "A" {
                    if result_detail == "N" {
                        result = "Ball"
                    }
                    else if result_detail == "W" {
                        result = "Walk"
                    }
                }
                else if pitch_result == "Z" || pitch_result == "L"{
                    if result_detail == "N" {
                        result = "Strike"
                    }
                    else if result_detail == "K" || result_detail == "C" || result_detail == "M"{
                        result = "Strikeout"
                    }
                }
                else if pitch_result == "T" {
                    result = "Foul Ball"
                }
                else if pitch_result == "O" {
                    if result_detail == "F" {
                        result = "Flyout"
                    }
                    else if result_detail == "G" {
                        result = "Groundout"
                    }
                    else if result_detail == "L" {
                        result = "Lineout"
                    }
                    else if result_detail == "P" {
                        result = "Popout"
                    }
                    else if result_detail == "Y" {
                        result = "Sac Bunt"
                    }
                    else if result_detail == "O" {
                        result = "Other"
                    }
                }
                else if pitch_result == "H" {
                    if result_detail == "S" {
                        result = "Single"
                    }
                    else if result_detail == "D" {
                        result = "Double"
                    }
                    else if result_detail == "T" {
                        result = "Triple"
                    }
                    else if result_detail == "H" {
                        result = "Homerun"
                    }
                    else if result_detail == "E" {
                        result = "Error"
                    }
                    else if result_detail == "B" {
                        result = "Hit by Pitch"
                    }
                }
            }
            else {
                result = "RUNNER OUT"
            }
            
            game_report.pbp_event_list.append(PBPLog(pitch_num: pitch_num, pitch_type: pitch_type, result: result, balls: balls, strikes: strikes, outs: outs, out_label: outs_label, velo: velo, inning: inning, result_detail: result_detail, pitcher: pitcher_name))
            
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
        game_report.pitches = 0
        
        game_report.singles = 0
        game_report.doubles = 0
        game_report.triples = 0
        game_report.homeruns = 0
        game_report.errors = 0
        game_report.p1_hits = 0
        game_report.p2_hits = 0
        game_report.p3_hits = 0
        game_report.p4_hits = 0
        game_report.most_hit_pit = ""
        game_report.mhp_pitches = 0
        game_report.mhp_hits = 0
        
        game_report.swings = 0
        game_report.swing_per = 0
        game_report.whiffs = 0
        game_report.whiff_per = 0
        
        game_report.rh_batters_faced = 0
        game_report.lh_batters_faced = 0
        game_report.bs_faced_factor = 0
        game_report.rh_hits = 0
        game_report.lh_hits = 0
        game_report.bs_hits_factor = 0
        game_report.rh_xbhs = 0
        game_report.lh_xbhs = 0
        game_report.bs_xbhs_factor = 0
        game_report.rh_strikeouts = 0
        game_report.lh_strikeouts = 0
        game_report.bs_strikeouts_factor = 0
        game_report.rh_walks = 0
        game_report.lh_walks = 0
        game_report.bs_walks_factor = 0
        
        game_report.p1_velo_list = []
        game_report.p2_velo_list = []
        game_report.p3_velo_list = []
        game_report.p4_velo_list = []
        
        game_report.velo_set_list = []
        
        game_report.p1_by_inn = [0]
        game_report.p2_by_inn = [0]
        game_report.p3_by_inn = [0]
        game_report.p4_by_inn = [0]
        
        game_report.x_coordinate_list = []
        game_report.y_coordinate_list = []
        game_report.pl_color_list = []
        game_report.pl_outline_list = []
        
        game_report.inn_pitched = 0
        var outs = 0
        
        let arsenal: [String] = [current_pitcher.pitch1, current_pitcher.pitch2, current_pitcher.pitch3, current_pitcher.pitch4]
        
        var inn_cntr = 1
        var first_inn = 1
        var p1_cntr = 0
        var p2_cntr = 0
        var p3_cntr = 0
        var p4_cntr = 0
        
        for evnt in events{
            if evnt.pitcher_id == current_pitcher.idcode {
                if evnt.inning > inn_cntr{
                    game_report.p1_by_inn.append(0)
                    game_report.p2_by_inn.append(0)
                    game_report.p3_by_inn.append(0)
                    game_report.p4_by_inn.append(0)
                    p1_cntr = 0
                    p2_cntr = 0
                    p3_cntr = 0
                    p4_cntr = 0
                    
                    if evnt.inning - inn_cntr > 1 {
                        first_inn = evnt.inning
                        inn_cntr = evnt.inning
                    }
                    else {
                        inn_cntr += 1
                    }
                    
                    
                    
                }
                
                if evnt.pitch_type == "P1" {
                    p1_cntr += 1
                    game_report.pl_color = Color("PowderBlue")
                    game_report.p1_velo_list.append(evnt.velocity)
                    if evnt.pitch_result == "H" && evnt.result_detail != "E" {
                        game_report.p1_hits += 1
                    }
                }
                else if evnt.pitch_type == "P2" {
                    p2_cntr += 1
                    game_report.pl_color = Color("Gold")
                    game_report.p2_velo_list.append(evnt.velocity)
                    if evnt.pitch_result == "H" && evnt.result_detail != "E" {
                        game_report.p2_hits += 1
                    }
                }
                else if evnt.pitch_type == "P3" {
                    p3_cntr += 1
                    game_report.pl_color = Color("Tangerine")
                    game_report.p3_velo_list.append(evnt.velocity)
                    if evnt.pitch_result == "H" && evnt.result_detail != "E" {
                        game_report.p3_hits += 1
                    }
                }
                else if evnt.pitch_type == "P4" {
                    p4_cntr += 1
                    game_report.pl_color = Color("Grey")
                    game_report.p4_velo_list.append(evnt.velocity)
                    if evnt.pitch_result == "H" && evnt.result_detail != "E" {
                        game_report.p4_hits += 1
                    }
                }
                
                game_report.p1_by_inn[inn_cntr - first_inn] = p1_cntr
                game_report.p2_by_inn[inn_cntr - first_inn] = p2_cntr
                game_report.p3_by_inn[inn_cntr - first_inn] = p3_cntr
                game_report.p4_by_inn[inn_cntr - first_inn] = p4_cntr
                
                game_report.pitches_by_inn = []
                
                game_report.pl_outline = .clear
                
                if evnt.result_detail != "R" {
                    game_report.pitches += 1
                    
                    if evnt.pitch_result != "A" && evnt.result_detail != "B"{
                        game_report.strikes += 1
                        if (evnt.balls == 0 && evnt.strikes == 0) || game_report.pitches == 1{
                            game_report.first_pitch_strike += 1
                        }
                        
                        if evnt.pitch_result == "T" {
                            game_report.swings += 1
                        }
                        else if evnt.pitch_result == "Z"{
                            game_report.whiffs += 1
                            game_report.swings += 1
                        }
                        
                        if evnt.pitch_result == "H" && evnt.result_detail != "E"{
                            game_report.hits += 1
                            game_report.swings += 1
                            
                            if evnt.batter_stance == "L" {
                                game_report.lh_hits += 1
                            }
                            else if evnt.batter_stance == "R" {
                                game_report.rh_hits += 1
                            }
                                
                            if evnt.result_detail == "S" {
                                game_report.game_score -= 2
                                game_report.singles += 1
                            }
                            else if evnt.result_detail == "D" {
                                game_report.game_score -= 3
                                game_report.doubles += 1
                                
                                if evnt.batter_stance == "L" {
                                    game_report.lh_xbhs += 1
                                }
                                else if evnt.batter_stance == "R" {
                                    game_report.rh_xbhs += 1
                                }
                                
                            }
                            else if evnt.result_detail == "T" {
                                game_report.game_score -= 4
                                game_report.triples += 1
                                
                                if evnt.batter_stance == "L" {
                                    game_report.lh_xbhs += 1
                                }
                                else if evnt.batter_stance == "R" {
                                    game_report.rh_xbhs += 1
                                }
                                
                            }
                            else if evnt.result_detail == "H" {
                                game_report.game_score -= 6
                                game_report.homeruns += 1
                                
                                if evnt.batter_stance == "L" {
                                    game_report.lh_xbhs += 1
                                }
                                else if evnt.batter_stance == "R" {
                                    game_report.rh_xbhs += 1
                                }
                            }
                                
                        }
                        else if evnt.result_detail == "E" {
                            game_report.errors += 1
                            game_report.swings += 1
                        }
                        else if evnt.pitch_result == "O" {
                            game_report.game_score += 2
                            game_report.swings += 1
                            outs += 1
                        }
                        else if evnt.result_detail == "K" || evnt.result_detail == "C" || evnt.result_detail == "M"{
                            game_report.pl_outline = .white
                            game_report.strikeouts += 1
                            game_report.game_score += 3
                            if evnt.result_detail != "C" {
                                outs += 1
                            }
                            
                            if evnt.batter_stance == "L" {
                                game_report.lh_strikeouts += 1
                            }
                            else if evnt.batter_stance == "R" {
                                game_report.rh_strikeouts += 1
                            }
                            
                        }
                    }
                    else if evnt.pitch_result == "A" || evnt.result_detail == "B"{
                        game_report.balls += 1
                        if (evnt.balls == 0 && evnt.strikes == 0) || game_report.pitches == 1{
                            game_report.first_pitch_ball += 1
                        }
                        
                        else if evnt.result_detail == "W"{
                            game_report.walks += 1
                            game_report.game_score -= 2
                            
                            if evnt.batter_stance == "L" {
                                game_report.lh_walks += 1
                            }
                            else if evnt.batter_stance == "R" {
                                game_report.rh_walks += 1
                            }
                            
                        }
                    }
                }
                else if evnt.result_detail == "R" {
                    outs += 1
                }

                if outs > 2 {
                    game_report.inn_pitched = round(game_report.inn_pitched) + 1
                    outs = 0
                }
                else {
                    game_report.inn_pitched = round(game_report.inn_pitched) + (Double(outs) * 0.1)
                }
                
                if (evnt.balls == 0 && evnt.strikes == 0 && evnt.result_detail != "R")  || game_report.pitches == 1{
                    game_report.batters_faced += 1
                    
                    if evnt.batter_stance == "L" {
                        game_report.lh_batters_faced += 1
                    }
                    else if evnt.batter_stance == "R" {
                        game_report.rh_batters_faced += 1
                    }
                    
                }
                
                game_report.x_coordinate_list.append(evnt.pitch_x_location)
                game_report.y_coordinate_list.append(evnt.pitch_y_location)
                game_report.pl_color_list.append(game_report.pl_color)
                game_report.pl_outline_list.append(game_report.pl_outline)
            }
        }
        
        game_report.fpb_to_fps.append(game_report.first_pitch_ball)
        game_report.fpb_to_fps.append(game_report.first_pitch_strike)
        
        game_report.balls_to_strikes.append(game_report.balls)
        game_report.balls_to_strikes.append(game_report.strikes)
        
        if game_report.first_pitch_strike > 0 {
            game_report.first_pit_strike_per = (game_report.first_pitch_strike * 100) / game_report.batters_faced
        }
        
        if game_report.swings > 0 {
            game_report.swing_per = (game_report.swings * 100) / game_report.strikes
        }
        
        if game_report.whiffs > 0 {
            game_report.whiff_per = (game_report.whiffs * 100) / game_report.swings
        }
        
        if game_report.strikes > 0 && game_report.pitches > 0{
            game_report.strikes_per = (game_report.strikes * 100) / game_report.pitches
        }
        
        if game_report.p1_hits > game_report.p2_hits && game_report.p1_hits > game_report.p3_hits && game_report.p1_hits > game_report.p4_hits {
            game_report.most_hit_pit = current_pitcher.pitch1
            game_report.mhp_pitches = game_report.p1_by_inn.reduce(0, +)
            game_report.mhp_hits = game_report.p1_hits
        }
        else if game_report.p2_hits > game_report.p3_hits && game_report.p2_hits > game_report.p4_hits {
            game_report.most_hit_pit = current_pitcher.pitch2
            game_report.mhp_pitches = game_report.p2_by_inn.reduce(0, +)
            game_report.mhp_hits = game_report.p2_hits
        }
        else if game_report.p3_hits > game_report.p4_hits {
            game_report.most_hit_pit = current_pitcher.pitch3
            game_report.mhp_pitches = game_report.p3_by_inn.reduce(0, +)
            game_report.mhp_hits = game_report.p3_hits
        }
        else if game_report.p4_hits > game_report.p3_hits{
            game_report.most_hit_pit = current_pitcher.pitch4
            game_report.mhp_pitches = game_report.p3_by_inn.reduce(0, +)
            game_report.mhp_hits = game_report.p4_hits
        }
        else {
            game_report.most_hit_pit = "None"
            game_report.mhp_pitches = 0
            game_report.mhp_hits = 0
        }
        
        if game_report.p1_velo_list.count >= 1 {
            let p1_avg = game_report.p1_velo_list.reduce(0, +) / Double(game_report.p1_velo_list.count)
            let p1_max = game_report.p1_velo_list.max() ?? 0
            var p1_factor = (p1_avg - 60) / 40
            if p1_factor <= 0.01 { p1_factor = 0.01 }
            else if p1_factor >= 0.86 { p1_factor = 0.86 }
            
            game_report.velo_set_list.append(PitchVeloSet(pitch_type: current_pitcher.pitch1, max_velo: p1_max, avg_velo: p1_avg, velo_factor: p1_factor))
        }
        if game_report.p2_velo_list.count >= 1 {
            let p2_avg = game_report.p2_velo_list.reduce(0, +) / Double(game_report.p2_velo_list.count)
            let p2_max = game_report.p2_velo_list.max() ?? 0
            var p2_factor = (p2_avg - 60) / 40
            if p2_factor <= 0.01 { p2_factor = 0.01 }
            else if p2_factor >= 0.86 { p2_factor = 0.86 }
            
            game_report.velo_set_list.append(PitchVeloSet(pitch_type: current_pitcher.pitch2, max_velo: p2_max, avg_velo: p2_avg, velo_factor: p2_factor))
        }
        if game_report.p3_velo_list.count >= 1 {
            let p3_avg = game_report.p3_velo_list.reduce(0, +) / Double(game_report.p3_velo_list.count)
            let p3_max = game_report.p3_velo_list.max() ?? 0
            var p3_factor = (p3_avg - 60) / 40
            if p3_factor <= 0.01 { p3_factor = 0.01 }
            else if p3_factor >= 0.86 { p3_factor = 0.86 }
            
            game_report.velo_set_list.append(PitchVeloSet(pitch_type: current_pitcher.pitch3, max_velo: p3_max, avg_velo: p3_avg, velo_factor: p3_factor))
        }
        if game_report.p4_velo_list.count >= 1 {
            let p4_avg = game_report.p4_velo_list.reduce(0, +) / Double(game_report.p4_velo_list.count)
            let p4_max = game_report.p4_velo_list.max() ?? 0
            var p4_factor = (p4_avg - 60) / 40
            if p4_factor <= 0.01 { p4_factor = 0.01 }
            else if p4_factor >= 0.86 { p4_factor = 0.86 }
            
            game_report.velo_set_list.append(PitchVeloSet(pitch_type: current_pitcher.pitch4, max_velo: p4_max, avg_velo: p4_avg, velo_factor: p4_factor))
        }
        
        
        if game_report.batters_faced != 0 {
            game_report.bs_faced_factor = Double(game_report.rh_batters_faced) / Double(game_report.batters_faced)
        }
        else {
            game_report.bs_faced_factor = 0.5
        }
        
        if game_report.hits != 0 {
            game_report.bs_hits_factor = Double(game_report.rh_hits) / Double(game_report.hits)
        }
        else {
            game_report.bs_hits_factor = 0.5
        }
        
        if (game_report.lh_xbhs + game_report.rh_xbhs) != 0 {
            game_report.bs_xbhs_factor = Double(game_report.rh_xbhs) / Double(game_report.lh_xbhs + game_report.rh_xbhs)
        }
        else {
            game_report.bs_xbhs_factor = 0.5
        }
        
        if game_report.strikeouts != 0 {
            game_report.bs_strikeouts_factor = Double(game_report.rh_strikeouts) / Double(game_report.strikeouts)
        }
        else {
            game_report.bs_strikeouts_factor = 0.5
        }
        
        if game_report.walks != 0 {
            game_report.bs_walks_factor = Double(game_report.rh_walks) / Double(game_report.walks)
        }
        else {
            game_report.bs_walks_factor = 0.5
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
        
        do {
            try context.delete(model: Event.self)
        } catch {
            print("Failed to delete all events.")
        }
        
        game_report.game_location = ""
        game_report.opponent_name = ""
        
        scoreboard.balls = 0
        scoreboard.strikes = 0
        scoreboard.outs = 0
        scoreboard.pitches = 0
        scoreboard.atbats = 1
        scoreboard.inning = 1
        scoreboard.baserunners = 0
        event.batter_stance = ""
        
        ptconfig.pitch_x_loc.removeAll()
        ptconfig.pitch_y_loc.removeAll()
        ptconfig.ab_pitch_color.removeAll()
        ptconfig.pitch_cur_ab = 0
        
        scoreboard.b1light = false
        scoreboard.b2light = false
        scoreboard.b3light = false
        
        scoreboard.s1light = false
        scoreboard.s2light = false
        
        scoreboard.o1light = false
        scoreboard.o2light = false
        
        clear_game_report()
        
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
        game_report.pitches = 0
        
        game_report.singles = 0
        game_report.doubles = 0
        game_report.triples = 0
        game_report.homeruns = 0
        game_report.errors = 0
        game_report.p1_hits = 0
        game_report.p2_hits = 0
        game_report.p3_hits = 0
        game_report.p4_hits = 0
        game_report.most_hit_pit = ""
        game_report.mhp_pitches = 0
        game_report.mhp_hits = 0
        
        game_report.swings = 0
        game_report.swing_per = 0
        game_report.whiffs = 0
        game_report.whiff_per = 0
        
        game_report.p1_velo_list = []
        game_report.p2_velo_list = []
        game_report.p3_velo_list = []
        game_report.p4_velo_list = []
        
        game_report.velo_set_list = []
        
        game_report.rh_batters_faced = 0
        game_report.lh_batters_faced = 0
        game_report.bs_faced_factor = 0
        game_report.rh_hits = 0
        game_report.lh_hits = 0
        game_report.bs_hits_factor = 0
        game_report.rh_xbhs = 0
        game_report.lh_xbhs = 0
        game_report.bs_xbhs_factor = 0
        game_report.rh_strikeouts = 0
        game_report.lh_strikeouts = 0
        game_report.bs_strikeouts_factor = 0
        game_report.rh_walks = 0
        game_report.lh_walks = 0
        game_report.bs_walks_factor = 0
        
        game_report.p1_by_inn = [0]
        game_report.p2_by_inn = [0]
        game_report.p3_by_inn = [0]
        game_report.p4_by_inn = [0]
        
        game_report.x_coordinate_list = []
        game_report.y_coordinate_list = []
        game_report.pl_color_list = []
        game_report.pl_outline_list = []
    }
    
    func load_previous_event() {
        let previous_event = events[events.count - 1]
        
        scoreboard.balls = previous_event.balls
        scoreboard.strikes = previous_event.strikes
        scoreboard.outs = previous_event.outs
        scoreboard.atbats = previous_event.atbats
        scoreboard.inning = previous_event.inning
        event.batter_stance = previous_event.batter_stance
        
        if ptconfig.pitch_x_loc.count > 0 && previous_event.result_detail != "R"{
            ptconfig.pitch_x_loc.removeLast()
            ptconfig.pitch_y_loc.removeLast()
            ptconfig.ab_pitch_color.removeLast()
            ptconfig.pitch_cur_ab -= 1
        }
        
        if newAtBat == true {
            newAtBat = false
        } else if previous_event.balls == 0 && previous_event.strikes == 0 && previous_event.result_detail != "R"{
            newAtBat = true
        }
        
        scoreboard.b1light = false
        scoreboard.b2light = false
        scoreboard.b3light = false
        
        scoreboard.s1light = false
        scoreboard.s2light = false
        
        scoreboard.o1light = false
        scoreboard.o2light = false
        
        if scoreboard.balls >= 1 {
            scoreboard.b1light = true
            if scoreboard.balls >= 2 {
                scoreboard.b2light = true
                if scoreboard.balls == 3 {
                    scoreboard.b3light = true
                }
            }
        }
        
        if scoreboard.strikes >= 1 {
            scoreboard.s1light = true
            if scoreboard.strikes == 2 {
                scoreboard.s2light = true
            }
        }
        
        if scoreboard.outs >= 1 {
            scoreboard.o1light = true
            if scoreboard.outs == 2 {
                scoreboard.o2light = true
            }
        }
        
        if previous_event.result_detail != "R" && scoreboard.pitches > 0 {
            scoreboard.pitches -= 1
        }
        else if previous_event.result_detail == "R" {
            scoreboard.baserunners += 1
        }
    }
    
    func load_previous_ab_pitches() {
        let prev_event = events[events.count - 1] //Previous event (t)
        var bl_ab_index = events.count - 2
        let atbat_before_last = events[bl_ab_index] //Before Last event (t - 1)
        
        if event.end_ab_rd.contains(prev_event.result_detail) && (prev_event.balls != 0 || prev_event.strikes != 0){
            while atbat_before_last.atbats == events[bl_ab_index].atbats {
                let prev_evnt = events[bl_ab_index]
                if prev_evnt.pitch_type != "NP" {
                    ptconfig.pitch_x_loc.insert(prev_evnt.pitch_x_location, at: 0)
                    ptconfig.pitch_y_loc.insert(prev_evnt.pitch_y_location, at: 0)
                    
                    if prev_evnt.pitch_type == "P1"{
                        ptconfig.ab_pitch_color.insert(ptconfig.arsenal_colors[0], at: 0)
                    }
                    else if prev_evnt.pitch_type == "P2"{
                        ptconfig.ab_pitch_color.insert(ptconfig.arsenal_colors[1], at: 0)
                    }
                    else if prev_evnt.pitch_type == "P3"{
                        ptconfig.ab_pitch_color.insert(ptconfig.arsenal_colors[2], at: 0)
                    }
                    else if prev_evnt.pitch_type == "P4"{
                        ptconfig.ab_pitch_color.insert(ptconfig.arsenal_colors[3], at: 0)
                    }
                    
                    ptconfig.pitch_cur_ab += 1
                }
                
                if bl_ab_index > 0 {
                    bl_ab_index -= 1
                }
                else{
                    break
                }
            }
            
            PitchOverlayPrevPitches()
            
        }
    }
    
    func change_cur_ab_stance() {
        if events.count >= 2 {
            var cur_event = events[events.count - 1]
            var prev_ab_index = events.count - 2
            var prev_event = events[prev_ab_index]
            while (cur_event.batter_stance != prev_event.batter_stance) && (cur_event.atbats == prev_event.atbats) {
                events[prev_ab_index].batter_stance = cur_event.batter_stance
                
                if prev_ab_index >= 1 {
                    prev_ab_index -= 1
                }
                else {
                    break
                }
            }
        }
    }
    
    func set_pitcher() {
        let pitcher_id = events[events.count - 1].pitcher_id
        for pitcher in pitchers {
            if pitcher.id == pitcher_id {
                current_pitcher.pitch_num = 0
                current_pitcher.firstName = pitcher.firstName
                current_pitcher.lastName = pitcher.lastName
                current_pitcher.pitch1 = pitcher.pitch1
                current_pitcher.idcode = pitcher.id
                if current_pitcher.pitch1 != "None" {
                    current_pitcher.pitch_num += 1
                    current_pitcher.arsenal[0] = pitcher.pitch1
                }
                
                current_pitcher.pitch2 = pitcher.pitch2
                if current_pitcher.pitch2 != "None" {
                    current_pitcher.pitch_num += 1
                    current_pitcher.arsenal[1] = pitcher.pitch2
                }
                
                current_pitcher.pitch3 = pitcher.pitch3
                if current_pitcher.pitch3 != "None" {
                    current_pitcher.pitch_num += 1
                    current_pitcher.arsenal[2] = pitcher.pitch3
                }
                
                current_pitcher.pitch4 = pitcher.pitch4
                if current_pitcher.pitch4 != "None" {
                    current_pitcher.pitch_num += 1
                    current_pitcher.arsenal[3] = pitcher.pitch4
                }
                break
            }
        }
    }
    
    func load_recent_event() {
        let recent_event = events[events.count - 1]
        let end_ab_br = ["S", "D", "T", "H", "E", "B", "C", "W"]
        let end_ab_out = ["F", "G", "L", "P", "Y", "K", "M", "R"]
        
        scoreboard.balls = recent_event.balls
        scoreboard.strikes = recent_event.strikes
        scoreboard.outs = recent_event.outs
        scoreboard.atbats = 0
        scoreboard.inning = recent_event.inning
        event.batter_stance = recent_event.batter_stance
        
        if end_ab_br.contains(recent_event.result_detail) {
            scoreboard.balls = 0
            scoreboard.strikes = 0
            newAtBat = true
        }
        else if end_ab_out.contains(recent_event.result_detail) {
            scoreboard.balls = 0
            scoreboard.strikes = 0
            scoreboard.outs += 1
            if scoreboard.outs >= 3 {
                scoreboard.inning += 1
                scoreboard.outs = 0
            }
            newAtBat = true
        }
        else if recent_event.pitch_result == "A" {
            scoreboard.balls += 1
        }
        else {
            scoreboard.strikes += 1
        }
        
        if ptconfig.pitch_x_loc.count > 0 && recent_event.result_detail != "R"{
            ptconfig.pitch_x_loc.removeLast()
            ptconfig.pitch_y_loc.removeLast()
            ptconfig.ab_pitch_color.removeLast()
            ptconfig.pitch_cur_ab -= 1
        }
        
        scoreboard.b1light = false
        scoreboard.b2light = false
        scoreboard.b3light = false
        
        scoreboard.s1light = false
        scoreboard.s2light = false
        
        scoreboard.o1light = false
        scoreboard.o2light = false
        
        if scoreboard.balls >= 1 {
            scoreboard.b1light = true
            if scoreboard.balls >= 2 {
                scoreboard.b2light = true
                if scoreboard.balls == 3 {
                    scoreboard.b3light = true
                }
            }
        }
        
        if scoreboard.strikes >= 1 {
            scoreboard.s1light = true
            if scoreboard.strikes == 2 {
                scoreboard.s2light = true
            }
        }
        
        if scoreboard.outs >= 1 {
            scoreboard.o1light = true
            if scoreboard.outs == 2 {
                scoreboard.o2light = true
            }
        }

        for evnt in events{
            
            if evnt.result_detail != "R" {
                if current_pitcher.idcode == evnt.pitcher_id{
                    scoreboard.pitches += 1
                    if (evnt.balls == 0 && evnt.strikes == 0) || scoreboard.pitches == 1{
                        scoreboard.atbats += 1
                    }
                }
            }
            else {
                if scoreboard.baserunners > 0{
                    scoreboard.baserunners -= 1
                }
            }
            if end_ab_br.contains(evnt.result_detail) {
                if scoreboard.baserunners < 3 {
                    scoreboard.baserunners += 1
                }
                if evnt.result_detail == "T" {
                    scoreboard.baserunners = 1
                }
                else if evnt.result_detail == "H" {
                    scoreboard.baserunners = 0
                }
            }
        }
    }
    
    func load_recent_ab_pitches() {
        var cur_ab_index = events.count - 1
        let cur_event = events[events.count - 1] //Previous event (t)
        
        if !event.end_ab_rd.contains(cur_event.result_detail) {
            while cur_event.atbats == events[cur_ab_index].atbats {
                let prev_evnt = events[cur_ab_index]
                if prev_evnt.pitch_type != "NP" {
                    ptconfig.pitch_x_loc.insert(prev_evnt.pitch_x_location, at: 0)
                    ptconfig.pitch_y_loc.insert(prev_evnt.pitch_y_location, at: 0)

                    if prev_evnt.pitch_type == "P1"{
                        ptconfig.ab_pitch_color.insert(ptconfig.arsenal_colors[0], at: 0)
                    }
                    else if prev_evnt.pitch_type == "P2"{
                        ptconfig.ab_pitch_color.insert(ptconfig.arsenal_colors[1], at: 0)
                    }
                    else if prev_evnt.pitch_type == "P3"{
                        ptconfig.ab_pitch_color.insert(ptconfig.arsenal_colors[2], at: 0)
                    }
                    else if prev_evnt.pitch_type == "P4"{
                        ptconfig.ab_pitch_color.insert(ptconfig.arsenal_colors[3], at: 0)
                    }

                    ptconfig.pitch_cur_ab += 1
                }
                if cur_ab_index > 0 {
                    cur_ab_index -= 1
                }
                else {
                    break
                }
            }
            PitchOverlayPrevPitches()
        }
    }
        
    func add_prev_event_string() {
        if event.recordEvent{
            let new_event = Event(pitcher_id: current_pitcher.idcode, pitch_result: event.pitch_result, pitch_type: event.pitch_type, result_detail: event.result_detail, balls: event.balls, strikes: event.strikes, outs: event.outs, inning: event.inning, atbats: event.atbats, pitch_x_location: event.x_cor, pitch_y_location: event.y_cor, batter_stance: event.batter_stance, velocity: event.velocity)
            context.insert(new_event)
            print_Event_String()
        }
    }

    func print_Event_String() {
        print(current_pitcher.idcode, event.pitch_result, event.pitch_type, event.result_detail, event.balls, event.strikes, event.outs, event.inning, event.atbats, event.batter_stance, event.velocity, event.x_cor, event.y_cor)
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
        event.x_cor = 0
        event.y_cor = 0
        
        scoreboard.outs += 1
        scoreboard.baserunners -= 1
        
        if scoreboard.outs == 1 {
            scoreboard.o1light = true
        }
        if scoreboard.outs == 2 {
            scoreboard.o2light = true
        }
        
        if scoreboard.outs == 3 {
            scoreboard.outs = 0
            scoreboard.inning += 1
            scoreboard.baserunners = 0
            scoreboard.o1light = false
            scoreboard.o2light = false
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
        
        scoreboard.b1light = false
        scoreboard.b2light = false
        scoreboard.b3light = false
        
        scoreboard.s1light = false
        scoreboard.s2light = false
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
            
            ZStack{
                
                PitchOverlayPrevPitches()
                    .transition(.opacity)
                
                Rectangle()
                    .fill(Color.black.opacity(0.01))
            }
            
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
                                        Task { await LocationInputTip.locationInput.donate() }
                                        }
                                    }) {
                                        Text("\(current_pitcher.arsenal[pt_num])")
                                            .textCase(.uppercase)
                                            .fontWeight(.bold)
                                            .font(.system(size: 15))
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, ver_padding)
                                    }
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
                                            Task { await LocationInputTip.locationInput.donate() }
                                        }
                                    }) {
                                            Text("\(current_pitcher.arsenal[pt_num])")
                                                .textCase(.uppercase)
                                                .fontWeight(.bold)
                                                .font(.system(size: 17))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, ver_padding / 2)
                                    }
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
                                            Task { await LocationInputTip.locationInput.donate() }
                                        }
                                    }) {
                                        Text("\(current_pitcher.arsenal[pt_num])")
                                            .textCase(.uppercase)
                                            .fontWeight(.bold)
                                            .font(.system(size: 17))
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, ver_padding / 2)
                                    }
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
                .clipShape(RoundedRectangle(cornerRadius: 8))
                    
            }
            .transition(.move(edge: .bottom))
            .ignoresSafeArea()
                    
        }
    }
    
}

struct PitchOverlayPrevPitches : View {
    
    @Environment(PitchTypeConfig.self) var ptconfig
    
    var body: some View {
                            
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
                        .font(.system(size: 17))
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

