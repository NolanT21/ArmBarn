//
//  StrikeoutOutResultView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 5/5/25.
//

import SwiftUI

struct StrikeoutResultView: View {
    
    @Binding var path: [Int]
    
    @Environment(Event_String.self) var event
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(LocationOverlay.self) var location_overlay
    @Environment(\.dismiss) private var dismiss
    
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
    
    var body: some View {
        
        VStack{
            VStack(alignment: .center, spacing: 5){
                HStack{
                    Button {
//                        location_overlay.showVeloInput = false
                        dismiss()
                    } label: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            //.background(.ultraThinMaterial)
                            .frame(width: 24, height: 24)
                            .overlay{
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15).bold())
                                    //.padding(5)
                            }
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 10)
                    
                    Spacer()
                    
                }
                
                Text("Out Recorded")
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: 350)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack{
                    Button{
                        add_Strike()
                        back_to_root()
                    } label: {
                        Text("Yes")
                            .font(.system(size: 17, weight: .bold))
                            .frame(maxWidth: 150, maxHeight: 45)
                            .background(button_gradient)
                            .foregroundColor(Color.white)
                            .cornerRadius(8.0)
                    }
                    
                    Button{
                        event.result_detail = "C"
                        reset_Count()
                        back_to_root()
                    } label: {
                        Text("No")
                            .font(.system(size: 17, weight: .bold))
                            .frame(maxWidth: 150, maxHeight: 45)
                            .background(button_gradient)
                            .foregroundColor(Color.white)
                            .cornerRadius(8.0)
                    }
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(.white)
            .background(.regularMaterial)
            .background(Color.black.opacity(0.85))
            .cornerRadius(15)
            .padding(.horizontal, 10)
            
            Spacer()
            
        }
    }
    
    func back_to_root() {
        withAnimation{
            location_overlay.showTabBar = true
            location_overlay.showCurPitchPulse = false
            scoreboard.disable_bottom_row = false
        }
        path.removeAll()
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
//    StrikeoutResultView()
//}
