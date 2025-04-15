//
//  ContentView.swift
//  Sandbox
//
//  Created by Nolan Thompson on 1/28/25.
//

import SwiftUI
import SwiftData
import Foundation

enum ShakeAnimation: CaseIterable {
    case leanLeft, leanRight, returnCenter
    
    var rotationDegrees: CGFloat {
        switch self {
        case .leanLeft: -0.5
        case .leanRight: 0.5
        case .returnCenter: 0
        }
    }
    
    var xoffset: CGFloat {
        switch self {
        case .leanLeft: -1.5
        case .leanRight: 1.5
        case .returnCenter: 0
        }
    }
    
}

struct MainDashboardView: View {
    
    @State private var input_nav_path = [Int]()
    
    @Environment(\.modelContext) private var context
    
    @State var showSummary: Bool = true
    @State var showGameLog: Bool = false
    
    @State var revealDropdown: Bool = false
    
    @State var side: CGFloat = 112
    
    var test_data_list: [[String]] = [["1", "B. Herrman", "5", "2-1", "Flyout, 1 out"], ["2", "B. Herrman", "7", "3-2", "Groundout, 2 outs"]]
    
    @State var test_pass: [String] = []
    
    @Environment(Event_String.self) var event
    @Environment(Scoreboard.self) var scoreboard
    @Environment(LocationOverlay.self) var location_overlay
    
    @State var main_body_padding: CGFloat = 10
    @State var light_width : CGFloat = 1.5
    
    @State private var show_navbar: Bool = true
    
    @State private var show_home: Bool = true
    @State private var show_pitcher_select: Bool = false
    @State private var show_game_report: Bool = false
    @State private var show_saved_games: Bool = false
    @State private var show_settings: Bool = false
    
    @State var location: CGPoint = .zero
    @State var cur_pitch_fill: Color = .clear
    @State var cur_pitch_outline: Color = .clear
    
    @State var red_light_color: Color = .red
    @State var green_light_color: Color = Color("ScoreboardGreen")
    
    var tap: some Gesture {
        SpatialTapGesture()
            .onEnded { click in
                location = click.location
                cur_pitch_fill = Color.blue
                cur_pitch_outline = .white
                //print("\(click)")
             }
    }
    
