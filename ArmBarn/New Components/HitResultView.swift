//
//  HitResultView.swift
//  Sandbox
//
//  Created by Nolan Thompson on 1/28/25.
//

import SwiftUI

struct HitResultView: View {
    
    @Binding var path: [Int]

    @Environment(Event_String.self) var event
    @Environment(Scoreboard.self) var scoreboard
    @Environment(LocationOverlay.self) var location_overlay
    @Environment(\.dismiss) private var dismiss
    
    @State private var button_color: Color = Color("ScoreboardGreen")
    
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
                                record_Hit()
                                path.removeAll()
                            } label: {
                                Text("Single")
                                    .font(.system(size: 17, weight: .bold))
                                    .frame(maxWidth: .infinity, maxHeight: 45)
                                    .background(button_color)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(8.0)
                            }
                            
                            Button {
                                record_Hit()
                                path.removeAll()
                            } label: {
                                Text("Double")
                                    .font(.system(size: 17, weight: .bold))
                                    .frame(maxWidth: .infinity, maxHeight: 45)
                                    .background(button_color)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(8.0)
                            }
                                            
                        }
                        
                        HStack(spacing: 12){
                            Button {
                                record_Hit()
                                path.removeAll()
                            } label: {
                                Text("Triple")
                                    .font(.system(size: 17, weight: .bold))
                            }
                            .frame(maxWidth: .infinity, maxHeight: 45)
                            .background(button_color)
                            .foregroundColor(Color.white)
                            .cornerRadius(8.0)
                            
                            Button {
                                record_Hit()
                                path.removeAll()
                            } label: {
                                Text("Homerun")
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
            }
            .ignoresSafeArea()
            .background(.regularMaterial)
            .cornerRadius(15)
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
//    HitResultView()
//}
