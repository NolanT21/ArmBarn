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
                                event.pitch_result = "K"
                                add_Strike()
                            }){
                                Text("Yes")
                            }
                        NavigationLink(destination: MainContainerView().navigationBarBackButtonHidden(true).onAppear{
                                event.pitch_result = "C"
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

                if scoreboard.baserunners > 0 {
                    VStack {
                        Spacer()
                            .frame(height: 50)
                        HStack {
                            
                            Spacer()
                            
                            NavigationLink(destination: PitchLocationView().navigationBarBackButtonHidden(true).onAppear{
                                record_baserunner_out()
                            }){
                                Text("Baserunner Out")
                            }
                            .padding(12.0)
                            .foregroundColor(Color.white)
                            .background(Color.orange)
                            .cornerRadius(8.0)
                        }
                        Spacer()
                    }
                }
                
            }
            .navigationTitle("")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.green)
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
                            Text("Back")
                                .imageScale(.large)
                                .foregroundColor(.white)
                                //.font(weight: .semibold)
                        }
                        
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
    
    func back_func() {
        
        //context.delete(events[events.count - 1])
        event.recordEvent = false
        
        ptconfig.pitch_x_loc.removeLast()
        ptconfig.pitch_y_loc.removeLast()
        ptconfig.ab_pitch_color.removeLast()
        ptconfig.pitch_cur_ab -= 1
        ptconfig.ptcolor = .clear
        
        //print(event.balls)
        
        scoreboard.balls = event.balls
        scoreboard.strikes = event.strikes
        scoreboard.outs = event.outs
        scoreboard.atbats = event.atbats
        scoreboard.inning = event.inning
        if scoreboard.pitches > 0 {
            scoreboard.pitches -= 1
        }
        
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
    
        //print_Scoreboard()
        
    }
    
    func add_Strike() {
        event.balls = scoreboard.balls
        event.strikes = scoreboard.strikes
        event.outs = scoreboard.outs
        event.inning = scoreboard.inning
        event.atbats = scoreboard.atbats
        
        scoreboard.pitches += 1
        scoreboard.strikes += 1
        
        if scoreboard.strikes == 3 {
            if event.result_detail == "C"{
                scoreboard.atbats += 1
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
    
    func record_baserunner_out() {
        event.pitch_result = "O"
        event.result_detail = "R"
        event.balls = scoreboard.balls
        event.strikes = scoreboard.strikes
        event.outs = scoreboard.outs
        event.inning = scoreboard.inning
        event.atbats = scoreboard.atbats
        
        scoreboard.outs += 1
        
        scoreboard.baserunners -= 1
        
        if scoreboard.outs == 1 {
            scoreboard.o1light = .red
        }
        if scoreboard.outs == 2 {
            scoreboard.o2light = .red
        }
        
        if scoreboard.outs == 3 {
            scoreboard.outs = 0
            scoreboard.inning += 1
            scoreboard.baserunners = 0
            scoreboard.o1light = .black
            scoreboard.o2light = .black
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
