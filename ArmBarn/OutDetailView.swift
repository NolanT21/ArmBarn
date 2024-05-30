//
//  OutDetailVIew.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 11/19/23.
//

import SwiftUI
import SwiftData

struct OutDetailView: View {
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(Event_String.self) var event
    @Environment(PitchTypeConfig.self) var ptconfig
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                ZStack{
                    Image("PLI_Background")
                        .resizable()
                    
                    ForEach(ptconfig.pitch_x_loc.indices, id: \.self){ index in
                        let xloc = ptconfig.pitch_x_loc[index]
                        let yloc = ptconfig.pitch_y_loc[index]
                        let point = CGPoint(x: xloc, y: yloc)
                        let pitch_color = ptconfig.ab_pitch_color[index]
                        Circle()
                            .fill(pitch_color)
                            .stroke(.white, lineWidth: 4)
                            .frame(width: 40, height: 40, alignment: .center)
                            .position(point)
                            .overlay {
                                Text("\(index + 1)")
                                    .foregroundColor(.white)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .position(point)
                            }
                    }
                }
                .blur(radius: 20, opaque: false)
                
                HStack{
                    
                    Spacer()
                    
                    VStack{
                        
                        Spacer()
                        
                        NavigationLink{
                            MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                                event.result_detail = "F"
                                record_Out()
                            }
                        } label: {
                            Text("FLYOUT")
                                .font(.system(size: 22))
                                .fontWeight(.black)
                                .padding(.horizontal, 45.0)
                                .padding(.vertical, 15.0)
                        }
                        .background(Color("ScoreboardGreen"))
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                    
                        NavigationLink{
                            MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                                event.result_detail = "G"
                                record_Out()
                            }
                        } label: {
                            Text("GROUNDOUT")
                                .font(.system(size: 22))
                                .fontWeight(.black)
                                .padding(.horizontal, 15.0)
                                .padding(.vertical, 15.0)
                        }
                        .background(Color("ScoreboardGreen"))
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                        
                        NavigationLink{
                            MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                                event.result_detail = "L"
                                record_Out()
                            }
                        } label: {
                            Text("LINEOUT")
                                .font(.system(size: 22))
                                .fontWeight(.black)
                                .padding(.horizontal, 38.0)
                                .padding(.vertical, 15.0)
                        }
                        .background(Color("ScoreboardGreen"))
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                        
                        NavigationLink{
                            MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                                event.result_detail = "P"
                                record_Out()
                            }
                        } label: {
                            Text("POPOUT")
                            
                                .font(.system(size: 22))
                                .fontWeight(.black)
                                .padding(.horizontal, 40.0)
                                .padding(.vertical, 15.0)
                        }
                        .background(Color("ScoreboardGreen"))
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                        
                        NavigationLink{
                            MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                                event.result_detail = "Y"
                                record_Out()
                            }
                        } label: {
                            Text("SAC BUNT")
                                .font(.system(size: 22))
                                .fontWeight(.black)
                                .padding(.horizontal, 30.0)
                                .padding(.vertical, 15.0)
                        }
                        .background(Color("ScoreboardGreen"))
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                        
                        NavigationLink{
                            MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                                event.result_detail = "O"
                                record_Out()
                            }
                        } label: {
                            Text("OTHER")
                                .font(.system(size: 22))
                                .fontWeight(.black)
                                .padding(.horizontal, 49.0)
                                .padding(.vertical, 15.0)
                        }
                        .background(Color("ScoreboardGreen"))
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                        
                        Spacer()
                        
                    }
                    
                    Spacer()
                    
                }
                
            }
            .background(.black)
            .ignoresSafeArea()
                
                
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
    
    func print_Scoreboard() {
        print("Strikes: ", scoreboard.strikes, "Balls: ", scoreboard.balls, "Outs: ", scoreboard.outs)
    }
}

#Preview {
    OutDetailView()
        .environment(Scoreboard())
        .environment(Event_String())
        .environment(PitchTypeConfig())
}
