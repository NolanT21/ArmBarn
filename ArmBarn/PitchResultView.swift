//
//  PitchResultView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 11/7/23.
//

import SwiftUI
import SwiftData
import Observation

struct PitchResultView: View {

    @Environment(Scoreboard.self) var scoreboard
    @Environment(Event_String.self) var event
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(currentPitcher.self) var current_pitcher
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    
    @Query var events: [Event]
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State private var showFoulBall = false
    @State private var showOutRecorded = false
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                VStack{
                    NavigationLink(destination: MainContainerView().navigationBarBackButtonHidden(true).onAppear {
                            add_Ball()
                    }) {
                        Text("Ball")
                    }
                    .padding(.horizontal, 45.0)
                    .padding(.vertical, 15.0)
                    .background(Color.orange)
                    .foregroundColor(Color.white)
                    .cornerRadius(8.0)
                    
                    
                    Button(action: {
                        showFoulBall = true
                        event.result_detail = "N"
                    }) {
                        Text("Strike")
                    }
                    //.padding(.horizontal, 30.0)
                    .background(Color.orange)
                    .foregroundColor(Color.white)
                    .cornerRadius(8.0)
                    .alert ("Foul Ball?", isPresented: $showFoulBall) {
                        NavigationLink(destination: MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                                event.pitch_result = "T"
                                add_Strike()
                            }){
                                Text("Yes")
                            }
                        
                        if scoreboard.strikes < 2 {
                            NavigationLink(destination: MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                                    event.pitch_result = "Z"
                                    if scoreboard.strikes == 2 {
                                        showOutRecorded = true
                                    }
                                    else {
                                        add_Strike()
                                    }
                                }){
                                    Text("No")
                                }
                        }
                        else {
                            Button(action: {
                                showOutRecorded = true
                            }) {
                                Text("No")
                            }
                        }
                        
                           
                    }
                    .alert ("Out Recorded?", isPresented: $showOutRecorded) {
                        NavigationLink(destination: MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                                event.pitch_result = "Z"
                                event.result_detail = "K"
                                add_Strike()
                            }){
                                Text("Yes")
                            }
                        NavigationLink(destination: MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                                event.pitch_result = "Z"
                                event.result_detail = "C"
                                reset_Count()
                            }){
                                Text("No")
                            }
                    }
                    .padding(.horizontal, 38.0)
                    .padding(.vertical, 15.0)
                    .background(Color.orange)
                    .foregroundColor(Color.white)
                    .cornerRadius(8.0)
                    
                    
                    NavigationLink(destination: HitDetailView().navigationBarBackButtonHidden(true).onAppear{
                        //record_Hit()
                    }){
                        Text("Hit")
                    }
                    .padding(.horizontal, 49.0)
                    .padding(.vertical, 15.0)
                    .background(Color.orange)
                    .foregroundColor(Color.white)
                    .cornerRadius(8.0)
                    
                    
                    NavigationLink(destination: OutDetailView().navigationBarBackButtonHidden(true).onAppear{
                        //record_Out()
                    }){
                        Text("Out")
                    }
                    .padding(.horizontal, 46.0)
                    .padding(.vertical, 15.0)
                    .background(Color.orange)
                    .foregroundColor(Color.white)
                    .cornerRadius(8.0)
                }
                
            }
            .navigationTitle("")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("ScoreboardGreen"))
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    
                    HStack{

                        Button(action: {
                            event.pitch_result = "NONE"
                            back_func()
                            dismiss()
                            
                            //print("dismiss")
                            //print("\(event.balls), \(event.strikes), \(event.outs)")
                            
                        }) {
                            Image(systemName: "chevron.left")
                                .frame(width: sbl_width, height: sbl_height)
                                .foregroundColor(.white)
                                .bold()
                            Text("BACK")
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                //.font(weight: .semibold)
                        }
                    }
                }
                
                ToolbarItemGroup(placement: .principal) {
                    HStack(alignment: .center){
                        Text("P")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        ZStack(alignment: .leading){
                            //Rectangle()
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundStyle(
                                    Color("ScoreboardGreen").shadow(.inner(color: .black.opacity(0.4), radius: 2, x: 1, y: 1))
                                )
                                .frame(width: 180, height: 30)

                            Text(current_pitcher.lastName)
                                .textCase(.uppercase)
                                .font(.system(size: 20))
                                .fontWeight(.black)
                                .foregroundColor(.white)
                                .padding(.leading,  5)
                                
                        }
                        
                    }
                }
            
            }
            
        }
        
    }
    
    func back_func() {
        
        //context.delete(events[events.count - 1])
        event.recordEvent = false
        scoreboard.update_scoreboard = false
        
        ptconfig.pitch_x_loc.removeLast()
        ptconfig.pitch_y_loc.removeLast()
        ptconfig.ab_pitch_color.removeLast()
        ptconfig.pitch_cur_ab -= 1
        ptconfig.ptcolor = .clear
        
        if scoreboard.balls == 1 {
            scoreboard.b1light = .blue
        }
        if scoreboard.balls == 2 {
            scoreboard.b2light = .blue
        }
        if scoreboard.balls == 3 {
            scoreboard.b3light = .blue
        }
        
        if scoreboard.strikes == 1 {
            scoreboard.s1light = .yellow
        }
        if scoreboard.strikes == 2 {
            scoreboard.s2light = .yellow
        }
        
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
                scoreboard.b1light = .blue
            }
            if scoreboard.balls == 2 {
                scoreboard.b2light = .blue
            }
            if scoreboard.balls == 3 {
                scoreboard.b3light = .blue
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
                    scoreboard.o1light = .black
                    scoreboard.o2light = .black
                }
                if scoreboard.outs == 1 {
                    scoreboard.o1light = .red
                }
                if scoreboard.outs == 2 {
                    scoreboard.o2light = .red
                }
            }
            
            if scoreboard.strikes == 1 {
                scoreboard.s1light = .yellow
            }
            if scoreboard.strikes == 2 {
                scoreboard.s2light = .yellow
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
    PitchResultView()
        .environment(Scoreboard())
        .environment(Event_String())
        .environment(PitchTypeConfig())
}
