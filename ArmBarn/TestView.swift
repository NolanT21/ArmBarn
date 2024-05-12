//
//  TestView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 1/7/24.
//

import SwiftUI
import SwiftData
import Charts
import Observation

struct TestView: View {
    
    @AppStorage("VelocityInput") var ASVeloInput : Bool?
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(currentPitcher.self) var current_pitcher
    @Query var events: [Event]
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    @Environment(Event_String.self) var event
    
    @Environment(GameReport.self) var game_report
    
    @Environment(\.dismiss) var dismiss
    
    @State var pitch_num: Int = 0
    @State var result: String = ""
    @State var prev_inn: Int = 0
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    var text_color: Color = .white
    
    let gradient = Gradient(colors: [.yellow, .orange, .red])
    
    var view_padding: CGFloat = 10
    var view_crnr_radius: CGFloat = 12
    
    let columns = [
        GridItem(.flexible(minimum: 0, maximum: 10000))
    ]
    
    var body: some View {
        
        ScrollView{
            VStack{
                
                Spacer()
                
                HStack{
                    
                    VStack{
                        
                        HStack{
                            Text("Pitch Velocity")
                                .font(.subheadline)
                                .foregroundStyle(text_color)
                            Spacer()
                        }
                        
                        VStack{
                            HStack{
                                VStack(alignment: .trailing){
                                    Text("Fastball")
                                        .font(.headline)
                                        .foregroundStyle(text_color)
                                    Text("Max: 102.9")
                                        .font(.caption2)
                                        .foregroundStyle(.grey)
                                }
                                
                                Spacer()
                                
                                ZStack{
                                    Rectangle()
                                        .fill(.grey)
                                        .frame(maxWidth: .infinity, maxHeight: 1)
                                    
                                    GeometryReader{ geometry in
                                        
                                        HStack(spacing: 0){
                                            Rectangle()
                                                .fill(.clear)
                                                .frame(width: geometry.size.width * 0.96)
                                            
                                            ZStack{
                                                Rectangle()
                                                    .fill(LinearGradient(colors: [.clear, Color("Gold"), Color("Gold"), .clear], startPoint: .leading, endPoint: .trailing).opacity(0.7))
                                                    .frame(width: 20, height: 15)
                                                
                                                Rectangle()
                                                    .fill(.black)
                                                    .frame(width: 2, height: 17)
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                .padding(.horizontal, view_padding)

                            }
                            
                        }
                        
                    }
                    .padding(view_padding)
                    .frame(maxWidth: .infinity)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    
                }
                .padding(.horizontal, view_padding)
                .padding(.bottom, view_padding)
                
                Spacer()
                
            }
            .background(.black)
            
        }
    }
}

#Preview {
    TestView()
}