    var body: some View {
        
        ZStack{
            
            VStack(spacing: 10){
                
                //"Scoreboard"
                ZStack{
                    VStack(spacing: 10){
                        
                        //Top Row
                        HStack{
                            
                            HStack{
                                Text("BALLS")
                                    .font(.system(size: 15))
                                    .bold()
                                HStack(spacing: 5){
                                    Circle()
                                        .stroke(scoreboard.b1light ? green_light_color : Color.white, lineWidth: light_width)
                                        .fill(scoreboard.b1light ? green_light_color : Color.clear)
                                        .frame(width: 15, height: 15)
                                    Circle()
                                        .stroke(scoreboard.b2light ? green_light_color : Color.white, lineWidth: light_width)
                                        .fill(scoreboard.b2light ? green_light_color : Color.clear)
                                        .frame(width: 15, height: 15)
                                    Circle()
                                        .stroke(scoreboard.b3light ? green_light_color : Color.white, lineWidth: light_width)
                                        .fill(scoreboard.b3light ? green_light_color : Color.clear)
                                        .frame(width: 15, height: 15)
                                }
                            }
                            
                            Spacer()
                            
                            HStack{
                                Text("STRIKES")
                                    .font(.system(size: 15))
                                    .bold()
                                HStack(spacing: 5){
                                    Circle()
                                        .stroke(scoreboard.s1light ? red_light_color : Color.white, lineWidth: light_width)
                                        .fill(scoreboard.s1light ? red_light_color : Color.clear)
                                        .frame(width: 15, height: 15)
                                    Circle()
                                        .stroke(scoreboard.s2light ? red_light_color : Color.white, lineWidth: light_width)
                                        .fill(scoreboard.s2light ? red_light_color : Color.clear)
                                        .frame(width: 15, height: 15)
                                }
                            }
                            
                            Spacer()
                            
                            HStack{
                                Text("OUTS")
                                    .font(.system(size: 15))
                                    .bold()
                                HStack(spacing: 5){
                                    Circle()
                                        .stroke(scoreboard.o1light ? red_light_color : Color.white, lineWidth: light_width)
                                        .fill(scoreboard.o1light ? red_light_color : Color.clear)
                                        .frame(width: 15, height: 15)
                                    Circle()
                                        .stroke(scoreboard.o2light ? red_light_color : Color.white, lineWidth: light_width)
                                        .fill(scoreboard.o2light ? red_light_color : Color.clear)
                                        .fill(.clear)
                                        .frame(width: 15, height: 15)
                                }
                            }
                            
                        }
                        .padding(.horizontal, 15)
                        .frame(maxWidth: 400)
                        
                        //Bottom Row
                        HStack{
                            
                            HStack{
                                VStack(alignment: .center, spacing: 2){
                                    Text("INN")
                                    Text("1")
                                }
                                .font(.system(size: 15))
                                .bold()
                                
                                Divider()
                                    .frame(height: 35)
                                
                                VStack(alignment: .leading, spacing: 2){
                                    Text("Brent Herrman")
                                        .font(.system(size: 17))
                                        .bold()
                                    HStack{
                                        Text("Pitches: 52")
                                        Text("Batters Faced: 11")
                                    }
                                    .font(.system(size: 11))
                                    .foregroundStyle(.gray)
                                }
                                
                                
                            }
                            .padding(.leading, 20)
                            
                            Spacer()
                            
                            HStack(alignment: .bottom, spacing: 10){
                                Button{
                                    
                                } label: {
                                    Image(systemName: "flag.pattern.checkered")
                                        .font(.system(size: 18))
                                        .frame(width: 30, height: 30)
                                    
                                }
                                .background(Color.gray)
                                .foregroundColor(Color.white)
                                .cornerRadius(8.0)
                                
                                Button{
                                    
                                } label: {
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.system(size: 18))
                                        .frame(width: 30, height: 30)
                                        .bold()
                                    
                                }
                                .background(Color.gray)
                                .foregroundColor(Color.white)
                                .cornerRadius(8.0)
                                
                            }
                            .padding(.trailing, 15)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 90)
                    .background(.regularMaterial)
                    .cornerRadius(15)
                    .padding(.horizontal, main_body_padding)
                    
                    Rectangle()
                        .fill(location_overlay.showinputoverlay ? Color.black.opacity(0.8): Color.clear)
                        .frame(maxWidth: .infinity, maxHeight: 90)
                    
                }
                
                
                Image("Background2.0")
                    .resizable()
                    .frame(maxHeight: 480, alignment: .bottom)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
                    .padding(.horizontal, main_body_padding)
                    .gesture(tap)
                    .overlay{
                        if location_overlay.showinputoverlay{
                            Circle()
                                .stroke(cur_pitch_outline, lineWidth: 4)
                                .fill(cur_pitch_fill)
                                .frame(width: 22.0, height: 22.0, alignment: .center)
                                .position(location)
                        }
                        
                    }
                    .phaseAnimator([ShakeAnimation.returnCenter, ShakeAnimation.leanLeft, ShakeAnimation.leanRight, ShakeAnimation.leanLeft, ShakeAnimation.returnCenter], trigger: location_overlay.shakecounter) { content, phase in
                        
                        content
                            .offset(x: phase.xoffset)
                            .rotationEffect(.degrees(phase.rotationDegrees))
                        
                        
                    } animation: { phase in
                        switch phase {
                        case .returnCenter: .easeIn(duration: 0.05)
                        case .leanLeft: .easeIn(duration: 0.05)
                        case .leanRight: .easeIn(duration: 0.05)
                        }
                    }
                
                
                //.clipped()
                
                VStack{
                    
                    NavigationStack(path: $input_nav_path){
                        VStack{
                            
                            Button{
                                show_navbar = false
                                input_nav_path.append(1)
                            } label: {
                                HStack(spacing: 5){
                                    Text("Enter Pitch")
                                        .padding(.leading, 10)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .padding(.trailing, 10)
                                }
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .foregroundStyle(.white)
                                .background(Color("ScoreboardGreen"))
                                .bold()
                                .cornerRadius(15)
                            }
                            
                            Spacer()
                            
                        }
                        .navigationDestination(for: Int.self) { selection in
                            //PitchTypeSelectView(path: $input_nav_path)
                            PitchTypeSelectView(path: $input_nav_path)
                                .navigationBarBackButtonHidden(true).preferredColorScheme(.dark)
                        }
                        
                        Spacer()
                        
                    }
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: 180)
                    .padding(.horizontal, main_body_padding)
                    .padding(.top, 10)
                    
                }
                
                Spacer()
                
                
            }
            .background(Color.black)
            
            //NavBar
        }
            
    }
    
    func resetNavbarState() {
        show_home = false
        show_pitcher_select = false
        show_game_report = false
        show_saved_games = false
        show_settings = false
    }
    
}

//#Preview {
//    PitchLocationView()
//        .modelContainer(for: Item.self, inMemory: true)
//}


