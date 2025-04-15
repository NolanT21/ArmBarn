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
    @Environment(LocationOverlay.self) var location_overlay
    @Environment(\.dismiss) private var dismiss
    
    @State private var selected_index: Int = 1
    
    @State private var button_color: Color = Color("ScoreboardGreen")
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                Button {
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
                
                //.transition(.slide)
                
                //Spacer()
                
            }
            
        }
        .ignoresSafeArea()
        .background(.regularMaterial)
        .cornerRadius(15)
    }
    
    @ViewBuilder
    func NoActionButtons() -> some View {
        
        VStack(alignment: .center) {
            
            HStack(spacing: 12){
                Button {
                    add_Ball()
                    path.removeAll()
                } label: {
                    Text("Ball")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_color)
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
                        .background(button_color)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                                
            }
            
            HStack(spacing: 12){
                Button {
                    path.removeAll()
                } label: {
                    Text("Foul Ball")
                        .font(.system(size: 17, weight: .bold))
                }
                .frame(maxWidth: .infinity, maxHeight: 45)
                .background(button_color)
                .foregroundColor(Color.white)
                .cornerRadius(8.0)
                
                Button {
                    path.removeAll()
                } label: {
                    Text("Hit by Pitch")
                        .font(.system(size: 17, weight: .bold))
                }
                .frame(maxWidth: .infinity, maxHeight: 45)
                .background(button_color)
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
                        .background(button_color)
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
                        .background(button_color)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                                
            }
            
            HStack(spacing: 12){
                Button {
                    path.removeAll()
                } label: {
                    Text("Sacrifice Bunt")
                        .font(.system(size: 17, weight: .bold))
                }
                .frame(maxWidth: .infinity, maxHeight: 45)
                .background(button_color)
                .foregroundColor(Color.white)
                .cornerRadius(8.0)
                
                Button {
                    path.removeAll()
                } label: {
                    Text("Error")
                        .font(.system(size: 17, weight: .bold))
                }
                .frame(maxWidth: .infinity, maxHeight: 45)
                .background(button_color)
                .foregroundColor(Color.white)
                .cornerRadius(8.0)
                
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 10)
        
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
    
    func reset_Count() {
        scoreboard.balls = 0
        scoreboard.strikes = 0
        
//        ptconfig.pitch_x_loc.removeAll()
//        ptconfig.pitch_y_loc.removeAll()
//        ptconfig.ab_pitch_color.removeAll()
//        ptconfig.pitch_cur_ab = 0
        
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
