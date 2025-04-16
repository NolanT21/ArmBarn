//
//  PitchTypeSelectView.swift
//  Sandbox
//
//  Created by Nolan Thompson on 4/8/25.
//

import SwiftUI

struct PitchTypeSelectView: View {
    
    @Binding var path: [Int]
    
    @Environment(Event_String.self) var event
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(LocationOverlay.self) var location_overlay
    @Environment(\.dismiss) private var dismiss
    
    @State var pitch1_color: Color = Color.blue
    @State var pitch2_color: Color = Color.orange
    @State var pitch3_color: Color = Color.red
    @State var pitch4_color: Color = Color.green
    
    @State var show_pitchtypes: Bool = true
    @State var selected_index: Int = 1
    
    @State private var button_color: Color = Color("ScoreboardGreen")
    
    var body: some View {
        VStack(spacing: 0){
            
            //Top Navigation Bar
            HStack{
                Button {
                    dismiss()
                    event.recordEvent = false
                    withAnimation{
                        location_overlay.showTabBar = true
                    }
                } label: {
                    HStack(spacing: 5){
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .font(.system(size: 13) .weight(.medium))
                .foregroundColor(.white)
                
                Spacer()
                
                Button{
                    withAnimation{
                        selected_index = 1
                    }
                } label : {
                    Text("Pitches")
                        .font(.system(size: 13))
                        .foregroundColor(selected_index == 1 ? Color.white : Color.gray)
                        .bold(selected_index == 1)
                }
                
                Divider()
                    .frame(height: 20)
                
                Button{
                    withAnimation{
                        selected_index = 2
                    }
                } label: {
                    Text("No Pitch")
                        .font(.system(size: 13))
                        .foregroundColor(selected_index == 2 ? Color.white : Color.gray)
                        .bold(selected_index == 2)
                }

            }
            .padding(10)
            
            HStack(alignment: .top){
                TabView(selection: $selected_index){
                    PitchTypeButtons()
                        .tag(1)
                    
                    NoPitchEvents()
                        .tag(2)
                        
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }

        }
        .ignoresSafeArea()
        .background(.regularMaterial)
        .cornerRadius(15)
        
    }
    
    @ViewBuilder
    func PitchTypeButtons() -> some View {
        VStack(alignment: .center){
            
            HStack{
                NavigationLink {
                    LocationNavigationView(path: $path).navigationBarBackButtonHidden(true).task{
                        call_location_overlay()
                        event.pitch_type = "P1"
                        ptconfig.ptcolor = pitch1_color
                    }
                } label: {
                    HStack(spacing: 12){
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .fill(Color.blue)
                            .frame(width: 18, height: 18)
                            .padding(.leading, 15)
                            
                        Text("Fastball")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Color.white)
                            .padding(.trailing, 15)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 45)
                    .background(.regularMaterial)
                    .cornerRadius(30)
                }
                
                NavigationLink {
                    LocationNavigationView(path: $path).navigationBarBackButtonHidden(true).task{
                        call_location_overlay()
                        event.pitch_type = "P2"
                        ptconfig.ptcolor = pitch2_color
                    }
                } label: {
                    HStack(spacing: 12){
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .fill(Color.orange)
                            .frame(width: 18, height: 18)
                            .padding(.leading, 15)
                            
                        Text("Curveball")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 45)
                    .background(.regularMaterial)
                    .cornerRadius(30)
                }
            }
            
            HStack{
                NavigationLink {
                    LocationNavigationView(path: $path).navigationBarBackButtonHidden(true).task{
                        call_location_overlay()
                        event.pitch_type = "P3"
                        ptconfig.ptcolor = pitch3_color
                    }
                } label: {
                    HStack(spacing: 12){
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .fill(Color.red)
                            .frame(width: 18, height: 18)
                            .padding(.leading, 15)
                            
                        Text("Change-Up")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 45)
                    .background(.regularMaterial)
                    .cornerRadius(30)
                }
                
                NavigationLink {
                    LocationNavigationView(path: $path).navigationBarBackButtonHidden(true).task{
                        call_location_overlay()
                        event.pitch_type = "P4"
                        ptconfig.ptcolor = pitch4_color
                    }
                } label: {
                    HStack(spacing: 12){
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .fill(Color.green)
                            .frame(width: 18, height: 18)
                            .padding(.leading, 15)
                            
                        Text("Other")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 45)
                    .background(.regularMaterial)
                    .cornerRadius(30)
                }
            }
            
            Spacer()
            
        }
        //.transition(.move(edge: .leading))
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func NoPitchEvents() -> some View {
        VStack(alignment: .center){
            HStack(spacing: 12){
                Button {
                    //ptconfig.non_pitch_event = false
                    add_PCV_Ball()
                    //add_non_pitch_event()
                    withAnimation{
                        location_overlay.showTabBar = true
                    }
                    path.removeAll()
                } label: {
                    Text("Violation - Ball")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_color)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                
                Button {
                    //ptconfig.non_pitch_event = false
                    add_PCV_Strike()
                    //add_non_pitch_event()
                    withAnimation{
                        location_overlay.showTabBar = true
                    }
                    path.removeAll()
                } label: {
                    Text("Violation - Strike")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_color)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                                
            }
            
            HStack(spacing: 12){
                Button {
                    //ptconfig.non_pitch_event = false
                    //ptconfig.npe_EOAB = true
                    add_Intentional_Walk()
                    //add_non_pitch_event()
                    withAnimation{
                        location_overlay.showTabBar = true
                    }
                    path.removeAll()
                } label: {
                    Text("Intentional Walk")
                        .font(.system(size: 17, weight: .bold))
                }
                .frame(maxWidth: .infinity, maxHeight: 45)
                .background(button_color)
                .foregroundColor(Color.white)
                .cornerRadius(8.0)
                
                Button {
                    record_baserunner_out()
                    withAnimation{
                        location_overlay.showTabBar = true
                    }
                    path.removeAll()
                } label: {
                    Text("Runner Out")
                        .font(.system(size: 17, weight: .bold))
                }
                .frame(maxWidth: .infinity, maxHeight: 45)
                .background(scoreboard.baserunners < 1 ? Color.gray.opacity(0.5) : button_color)
                .foregroundColor(scoreboard.baserunners < 1 ? Color.gray : Color.white)
                .cornerRadius(8.0)
                .disabled(scoreboard.baserunners < 1)
                
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 10)
    }
    
    func call_location_overlay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            location_overlay.shakecounter += 1
        }
        
        withAnimation{
            location_overlay.showinputoverlay = true
        }
    }
    
//    func add_non_pitch_event() {
//        
//        let npe = Event(pitcher_id: current_pitcher.idcode, pitch_result: event.pitch_result, pitch_type: "NP", result_detail: event.result_detail, balls: event.balls, strikes: event.strikes, outs: event.outs, inning: event.inning, atbats: event.atbats, pitch_x_location: 0, pitch_y_location: 0, batter_stance: event.batter_stance, velocity: 0, event_number: event.event_number)
//        
//        context.insert(npe)
//        
//        event.event_number += 1
//        print_Event_String()
//    }
//
//    func print_Event_String() {
//        print(current_pitcher.idcode, event.pitch_result, event.pitch_type, event.result_detail, event.balls, event.strikes, event.outs, event.inning, event.atbats, event.batter_stance, event.velocity, 0, 0)
//    }
    
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
        
        //add_non_pitch_event() //<- Try using this first
        //add_prev_event_string()
        
    }
    
}

//#Preview {
//    PitchTypeSelectView()
//}
