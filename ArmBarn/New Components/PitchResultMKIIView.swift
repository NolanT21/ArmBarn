//
//  PitchResultView.swift
//  Sandbox
//
//  Created by Nolan Thompson on 4/9/25.
//

import SwiftUI

struct PitchResultMKIIView: View {
    
    @Binding var path: [Int]
    
    @Environment(Event_String.self) var event
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(LocationOverlay.self) var location_overlay
    @Environment(\.dismiss) private var dismiss
    
    @State private var selected_index: Int = 1
    
    @State var button_gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color("ScoreboardGreen"), Color("DarkScoreboardGreen")]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    @State var disabled_gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color.gray.opacity(0.5)]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    @State private var button_color: Color = Color("ScoreboardGreen")
    
    var body: some View {
        VStack{
            VStack(spacing: 0){
                HStack{
                    Button {
                        ptconfig.pitch_x_loc.removeLast()
                        ptconfig.pitch_y_loc.removeLast()
                        ptconfig.ab_pitch_color.removeLast()
                        ptconfig.pitch_cur_ab -= 1
                        location_overlay.showCurPitchPulse = false
                        location_overlay.zero_location = false
                        dismiss()
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
                        Text("No Action")
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
                        Text("BIP")
                            .font(.system(size: 13))
                            .foregroundColor(selected_index == 2 ? Color.white : Color.gray)
                            .bold(selected_index == 2)
                    }
                    
                }
                .padding(10)
                
                HStack(alignment: .top){
                    TabView(selection: $selected_index){
                        //PitchTypeButtons()
                        NoActionButtons()
                            .tag(1)
                        
                        BallInPlayButtons()
                            .tag(2)
                        
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                }
                
                
                
            }
            .ignoresSafeArea()
            .background(.regularMaterial)
            .cornerRadius(15)
            .padding(.horizontal, 10)
            
            Spacer()
            
        }
    }
    
    @ViewBuilder
    func NoActionButtons() -> some View {
        
        VStack(alignment: .center) {
            
            HStack(spacing: 12){
                Button {
                    add_Ball()
                    back_to_root()
                } label: {
                    Text("Ball")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_gradient)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                
                NavigationLink {
                    StrikeResultView(path: $path).navigationBarBackButtonHidden(true).task{
                        
                    }
                } label: {
                    Text("Strike")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_gradient)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                                
            }
            
            HStack(spacing: 12){
                Button {
                    event.pitch_result = "T"
                    event.result_detail = "N"
                    add_Foul_Ball()
                    back_to_root()
                } label: {
                    Text("Foul Ball")
                        .font(.system(size: 17, weight: .bold))
                }
                .frame(maxWidth: .infinity, maxHeight: 45)
                .background(button_gradient)
                .foregroundColor(Color.white)
                .cornerRadius(8.0)
                
                Button {
                    event.result_detail = "B"
                    record_HBP()
                    back_to_root()
                } label: {
                    Text("Hit by Pitch")
                        .font(.system(size: 17, weight: .bold))
                }
                .frame(maxWidth: .infinity, maxHeight: 45)
                .background(button_gradient)
                .foregroundColor(Color.white)
                .cornerRadius(8.0)
                
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 10)
        
    }
    
    @ViewBuilder
    func BallInPlayButtons() -> some View {
        
        VStack(alignment: .center) {
            
            HStack(spacing: 12){
                NavigationLink {
                    HitResultView(path: $path).navigationBarBackButtonHidden(true).task{
                        
                    }
                    
                } label: {
                    Text("Hit")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_gradient)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                
                NavigationLink {
                    OutResultView(path: $path).navigationBarBackButtonHidden(true).task{
                        
                    }
                } label: {
                    Text("Out")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_gradient)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                                
            }
            
            HStack(spacing: 12){
                Button {
                    event.result_detail = "Y"
                    record_Out()
                    back_to_root()
                } label: {
                    Text("Sacrifice Bunt")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_gradient)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                
                Button {
                    event.result_detail = "E"
                    record_Hit()
                    back_to_root()
                } label: {
                    Text("Error")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_gradient)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 10)
        
    }
    
    func back_to_root() {
        withAnimation{
            location_overlay.showTabBar = true
            location_overlay.showCurPitchPulse = false
            scoreboard.disable_bottom_row = false
        }
        path.removeAll()
    }
    
    func add_Ball() {
        event.pitch_result = "A"
        event.result_detail = "N"
        event.balls = scoreboard.balls
        event.strikes = scoreboard.strikes
        event.outs = scoreboard.outs
        event.inning = scoreboard.inning
        event.atbats = scoreboard.atbats
        
        if scoreboard.update_scoreboard {
            scoreboard.pitches += 1
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
                reset_Count()
            }
        }
    }
    
    func add_Strike() {
        event.balls = scoreboard.balls
        event.strikes = scoreboard.strikes
        event.outs = scoreboard.outs
        event.inning = scoreboard.inning
        event.atbats = scoreboard.atbats
        
        if scoreboard.update_scoreboard {
            scoreboard.pitches += 1
            scoreboard.strikes += 1
            
            if scoreboard.strikes == 3 {
                if event.result_detail == "C"{
                    scoreboard.atbats += 1
                    scoreboard.baserunners += 1
                    reset_Count()
                }
                else if event.pitch_result == "T"{
                    scoreboard.strikes = 2
                }
                else{
                    scoreboard.outs += 1
                    scoreboard.atbats += 1
                    reset_Count()
                }
                
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
    
    func add_Foul_Ball() {
        event.balls = scoreboard.balls
        event.strikes = scoreboard.strikes
        event.outs = scoreboard.outs
        event.inning = scoreboard.inning
        event.atbats = scoreboard.atbats
        
        if scoreboard.update_scoreboard {
            scoreboard.pitches += 1
            scoreboard.strikes += 1
            
            if scoreboard.strikes == 3 {
                scoreboard.strikes = 2
            }
            
            if scoreboard.strikes == 1 {
                scoreboard.s1light = true
            }
            if scoreboard.strikes == 2 {
                scoreboard.s2light = true
            }
        }
    }
    
    func record_Hit() {
        event.pitch_result = "H"
        event.balls = scoreboard.balls
        event.strikes = scoreboard.strikes
        event.outs = scoreboard.outs
        event.inning = scoreboard.inning
        event.atbats = scoreboard.atbats
        
        if scoreboard.update_scoreboard {
            scoreboard.pitches += 1
            scoreboard.atbats += 1
            
            if event.result_detail != "H" {
                scoreboard.baserunners += 1
            }
            else if event.result_detail == "T" {
                scoreboard.baserunners = 1
            }
            else if event.result_detail == "H" {
                scoreboard.baserunners = 0
            }
            
            reset_Count()
        }
    }
    
    func record_Out() {
        event.pitch_result = "O"
        event.balls = scoreboard.balls
        event.strikes = scoreboard.strikes
        event.outs = scoreboard.outs
        event.inning = scoreboard.inning
        event.atbats = scoreboard.atbats
        
        if scoreboard.update_scoreboard {
            scoreboard.pitches += 1
            scoreboard.outs += 1
            scoreboard.atbats += 1
            
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
            }
            
            reset_Count()
        }
    }
    
    func record_HBP() {
        event.pitch_result = "H"
        event.balls = scoreboard.balls
        event.strikes = scoreboard.strikes
        event.outs = scoreboard.outs
        event.inning = scoreboard.inning
        event.atbats = scoreboard.atbats
        
        if scoreboard.update_scoreboard {
            scoreboard.pitches += 1
            scoreboard.atbats += 1
            scoreboard.baserunners += 1
            reset_Count()
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

//#Preview {
//    PitchResultView()
//}
