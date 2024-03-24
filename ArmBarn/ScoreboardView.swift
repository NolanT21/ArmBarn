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
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack{
                    Text("INN")
                        .font(.title3)
                        .fontWeight(.bold)
                    ZStack(alignment: .center){
                        //Rectangle()
                        RoundedRectangle(cornerRadius: crnr_radius)
                            .foregroundStyle(
                                Color("ScoreboardGreen").shadow(.inner(color: .black.opacity(0.4), radius: 2, x: 1, y: 1))
                            )
                            .frame(width: 30, height: 30)
                        
                        Text(String(scoreboard.inning))
                            .font(.title3)
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
                            .font(.title3)
                            .fontWeight(.bold)
                        HStack(spacing: 2.0){
                            Ellipse()
                                .fill(scoreboard.b1light)
                                .frame(width: sbl_size, height: sbl_size)
                            
                            Ellipse()
                                .fill(scoreboard.b2light)
                                .frame(width: sbl_size, height: sbl_size)
                            
                            Ellipse()
                                .fill(scoreboard.b3light)
                                .frame(width: sbl_size, height: sbl_size)
                        }
                        .padding(.top, -5.0)
                    }
                    Spacer()
                    VStack{
                        Text("STRIKES")
                            .font(.title3)
                            .fontWeight(.bold)
                        HStack(spacing: 2.0){
                            Ellipse()
                                .fill(scoreboard.s1light)
                                .frame(width: sbl_size, height: sbl_size)
                            Ellipse()
                                .fill(scoreboard.s2light)
                                .frame(width: sbl_size, height: sbl_size)
                        }
                        .padding(.top, -5.0)
                    }
                    Spacer()
                    VStack{
                        Text("OUTS")
                            .font(.title3)
                            .fontWeight(.bold)
                        HStack(spacing: 2.0){
                            Ellipse()
                                .fill(scoreboard.o1light)
                                .frame(width: sbl_size, height: sbl_size)
                            Ellipse()
                                .fill(scoreboard.o2light)
                                .frame(width: sbl_size, height: sbl_size)
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
                            .font(.title3)
                            .fontWeight(.bold)
                        ZStack(alignment: .center){
                            //Rectangle()
                            RoundedRectangle(cornerRadius: crnr_radius)
                                .foregroundStyle(
                                    Color("ScoreboardGreen").shadow(.inner(color: .black.opacity(0.4), radius: 2, x: 1, y: 1))
                                )
                                .frame(width: 40, height: 30)
                            Text(String(scoreboard.pitches))
                                .font(.title3)
                                .fontWeight(.black)
                        }
                    }
                    .padding(.top, 10)
                    HStack{
                        Text("AB")
                            .font(.title3)
                            .fontWeight(.bold)
                        ZStack(alignment: .center){
                            //Rectangle()
                            RoundedRectangle(cornerRadius: crnr_radius)
                                .foregroundStyle(
                                    Color("ScoreboardGreen").shadow(.inner(color: .black.opacity(0.4), radius: 2, x: 1, y: 1))
                                )
                                .frame(width: 30, height: 30)
                            Text(String(scoreboard.atbats))
                                .font(.title3)
                                .fontWeight(.black)
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
