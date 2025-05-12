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

    @State private var path = [Int]()
    
    @AppStorage("BatterStance") var ASBatterStance: Bool?
    @AppStorage("BullpenMode") var ASBullpenMode : Bool?
    @AppStorage("CurrentOpponentName") var ASCurOpponentName : String?
    @AppStorage("GameLocation") var ASGameLocation : String?
    @AppStorage("VelocityUnits") var ASVeloUnits : String?
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(currentPitcher.self) var current_pitcher
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    @Environment(Event_String.self) var event
    @Environment(GameReport.self) var game_report
    @Environment(AtBatBreakdown.self) var at_bat_brkdwn
//    @Environment(SavedGames.self) var saved_games
    
    @Query(sort: \Event.event_number) var events: [Event]
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    private let selectpitchertip = SelectPitcherTip()
    private let locationinputtip = LocationInputTip()
    
    @State private var balls: Int = 0
    @State private var strikes: Int = 0
    
    @State private var hidePitchOverlay = false
    @State private var showGameReport = false
    @State private var showPitcherSelect = false
    @State private var showSavedGames: Bool = false
    @State private var newAtBat = false
    @State private var showEndGame = false
    @State private var showSaveGame = false
    @State private var showNoSave = false
    @State private var showResumeGame = false
    @State private var showFileNameInfo = false
    @State private var showSettingsView = false
    @State private var showDifferentPreviousPitcher: Bool = false
    
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
        
        NavigationStack(path: $path){
                
                VStack{
                    
                    ZStack{
                        
                        ZStack{
                            
                            SaveEventView().task{
                                
                                //let date = Date.now
                                //let formattedTime = date.formatted(.dateTime.hour().minute().second().secondFraction(.fractional(3)))
                                //print("New Entry Beginning: " + formattedTime)
                                
                                
                                add_prev_event_string()
                                event.recordEvent = true
                                scoreboard.update_scoreboard = true
                                
                                balls = scoreboard.balls
                                strikes = scoreboard.strikes
                                
                                if events.count > 0 && (scoreboard.balls == 0 && scoreboard.strikes == 0 && scoreboard.pitches == 0 && scoreboard.atbats == 1) {
                                    showResumeGame = true
                                }
                                else if game_report.game_location == "" && game_report.opponent_name == ""{
                                    showFileNameInfo = true
                                }
                                
                                if event.end_ab_rd.contains(event.result_detail) {
                                    print(event.result_detail)
                                    newAtBat = true
                                }
                                else if balls == 0 && strikes == 0 && scoreboard.pitches > 0 && current_pitcher.lastName != "Change Me"{
                                    newAtBat = true
                                }
                                
                                if scoreboard.inning > 9 && scoreboard.balls == 0 && scoreboard.strikes == 0 && scoreboard.outs == 0 && scoreboard.baserunners == 0 {
                                    scoreboard.baserunners += 1
                                }
                                
                            }
                            
                            Image("PLI_Background")
                                .resizable()
                                .gesture(tap)
                            
                            Circle()
                                .stroke(cur_pitch_outline, lineWidth: 8)
                                .frame(width: 35.0, height: 35.0, alignment: .center)
                                .position(location)
                            
                            Button{
                                path.append(1)
                                
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
                            } label: {
                                Text("")
                                    .frame(width: 35.0, height: 35.0)
                            }
                            .background(cur_pitch_color)
                            .foregroundColor(.white)
                            .cornerRadius(90.0)
                            .position(location)
                            
                        }
                        .navigationDestination(for: Int.self) { selection in
                            PitchResultView(path: $path)
                                .navigationBarBackButtonHidden(true).preferredColorScheme(.dark)
                        }
                        
                        
                        ZStack{
                            
                            if current_pitcher.pitch_num > 0{
                                PitchLocationInput()
                            }
                            
                            VStack(alignment: .center){
                                
                                if ASBatterStance == true {
                                    Button {
                                        if ptconfig.npe_EOAB != true {
                                            newAtBat = true
                                        }
                                        
                                    } label: {
                                        HStack{
                                            
                                            //Spacer()
                                            
                                            if event.batter_stance == "R" {
                                                Image(systemName: "chevron.left")
                                                    .imageScale(.small)
                                                    .foregroundStyle(ptconfig.npe_EOAB ? Color.white.opacity(0.7) : Color.white)
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
                                                .foregroundStyle(ptconfig.npe_EOAB ? Color.white.opacity(0.7) : Color.white)
                                            
                                            if event.batter_stance == "L" {
                                                Image(systemName: "chevron.right")
                                                    .imageScale(.small)
                                                    .foregroundStyle(ptconfig.npe_EOAB ? Color.white.opacity(0.7) : Color.white)
                                                    .padding(.leading, -5)
                                            }
                                            else {
                                                Image(systemName: "chevron.right")
                                                    .imageScale(.small)
                                                    .foregroundStyle(.clear)
                                                    .padding(.leading, -5)
                                            }
                                            
                                            //Spacer()
                                            
                                        }
                                        
                                    }
                                    .padding(.top, 58)
                                }
                                
                                Spacer()
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
                            
                            if newAtBat == true  && ASBatterStance == true{
                                BatterPositionView(isActive: $newAtBat, close_action: {DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {newAtBat = false}})
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
                            
                            if current_pitcher.pitch_num <= 0 {
                                ZStack {
                                    Color(.black)
                                        .opacity(0.2)
                                    
                                    Spacer()
                                    
                                    VStack{
                                        
                                        Spacer()
                                        
                                        HStack{
                                            Button(action: {
                                                showSettingsView = true
                                            }) {
                                                HStack{
                                                    Image(systemName: "gearshape.fill")
                                                        .imageScale(.large)
                                                        .font(.system(size: 17))
                                                        .frame(width: sbl_width, height: sbl_height)
                                                        .foregroundColor(Color.white)
                                                        .padding(10.5)
                                                }
                                                .background(Color("ScoreboardGreen"))
                                                .cornerRadius(8.0)
                                            }
                                            .popover(isPresented: $showSettingsView) {
                                                SettingsView()
                                                    .preferredColorScheme(.dark)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.leading, 10)
                                        
                                        VStack{
                                            Button{
                                                
                                                showPitcherSelect = true
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
                                        .padding(45)
                                        .background(Color.black.opacity(0.5))
                                        .background(.ultraThinMaterial)
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
                                FileNamePopUpView(action: {showFileNameInfo = false; newAtBat = true; scoreboard.disable_bottom_row = true})
                            }
                            
//                            if showEndGame == true{
//                                PopupAlertView(isActive: $showEndGame, title: "End Game", message: "This game and its data will not be saved!", leftButtonAction: {new_game_func(); newAtBat = false; showFileNameInfo = true; showEndGame = false; scoreboard.disable_bottom_row = true}, rightButtonAction: {showEndGame = false; scoreboard.disable_bottom_row = true})
//                            }
                            
                            if showDifferentPreviousPitcher == true {
                                XInfoPopUpView(isActive: $showDifferentPreviousPitcher, show_close: false, title: "Attention", message: current_pitcher.firstName + " " + current_pitcher.lastName + " was in the game for the previous event. They have been set to the current pitcher.", buttonAction: {scoreboard.disable_bottom_row = true; showDifferentPreviousPitcher = false}, XButtonAction: {scoreboard.disable_bottom_row = true; showDifferentPreviousPitcher = false})
                            }
                            
                            if showEndGame == true && events.count > 0{
                                XPopupAlertView(isActive: $showEndGame, show_close: false, title: "Save Game", message: "Do you want to save this game before starting a new one?", leftButtonAction: {scoreboard.disable_bottom_row = true; save_game_func(); showSaveGame = true;}, rightButtonAction: {showNoSave = true}, XButtonAction: {scoreboard.disable_bottom_row = true; showEndGame = false})
                            }
                            else if showEndGame == true && events.count == 0{
                                XPopupAlertView(isActive: $showEndGame, show_close: false, title: "New Game", message: "Do you want to start a new game?", leftButtonAction: {scoreboard.disable_bottom_row = true; showEndGame = false; showFileNameInfo = true}, rightButtonAction: {showEndGame = false}, XButtonAction: {scoreboard.disable_bottom_row = true; showEndGame = false})
                            }
                            
                            if showNoSave == true {
                                XPopupAlertView(isActive: $showNoSave, show_close: true, title: "Are you sure?", message: "This game and its data will not be saved!", leftButtonAction: {new_game_func(); newAtBat = false; showFileNameInfo = true; showNoSave = false; showEndGame = false; scoreboard.disable_bottom_row = true}, rightButtonAction: {showNoSave = false}, XButtonAction: {new_game_func(); showNoSave = false; scoreboard.disable_bottom_row = true})
                            }
                            
                            if showSaveGame == true {
                                SavePopUpView(isActive: $showSaveGame, Action: {showSaveGame = false; scoreboard.disable_bottom_row = true; new_game_func(); showFileNameInfo = true; showEndGame = false})
                            }
                            
                            if showResumeGame == true {
                                PopupAlertView(isActive: $showResumeGame, title: "Resume Game", message: "A previous game was being recorded. Do you want to continue?", leftButtonAction: {set_pitcher(); load_pitcher_appearance_list(); load_recent_event(); load_recent_ab_pitches(); load_game_location();  showResumeGame = false; scoreboard.disable_bottom_row = true;}, rightButtonAction: {new_game_func(); showFileNameInfo = true; showResumeGame = false; scoreboard.disable_bottom_row = true})
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
                            
                            //Haptic ability
                            let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                            
                            //If no popup view is showing
                            if scoreboard.disable_bottom_row == true {
                                //Back button logic after pitch input
                                if ptconfig.hidePitchOverlay == true {
                                    cur_pitch_color = .clear
                                    cur_pitch_outline = .clear
                                }
                                //If there has been an event entered
                                else if events.count > 0 {
                                    
                                    //Show undo toast
                                    showUndoToast = true
                                    
                                    //If there are more than one event (Most cases)
                                    if events.count != 1 {
                                        load_previous_event()
                                        load_previous_ab_pitches()
                                        context.delete(events[events.count - 1])
                                    }
                                    //If there is only one event
                                    else {
                                        //If one pitch has been entered (Not a NPE)
                                        if scoreboard.pitches > 0 && event.result_detail != "R" && event.result_detail != "RE" && event.pitch_result != "IW" && event.pitch_result != "VZ" && event.pitch_result != "VA"{ //Non pitch event (pitch not thrown)
                                            scoreboard.pitches -= 1
                                        }
                                        
                                        //Reset game and show NewAtBat popup
                                        newAtBat = true
                                        new_game_func()
                                        
                                        //Delete current instance of Event data model
                                        do {
                                            try context.delete(model: Event.self)
                                        } catch {
                                            print("Did not clear event data")
                                        }
                                        
                                        //Reset game information, triggers popup
                                        game_report.game_location = ASGameLocation ?? ""
                                        game_report.opponent_name = ASCurOpponentName ?? ""
                                        
                                    }
                                    
                                }
                                //Reset pitch overlay conditions
                                ptconfig.hidePitchOverlay = false
                                ptconfig.ptcolor = .clear
                            }
                            
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
                        HStack(alignment: .center, spacing: 1){
                            Text("P")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                //.padding(.leading, -7)
                                
                                let pitcher_lname = String(current_pitcher.lastName.prefix(10))
                                
                                Button(action: {
                                    if scoreboard.disable_bottom_row == true {
                                        showPitcherSelect = true
                                        if current_pitcher.lastName == "Change Me" {
                                            selectpitchertip.invalidate(reason: .actionPerformed)
                                        }
                                    }
                                }) {
                                    ZStack(alignment: .leading){
                                        RoundedRectangle(cornerRadius: 4)
                                            .foregroundStyle(
                                                Color("ScoreboardGreen").shadow(.inner(color: .black.opacity(0.4), radius: 2, x: 1, y: 1))
                                            )
                                            .frame(width: 160, height: 30)
                                        
                                        Text(pitcher_lname)
                                            .textCase(.uppercase)
                                            .font(.system(size: 20))
                                            .fontWeight(.black)
                                            .foregroundColor(.white)
                                            .padding(.leading, 5)

                                    }

                                }
                                .popover(isPresented: $showPitcherSelect) {
                                    SelectPitcherView()
                                        .preferredColorScheme(.dark)
                            }
                        }
                    }
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        HStack(/*spacing: 5*/){
                            
                            Button(action: {
                                if scoreboard.disable_bottom_row == true {
                                    showGameReport = true
                                }
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
                                    generate_at_bat_array()
                                    generate_pbp_array()
                                }
                            }
                            
                            Button(action: {
                                if scoreboard.disable_bottom_row == true {
                                    showEndGame = true
                                }
                            }) {
                                Image(systemName: "flag.checkered")
                                    .imageScale(.large)
                                    .font(.system(size: 17))
                                    .frame(width: sbl_width, height: sbl_height)
                                    .foregroundColor(Color.white)
                            }
                            
                            Button{
                                showSavedGames = true
                            } label: {
                                Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                                    .imageScale(.large)
                                    .font(.system(size: 17))
                                    .frame(width: sbl_width, height: sbl_height)
                                    .foregroundColor(Color.white)
                                    .bold()
                            }
                            .popover(isPresented: $showSavedGames) {
                                SavedGamesView().preferredColorScheme(.dark)
                            }
                        }
                        .padding(.trailing, -5)
                    }
                    
                }
            
        }
    }
    
    func generate_at_bat_array() {
        //Check for pitcher
        //Set at bat number
        //If at bat is greater: record at-bat and reset variables
        //Else: Add pitch to pitch_info_ab datatype
        var cur_at_bat = 1
        var pitches_this_ab: [pitch_info_ab] = []
        var x_coor_list: [Double] = []
        var y_coor_list: [Double] = []
        var color_list: [Color] = []
        var plot_list: [Int] = []
        var num_list: [Int] = []
        var num = 0
        var prev_batter_stance = ""
        var outs = 99
        var prev_inning = 1
        at_bat_brkdwn.at_bat_list.removeAll()
        
        for evnt in events {
            if evnt.pitcher_id == current_pitcher.idcode {
                
                var result = "" //Set based on logic for description
                var color: Color = .clear
                var pitch_type = "" //Set pitch types with logic
                let velocity = evnt.velocity
                let balls = evnt.balls
                let strikes = evnt.strikes
                let inning = evnt.inning
                //var outs = evnt.outs
                let x_coor = evnt.pitch_x_location
                let y_coor = evnt.pitch_y_location
                let batter_hand = evnt.batter_stance
                var plot = 1
                //sync unit variable
                
                if outs == 99 {
                    outs = evnt.outs
                }
                
                if evnt.pitch_type == "P1" {
                    pitch_type = current_pitcher.pitch1
                }
                else if evnt.pitch_type == "P2" {
                    pitch_type = current_pitcher.pitch2
                }
                else if evnt.pitch_type == "P3" {
                    pitch_type = current_pitcher.pitch3
                }
                else if evnt.pitch_type == "P4" {
                    pitch_type = current_pitcher.pitch4
                }
                
                if (evnt.atbats > cur_at_bat && evnt.result_detail != "RE" && evnt.result_detail != "R") {
                    cur_at_bat = evnt.atbats
                    at_bat_brkdwn.at_bat_list.append(AtBatDT(outs: outs, inning: prev_inning, batter_hand: prev_batter_stance, pitch_list: pitches_this_ab, x_coor_list: x_coor_list, y_coor_list: y_coor_list, pitch_color_list: color_list, plot_pitch_list: plot_list, pitch_num_list: num_list))
                    pitches_this_ab.removeAll()
                    x_coor_list.removeAll()
                    y_coor_list.removeAll()
                    color_list.removeAll()
                    plot_list.removeAll()
                    num_list.removeAll()
                    outs = evnt.outs
                    num = 0
                    result = ""
                }
                
                if evnt.pitch_result == "A" {
                    num += 1
                    color = Color("PowderBlue")
                    
                    if evnt.result_detail == "N" {
                        result = "Ball"
                    }
                    else if evnt.result_detail == "W" {
                        color = Color("Tangerine")
                        result = "Walk"
                    }
                }
                else if evnt.pitch_result == "Z" || evnt.pitch_result == "L"{
                    num += 1
                    color = Color("Gold")
                    if evnt.result_detail == "N" {
                        result = "Strike"
                    }
                    else if evnt.pitch_result == "L" {
                            result = "K - Called"
                    }
                    else if evnt.pitch_result == "Z" {
                        result = "K - Swinging"
                    }
                    
                    if evnt.result_detail == "K" || evnt.result_detail == "C" || evnt.result_detail == "M"{
                        color = Color("Grey")
                        result = "Strikeout"
                        if evnt.result_detail == "M" {
                            result = "Strikeout - ꓘ"
                        }
                        else if evnt.result_detail == "K" {
                            result = "Strikeout - K"
                        }
                        else if evnt.result_detail == "C" {
                            result = "Strikeout - No Out"
                            color = Color("Tangerine")
                        }
                    }
                }
                else if evnt.pitch_result == "T" {
                    num += 1
                    color = Color("Gold")
                    result = "Foul Ball"
                }
                else if evnt.pitch_result == "O" {
                    num += 1
                    color = Color("Grey")
                    if evnt.result_detail == "F" {
                        result = "Flyout"
                    }
                    else if evnt.result_detail == "G" {
                        result = "Groundout"
                    }
                    else if evnt.result_detail == "L" {
                        result = "Lineout"
                    }
                    else if evnt.result_detail == "P" {
                        result = "Popout"
                    }
                    else if evnt.result_detail == "Y" {
                        //sac but
                        result = "Sac Bunt"
                    }
                    else if evnt.result_detail == "O" {
                        result = "Out"
                    }
                    else if evnt.result_detail == "R" || evnt.result_detail == "RE"{
//                        if outs > 0 {
//                            outs -= 1
//                        }
                        num -= 1
                        plot = 0
                        color = Color(.red)
                        pitch_type = "NPE"
                        result = "BASERUNNER OUT"
                        
                        if evnt.result_detail == "RE" && (evnt.balls > 0 || evnt.strikes > 0) {
                            pitches_this_ab.removeAll()
                            x_coor_list.removeAll()
                            y_coor_list.removeAll()
                            color_list.removeAll()
                            plot_list.removeAll()
                            num_list.removeAll()
                            outs = 0
                            num = 0
                            result = ""
                            continue
                        }
                        
                    }
                }
                else if evnt.pitch_result == "H"{
                    num += 1
                    color = Color("Tangerine")
                    if evnt.result_detail == "S" {
                        result = "Single"
                    }
                    else if evnt.result_detail == "D" {
                        result = "Double"
                    }
                    else if evnt.result_detail == "T" {
                        result = "Triple"
                    }
                    else if evnt.result_detail == "H" {
                        result = "Homerun"
                    }
                    else if evnt.result_detail == "B" {
                        result = "Hit by Pitch"
                    }
                    else if evnt.result_detail == "E" {
                        result = "Error"
                    }
                }
                else if evnt.pitch_result == "VA" {
                    plot = 0
                    color = Color(.yellow)
                    pitch_type = "NPE"
                    result = "VIOLATION - BALL"
                    if evnt.result_detail == "W" {
                        result = "VIOLATION - WALK"
                    }
                }
                else if evnt.pitch_result == "VZ" {
                    plot = 0
                    color = Color(.yellow)
                    pitch_type = "NPE"
                    result = "VIOLATION - STRIKE"
                    if evnt.result_detail == "K" {
                        result = "VIOLATION - STRIKEOUT"
                    }
                }
                else if evnt.pitch_result == "IW" {
                    plot = 0
                    color = Color(.yellow)
                    pitch_type = "NPE"
                    result = "INTENTIONAL WALK"
                }
                
                x_coor_list.append(x_coor)
                y_coor_list.append(y_coor)
                color_list.append(color)
                plot_list.append(plot)
                num_list.append(num)
                
                pitches_this_ab.append(pitch_info_ab(result: result, result_color: color, pitch_type: pitch_type, velocity: velocity, balls: balls, strikes: strikes, units: "mph"))
                
                prev_batter_stance = batter_hand
                //prev_outs = outs
                prev_inning = inning
                
                if evnt == events.last {
                    at_bat_brkdwn.at_bat_list.append(AtBatDT(outs: outs, inning: prev_inning, batter_hand: prev_batter_stance, pitch_list: pitches_this_ab, x_coor_list: x_coor_list, y_coor_list: y_coor_list, pitch_color_list: color_list, plot_pitch_list: plot_list, pitch_num_list: num_list))
                }
            }
            else if pitches_this_ab.count > 0 {
                //print(pitches_this_ab.count)
                at_bat_brkdwn.at_bat_list.append(AtBatDT(outs: outs, inning: prev_inning, batter_hand: prev_batter_stance, pitch_list: pitches_this_ab, x_coor_list: x_coor_list, y_coor_list: y_coor_list, pitch_color_list: color_list, plot_pitch_list: plot_list, pitch_num_list: num_list))
                pitches_this_ab.removeAll()
            }
        }
        
        //print(at_bat_brkdwn.at_bat_list)
        
    }
    
    func generate_pbp_array(){
        var pitch_num = 0
        let pitch_abbreviations = ["FB" : "Fastball", "CU" : "Curveball", "SL" : "Slider", "CH" : "Change-Up", "FS" : "Splitter", "FC" : "Cutter", "SI" : "Sinker", "OT" : "Other", "ST" : "Sweeper"]
        game_report.pbp_event_list = []
        for (index, evnt) in events.enumerated() {
            
            //if evnt.pitcher_id == current_pitcher.idcode {
            
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
            
            var pitch_type = evnt.pitch_type
            
            //print("\(evnt.event_number) " + evnt.pitch_type + " \(evnt.balls)" + " - " + "\(evnt.strikes)")
            
            for pitcher in pitchers {
                if pitcher.id == pitcher_id {
                    pitcher_name = pitcher.firstName + " " + pitcher.lastName
                    if pitcher_id != game_report.cur_pitcher_id {
                        game_report.cur_pitcher_id = pitcher_id
                        pitch_num = 0
                    }
                    if pitch_type == "P1" {
                        pitch_type = pitcher.pitch1
                    }
                    else if pitch_type == "P2" {
                        pitch_type = pitcher.pitch2
                    }
                    else if pitch_type == "P3" {
                        pitch_type = pitcher.pitch3
                    }
                    else if pitch_type == "P4" {
                        pitch_type = pitcher.pitch4
                    }
                }
            }
            
            if outs != 1 {
                outs_label = "Outs"
            }
            else {
                outs_label = "Out"
            }
            
            for abbr in pitch_abbreviations {
                if abbr.value == pitch_type {
                    pitch_type = abbr.key
                }
            }
            
            if result_detail != "R" && result_detail != "RE" && pitch_result != "VA" && pitch_result != "VZ" && pitch_result != "IW"{
                
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
            else if pitch_result == "VA" {
                if result_detail == "N" {
                    result = "PCVBALL"
                }
                else if result_detail == "W" {
                    result = "PCVWALK"
                }
            }
            else if pitch_result == "VZ" {
                if result_detail == "N" {
                    result = "PCVSTRIKE"
                }
                else if result_detail == "K" {
                    result = "PCVSTRIKEOUT"
                }
            }
            else if pitch_result == "IW" {
                result = "IW"
            }
            else {
                result = "RUNNER OUT"
            }
            
            //print("\(pitch_num)" + " \(balls)" + " - " + "\(strikes)")
            
            game_report.pbp_event_list.append(PBPLog(pitch_num: pitch_num, pitch_type: pitch_type, result: result, balls: balls, strikes: strikes, outs: outs, out_label: outs_label, velo: velo, inning: inning, result_detail: result_detail, pitcher: pitcher_name))
            
        }
        
        //print(game_report.pbp_event_list)
        
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
        
        let first_base_run_matrix = [0.42, 0.27, 0.13]
        let second_base_run_matrix = [0.62, 0.41, 0.22]
        let third_base_run_matrix = [0.84, 0.66, 0.27]
        
        var velo_offset = 0.0
        if ASVeloUnits == "MPH" {
            velo_offset = 60.0
        }
        else if ASVeloUnits == "KPH" {
            velo_offset = 100.0
        }
        
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
                
                if evnt.result_detail != "R" && evnt.result_detail != "RE" && evnt.pitch_result != "IW" && evnt.pitch_result != "VA" && evnt.pitch_result != "VZ"{
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
                            game_report.game_score -= 2
                            
                            if evnt.batter_stance == "L" {
                                game_report.lh_hits += 1
                            }
                            else if evnt.batter_stance == "R" {
                                game_report.rh_hits += 1
                            }
                                
                            if evnt.result_detail == "S" {
                                game_report.game_score -= first_base_run_matrix[evnt.outs] * 3
                                game_report.singles += 1
                            }
                            else if evnt.result_detail == "D" {
                                game_report.game_score -= second_base_run_matrix[evnt.outs] * 3
                                game_report.doubles += 1
                                
                                if evnt.batter_stance == "L" {
                                    game_report.lh_xbhs += 1
                                }
                                else if evnt.batter_stance == "R" {
                                    game_report.rh_xbhs += 1
                                }
                                
                            }
                            else if evnt.result_detail == "T" {
                                game_report.game_score -= third_base_run_matrix[evnt.outs] * 3
                                game_report.triples += 1
                                
                                if evnt.batter_stance == "L" {
                                    game_report.lh_xbhs += 1
                                }
                                else if evnt.batter_stance == "R" {
                                    game_report.rh_xbhs += 1
                                }
                                
                            }
                            else if evnt.result_detail == "H" {
                                game_report.game_score -= 8
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
                        
                        else if evnt.result_detail == "B" {
                            game_report.game_score -= 2
                            game_report.game_score -= first_base_run_matrix[evnt.outs] * 3
                        }
                        
                        else if evnt.result_detail == "W"{
                            game_report.walks += 1
                            game_report.game_score -= 2
                            game_report.game_score -= first_base_run_matrix[evnt.outs] * 3
                            
                            if evnt.batter_stance == "L" {
                                game_report.lh_walks += 1
                            }
                            else if evnt.batter_stance == "R" {
                                game_report.rh_walks += 1
                            }
                            
                        }
                    }
                }
                else if evnt.pitch_result == "VA" {
                    if evnt.result_detail == "W" {
                        game_report.walks += 1
                        game_report.game_score -= 2
                        game_report.game_score -= first_base_run_matrix[evnt.outs] * 3
                    }
                }
                else if evnt.pitch_result == "VZ" {
                    if evnt.result_detail == "K" {
                        game_report.strikeouts += 1
                        game_report.game_score += 3
                        outs += 1
                    }
                }
                else if evnt.result_detail == "R" || evnt.result_detail == "RE" {
                    outs += 1
                    game_report.game_score += 2
                }

                if outs > 2 {
                    game_report.inn_pitched = round(game_report.inn_pitched) + 1
                    outs = 0
                }
                else {
                    game_report.inn_pitched = round(game_report.inn_pitched) + (Double(outs) * 0.1)
                }
                
                if (evnt.balls == 0 && evnt.strikes == 0 && evnt.result_detail != "R" && evnt.result_detail != "RE" && evnt.pitch_result != "IW") {
                    
                    game_report.batters_faced += 1
                    
                    if evnt.batter_stance == "L" {
                        game_report.lh_batters_faced += 1
                    }
                    else if evnt.batter_stance == "R" {
                        game_report.rh_batters_faced += 1
                    }
                    
                }
                else if game_report.pitches == 1 && game_report.batters_faced == 0 && evnt.result_detail != "R" && evnt.result_detail != "RE" && evnt.pitch_result != "IW"{
                    
                    game_report.batters_faced += 1
                    
                    if evnt.batter_stance == "L" {
                        game_report.lh_batters_faced += 1
                    }
                    else if evnt.batter_stance == "R" {
                        game_report.rh_batters_faced += 1
                    }
                    
                }
                
                //Logic for inning end with baserunner out
                if evnt.result_detail == "RE" && (evnt.balls > 0 || evnt.strikes > 0) {
                    game_report.batters_faced -= 1
                }
                
                if evnt.pitch_result != "VA" &&  evnt.pitch_result != "VZ"  &&  evnt.pitch_result != "IW" && evnt.result_detail != "RE" && evnt.result_detail != "R"{
                    game_report.x_coordinate_list.append(evnt.pitch_x_location)
                    game_report.y_coordinate_list.append(evnt.pitch_y_location)
                    game_report.pl_color_list.append(game_report.pl_color)
                    game_report.pl_outline_list.append(game_report.pl_outline)
                }

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
            
            //Average for middle line and label
            let p1_avg = game_report.p1_velo_list.reduce(0, +) / Double(game_report.p1_velo_list.count)
            
            //Min and Max values for calculating range
            let p1_max = game_report.p1_velo_list.max() ?? 0
            let p1_min = game_report.p1_velo_list.min() ?? 0
            
            //Range factor for showing range of pitch velos
            var p1_range_factor = ((p1_max - p1_min) / 2) * 10
            if p1_range_factor < 30 {p1_range_factor = 30}

            //Factor for positioning average velo line
            var p1_factor = (p1_avg - velo_offset) / 40
            if p1_factor <= 0.06 { p1_factor = 0.06 }
            else if p1_factor >= 0.92 { p1_factor = 0.92 }
            
            //Add to velo list for pitch1 component visual
            game_report.velo_set_list.append(PitchVeloSet(pitch_type: current_pitcher.pitch1, max_velo: p1_max, min_velo: p1_min, avg_velo: p1_avg, velo_factor: p1_factor, range_factor: p1_range_factor))
        }
        if game_report.p2_velo_list.count >= 1 {
            let p2_avg = game_report.p2_velo_list.reduce(0, +) / Double(game_report.p2_velo_list.count)
            let p2_max = game_report.p2_velo_list.max() ?? 0
            let p2_min = game_report.p2_velo_list.min() ?? 0
            var p2_range_factor = ((p2_max - p2_min) / 2) * 10
            if p2_range_factor < 30 {p2_range_factor = 30}
            var p2_factor = (p2_avg - velo_offset) / 40
            if p2_factor <= 0.06 { p2_factor = 0.06 }
            else if p2_factor >= 0.92 { p2_factor = 0.92 }
            
            game_report.velo_set_list.append(PitchVeloSet(pitch_type: current_pitcher.pitch2, max_velo: p2_max, min_velo: p2_min, avg_velo: p2_avg, velo_factor: p2_factor, range_factor: p2_range_factor))
        }
        if game_report.p3_velo_list.count >= 1 {
            let p3_avg = game_report.p3_velo_list.reduce(0, +) / Double(game_report.p3_velo_list.count)
            let p3_max = game_report.p3_velo_list.max() ?? 0
            let p3_min = game_report.p3_velo_list.min() ?? 0
            var p3_range_factor = ((p3_max - p3_min) / 2) * 10
            if p3_range_factor < 30 {p3_range_factor = 30}
            var p3_factor = (p3_avg - velo_offset) / 40
            if p3_factor <= 0.06 { p3_factor = 0.06 }
            else if p3_factor >= 0.92 { p3_factor = 0.92 }
            
            game_report.velo_set_list.append(PitchVeloSet(pitch_type: current_pitcher.pitch3, max_velo: p3_max, min_velo: p3_min, avg_velo: p3_avg, velo_factor: p3_factor, range_factor: p3_range_factor))
        }
        if game_report.p4_velo_list.count >= 1 {
            let p4_avg = game_report.p4_velo_list.reduce(0, +) / Double(game_report.p4_velo_list.count)
            let p4_max = game_report.p4_velo_list.max() ?? 0
            let p4_min = game_report.p4_velo_list.min() ?? 0
            var p4_range_factor = ((p4_max - p4_min) / 2) * 10
            if p4_range_factor < 30 {p4_range_factor = 30}
            var p4_factor = (p4_avg - velo_offset) / 40
            if p4_factor <= 0.06 { p4_factor = 0.06 }
            else if p4_factor >= 0.92 { p4_factor = 0.92 }
            
            game_report.velo_set_list.append(PitchVeloSet(pitch_type: current_pitcher.pitch4, max_velo: p4_max, min_velo: p4_min, avg_velo: p4_avg, velo_factor: p4_factor, range_factor: p4_range_factor))
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
        
        
        if game_report.p1_by_inn.last == 0 && game_report.p2_by_inn.last == 0 && game_report.p3_by_inn.last == 0 && game_report.p4_by_inn.last == 0 {
            game_report.p1_by_inn.removeLast()
            game_report.p2_by_inn.removeLast()
            game_report.p3_by_inn.removeLast()
            game_report.p4_by_inn.removeLast()
        }
        
//        print(game_report.p1_by_inn)
//        print(game_report.p2_by_inn)
//        print(game_report.p3_by_inn)
//        print(game_report.p4_by_inn)
        
        
        let temp_inn_pitches = [game_report.p1_by_inn, game_report.p2_by_inn, game_report.p3_by_inn, game_report.p4_by_inn]
        
        for index in 0..<temp_inn_pitches.count {
            if temp_inn_pitches[index].reduce(0, +) > 0 {
                game_report.pitches_by_inn.append(
                    PitchTypeDataset(name: arsenal[index], dataset: temp_inn_pitches[index])
                )
            }
        }
    }
    
    func save_game_func() {
        
        let date = game_report.start_date
        let opponent_name = game_report.opponent_name
        let location = game_report.game_location
        var game_data_list: [SavedEvent] = []
        for event in events {

            let saved_event = SavedEvent(event_num: event.event_number, pitcher_id: event.pitcher_id, pitch_result: event.pitch_result, pitch_type: event.pitch_type, result_detail: event.result_detail, balls: event.balls, strikes: event.strikes, outs: event.outs, inning: event.inning, battersfaced: event.atbats, pitch_x_location: event.pitch_x_location, pitch_y_location: event.pitch_y_location, batters_stance: event.batter_stance, velocity: event.velocity)
                
            game_data_list.append(saved_event)
        }
        //print(game_data_list)
        
        var saved_pitcher_list: [SavedPitcherInfo] = []
        var pitcher_id_list: [UUID] = []
        
        //print("Appearance List: ", scoreboard.pitchers_appearance_list)
        
        //print("Saving Pitcher IDs")
        //print("Adding Pitchers from Scoreboard List")
        for pitcher in scoreboard.pitchers_appearance_list {
            //print("Adding: ", pitcher.pitcher_id)
            pitcher_id_list.append(pitcher.pitcher_id)
        }
        //print("Adding Current Pitcher if not already added")
        if !pitcher_id_list.contains(current_pitcher.idcode) {
            //print("Adding: ", current_pitcher.idcode)
            pitcher_id_list.append(current_pitcher.idcode)
        }
        //print("Finished Storing Pitcher IDs")
        
        var first_name: String = ""
        var last_name: String = ""
        var pitch1: String = ""
        var pitch2: String = ""
        var pitch3: String = ""
        var pitch4: String = ""
        
        //print("Generating Saved Pitcher Info")
        //print("Pitcher ID List: ", pitcher_id_list)
        for pitcher_id in pitcher_id_list {
            for player in pitchers {
                if pitcher_id == player.id {
                    first_name = player.firstName
                    last_name = player.lastName
                    pitch1 = player.pitch1
                    pitch2 = player.pitch2
                    pitch3 = player.pitch3
                    pitch4 = player.pitch4
                    break
                }
            }
            
            saved_pitcher_list.append(SavedPitcherInfo(pitcher_id: pitcher_id, first_name: first_name, last_name: last_name, pitch1: pitch1, pitch2: pitch2, pitch3: pitch3, pitch4: pitch4))
            
            //print("Added: ", first_name, last_name, pitcher_id)
        }
        
        let new_saved_game = SavedGames(opponent_name: opponent_name, date: date, location: location, game_data: game_data_list, pitcher_info: saved_pitcher_list)
        
        context.insert(new_saved_game)
        
    }
    
    func new_game_func() {
        
        do {
            try context.delete(model: Event.self)
        } catch {
            print("Failed to delete all events.")
        }
        
        ptconfig.hidePitchOverlay = false
        
        scoreboard.pitchers_appearance_list.removeAll()
        
        scoreboard.balls = 0
        scoreboard.strikes = 0
        scoreboard.outs = 0
        scoreboard.pitches = 0
        scoreboard.atbats = 1
        scoreboard.inning = 1
        scoreboard.baserunners = 0
        event.batter_stance = ""
        event.event_number = 0
        
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
        
        game_report.game_location = ""
        game_report.opponent_name = ""
        
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
        
        game_report.start_date = Date()
        
        let previous_event = events[events.count - 1]
        
        if current_pitcher.idcode != previous_event.pitcher_id {
            let pitcher_appearance_list = scoreboard.pitchers_appearance_list
            for pitcher in pitchers {
                if pitcher.id == previous_event.pitcher_id {
                    print("Different pitcher was in game for previous event")
                    //Set current pitcher characteristics
                    current_pitcher.firstName = pitcher.firstName
                    current_pitcher.lastName = pitcher.lastName
                    current_pitcher.pitch1 = pitcher.pitch1
                    current_pitcher.pitch2 = pitcher.pitch2
                    current_pitcher.pitch3 = pitcher.pitch3
                    current_pitcher.pitch4 = pitcher.pitch4
                    current_pitcher.idcode = pitcher.id
                    
                    //Set scoreboard values for previous pitcher
                    for p_er in pitcher_appearance_list {
                        if p_er.pitcher_id == pitcher.id {
                            scoreboard.pitches = p_er.pitches
                            scoreboard.atbats = p_er.batters_faced
                        }
                    }
                    
                    showDifferentPreviousPitcher = true
                   
                    break

                }
            }
        }
        
        //print(previous_event.atbats)
        
        scoreboard.balls = previous_event.balls
        scoreboard.strikes = previous_event.strikes
        scoreboard.outs = previous_event.outs
        scoreboard.inning = previous_event.inning
        event.batter_stance = previous_event.batter_stance
        
        scoreboard.atbats = previous_event.atbats
//        if event.end_ab_rd.contains(previous_event.result_detail) {
//            scoreboard.atbats += 1
//        }
        event.event_number -= 1
        
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
        
        if previous_event.result_detail != "R" && previous_event.result_detail != "RE" && previous_event.pitch_result != "VA" && previous_event.pitch_result != "VZ" && scoreboard.pitches > 0 {
            scoreboard.pitches -= 1
        }
        else if previous_event.result_detail == "R" || previous_event.result_detail == "RE" {
            scoreboard.baserunners += 1
        }
        
        if previous_event.pitch_result == "H" || previous_event.result_detail == "W" || previous_event.result_detail == "C" {
            if scoreboard.baserunners > 0 {
                scoreboard.baserunners -= 1
            }
            if previous_event.pitch_result == "IW" {
                scoreboard.pitches += 1
            }
        }
        //print(scoreboard.baserunners)
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
        }
    }
    
    func change_cur_ab_stance() {
        if events.count >= 2 {
            let cur_event = events[events.count - 1]
            var prev_ab_index = events.count - 2
            let prev_event = events[prev_ab_index]
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
    
    func load_pitcher_appearance_list() {
        //load pitcher appearance list
        
        var pitcher_id_list: [UUID] = []
        
        for evnt in events {
            if !pitcher_id_list.contains(evnt.pitcher_id) {
                pitcher_id_list.append(evnt.pitcher_id)
                //print(evnt.pitcher_id)
            }
        }
        
        //print(pitcher_id_list)
        
        for pitcher in pitcher_id_list {
            //print(pitcher)
            var p_at_bats = 0
            var p_pitch_num = 0
            
            for vent in events {
                //print(vent.pitcher_id)
                if vent.pitcher_id == pitcher {
                    if vent.result_detail != "R" && vent.result_detail != "RE" && vent.pitch_result != "VZ" && vent.pitch_result != "VA" && vent.pitch_result != "IW"{
                        p_pitch_num += 1
                    }
                    if event.end_ab_rd.contains(vent.result_detail) || (p_pitch_num == 1 && p_at_bats == 0){
                        p_at_bats += 1
                        //print("Batters Faced: \(p_at_bats)")
                    }
                }
            }
            
            scoreboard.pitchers_appearance_list.append(PitchersAppeared(pitcher_id: pitcher, pitches: p_pitch_num, batters_faced: p_at_bats))
            
        }
        
        //print(scoreboard.pitchers_appearance_list)
        
    }
    
    func load_recent_event() {
        let recent_event = events[events.count - 1]
        let end_ab_br = ["S", "D", "T", "H", "E", "B", "C", "W"]
        let end_ab_out = ["F", "G", "L", "P", "Y", "K", "M", "R", "RE"]
        
        game_report.opponent_name = ASCurOpponentName ?? ""
        game_report.game_location = ASGameLocation ?? ""
        
        scoreboard.balls = recent_event.balls
        scoreboard.strikes = recent_event.strikes
        scoreboard.outs = recent_event.outs
        scoreboard.atbats = 0
        scoreboard.inning = recent_event.inning
        event.batter_stance = recent_event.batter_stance
        event.event_number = recent_event.event_number + 1
        //print("Event number: \(event.event_number)")
        
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
        else if recent_event.pitch_result == "A" || recent_event.pitch_result == "VA"{
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

        var inning_index = 1
        
        for evnt in events{
            
            if evnt.result_detail != "R" && evnt.result_detail != "RE" && evnt.pitch_result != "IW" && evnt.pitch_result != "VA" && evnt.pitch_result != "VZ"{
                if current_pitcher.idcode == evnt.pitcher_id{
                    scoreboard.pitches += 1
                    if (evnt.balls == 0 && evnt.strikes == 0) || scoreboard.pitches == 1{
                        scoreboard.atbats += 1
                        //print("Batters Faced: \(scoreboard.atbats)")
                    }
                }
            }
            else if evnt.pitch_result == "VA" || evnt.pitch_result == "VZ" {
                if (evnt.balls == 0 && evnt.strikes == 0) || scoreboard.pitches == 0{
                    scoreboard.atbats += 1
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
            if evnt.inning > inning_index {
                inning_index += 1
                scoreboard.baserunners = 0
            }
            //print(scoreboard.baserunners)
        }
        
        if inning_index < scoreboard.inning {
            scoreboard.baserunners = 0
        }
        
        let recent_pitcher_id = recent_event.pitcher_id
        for pitcher_ids in scoreboard.pitchers_appearance_list {
            if pitcher_ids.pitcher_id == recent_pitcher_id {
                scoreboard.pitches = pitcher_ids.pitches
                scoreboard.atbats = pitcher_ids.batters_faced
                break
            }
        }
        //print(scoreboard.pitchers_appearance_list)
        
        
    }
    
    func load_recent_ab_pitches() {
        var cur_ab_index = events.count - 1
        let cur_event = events[events.count - 1] //Previous event (t)
        
        if !event.end_ab_rd.contains(cur_event.result_detail){
            while !event.end_ab_rd.contains(events[cur_ab_index].result_detail){
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
            
        }
    }
    
    func load_game_location() {
        let prev_location = ASGameLocation ?? "Home"
        game_report.game_location = prev_location
    }
        
    func add_prev_event_string() {
        if event.recordEvent{
            let new_event = Event(pitcher_id: current_pitcher.idcode, pitch_result: event.pitch_result, pitch_type: event.pitch_type, result_detail: event.result_detail, balls: event.balls, strikes: event.strikes, outs: event.outs, inning: event.inning, atbats: event.atbats, pitch_x_location: event.x_cor, pitch_y_location: event.y_cor, batter_stance: event.batter_stance, velocity: event.velocity, event_number: event.event_number)
            
            context.insert(new_event)
            
            event.event_number += 1
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
            event.result_detail = "RE"
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

struct PitchClockViolation: View {
    
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(currentPitcher.self) var current_pitcher
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    @Environment(Event_String.self) var event
    @Environment(Scoreboard.self) var scoreboard
    @Environment(\.modelContext) var context
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    @State var ver_padding: Double = 35.0
    
    var body: some View {
        VStack{

            VStack{
                    
                    Spacer()
                    
                    HStack{
                        
                        Button {
                            withAnimation{
                                ptconfig.non_pitch_event = false
                            }
                        } label: {
                                
                            HStack(spacing: 1){
                                Image(systemName: "baseball.fill")
                                    .imageScale(.medium)
                                    .font(.system(size: 17))
                                    .frame(width: sbl_width, height: sbl_height)
                                    .foregroundColor(Color.white)
                                
                                Text("PITCHES")
                                    .font(.system(size: 15))
                                    .fontWeight(.black)
                                    .padding(.vertical, 8.0)
                                    .padding(.horizontal, 5.0)
                            }
                            .padding(.leading, 7)
                            
                        }
                        .foregroundColor(Color.white)
                        .background(Color("ScoreboardGreen"))
                        .cornerRadius(8.0)
                        .padding(.leading, 15)
                        
                        Spacer()
                        
                    }
                    
                    VStack{
                        
                        Button{
                            withAnimation{
                                ptconfig.non_pitch_event = false
                                ptconfig.npe_EOAB = true
                                add_Intentional_Walk()
                                add_non_pitch_event()
                                //newAtBat = true
                            }
                            
                        } label: {
                            Text("INTENTIONAL WALK")
                                .fontWeight(.bold)
                                .font(.system(size: 17))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, ver_padding / 2)
                        }
                        .foregroundColor(Color.white)
                        .background(Color("ScoreboardGreen"))
                        .cornerRadius(8.0)
                        .padding(.horizontal, 20)
                        
                        Button{
                            withAnimation{
                                //Write Violation to Event
                                //Add logic to pbp log
                                ptconfig.non_pitch_event = false
                                add_PCV_Ball()
                                add_non_pitch_event()
                            }
                        } label: {
                            Text("VIOLATION - BALL")
                                .fontWeight(.bold)
                                .font(.system(size: 17))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, ver_padding / 2)
                        }
                        .foregroundColor(Color.white)
                        .background(Color.red)
                        .cornerRadius(8.0)
                        .padding(.horizontal, 20)
                        
                        Button{
                            withAnimation{
                                //Write Violation to Event
                                //Add logic to pbp log
                                ptconfig.non_pitch_event = false
                                add_PCV_Strike()
                                add_non_pitch_event()
                            }
                        } label: {
                            Text("VIOLATION - STRIKE")
                                .fontWeight(.bold)
                                .font(.system(size: 17))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, ver_padding / 2)
                        }
                        .foregroundColor(Color.white)
                        .background(Color.red)
                        .cornerRadius(8.0)
                        .padding(.horizontal, 20)
                        
                    }
                    .padding(.vertical, 25.0)
                    .padding(.horizontal, 20.0)
                    .background(Color.black.opacity(0.5))
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                }
                .transition(.move(edge: .bottom))
                .ignoresSafeArea()
            
        }
    }
    
    func add_non_pitch_event() {
        
        let npe = Event(pitcher_id: current_pitcher.idcode, pitch_result: event.pitch_result, pitch_type: "NP", result_detail: event.result_detail, balls: event.balls, strikes: event.strikes, outs: event.outs, inning: event.inning, atbats: event.atbats, pitch_x_location: 0, pitch_y_location: 0, batter_stance: event.batter_stance, velocity: 0, event_number: event.event_number)
        
        context.insert(npe)
        
        event.event_number += 1
        print_Event_String()
    }

    func print_Event_String() {
        print(current_pitcher.idcode, event.pitch_result, event.pitch_type, event.result_detail, event.balls, event.strikes, event.outs, event.inning, event.atbats, event.batter_stance, event.velocity, 0, 0)
    }
    
    func add_Intentional_Walk() {
        
        event.pitch_result = "IW"
        event.result_detail = "W"
        event.pitch_type = "NP"
        event.balls = scoreboard.balls
        event.strikes = scoreboard.strikes
        event.outs = scoreboard.outs
        event.inning = scoreboard.inning
        event.atbats = scoreboard.atbats
        
        if scoreboard.baserunners < 3 {
            scoreboard.baserunners += 1
        }
        if scoreboard.balls > 0 || scoreboard.strikes > 0 {
            scoreboard.atbats += 1
        }
        
        reset_Count()
        
    }
    
    func add_PCV_Strike() {
        event.pitch_result = "VZ"
        event.result_detail = "N"
        event.pitch_type = "NP"
        event.balls = scoreboard.balls
        event.strikes = scoreboard.strikes
        event.outs = scoreboard.outs
        event.inning = scoreboard.inning
        event.atbats = scoreboard.atbats
        
        
        if scoreboard.update_scoreboard {
            scoreboard.strikes += 1
            
            if scoreboard.strikes == 3 {
                event.result_detail = "K"
                scoreboard.outs += 1
                scoreboard.atbats += 1
                reset_Count()
                
                if scoreboard.outs >= 3{
                    scoreboard.outs = 0
                    scoreboard.inning += 1
                    scoreboard.baserunners = 0
                    scoreboard.o1light = false
                    scoreboard.o2light = false
                }
                if scoreboard.outs == 1 {
                    scoreboard.o1light = true
                }
                if scoreboard.outs == 2 {
                    scoreboard.o2light = true
                }
            }
            
            if scoreboard.strikes == 1 {
                scoreboard.s1light = true
            }
            if scoreboard.strikes == 2 {
                scoreboard.s2light = true
            }
        }
        
    }
    
    func add_PCV_Ball() {
        
        event.pitch_result = "VA"
        event.result_detail = "N"
        event.pitch_type = "NP"
        event.balls = scoreboard.balls
        event.strikes = scoreboard.strikes
        event.outs = scoreboard.outs
        event.inning = scoreboard.inning
        event.atbats = scoreboard.atbats
        
        if scoreboard.update_scoreboard {
            scoreboard.balls += 1
            if scoreboard.balls == 1 {
                scoreboard.b1light = true
            }
            if scoreboard.balls == 2 {
                scoreboard.b2light = true
            }
            if scoreboard.balls == 3 {
                scoreboard.b3light = true
            }
            
            if scoreboard.balls == 4 {
                event.result_detail = "W"
                scoreboard.balls = 0
                scoreboard.atbats += 1
                scoreboard.baserunners += 1
                if scoreboard.baserunners > 3 {
                    scoreboard.baserunners = 3
                }
                reset_Count()
            }
        }
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
    
    @State private var newAtBat: Bool = false
    
    @State var location: CGPoint = .zero
    @State var cur_pitch_color = Color.clear
    @State var cur_pitch_outline = Color.clear
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    @State var ver_padding: Double = 35.0
    @State private var showSettingsView = false
    
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
        ZStack{
            
            if !ptconfig.hidePitchOverlay{
                
                ZStack{
                    
                    PitchOverlayPrevPitches()
                        .transition(.opacity)
                    
                    Rectangle()
                        .fill(Color.black.opacity(0.01))
                }
                
                if !ptconfig.non_pitch_event {
                    VStack{
                        
                        Spacer()
                        
                        HStack(alignment: .bottom, spacing: 5){
                            
                            Button(action: {
                                showSettingsView = true
                            }) {
                                HStack{
                                    Image(systemName: "gearshape.fill")
                                        .imageScale(.large)
                                        .font(.system(size: 17))
                                        .frame(width: sbl_width, height: sbl_height)
                                        .foregroundColor(Color.white)
                                        .padding(10.5)
                                }
                                .background(Color("ScoreboardGreen"))
                                .cornerRadius(8.0)
                            }
                            .popover(isPresented: $showSettingsView) {
                                SettingsView()
                                    .preferredColorScheme(.dark)
                            }
                            
                            Button {
                                withAnimation{
                                    ptconfig.non_pitch_event = true
                                }
                            } label: {
                                    
                                HStack{
                                    Text("NON-PITCH")
                                        .font(.system(size: 15))
                                        .fontWeight(.black)
                                        .padding(.vertical, 8.0)
                                        .padding(.horizontal, 5.0)
                                }
                                
                                
                            }
                            .foregroundColor(Color.white)
                            .background(Color("ScoreboardGreen"))
                            .cornerRadius(8.0)
                            
                            Spacer()

                        }
                        .padding(.leading, 10)
                        
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
                        .background(Color.black.opacity(0.5))
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                    }
                    .transition(.move(edge: .bottom))
                    .ignoresSafeArea()
                }
                else {
                    PitchClockViolation()
                        .onDisappear{
                            if event.pitch_result == "IW" || (event.pitch_result == "VA" && event.result_detail == "W") || (event.pitch_result == "VZ" && event.result_detail == "K") {
                                newAtBat = true
                                ptconfig.npe_EOAB = true
                            }
                        }
                        .transition(.move(edge: .bottom))
                        .ignoresSafeArea()
                }
            }
            
            if newAtBat == true{
                BatterPositionView(isActive: $newAtBat, close_action: {DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {newAtBat = false; ptconfig.npe_EOAB = false}})
            }
            
            //Batter Position PopUp Here
            
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
        

//#Preview {
//    PitchLocationView()
//        .environment(Scoreboard())
//        .environment(Event_String())
//        .environment(PitchTypeConfig())
//}
