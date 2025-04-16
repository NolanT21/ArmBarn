//
//  StrikeResultView.swift
//  Sandbox
//
//  Created by Nolan Thompson on 4/14/25.
//

import SwiftUI

struct StrikeResultView: View {
    
    @Binding var path: [Int]
    
    @Environment(Event_String.self) var event
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(LocationOverlay.self) var location_overlay
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
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
                        
                    }
                    .padding(10)
                    .padding(.top, 3)
                    
                    VStack(alignment: .center) {
                        
                        HStack(spacing: 12){
                            Button {
                                event.pitch_result = "L"
                                event.result_detail = "N"
                                add_Strike()
                                withAnimation{
                                    location_overlay.showTabBar = true
                                }
                                path.removeAll()
                            } label: {
                                Text("Called")
                                    .font(.system(size: 17, weight: .bold))
                                    .frame(maxWidth: .infinity, maxHeight: 45)
                                    .background(Color("ScoreboardGreen"))
                                    .foregroundColor(Color.white)
                                    .cornerRadius(8.0)
                            }
                            
                            Button {
                                event.pitch_result = "Z"
                                event.result_detail = "N"
                                add_Strike()
                                withAnimation{
                                    location_overlay.showTabBar = true
                                }
                                path.removeAll()
                            } label: {
                                Text("Swinging")
                                    .font(.system(size: 17, weight: .bold))
                                    .frame(maxWidth: .infinity, maxHeight: 45)
                                    .background(Color("ScoreboardGreen"))
                                    .foregroundColor(Color.white)
                                    .cornerRadius(8.0)
                            }
                                            
                        }
                        
                        HStack(spacing: 12){
                            Button {
                                event.pitch_result = "TO"
                                event.result_detail = "N"
                                add_Strike()
                                withAnimation{
                                    location_overlay.showTabBar = true
                                }
                                path.removeAll()
                            } label: {
                                Text("Foul Tip")
                                    .font(.system(size: 17, weight: .bold))
                            }
                            .frame(maxWidth: .infinity, maxHeight: 45)
                            .background(Color("ScoreboardGreen"))
                            .foregroundColor(Color.white)
                            .cornerRadius(8.0)
                            
                            Button {
                                
                            } label: {
                                Text("")
                                    .font(.system(size: 17, weight: .bold))
                            }
                            .frame(maxWidth: .infinity, maxHeight: 45)
                            .background(Color.clear)
                            .foregroundColor(Color.clear)
                            .cornerRadius(8.0)
                            
                        }
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 10)
                    
                }
            }
            .ignoresSafeArea()
            .background(.regularMaterial)
            .cornerRadius(15)
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
                    if event.pitch_result == "Z" || event.pitch_result == "TO"{
                        event.result_detail = "K"
                    }
                    else if event.pitch_result == "L" {
                        event.result_detail = "M"
                    }
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
//    StrikeResultView()
//}
