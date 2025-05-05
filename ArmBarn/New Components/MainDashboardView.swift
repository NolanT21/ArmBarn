//
//  ContentView.swift
//  Sandbox
//
//  Created by Nolan Thompson on 1/28/25.
//

import SwiftUI
import SwiftData
import Foundation

enum ShakeAnimation: CaseIterable {
    case leanLeft, leanRight, returnCenter
    
    var rotationDegrees: CGFloat {
        switch self {
        case .leanLeft: -0.3
        case .leanRight: 0.3
        case .returnCenter: 0
        }
    }
    
    var xoffset: CGFloat {
        switch self {
        case .leanLeft: -1.5
        case .leanRight: 1.5
        case .returnCenter: 0
        }
    }
}

enum DefaultAnimationStages: CaseIterable {
    case start, middle, end
}


struct MainDashboardView: View {
    
    @State private var input_nav_path = [Int]()
    
    @State var show_undo_toast: Bool = false
    @State var show_save_toast: Bool = false
    @State var saving_animation: Bool = false
    @State var isRotating = 0.0
    @State var game_info_animation = 1.0
    @State var highlight_game_info: Bool = false
    
    @State var is_locked: Bool = false
    @State var righty_hitter: Bool = false
    @State var lefty_hitter: Bool = false
    
    @Environment(GameReport.self) var game_report
    @Environment(currentPitcher.self) var current_pitcher
    @Environment(Event_String.self) var event
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(LocationOverlay.self) var location_overlay
    
    @Query(sort: \Event.event_number) var events: [Event]
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State var main_body_padding: CGFloat = 10
    @State var light_width : CGFloat = 1.5
    
    @State var location: CGPoint = .zero
    @State var cur_pitch_fill: Color = .clear
    @State var cur_pitch_outline: Color = .clear
    @State var cur_pitch_pulse: Bool = false
    
    @State var red_light_color: Color = .red
    @State var green_light_color: Color = Color("ScoreboardGreen")
    
