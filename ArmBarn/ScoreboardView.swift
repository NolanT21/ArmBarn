//
//  ScoreboardView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 12/27/23.
//

import SwiftData
import SwiftUI
import Observation

struct ScoreboardView: View {
    
    @Environment(Scoreboard.self) var scoreboard
    
    @State var sbl_size: Double = 20.0
    @State var crnr_radius: CGFloat = 4
    @State var font_size: CGFloat = 20.0
    @State var light_radius: CGFloat = 3
    @State var light_background: Color = .black
    
    @State var hidepitchnum: Bool = false
    @State var hideatbats: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack{
                    Text("INN")
                        .font(.system(size: font_size))
                        .fontWeight(.bold)
                    ZStack(alignment: .center){
                        //Rectangle()
                        RoundedRectangle(cornerRadius: crnr_radius)
                            .foregroundStyle(
                                Color("ScoreboardGreen").shadow(.inner(color: .black.opacity(0.4), radius: 2, x: 1, y: 1))
                            )
                            .frame(width: 30, height: 30)
                        
                        Text(String(scoreboard.inning))
                            .font(.system(size: font_size))
                            .fontWeight(.black)
                    }
                    .padding(.top, -10)
                    
                }
                .padding(.top, 5)
                
                Spacer()
                
                HStack{
                    Spacer()
                    VStack{
                        Text("BALLS")
                            .font(.system(size: font_size))
                            .fontWeight(.bold)
                        HStack(spacing: 2.0){
                            
                            ZStack{
                                
                                Ellipse()
                                    .fill(light_background)
                                    .frame(width: sbl_size, height: sbl_size)
                                
                                if scoreboard.b1light == true {
                                    Ellipse()
                                        .fill(Color("LightBeam"))
                                        .frame(width: sbl_size, height: sbl_size)
                                        .blur(radius: light_radius)
                                }
                                Ellipse()
                                    .fill(Color("BlueLight"))
                                    .frame(width: sbl_size, height: sbl_size)
                            }
                            
                            ZStack{
                                
                                Ellipse()
                                    .fill(light_background)
                                    .frame(width: sbl_size, height: sbl_size)
                                
                                if scoreboard.b2light == true {
                                    Ellipse()
                                        .fill(Color("LightBeam"))
                                        .frame(width: sbl_size, height: sbl_size)
                                        .blur(radius: light_radius)
                                }
                                
                                Ellipse()
                                    .fill(Color("BlueLight"))
                                    .frame(width: sbl_size, height: sbl_size)
                            }
                            
                            ZStack{
                                
                                Ellipse()
                                    .fill(light_background)
                                    .frame(width: sbl_size, height: sbl_size)
                                
                                if scoreboard.b3light == true {
                                    Ellipse()
                                        .fill(Color("LightBeam"))
                                        .frame(width: sbl_size, height: sbl_size)
                                        .blur(radius: light_radius)
                                }
                                
                                Ellipse()
                                    .fill(Color("BlueLight"))
                                    .frame(width: sbl_size, height: sbl_size)
                            }
                        }
                        .padding(.top, -5.0)
                    }
                    Spacer()
                    VStack{
                        Text("STRIKES")
                            .font(.system(size: font_size))
                            .fontWeight(.bold)
                        HStack(spacing: 2.0){
                            ZStack{
                                
                                Ellipse()
                                    .fill(light_background)
                                    .frame(width: sbl_size, height: sbl_size)
                                
                                if scoreboard.s1light == true {
                                    Ellipse()
                                        .fill(Color("LightBeam"))
                                        .frame(width: sbl_size, height: sbl_size)
                                        .blur(radius: light_radius)
                                }
                                
                                Ellipse()
                                    .fill(Color("RedLight"))
                                    .frame(width: sbl_size, height: sbl_size)
                            }
                            
                            ZStack{
                                
                                Ellipse()
                                    .fill(light_background)
                                    .frame(width: sbl_size, height: sbl_size)
                                
                                if scoreboard.s2light == true {
                                    Ellipse()
                                        .fill(Color("LightBeam"))
                                        .frame(width: sbl_size, height: sbl_size)
                                        .blur(radius: light_radius)
                                }
                                
                                Ellipse()
                                    .fill(Color("RedLight"))
                                    .frame(width: sbl_size, height: sbl_size)
                            }
                        }
                        .padding(.top, -5.0)
                    }
                    Spacer()
                    VStack{
                        Text("OUTS")
                            .font(.system(size: font_size))
                            .fontWeight(.bold)
                        HStack(spacing: 2.0){
                            
                            ZStack{
                                
                                Ellipse()
                                    .fill(light_background)
                                    .frame(width: sbl_size, height: sbl_size)
                                
                                if scoreboard.o1light == true {
                                    Ellipse()
                                        .fill(Color("LightBeam"))
                                        .frame(width: sbl_size, height: sbl_size)
                                        .blur(radius: light_radius)
                                }
                                
                                Ellipse()
                                    .fill(Color("RedLight"))
                                    .frame(width: sbl_size, height: sbl_size)
                            }
                            
                            ZStack{
                                
                                Ellipse()
                                    .fill(light_background)
                                    .frame(width: sbl_size, height: sbl_size)
                                
                                if scoreboard.o2light == true {
                                    Ellipse()
                                        .fill(Color("LightBeam"))
                                        .frame(width: sbl_size, height: sbl_size)
                                        .blur(radius: light_radius)
                                }
                                Ellipse()
                                    .fill(Color("RedLight"))
                                    .frame(width: sbl_size, height: sbl_size)
                            }
                        }
                        .padding(.top, -5.0)
                    }
                    Spacer()
                }
                //.padding(.leading, 5)
                .padding(.top, 5)
                
                //Spacer()
                
                VStack(alignment: .trailing){
                    HStack{
                        Text("P#")
                            .font(.system(size: font_size))
                            .fontWeight(.bold)
                        ZStack(alignment: .center){
                            //Rectangle()
                            RoundedRectangle(cornerRadius: crnr_radius)
                                .foregroundStyle(
                                    Color("ScoreboardGreen").shadow(.inner(color: .black.opacity(0.4), radius: 2, x: 1, y: 1))
                                )
                                .frame(width: 40, height: 30)
                            
                            Text(String(scoreboard.pitches))
                                .font(.system(size: font_size))
                                .fontWeight(.black)
                            
                            if hidepitchnum == true {
                                
                            }
                            
                        }
                    }
                    .padding(.top, 10)
                    HStack{
                        Text("AB")
                            .font(.system(size: font_size))
                            .fontWeight(.bold)
                        ZStack(alignment: .center){
                            //Rectangle()
                            RoundedRectangle(cornerRadius: crnr_radius)
                                .foregroundStyle(
                                    Color("ScoreboardGreen").shadow(.inner(color: .black.opacity(0.4), radius: 2, x: 1, y: 1))
                                )
                                .frame(width: 30, height: 30)
                            
                            Text(String(scoreboard.atbats))
                                .font(.system(size: font_size))
                                .fontWeight(.black)
                            
                            if hideatbats == true {
                                ZStack{
                                    
                                }
//                                .frame(maxWidth: 30, maxHeight: 30)
//                                .background(.ultraThinMaterial.opacity(0.6))
//                                .blur(radius: 5)
                            }
                            
                        }
                    }
                    .padding(.top, -5)
                }
                Spacer()
            }
        }
        .background(Color("ScoreboardGreen"))
        .foregroundColor(.white)
        .padding(.bottom, -5)
    }
}

#Preview {
    ScoreboardView()
        .environment(Scoreboard())
}
