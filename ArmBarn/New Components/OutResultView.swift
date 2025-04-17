//
//  OutResultView.swift
//  Sandbox
//
//  Created by Nolan Thompson on 1/28/25.
//

import SwiftUI

struct OutResultView: View {
    
    @Binding var path: [Int]

    @Environment(Event_String.self) var event
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(LocationOverlay.self) var location_overlay
    @Environment(\.dismiss) private var dismiss
    
    @State private var selected_index: Int = 1
    
    @State private var button_color: Color = Color("ScoreboardGreen")
    
    var body: some View {
        
        VStack{
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
                        Text("Page 1")
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
                        Text("Page 2")
                            .font(.system(size: 13))
                            .foregroundColor(selected_index == 2 ? Color.white : Color.gray)
                            .bold(selected_index == 2)
                    }
                    
                }
                .padding(10)
                
                HStack(alignment: .top){
                    TabView(selection: $selected_index){
                        OutDetail1()
                            .tag(1)
                        
                        OutDetail2()
                            .tag(2)
                            
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    
                    //.transition(.slide)
                    
                    //Spacer()
                    
                }
                
            }
        }
        .ignoresSafeArea()
        .background(.regularMaterial)
        .cornerRadius(15)
        
    }
    
    @ViewBuilder
    func OutDetail1() -> some View {
        VStack(alignment: .center) {
            
            HStack(spacing: 12){
                Button {
                    event.result_detail = "F"
                    record_Out()
                    back_to_root()
                } label: {
                    Text("Flyout")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_color)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                
                Button {
                    event.result_detail = "G"
                    record_Out()
                    back_to_root()
                } label: {
                    Text("Groundout")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_color)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                                
            }
            
            HStack(spacing: 12){
                Button {
                    event.result_detail = "L"
                    record_Out()
                    back_to_root()
                } label: {
                    Text("Lineout")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_color)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                
                
                Button {
                    event.result_detail = "P"
                    record_Out()
                    back_to_root()
                } label: {
                    Text("PopUp")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_color)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                
                
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func OutDetail2() -> some View {
        VStack(alignment: .center) {
            
            HStack(spacing: 12){
                Button {
                    event.result_detail = "Y"
                    record_Out()
                    back_to_root()
                } label: {
                    Text("Sacrifice Bunt")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_color)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                
                Button {
                    event.result_detail = "O"
                    record_Out()
                    back_to_root()
                } label: {
                    Text("Other")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_color)
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
        }
        location_overlay.showCurPitchPulse = false
        path.removeAll()
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
//    OutResultView()
//}
