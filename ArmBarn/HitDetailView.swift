//
//  HitDetailView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 11/19/23.
//

import SwiftUI
import SwiftData

struct HitDetailView: View {
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(Event_String.self) var event
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(currentPitcher.self) var current_pitcher
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
                VStack{
                    
                    NavigationLink(destination: MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                        event.result_detail = "S"
                        record_Hit()
                        }){
                        Text("Single")
                    }
                    .padding(.horizontal, 45.0)
                    .padding(.vertical, 15.0)
                    .background(Color.orange)
                    .foregroundColor(Color.white)
                    .cornerRadius(8.0)
                
                    NavigationLink(destination: MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                        event.result_detail = "D"
                        record_Hit()
                        }){
                        Text("Double")
                    }
                    .padding(.horizontal, 38.0)
                    .padding(.vertical, 15.0)
                    .background(Color.orange)
                    .foregroundColor(Color.white)
                    .cornerRadius(8.0)
                    
                    NavigationLink(destination: MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                        event.result_detail = "T"
                        record_Hit()
                        }){
                        Text("Triple")
                    }
                    .padding(.horizontal, 45.0)
                    .padding(.vertical, 15.0)
                    .background(Color.orange)
                    .foregroundColor(Color.white)
                    .cornerRadius(8.0)
                    
                    NavigationLink(destination: MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                        event.result_detail = "H"
                        record_Hit()
                        }){
                        Text("Homerun")
                    }
                    .padding(.horizontal, 30.0)
                    .padding(.vertical, 15.0)
                    .background(Color.orange)
                    .foregroundColor(Color.white)
                    .cornerRadius(8.0)
                    
                    NavigationLink(destination: MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                        event.result_detail = "E"
                        record_Hit()
                        }){
                        Text("Error")
                    }
                    .padding(.horizontal, 46.0)
                    .padding(.vertical, 15.0)
                    .background(Color.orange)
                    .foregroundColor(Color.white)
                    .cornerRadius(8.0)
                    
                    NavigationLink(destination: MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                        event.result_detail = "B"
                        record_Hit()
                        }){
                        Text("Hit By Pitch")
                    }
                    .padding(.horizontal, 20.0)
                    .padding(.vertical, 15.0)
                    .background(Color.orange)
                    .foregroundColor(Color.white)
                    .cornerRadius(8.0)
                }
                .navigationTitle("")
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.green)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        
                        
                        HStack{
                            
                            Button(action: {
                                ptconfig.pitch_x_loc.removeLast()
                                ptconfig.pitch_y_loc.removeLast()
                                ptconfig.ab_pitch_color.removeLast()
                                ptconfig.pitch_cur_ab -= 1
                                dismiss()
                                print("dismiss")
                            }) {
                                Image(systemName: "chevron.left")
                                    .frame(width: sbl_width, height: sbl_height)
                                    .foregroundColor(.white)
                                    .bold()
                                Text("Back")
                                    .imageScale(.large)
                                    .foregroundColor(.white)
                                    .bold()
                                    //.font(weight: .semibold)
                            }
                                //.font(weight: .semibold)
                            
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            Spacer()
                            
                            HStack{
                                Text("P")
                                    .bold()
                                    .foregroundColor(Color.white)
                                
                                Spacer()
                                
                                Menu(content: {
                                    ForEach(pitchers) { value in
                                        Button(value.lastName) {
                                            current_pitcher.pitch_num = 0
                                            current_pitcher.firstName = value.firstName
                                            current_pitcher.lastName = value.lastName
                                            current_pitcher.pitch1 = value.pitch1
                                            if current_pitcher.pitch1 != "None" {
                                                current_pitcher.pitch_num += 1
                                                current_pitcher.arsenal[0] = value.pitch1
                                            }
                                            
                                            current_pitcher.pitch2 = value.pitch2
                                            if current_pitcher.pitch2 != "None" {
                                                current_pitcher.pitch_num += 1
                                                current_pitcher.arsenal[1] = value.pitch2
                                            }
                                            
                                            current_pitcher.pitch3 = value.pitch3
                                            if current_pitcher.pitch3 != "None" {
                                                current_pitcher.pitch_num += 1
                                                current_pitcher.arsenal[2] = value.pitch3
                                            }
                                            
                                            current_pitcher.pitch4 = value.pitch4
                                            if current_pitcher.pitch4 != "None" {
                                                current_pitcher.pitch_num += 1
                                                current_pitcher.arsenal[3] = value.pitch4
                                            }
                                        }
                                        
                                    }
                                    
                                }, label: {
                                    if pitchers.count <= 0 {
                                        Text("Add Pitcher")
                                    }
                                    else {
                                        Text(current_pitcher.lastName)
                                    }
                                    
                                })
                                .foregroundColor(Color.white)
                                .bold()
                            }
                        }
                    }
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        HStack{
                            Image(systemName: "square.and.arrow.up")
                                .frame(width: sbl_width, height: sbl_height)
                                .foregroundColor(Color.white)
                            
                            Spacer()
                            
                            Image(systemName: "flag.checkered")
                                .frame(width: sbl_width, height: sbl_height)
                                .foregroundColor(Color.white)
                            
                            Spacer()
                            
                            Image(systemName: "gearshape.fill")
                                .frame(width: sbl_width, height: sbl_height)
                                .foregroundColor(Color.white)
                            
                        }
                    }
                
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
            
            reset_Count()
        }
        
        //print_Scoreboard()
    }
    
    func reset_Count() {
        scoreboard.balls = 0
        scoreboard.strikes = 0
        
        ptconfig.pitch_x_loc.removeAll()
        ptconfig.pitch_y_loc.removeAll()
        ptconfig.ab_pitch_color.removeAll()
        ptconfig.pitch_cur_ab = 0
        
        scoreboard.b1light = .black
        scoreboard.b2light = .black
        scoreboard.b3light = .black
        
        scoreboard.s1light = .black
        scoreboard.s2light = .black
    }
    
    func print_Scoreboard() {
        print("Strikes: ", scoreboard.strikes, "Balls: ", scoreboard.balls, "Outs: ", scoreboard.outs)
    }
    
}

#Preview {
    HitDetailView()
        .environment(Scoreboard())
        .environment(Event_String())
        .environment(PitchTypeConfig())
}
