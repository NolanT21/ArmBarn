//
//  StrikeoutAlertView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 4/16/24.
//

import SwiftUI

struct StrikeoutAlertView: View {
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(Event_String.self) var event
    @Environment(PitchTypeConfig.self) var ptconfig
    
    @State private var offset: CGFloat = 1000
    
    var font_color: Color = .white
    var crnr_radius: CGFloat = 12
    var background_color: Color = Color("DarkGrey")
    
    @Binding var isActive: Bool
    
    let title: String = "Out Recorded?"
    let leftButtonText: String = "YES"
    let rightButtonText: String = "NO"
    let result_detail: String
    
    var body: some View {
        ZStack{
            
            Color(.black)
                .opacity(0.2)
            
            VStack{
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(font_color)
                    .padding()
                
                HStack{
                    
                    NavigationLink(destination: MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                            event.result_detail = result_detail
                            add_Strike()
                        }){
                            ZStack{
                                RoundedRectangle(cornerRadius: crnr_radius)
                                    .foregroundColor(Color("ScoreboardGreen"))

                                Text("YES")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(font_color)
                                    .padding()
                            }
                        }
                    NavigationLink(destination: MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                            event.result_detail = "C"
                            reset_Count()
                        }){
                            ZStack{
                                RoundedRectangle(cornerRadius: crnr_radius)
                                    .foregroundColor(Color("ScoreboardGreen"))

                                Text("NO")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(font_color)
                                    .padding()
                            }
                        }
                }
                .padding()
            }
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .padding()
            .background(Color("DarkGrey"))
            .clipShape(RoundedRectangle(cornerRadius: crnr_radius))
            .shadow(radius: 20)
            .padding(30)
            .offset(x: 0, y: offset)
            .onAppear{
                withAnimation(.spring()) {
                    offset = -120
                }
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
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
        }
    }
    
}

#Preview {
    StrikeoutAlertView(isActive: .constant(true), result_detail: "")
}
