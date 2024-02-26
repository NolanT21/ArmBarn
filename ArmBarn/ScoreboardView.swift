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
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack{
                    Text("INN")
                        .bold()
                    Text(String(scoreboard.inning))
                        .bold()
                }
                Spacer()
                VStack{
                    Text("BALLS")
                        .bold()
                    HStack(spacing: 2.0){
                        Ellipse()
                            .fill(scoreboard.b1light)
                            .frame(width: 17.0, height: 17.0)
                        
                        Ellipse()
                            .fill(scoreboard.b2light)
                            .frame(width: 17.0, height: 17.0)
                        
                        Ellipse()
                            .fill(scoreboard.b3light)
                            .frame(width: 17.0, height: 17.0)
                    }
                    .padding(.top, -5.0)
                }
                Spacer()
                VStack{
                    Text("STRIKES")
                        .bold()
                    HStack(spacing: 2.0){
                        Ellipse()
                            .fill(scoreboard.s1light)
                            .frame(width: 17.0, height: 17.0)
                        Ellipse()
                            .fill(scoreboard.s2light)
                            .frame(width: 17.0, height: 17.0)
                    }
                    .padding(.top, -5.0)
                }
                Spacer()
                VStack{
                    Text("OUTS")
                        .bold()
                    HStack(spacing: 2.0){
                        Ellipse()
                            .fill(scoreboard.o1light)
                            .frame(width: 17.0, height: 17.0)
                        Ellipse()
                            .fill(scoreboard.o2light)
                            .frame(width: 17.0, height: 17.0)
                    }
                    .padding(.top, -5.0)
                }
                Spacer()
                VStack(alignment: .center){
                    HStack{
                        Text("P#")
                            .bold()
                        Text(String(scoreboard.pitches))
                            .bold()
                    }
                    HStack{
                        Text("AB")
                            .bold()
                        Text(String(scoreboard.atbats))
                            .bold()
                    }
                }
                Spacer()
            }
        }
        .background(Color("ScoreboardGreen"))
        .foregroundColor(.white)
    }
}

#Preview {
    ScoreboardView()
        .environment(Scoreboard())
}
