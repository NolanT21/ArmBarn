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

enum PulseAnimation: CaseIterable {
    case start, middle, end
}

struct MainDashboardView: View {
    
    @State private var input_nav_path = [Int]()
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State var show_undo_toast: Bool = false
    
    @Environment(currentPitcher.self) var current_pitcher
    @Environment(Event_String.self) var event
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(LocationOverlay.self) var location_overlay
    
    @Query(sort: \Event.event_number) var events: [Event]
    
    @State var main_body_padding: CGFloat = 10
    @State var light_width : CGFloat = 1.5
    
    @State var location: CGPoint = .zero
    @State var cur_pitch_fill: Color = .clear
    @State var cur_pitch_outline: Color = .clear
    @State var cur_pitch_pulse: Bool = false
    
    @State var red_light_color: Color = .red
    @State var green_light_color: Color = Color("ScoreboardGreen")
    
    var tap: some Gesture {
        SpatialTapGesture()
            .onEnded { click in
                if location_overlay.showinputoverlay{
                    ptconfig.cur_x_location = click.location.x
                    ptconfig.cur_y_location = click.location.y
                    location = click.location
                    cur_pitch_fill = ptconfig.ptcolor
                    cur_pitch_outline = .white
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
                                    new_game_func()
                                } label: {
                                    Image(systemName: "flag.pattern.checkered")
                                        .font(.system(size: 18))
                                        .frame(width: 30, height: 30)
                                    
                                }
                                .background(events.count <= 0 ? Color.gray.opacity(0.5) : Color("ScoreboardGreen"))
                                .foregroundColor(events.count <= 0 ? Color.gray : Color.white)
                                .cornerRadius(8.0)
                                .shadow(color: .black.opacity(0.5), radius: 3, x: 3, y: 3)
                                .disabled(events.count <= 0)
                                
                                Button{
                                    withAnimation{
                                        show_undo_toast = true
                                        impact.impactOccurred()
                                    }
                                } label: {
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.system(size: 18))
                                        .frame(width: 30, height: 30)
                                        .bold()
                                    
                                }
                                .background(events.count < 1 ? Color.gray.opacity(0.5) : Color("ScoreboardGreen"))
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
                                        Circle()
                                            .stroke(cur_pitch_outline, lineWidth: 4)
                                            .fill(cur_pitch_fill)
                                            .frame(width: geometry.size.width * 0.055, height: geometry.size.width * 0.055, alignment: .center)
                                            .position(location)
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
                
                
                VStack{
                    
                    NavigationStack(path: $input_nav_path){
                        VStack{
                            
                            Button{
                                withAnimation{
                                    location_overlay.showTabBar = false
                                }
                                input_nav_path.append(1)
                            } label: {
                                HStack(spacing: 5){
                                    Text("Enter Pitch")
                                        .padding(.leading, 10)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .padding(.trailing, 10)
                                }
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .foregroundStyle(.white)
                                .background(Color("ScoreboardGreen"))
                                .bold()
                                .cornerRadius(15)
                            }
                            
                        }
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
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: 180)
                    .padding(.horizontal, main_body_padding)
                    .padding(.top, 10)
                    
                }
                //.border(Color.white, width: 2)
                
                Spacer()
                
            }
            .background(Color.black)
            
            //NavBar
        }
            
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
                        .phaseAnimator(PulseAnimation.allCases) { content, phase in
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
    
    func add_prev_event_string() {
        if event.recordEvent{
            let new_event = Event(pitcher_id: UUID()/*current_pitcher.idcode*/, pitch_result: event.pitch_result, pitch_type: event.pitch_type, result_detail: event.result_detail, balls: event.balls, strikes: event.strikes, outs: event.outs, inning: event.inning, atbats: event.atbats, pitch_x_location: event.x_cor, pitch_y_location: event.y_cor, batter_stance: event.batter_stance, velocity: event.velocity, event_number: event.event_number)
            
            context.insert(new_event)
            
            event.event_number += 1
            print_Event_String()
        }
    }
    
    func print_Event_String() {
        print(/*current_pitcher.idcode,*/ event.pitch_result, event.pitch_type, event.result_detail, event.balls, event.strikes, event.outs, event.inning, event.atbats, event.batter_stance, event.velocity, event.x_cor, event.y_cor)
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
        
        //clear_game_report()
        
    }
    
}

//#Preview {
//    PitchLocationView()
//        .modelContainer(for: Item.self, inMemory: true)
//}


