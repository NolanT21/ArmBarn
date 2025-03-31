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
    
    @Binding var path: [Int]
    
    @AppStorage("StrikeType") var ASStrikeType : Bool?
    @AppStorage("VelocityInput") var ASVeloInput : Bool?

    @Environment(Scoreboard.self) var scoreboard
    @Environment(Event_String.self) var event
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(currentPitcher.self) var current_pitcher
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    
    @Query(sort: \Event.event_number) var events: [Event]
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @State private var showVeloInput: Bool = true
    @State private var showOutRecorded: Bool = false
    
    @State private var showPitchResult = true
    @State private var showHitResult = false
    @State private var showOutResult = false
    
    @State private var result_detail: String = ""
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    var body: some View {
        
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
            
            if showPitchResult == true {
                HStack{
                    
                    Spacer()
                    
                    VStack{
                        
                        Spacer()
                        
//                            NavigationLink {
//                                MainContainerView().navigationBarBackButtonHidden(true).onAppear {
//                                    add_Ball()
//                                }
                        Button {
                            add_Ball()
                            path.removeAll()
                        } label: {
                            Text("BALL")
                                .font(.system(size: 22))
                                .fontWeight(.black)
                                .padding(.horizontal, 53.0)
                                .padding(.vertical, 15.0)
                        }
                        .foregroundColor(Color.white)
                        .background(Color("ScoreboardGreen"))
                        .cornerRadius(8.0)
                        
                        if scoreboard.strikes < 2 {
                            if ASStrikeType == true {
                                Button {
                                    
                                    event.pitch_result = "L"
                                    event.result_detail = "N"
                                    add_Strike()
                                    
                                    path.removeAll()
                                    
                                } label: {
                                    HStack{
                                        Text("K")
                                            //.rotationEffect(.degrees(-180))
                                            .font(.system(size: 22))
                                            .fontWeight(.black)
                                        
                                         Text("- CALLED")
                                            .font(.system(size: 22))
                                            .fontWeight(.black)
                                    }
                                    .padding(.horizontal, 18.0)
                                    .padding(.vertical, 15.0)
                                }
                                .foregroundColor(Color.white)
                                .background(Color("ScoreboardGreen"))
                                .cornerRadius(8.0)
                            }
                            
                            Button {
                                
                                event.pitch_result = "Z"
                                event.result_detail = "N"
                                add_Strike()
                                
                                path.removeAll()
                                
                            } label: {
                                if ASStrikeType == true {
                                    Text("K - SWINGING")
                                        .font(.system(size: 22))
                                        .fontWeight(.black)
                                        .padding(.horizontal, 5.0)
                                        .padding(.vertical, 15.0)
                                } else {
                                    Text("STRIKE")
                                        .font(.system(size: 22))
                                        .fontWeight(.black)
                                        .padding(.horizontal, 40.0)
                                        .padding(.vertical, 15.0)
                                }
                                
                            }
                            .foregroundColor(Color.white)
                            .background(Color("ScoreboardGreen"))
                            .cornerRadius(8.0)
                            
                        }
                        else {
                            if ASStrikeType == true {
                                Button(action: {
                                    event.pitch_result = "L"
                                    result_detail = "M"
                                    
                                    if scoreboard.strikes == 2 {
                                        showOutRecorded = true

                                    }
                                    else {
                                        add_Strike()
                                    }
                                }) {
                                    HStack{
                                        Text("K")
                                            //.rotationEffect(.degrees(-180))
                                            .font(.system(size: 22))
                                            .fontWeight(.black)
                                        
                                         Text("- CALLED")
                                            .font(.system(size: 22))
                                            .fontWeight(.black)
                                    }
                                    .padding(.horizontal, 18.0)
                                    .padding(.vertical, 15.0)
                                }
                                .background(Color("ScoreboardGreen"))
                                .foregroundColor(Color.white)
                                .cornerRadius(8.0)
                            }
                            

                            Button(action: {
                                event.pitch_result = "Z"
                                result_detail = "K"
                                if scoreboard.strikes == 2 {
                                    showOutRecorded = true
                                }
                                else {
                                    add_Strike()
                                }
                            }) {
                                if ASStrikeType == true {
                                    HStack{
                                        Text("K - SWINGING")
                                            .font(.system(size: 22))
                                            .fontWeight(.black)
                                            .padding(.horizontal, 5.0)
                                            .padding(.vertical, 15.0)
                                        
                                    }
                                    .foregroundColor(Color.white)
                                    .background(Color("ScoreboardGreen"))
                                    .cornerRadius(8.0)
                                }
                                else {
                                    HStack{
                                        Text("STRIKE")
                                            .font(.system(size: 22))
                                            .fontWeight(.black)
                                            .padding(.horizontal, 40.0)
                                            .padding(.vertical, 15.0)
                                        
                                    }
                                    .foregroundColor(Color.white)
                                    .background(Color("ScoreboardGreen"))
                                    .cornerRadius(8.0)
                                }
                                
                                
                            }
                            .background(Color("ScoreboardGreen"))
                            .foregroundColor(Color.white)
                            .cornerRadius(8.0)
                        }
                        
                        Button {
                            event.pitch_result = "T"
                            event.result_detail = "N"
                            add_Strike()
                            
                            path.removeAll()
                            
                        } label: {
                            Text("FOUL BALL")
                                .font(.system(size: 22))
                                .fontWeight(.black)
                                .padding(.vertical, 15.0)
                                .padding(.horizontal, 20.0)
                        }
                        .background(Color("ScoreboardGreen"))
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                        
                        NavigationLink {
                            HitDetailView(path: $path).navigationBarBackButtonHidden(true)
                        } label: {
                            Text("HIT")
                                .font(.system(size: 22))
                                .fontWeight(.black)
                                .padding(.horizontal, 60.0)
                                .padding(.vertical, 15.0)
                        }
                        .background(Color("ScoreboardGreen"))
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                        
                        NavigationLink {
                            OutDetailView(path: $path).navigationBarBackButtonHidden(true)
//                                withAnimation{
//                                    showPitchResult = false
//                                    showOutResult = true
//                                }
                        } label: {
                            Text("OUT")
                                .font(.system(size: 22))
                                .fontWeight(.black)
                                .padding(.horizontal, 55.0)
                                .padding(.vertical, 15.0)
                        }
                        .background(Color("ScoreboardGreen"))
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                        
                        Button {
                            event.result_detail = "B"
                            record_HBP()
                            
                            path.removeAll()
                            
                        } label: {
                            Text("HIT BY PITCH")
                                .font(.system(size: 22))
                                .fontWeight(.black)
                                .padding(.horizontal, 5.0)
                                .padding(.vertical, 15.0)
                        }
                        .background(Color("ScoreboardGreen"))
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                        
                        Spacer()
                        
                    }
                    
                    Spacer()
                    
                }
                .transition(.opacity)
            }
//                else if showHitResult == true {
//                    HitDetailView()
//                        .transition(.opacity)
//                }
//                else if showOutResult == true {
//                    OutDetailView()
//                        .transition(.opacity)
//                }
            
            if showOutRecorded == true{
                StrikeoutAlertView(path: $path, isActive: $showOutRecorded, result_detail: result_detail)
            }
            
            if showVeloInput == true && ASVeloInput == true{
                VelocityInputView(isActive: $showVeloInput, close_action: {showVeloInput = false})
                    .preferredColorScheme(.dark)
            }

        }
        .background(.black)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea()
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color("ScoreboardGreen"))
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                
                HStack{

                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        event.pitch_result = "NONE"
                        if showHitResult == true {
                            withAnimation{
                                showHitResult = false
                                showPitchResult = true
                            }
                        }
                        else if showOutResult == true {
                            withAnimation{
                                showOutResult = false
                                showPitchResult = true
                            }
                        }
                        else if showOutRecorded == true {
                            showOutRecorded = false
                        }
                        else if showVeloInput == false{
                            showVeloInput = true
                        }
                        else {
                            back_func()
                            dismiss()
                        }
                        
                    }) {
                        Image(systemName: "chevron.left")
                            .imageScale(.medium)
                            .font(.system(size: 17))
                            .frame(width: sbl_width, height: sbl_height)
                            .foregroundColor(.white)
                            .bold()
                        Text("BACK")
                            .font(.system(size: 17))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding(.leading, -5)
                    }
                    .padding(.leading, -5)
                }
            }
            
            ToolbarItemGroup(placement: .principal) {
                HStack(alignment: .center){
                    Text("P")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(
                                Color("ScoreboardGreen").shadow(.inner(color: .black.opacity(0.4), radius: 2, x: 1, y: 1))
                            )
                            .frame(width: 170, height: 30)
                        
                        let pitcher_lname = String(current_pitcher.lastName.prefix(11))

                        Text(pitcher_lname)
                            .textCase(.uppercase)
                            .font(.system(size: 20))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .padding(.leading,  4)
                    }
                }
            }
        }
        
    }
    
    func back_func() {
        
        event.recordEvent = false
        scoreboard.update_scoreboard = false
        
        ptconfig.pitch_x_loc.removeLast()
        ptconfig.pitch_y_loc.removeLast()
        ptconfig.ab_pitch_color.removeLast()
        ptconfig.pitch_cur_ab -= 1
        ptconfig.ptcolor = .clear
        
        if scoreboard.balls == 1 {
            scoreboard.b1light = true
        }
        if scoreboard.balls == 2 {
            scoreboard.b2light = true
        }
        if scoreboard.balls == 3 {
            scoreboard.b3light = true
        }
        
        if scoreboard.strikes == 1 {
            scoreboard.s1light = true
        }
        if scoreboard.strikes == 2 {
            scoreboard.s2light = true
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
    
    func record_HBP() {
        event.pitch_result = "H"
        event.balls = scoreboard.balls
        event.strikes = scoreboard.strikes
        event.outs = scoreboard.outs
        event.inning = scoreboard.inning
        event.atbats = scoreboard.atbats
        
        if scoreboard.update_scoreboard {
            scoreboard.pitches += 1
            scoreboard.atbats += 1
            scoreboard.baserunners += 1
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

//#Preview {
//    PitchResultView()
//        .environment(Scoreboard())
//        .environment(Event_String())
//        .environment(PitchTypeConfig())
//}
