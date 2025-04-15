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
        case .leanLeft: -0.7
        case .leanRight: 0.7
        case .returnCenter: 0
        }
    }
    
    var xoffset: CGFloat {
        switch self {
        case .leanLeft: -1
        case .leanRight: 1
        case .returnCenter: 0
        }
    }
    
}

struct MainDashboardView: View {
    
    @State private var input_nav_path = [Int]()
    
    @Environment(\.modelContext) private var context
    @Query private var items: [Item]
    
    @State var showSummary: Bool = true
    @State var showGameLog: Bool = false
    
    @State var revealDropdown: Bool = false
    
    @State var side: CGFloat = 112
    
    var test_data_list: [[String]] = [["1", "B. Herrman", "5", "2-1", "Flyout, 1 out"], ["2", "B. Herrman", "7", "3-2", "Groundout, 2 outs"]]
    
    @State var test_pass: [String] = []
    
    @Environment(LocationPopUp.self) var location_overlay
    
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
                        HStack(/*spacing: 20*/){
                            
                            HStack{
                                Text("BALLS")
                                    .font(.system(size: 15))
                                    .bold()
                                HStack(spacing: 5){
                                    Circle()
                                        .stroke(Color.green, lineWidth: light_width)
                                        .fill(.green)
                                        .frame(width: 15, height: 15)
                                    Circle()
                                        .stroke(Color.white, lineWidth: light_width)
                                        .fill(.clear)
                                        .frame(width: 15, height: 15)
                                    Circle()
                                        .stroke(Color.white, lineWidth: light_width)
                                        .fill(.clear)
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
                                        .stroke(Color.red, lineWidth: light_width)
                                        .fill(.red)
                                        .frame(width: 15, height: 15)
                                    Circle()
                                        .stroke(Color.white, lineWidth: light_width)
                                        .fill(.clear)
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
                                        .stroke(Color.red, lineWidth: light_width)
                                        .fill(.red)
                                        .frame(width: 15, height: 15)
                                    Circle()
                                        .stroke(Color.white, lineWidth: light_width)
                                        .fill(.clear)
                                        .frame(width: 15, height: 15)
                                }
                            }
                            
                        }
                        .padding(.horizontal, 15)
                        
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
                        case .returnCenter: .easeIn(duration: 0.1)
                        case .leanLeft: .easeIn(duration: 0.1)
                        case .leanRight: .easeIn(duration: 0.1)
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
                                .background(Color.green)
                                .bold()
                                .cornerRadius(15)
                            }
                            
                            Spacer()
                            
                        }
                        .navigationDestination(for: Int.self) { selection in
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
//                HStack(alignment: .center, spacing: 10){
//                    
//                    Button{
//                        resetNavbarState()
//                        show_home = true
//                    } label: {
//                        ZStack{
//                            Circle()
//                                .fill(show_home ? Color.green : Color.clear)
//                                .frame(width: 35, height: 35)
//                            Image(systemName: "house.fill")
//                                .foregroundStyle(show_home ? Color.white : Color.gray)
//                        }
//                    }
//                    
//                    Button{
//                        resetNavbarState()
//                        show_pitcher_select = true
//                    } label: {
//                        ZStack{
//                            Circle()
//                                .fill(show_pitcher_select ? Color.green : Color.clear)
//                                .frame(width: 35, height: 35)
//                            Image(systemName: "person.fill")
//                                .foregroundStyle(show_pitcher_select ? Color.white : Color.gray)
//                        }
//                    }
//                    
//                    Button{
//                        resetNavbarState()
//                        show_game_report = true
//                    } label: {
//                        ZStack{
//                            Circle()
//                                .fill(show_game_report ? Color.green : Color.clear)
//                                .frame(width: 35, height: 35)
//                            Image(systemName: "chart.bar.xaxis")
//                                .foregroundStyle(show_game_report ? Color.white : Color.gray)
//                        }
//                    }
//                    
//                    Button{
//                        resetNavbarState()
//                        show_saved_games = true
//                    } label: {
//                        ZStack{
//                            Circle()
//                                .fill(show_saved_games ? Color.green : Color.clear)
//                                .frame(width: 35, height: 35)
//                            Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
//                                .foregroundStyle(show_saved_games ? Color.white : Color.gray)
//                        }
//                    }
//                    
//                    Button{
//                        resetNavbarState()
//                        show_settings = true
//                    } label: {
//                        ZStack{
//                            Circle()
//                                .fill(show_settings ? Color.green : Color.clear)
//                                .frame(width: 35, height: 35)
//                            Image(systemName: "gearshape.fill")
//                                .foregroundStyle(show_settings ? Color.white : Color.gray)
//                        }
//                    }
//                }
//                .font(.system(size: 20))
//                .frame(maxWidth: 225, maxHeight: 45)
//                .background(.regularMaterial)
//                .cornerRadius(25)
//                .foregroundStyle(.gray)
                
                
            }
            
//            if location_overlay.showPopUp == true{
//                PitchLocationOverlay()
//                    .padding(.horizontal, 10)
//            }
            
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