    @State var button_gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color("ScoreboardGreen"), Color("DarkScoreboardGreen")]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    @State var alt_button_gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color.orange, Color("DarkOrange")]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    @State var disabled_gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color.gray.opacity(0.5)]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    @State var showGameInfo: Bool = false
    @State var showResumeGame: Bool = false
    @State var showDifferentPreviousPitcher: Bool = false
    @State var showAddGameInfo: Bool = false
    @State var showEndGame: Bool = false
    
    @State private var show_velo_input: Bool = false
    @FocusState private var fieldIsFocused: Bool
    @State var veloinput: Double = 0.0
    @State var validVeloInput: Bool = false
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var tap: some Gesture {
        SpatialTapGesture()
            .onEnded { click in
                if location_overlay.showinputoverlay{
                    ptconfig.cur_x_location = click.location.x
                    ptconfig.cur_y_location = click.location.y
                    location = click.location
                    cur_pitch_fill = ptconfig.ptcolor
                    cur_pitch_outline = .white
                    
                    location_overlay.zero_location = false
                    
                }
             }
    }
    
    var body: some View {
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        
        ZStack{
            
            VStack(spacing: 10){
                
                //"Scoreboard"
                ZStack{
                    VStack(spacing: 10){
                        
                        //Top Row
                        HStack{
                            
                            HStack{
                                Text("BALLS")
                                    .font(.system(size: 15))
                                    .bold()
                                HStack(spacing: 5){
                                    Circle()
                                        .stroke(scoreboard.b1light ? green_light_color : Color.white, lineWidth: light_width)
                                        .fill(scoreboard.b1light ? green_light_color : Color.clear)
                                        .frame(width: 15, height: 15)
                                    Circle()
                                        .stroke(scoreboard.b2light ? green_light_color : Color.white, lineWidth: light_width)
                                        .fill(scoreboard.b2light ? green_light_color : Color.clear)
                                        .frame(width: 15, height: 15)
                                    Circle()
                                        .stroke(scoreboard.b3light ? green_light_color : Color.white, lineWidth: light_width)
                                        .fill(scoreboard.b3light ? green_light_color : Color.clear)
                                        .frame(width: 15, height: 15)
                                }
                            }
                            
                            Spacer()
                            
                            HStack{
                                Text("STRIKES")
                                    .font(.system(size: 15))
                                    .bold()
                                HStack(spacing: 5){
                                    Circle()
                                        .stroke(scoreboard.s1light ? red_light_color : Color.white, lineWidth: light_width)
                                        .fill(scoreboard.s1light ? red_light_color : Color.clear)
                                        .frame(width: 15, height: 15)
                                    Circle()
                                        .stroke(scoreboard.s2light ? red_light_color : Color.white, lineWidth: light_width)
                                        .fill(scoreboard.s2light ? red_light_color : Color.clear)
                                        .frame(width: 15, height: 15)
                                }
                            }
                            
                            Spacer()
                            
                            HStack{
                                Text("OUTS")
                                    .font(.system(size: 15))
                                    .bold()
                                HStack(spacing: 5){
                                    Circle()
                                        .stroke(scoreboard.o1light ? red_light_color : Color.white, lineWidth: light_width)
                                        .fill(scoreboard.o1light ? red_light_color : Color.clear)
                                        .frame(width: 15, height: 15)
                                    Circle()
                                        .stroke(scoreboard.o2light ? red_light_color : Color.white, lineWidth: light_width)
                                        .fill(scoreboard.o2light ? red_light_color : Color.clear)
                                        .fill(.clear)
                                        .frame(width: 15, height: 15)
                                }
                            }
                            
                        }
                        .padding(.horizontal, 15)
                        .frame(maxWidth: 400)
                        
                        //Bottom Row
                        HStack{
                            
                            HStack{
                                VStack(alignment: .center, spacing: 2){
                                    Text("INN")
                                    Text("\(scoreboard.inning)")
                                }
                                .font(.system(size: 15))
                                .bold()
                                
                                Divider()
                                    .frame(height: 35)
                                
                                VStack(alignment: .leading, spacing: 2){
                                    let pitcher_name = current_pitcher.firstName + " " + current_pitcher.lastName
                                    Text(pitcher_name.prefix(25))
                                        .font(.system(size: 17))
                                        .bold()
                                    HStack{
                                        Text("Pitches: \(scoreboard.pitches)")
                                        Text("Batters Faced: \(scoreboard.atbats)")
                                    }
                                    .font(.system(size: 11))
                                    .foregroundStyle(.gray)
                                }
                                
                                
                            }
                            .padding(.leading, 20)
                            
                            Spacer()
                            
                            HStack(alignment: .bottom, spacing: 10){
                                Button{
                                    
                                    withAnimation{
                                        showEndGame = true
                                        location_overlay.showTabBar = false
                                    }
                                    
                                } label: {
                                    Image(systemName: "flag.pattern.checkered")
                                        .font(.system(size: 18))
                                        .frame(width: 30, height: 30)
                                    
                                }
                                .background(events.count <= 0 ? disabled_gradient : button_gradient)
                                .foregroundColor(events.count <= 0 ? Color.gray : Color.white)
                                .cornerRadius(8.0)
                                .shadow(color: .black.opacity(0.5), radius: 3, x: 3, y: 3)
                                .disabled(events.count <= 0)
                                
                                Button{
                                    withAnimation{
                                        show_undo_toast = true
                                        //impact.impactOccurred()
                                        
                                        //More than one event entered
                                        if events.count > 1 {
                                            load_previous_event()
                                            load_previous_ab_pitches()
                                            context.delete(events[events.count - 1])
                                            //Keep batter stance input locked on undo; not the reason user is removing event, able to change anytime
                                            is_locked = true
                                            
                                        }
                                        //Only one event entered
                                        else if events.count == 1 {
                                            if scoreboard.pitches > 0 && event.result_detail != "R" && event.result_detail != "RE" && event.pitch_result != "IW" && event.pitch_result != "VZ" && event.pitch_result != "VA"{ //Non pitch event (pitch not thrown)
                                                scoreboard.pitches -= 1
                                            }
                                            
                                            //Store variables temporarily before calling new_game_func(); function wipes out all in-game variables
                                            //Store current pitcher id
                                            let current_pitcher_id = current_pitcher.idcode
                                            
                                            //Store game information and batter stance
                                            let opponent = game_report.opponent_name
                                            let location = game_report.game_location
                                            let date = game_report.start_date

                                            let batter_stance = event.batter_stance
                                            
                                            //Reset game variables
                                            new_game_func()
                                            
                                            //Call functions to reselect current pitcher and re-enter game_information
                                            reselect_current_pitcher(pitcher_id: current_pitcher_id)
                                            
                                            set_game_information(opponent: opponent, location: location, date: date, batter_stance: batter_stance)
                                            
                                            //Keep batter stance input locked on undo; not the reason user is removing event, able to change anytime
                                            is_locked = true
                                            
                                        }
                                    }
                                } label: {
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.system(size: 18))
                                        .frame(width: 30, height: 30)
                                        .bold()
                                    
                                }
                                .background(events.count < 1 ? disabled_gradient : button_gradient)
                                .foregroundColor(events.count < 1 ? Color.gray : Color.white)
                                .cornerRadius(8.0)
                                .shadow(color: .black.opacity(0.5), radius: 3, x: 3, y: 3)
                                .disabled(events.count < 1)
                                .onChange(of: show_undo_toast) {
                                    if show_undo_toast == true {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            withAnimation{
                                                show_undo_toast.toggle()
                                            }
                                        }
                                    }
                                }
                                
                            }
                            .padding(.trailing, 15)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 90)
                    .background(.regularMaterial)
                    .cornerRadius(15)
                    .padding(.horizontal, main_body_padding)
                    
                    Rectangle()
                        .fill(location_overlay.showinputoverlay ? Color.black.opacity(0.8): Color.clear)
                        .frame(maxWidth: .infinity, maxHeight: 90)
                    
                }
                
                ZStack{
                    VStack{

                        GeometryReader{ geometry in
                            
                            Image("Background2.0")
                                .resizable()
                                .frame(maxHeight: 480, alignment: .center)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                                .padding(.horizontal, main_body_padding)
                                .gesture(tap)
                                //.clipped()
                                .overlay{
                                    
                                    //Hide overlay when inputting new pitch
                                    if !location_overlay.showinputoverlay{
                                        ABPitchOverlay()
                                    }
                                    
                                    if location_overlay.showinputoverlay{
                                        
                                        if location_overlay.zero_location == false{
                                            Circle()
                                                .stroke(cur_pitch_outline, lineWidth: 4)
                                                .fill(cur_pitch_fill)
                                                .frame(width: geometry.size.width * 0.055, height: geometry.size.width * 0.055, alignment: .center)
                                                .position(location)
                                                .onAppear{
                                                    if cur_pitch_fill != Color.clear{
                                                        cur_pitch_fill = ptconfig.ptcolor
                                                    }
                                                }
                                        }
                                    }
                                    
                                }
                                .phaseAnimator([ShakeAnimation.returnCenter, ShakeAnimation.leanLeft, ShakeAnimation.leanRight, ShakeAnimation.leanLeft, ShakeAnimation.returnCenter], trigger: location_overlay.shakecounter) { content, phase in
                                    
                                    content
                                        .offset(x: phase.xoffset)
                                        .rotationEffect(.degrees(phase.rotationDegrees))
                                    
                                    
                                } animation: { phase in
                                    switch phase {
                                    case .returnCenter: .easeIn(duration: 0.05)
                                    case .leanLeft: .easeIn(duration: 0.05)
                                    case .leanRight: .easeIn(duration: 0.05)
                                    }
                                }
                        }
                        
                    }
                    
                    SaveToast()
                    
                    //Undo Toast
                    VStack{
                        if show_undo_toast == true{
                        
                            HStack{
                                ZStack{
                                    
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(Color.black.opacity(0.4))
                                        .frame(width: 185, height: 32)
                                    
                                    Text("Previous Event Removed")
                                        .font(.system(size: 13) .weight(.medium))
                                        //.bold()

                                }
                            }
                            .background(.regularMaterial)
                            .clipShape(Capsule())
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .padding(.top, 10)
                            
                        }
                        
                        Spacer()
                        
                    }
                                        
                }
                .frame(maxHeight: 480)
                
                VStack(spacing: 5){
                    
                    NavigationStack(path: $input_nav_path){
                        VStack(spacing: 10){
                            
                            HStack{
                                
                                if current_pitcher.firstName == "No Pitcher Selected"{
                                    Button{

                                    } label: {
                                        HStack(spacing: 5){
                                            Text("Select Pitcher")
                                                .font(.system(size: 17, weight: .medium))
                                                .padding(.leading, 10)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 17, weight: .medium))
                                                .padding(.trailing, 10)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: 50)
                                        .foregroundStyle(Color.white)
                                        .background(Color.red)
                                        .bold()
                                        .cornerRadius(15)
                                    }
                                }
                                else {
                                    Button{
                                        withAnimation{
                                            location_overlay.showTabBar = false
                                        }
                                        input_nav_path.append(1)
                                    } label: {
                                        HStack(spacing: 5){
                                            Text("Enter Pitch")
                                                .font(.system(size: 17, weight: .medium))
                                                .padding(.leading, 10)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 17, weight: .medium))
                                                .padding(.trailing, 10)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: 50)
                                        .foregroundStyle(current_pitcher.firstName == "No Pitcher Selected" || event.batter_stance == "" ? Color.gray : Color.white)
                                        .background(current_pitcher.firstName == "No Pitcher Selected" || event.batter_stance == "" ? disabled_gradient : button_gradient)
                                        .bold()
                                        .cornerRadius(15)
                                    }
                                    .disabled(current_pitcher.firstName == "No Pitcher Selected" || event.batter_stance == "")
                                }
                                
                                Button {
                                    withAnimation{
                                        showGameInfo = true
                                        location_overlay.showTabBar = false
                                    }
                                } label: {
                                    ZStack{
                                        //Fix glowing rectangle size and functionality
                                        if location_overlay.game_info_entered == false {
//                                            Rectangle()
//                                                .fill(alt_button_gradient)
//                                                .frame(maxWidth: 135, maxHeight: 55)
//                                                .phaseAnimator([0, 1, 3]) { view, phase in
//                                                        view
//                                                    
//                                                        .blur(radius: phase == 1 ? 2 : 8)
//                                                    
//                                                    }
//                                                .cornerRadius(15)
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(AngularGradient(colors: [.orange, Color("DarkOrange"), Color("LightBeam"), .orange, Color("DarkOrange"), Color("LightBeam")], center: .center, angle: .degrees(highlight_game_info ? 360 : 0)))
                                                .frame(width: 130, height: 54)
                                                .blur(radius: 1)
                                                .onAppear{
                                                    withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)){
                                                        highlight_game_info = true
                                                    }
                                                }

                                        }
                                        
                                        HStack(alignment: .center, spacing: 5){
                                            
                                            //Spacer()
                                            
                                            Image(systemName: "square.and.pencil")
                                                .font(.system(size: 19, weight: .semibold))
                                            //.padding(.leading, 10)
                                                .padding(.bottom, 3)
                                                .foregroundStyle(.white)
                                            
                                            if location_overlay.game_info_entered == false {
                                                Text("Game Info")
                                                    .font(.system(size: 17, weight: .medium))
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                        .frame(maxWidth: location_overlay.game_info_entered ? 50 : 125, maxHeight: 50, alignment: .center)
                                        .background(alt_button_gradient)
                                        .cornerRadius(15)
                                        .foregroundStyle(.white)
                                        
                                    }
                                    
    
                                }

                            }
                            
                            //Batter Stance Input View
                            BatterStanceInput()
                            
                        }
                        .font(.system(size: 17) .weight(.semibold))
                        .navigationDestination(for: Int.self) { selection in
                            //PitchTypeSelectView(path: $input_nav_path)
                            PitchTypeSelectView(path: $input_nav_path)
                                .navigationBarBackButtonHidden(true).preferredColorScheme(.dark)
                        }
                        .onAppear{
                            //print("Entered MainDashboardView.onAppear")
                            add_prev_event_string()
                            event.recordEvent = true
                            
                            //Keep startup location from appearing before input
                            cur_pitch_fill = .clear
                            cur_pitch_outline = .clear
                            location = CGPoint(x: 0, y: 0)
                        }
                        
                        Spacer()
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: 180)
                    .padding(.horizontal, main_body_padding)
                    //.padding(.top, 10)
                    
                }
                
                Spacer()
                
            }
            .background(Color.black)
            .ignoresSafeArea(.keyboard)
            
            
            //Call PopUp Views
            if location_overlay.showVeloInput == true{
                veloPopupView()
                    .transition(.opacity)
                    .onAppear {
                        fieldIsFocused = true
                    }
            }
            
            if showAddGameInfo == true {
                ZeroInputXPopUp(title: "Attention", description: "The game information has not been recorded. Please enter this before saving the current game", close_action: {withAnimation{showAddGameInfo = false}; location_overlay.showTabBar = true})
                    .transition(.opacity)
            }
            
            if showDifferentPreviousPitcher == true {
                ZeroInputXPopUp(title: "Attention", description: "A different pitcher was recorded for the previous event, they have been set to the current pitcher", close_action: {withAnimation{showDifferentPreviousPitcher = false; location_overlay.showTabBar = true}})
                    .transition(.opacity)
            }
            
            //Checking if there is data from previous game; event count and scoreboard is empty
            if showResumeGame == true{
                TwoInputXPopUp(title: "Resume Game", description: "Looks like a previous game was being scored. Would you like to resume?", leftButtonText: "Yes",  leftButtonAction: {set_pitcher(); load_pitcher_appearance_list(); load_recent_event(); load_recent_ab_pitches();}, rightButtonText: "No", rightButtonAction: {new_game_func()}, close_action: {withAnimation{showResumeGame = false}}, flex_action: {new_game_func()})
                    .transition(.opacity)
            }
            
            if showEndGame == true {
                TwoInputXPopUp(title: "Save Game", description: "Would you like to save this game before starting a new one?", leftButtonText: "Yes",  leftButtonAction: {save_logic_handling_func()}, rightButtonText: "No", rightButtonAction: {new_game_func(); withAnimation{location_overlay.showTabBar = true}}, close_action: {withAnimation{showEndGame = false}}, flex_action: {withAnimation{location_overlay.showTabBar = true}})
                    .transition(.opacity)
            }
            
            if showGameInfo == true {
                GameInfoPopUp(close_action: { withAnimation{showGameInfo = false; location_overlay.showTabBar = true; highlight_game_info = false} })
                    .transition(.opacity)
            }
            

        }
        .ignoresSafeArea(.keyboard)
        .onAppear{
            if events.count >= 1 && (scoreboard.balls == 0 && scoreboard.strikes == 0 && scoreboard.pitches == 0 && scoreboard.atbats == 1 && current_pitcher.firstName == "No Pitcher Selected") {
                    showResumeGame = true
            }
        }
            
    }
    
    @ViewBuilder
    func veloPopupView() -> some View{
        ZStack{
            Color.black.opacity(0.5)
            
            VStack{
                
                Spacer()
                    .frame(height: 150)
                    
                    VStack(){
                        
                        Spacer()
                            .frame(maxHeight: 10)
                        
                        VStack(spacing: 20){
                            Text("Enter Pitch Velocity")
                                .font(.system(size: 17, weight: .semibold))
                                                        
                            TextField("mph", value: $veloinput, formatter: formatter)
                                .padding(.vertical, 5)
                                .padding(.trailing, 10)
                                .focused($fieldIsFocused)
                                .submitLabel(.done)
                                .onSubmit {
                                    //event.velocity = veloinput
                                    //close()
                                    //close_action()
                                }
                                .font(.system(size: 17, weight: .medium))
                                .background(Color.gray.opacity(0.2))
                                .background(.regularMaterial)
                                .cornerRadius(8)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .overlay{
                                    HStack{
                                        
                                        Image(systemName: "gauge.with.needle")
                                            .bold()
                                            .padding(5)
                                        
                                        Spacer()
                                    }
                                    
                                }
                                .padding(.horizontal, 30)
                                
                            
                            Button {
                                withAnimation{
                                    
                                    location_overlay.showVeloInput = false
                                    
                                }
                                fieldIsFocused = false
                                event.velocity = veloinput
                                veloinput = 0
                            } label: {
                                Text("Enter")
                                    .font(.system(size: 17, weight: .bold))
                                    .frame(width: 125, height: 40)
                                    .background(!validVeloInput || (veloinput > 115 || veloinput < 30) ? disabled_gradient : button_gradient)
                                    .foregroundColor(!validVeloInput || (veloinput > 115 || veloinput < 30) ? Color.gray.opacity(0.5) : Color.white)
                                    .cornerRadius(8.0)
                            }
                            .disabled(!validVeloInput || (veloinput > 115 || veloinput < 30))
                            .onChange(of: veloinput){ _, _ in
                                validate_velocity_input()
                            }
                        }
                        
                        Spacer()
                            .frame(maxHeight: 10)
                    
                }
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .padding()
                .background(Color.black.opacity(0.2))
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 20)
                .padding(45)
                
                Spacer()
                
            }
        }
    }
    
    //Function for validating velocity input
    func validate_velocity_input() {
        let validate = NSPredicate(format: "SELF MATCHES %@", "^[+]?([0-9]+(?:[\\.][0-9]*)?|\\.[0-9]+)$")
        validVeloInput = validate.evaluate(with: String(veloinput))
    }
    
    @ViewBuilder
    func ABPitchOverlay() -> some View {
        
        GeometryReader{ geometry in
            ForEach(ptconfig.pitch_x_loc.indices, id: \.self){ index in
                let xloc = ptconfig.pitch_x_loc[index]
                let yloc = ptconfig.pitch_y_loc[index]
                let point = CGPoint(x: xloc, y: yloc)
                let pitch_color = ptconfig.ab_pitch_color[index]
                
                if index == ptconfig.pitch_x_loc.count - 1 && location_overlay.showCurPitchPulse {
                    Circle()
                        .fill(.clear)
                        .stroke(.white.opacity(0.5), lineWidth: 10)
                        .frame(width: geometry.size.width * 0.062, height: geometry.size.width * 0.062, alignment: .center)
                        .position(point)
                        .phaseAnimator(DefaultAnimationStages.allCases) { content, phase in
                                    content
                                        .blur(radius: phase == .start ? 2 : 8)
                                        //.scaleEffect(phase == .middle ? 3 : 1)
                                } animation: { phase in
                                    switch phase {
                                    case .start, .end, .middle: .easeInOut(duration: 0.62)
                                    }
                                }
                }
                
                Circle()
                    .fill(pitch_color)
                    .stroke(.white, lineWidth: 2)
                    .frame(width: geometry.size.width * 0.055, height: geometry.size.width * 0.055, alignment: .center)
                    .position(point)
                    .overlay {
                        Text("\(index + 1)")
                            .foregroundColor(.white)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(.system(size: 13))
                            .position(point)
                    }
            }
        }
        
    }
    
    @ViewBuilder
    func BatterStanceInput() -> some View {
        VStack(spacing: 7){
            
            HStack{
                Text("Batter Stance")
                    .font(.system(size: 13, weight: .medium))
                    .padding(.top, 3)
                    .padding(.leading, 3)
                
                Spacer()
                
            }
            
            HStack{
                
//                Spacer()
                
                Button{
                    is_locked = true
                    righty_hitter = true
                    lefty_hitter = false
                    event.batter_stance = "R"
                    update_ab_stance(using: context)
                } label: {
                    ZStack{
                        
                        HStack{
                            Image(systemName: "arrowtriangle.left.fill")
                                .scaleEffect(x: 0.6)
                            
                            Spacer()
                            
                            Text("Right")
                        }
                        .padding(.horizontal, 15)
                        .padding(.trailing, 10)
                        .frame(width: 110, height: 35, alignment: .center)
                        .background(.regularMaterial)
                        .cornerRadius(18)
                        
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(righty_hitter ? Color("ScoreboardGreen") : Color.clear, lineWidth: 3)
                            .fill(.clear)
                            .frame(width: 110, height: 35)
                    }
                    .font(.system(size: 17) .weight(.semibold))
                    .cornerRadius(18)
                    
                }
                
                Spacer()
                
                Image("HomeplateFromBehind")
                    .resizable()
                    .frame(width: 65, height: 20)
                
                Spacer()
                
                Button{
                    is_locked = true
                    lefty_hitter = true
                    righty_hitter = false
                    event.batter_stance = "L"
                    update_ab_stance(using: context)
                } label: {
                    ZStack{
                        
                        HStack{
                            Text("Left")
                            
                            Spacer()
                            
                            Image(systemName: "arrowtriangle.right.fill")
                                .scaleEffect(x: 0.6)
                        }
                        .padding(.horizontal, 15)
                        .padding(.leading, 10)
                        .frame(width: 110, height: 35, alignment: .center)
                        .background(.regularMaterial)
                        .cornerRadius(18)
                        
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(lefty_hitter ? Color("ScoreboardGreen") : Color.clear, lineWidth: 3)
                            .fill(.clear)
                            .frame(width: 110, height: 35)
                    }
                    .font(.system(size: 17) .weight(.semibold))
                    .cornerRadius(18)
                }
                
                Spacer()
                
            }
            .padding(.trailing, 25) //Leave Space for Lock
            .padding(.horizontal, 10)
        }
        .padding(.horizontal, 10)
        //.padding(.trailing, 28)
        .frame(maxWidth: .infinity, maxHeight: 75)
        .foregroundStyle(.white)
        .background(.regularMaterial)
        .cornerRadius(15)
        .overlay{
            if is_locked{
                HStack{
                    //View to overlay batter stance input when locked
                }
                .frame(maxWidth: .infinity, maxHeight: 75)
                .background(Color.black.opacity(0.3))
                .cornerRadius(15)
            }
//            VStack{
                
                HStack(alignment: .top){
                    
                    Spacer()
                    
                    Button{
                        if righty_hitter == true || lefty_hitter == true{
                            is_locked.toggle()
                        }
                    } label: {
                        Image(systemName: is_locked ? "lock.fill" : "lock.open.fill")
                            .font(.system(size: 22) .weight(.semibold))
                            .foregroundColor(.white)
                            .contentTransition(.symbolEffect(.replace))
                            
                    }
                    .frame(width: 25)
                }
                .padding(.trailing, 5)
                .padding(10)
                
//                Spacer()
//                
//            }
            
        }
    }
    
    @ViewBuilder
    func SaveToast() -> some View {
        //Saving Game Toast
        VStack{
            if show_save_toast == true{
            
                HStack{
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.black.opacity(0.4))
                            .frame(width: 125, height: 32)
                        
                        HStack{
                            
                            Text("Saving Game")
                                .font(.system(size: 13) .weight(.medium))
                                //.bold()
                            
                            HStack{
                                
                                if saving_animation == false {
                                    Circle()
                                        .trim(from: 0.0, to: 0.70)
                                        .stroke(style: StrokeStyle(lineWidth: 2.0, lineCap: .round, lineJoin: .round))
                                        .fill(AngularGradient(gradient: Gradient(colors: [.black, .white]), center: .center, endAngle: .degrees(250)))
                                        .frame(width: 18, height: 18)
                                        .rotationEffect(.degrees(isRotating))
                                        .onAppear {
                                            withAnimation(.linear(duration: 1).speed(0.9).repeatForever(autoreverses: false)) {
                                                isRotating = 360
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                                saving_animation = true
                                            }
                                        }

                                }
                                else {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 9))
                                        .imageScale(.large)
                                        .bold()
                                        .onAppear{
                                            //impact.impactOccurred()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                                saving_animation = false
                                                isRotating = 0
                                            }
                                        }
                                }
                            }
                            .frame(width: 20)
                        }
                    }
                }
                .background(.regularMaterial)
                .clipShape(Capsule())
                .transition(.move(edge: .top).combined(with: .opacity))
                .padding(.top, 10)
                .onAppear{
                    if show_save_toast == true {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                            withAnimation{
                                show_save_toast.toggle()
                            }
                        }
                    }
                }
                
            }
            
            Spacer()
            
        }
    }
    
    func add_prev_event_string() {
        if event.recordEvent{
            let new_event = Event(pitcher_id: current_pitcher.idcode, pitch_result: event.pitch_result, pitch_type: event.pitch_type, result_detail: event.result_detail, balls: event.balls, strikes: event.strikes, outs: event.outs, inning: event.inning, atbats: event.atbats, pitch_x_location: event.x_cor, pitch_y_location: event.y_cor, batter_stance: event.batter_stance, velocity: event.velocity, event_number: event.event_number)
            
            context.insert(new_event)
            event.event_number += 1
            print_Event_String()
            
            ptconfig.cur_x_location = 0
            ptconfig.cur_y_location = 0
            
            if event.end_ab_rd.contains(event.result_detail){
                is_locked = false
                righty_hitter = false
                lefty_hitter = false
                event.batter_stance = ""
            }
            
        }
    }
    
    func print_Event_String() {
        print(current_pitcher.idcode, event.pitch_result, event.pitch_type, event.result_detail, event.balls, event.strikes, event.outs, event.inning, event.atbats, event.batter_stance, event.velocity, event.x_cor, event.y_cor)
    }
    
    func save_logic_handling_func() {
        if location_overlay.game_info_entered == true {
            withAnimation{
                show_save_toast = true
                location_overlay.showTabBar = true
            }
            save_game_func()
            new_game_func()
        }
        else if location_overlay.game_info_entered == false {
            //Show enter gameinfo popup (ZeroInput: Please enter the game information before saving.)
            //Dismiss Save Game popup
            withAnimation{
                showEndGame = false
                showAddGameInfo = true
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
            
        }
        
        let new_saved_game = SavedGames(opponent_name: opponent_name, date: date, location: location, game_data: game_data_list, pitcher_info: saved_pitcher_list)
        
        context.insert(new_saved_game)
        
    }
    
    func reselect_current_pitcher(pitcher_id: UUID) {
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
                
            }
        }
    }
    
    func set_game_information(opponent: String, location: String, date: Date, batter_stance: String){
        
        if batter_stance == "L" {
            lefty_hitter = true
            event.batter_stance = "L"
        } else if batter_stance == "R"{
            righty_hitter = true
            event.batter_stance = "R"
        }
        
        if game_report.opponent_name != "" && game_report.game_location != ""{
            game_report.opponent_name = opponent
            game_report.game_location = location
            game_report.start_date = date
            
            withAnimation{
                location_overlay.game_info_entered = true
            }
        }
    }
    
    func load_previous_event() {
        
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
        
        //Keep batter stance locked on undo, user can change anytime
        is_locked = true
  
        //Set batter stance
        if event.batter_stance == "L" {
            lefty_hitter = true
            righty_hitter = false
        } else if event.batter_stance == "R" {
            righty_hitter = true
            lefty_hitter = false
        }
        
        print("Lefty: \(lefty_hitter) \nRighty: \(righty_hitter)")
        
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
                        ptconfig.ab_pitch_color.insert(Color.blue, at: 0)
                    }
                    else if prev_evnt.pitch_type == "P2"{
                        ptconfig.ab_pitch_color.insert(Color.orange, at: 0)
                    }
                    else if prev_evnt.pitch_type == "P3"{
                        ptconfig.ab_pitch_color.insert(Color.red, at: 0)
                    }
                    else if prev_evnt.pitch_type == "P4"{
                        ptconfig.ab_pitch_color.insert(Color.green, at: 0)
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
    
    func update_ab_stance(using context: ModelContext){
        
        let fetchDescriptor = FetchDescriptor<Event>()
        
        do {
            let events = try context.fetch(fetchDescriptor)
                
            for evnt in events.reversed() {
                if event.end_ab_rd.contains(evnt.result_detail) {
                    break
                }
                else if evnt.atbats == scoreboard.atbats && evnt.batter_stance != event.batter_stance{
                    evnt.batter_stance = event.batter_stance
                }
            }
        } catch {
            print("Error")
        }
        
    }
    
    func new_game_func() {
        
        do {
            try context.delete(model: Event.self)
            try context.save()
        } catch {
            print("Did not clear event data")
        }
        
        var cntr = 0
        for pitch in events{
            cntr += 1
            context.delete(pitch)
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
        righty_hitter = false
        lefty_hitter = false
        is_locked = false
        event.event_number = 0
        
        current_pitcher.firstName = "No Pitcher Selected"
        current_pitcher.lastName = ""
        current_pitcher.idcode = UUID()
        
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
        
        withAnimation{
            location_overlay.game_info_entered = false
        }
        game_report.opponent_name = ""
        game_report.game_location = "Home"
        game_report.start_date = Date()
        
        //clear_game_report()
        
    }
    
    //Resume Game functions
    func set_pitcher() {
        let pitcher_id = events[events.count - 1].pitcher_id
        for pitcher in pitchers {
            if pitcher.id == pitcher_id {
                current_pitcher.pitch_num = 0
                current_pitcher.firstName = pitcher.firstName
                current_pitcher.lastName = pitcher.lastName
                current_pitcher.idcode = pitcher.id
                
                current_pitcher.pitch1 = pitcher.pitch1
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
                
        scoreboard.balls = recent_event.balls
        scoreboard.strikes = recent_event.strikes
        scoreboard.outs = recent_event.outs
        scoreboard.atbats = 0
        scoreboard.inning = recent_event.inning
        event.batter_stance = recent_event.batter_stance
        event.event_number = recent_event.event_number + 1
        //print("Event number: \(event.event_number)")
        
        //Keep batter stance locked when resuming, user can change anytime
        is_locked = true
        
        if recent_event.batter_stance == "R" {
            righty_hitter = true
            lefty_hitter = false
        }
        else if recent_event.batter_stance == "L" {
            lefty_hitter = true
            righty_hitter = false
        }
        
        print("Lefty: \(lefty_hitter) \nRighty: \(righty_hitter)")
        
        if end_ab_br.contains(recent_event.result_detail) {
            scoreboard.balls = 0
            scoreboard.strikes = 0
            lefty_hitter = false
            righty_hitter = false
        }
        else if end_ab_out.contains(recent_event.result_detail) {
            scoreboard.balls = 0
            scoreboard.strikes = 0
            scoreboard.outs += 1
            if scoreboard.outs >= 3 {
                scoreboard.inning += 1
                scoreboard.outs = 0
            }
            lefty_hitter = false
            righty_hitter = false
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
                        ptconfig.ab_pitch_color.insert(Color.blue, at: 0)
                    }
                    else if prev_evnt.pitch_type == "P2"{
                        ptconfig.ab_pitch_color.insert(Color.orange, at: 0)
                    }
                    else if prev_evnt.pitch_type == "P3"{
                        ptconfig.ab_pitch_color.insert(Color.red, at: 0)
                    }
                    else if prev_evnt.pitch_type == "P4"{
                        ptconfig.ab_pitch_color.insert(Color.green, at: 0)
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
}


