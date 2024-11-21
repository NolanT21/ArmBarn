//
//  AtBatReportView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 11/11/24.
//

import SwiftUI

struct AtBatReportView: View {
    
    @Environment(currentPitcher.self) var current_pitcher
    @Environment(AtBatBreakdown.self) var at_bat_brkdwn
    
    var view_padding: CGFloat = 10
    var view_crnr_radius: CGFloat = 12
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                ForEach(Array(at_bat_brkdwn.at_bat_list.enumerated()), id: \.offset){ index, atbat in
                    VStack{
                        Spacer()
                        
                        //Text("\(atbat.pitch_list)")
                        
                        VStack{
                            HStack{/*"Header" Description*/
                                Text("INN 1")
                                    .font(.system(size: 14))
                                    .bold()
                                Spacer()
                                Text("0 Outs")
                                    .font(.system(size: 14))
                                    .bold()
                            }
                            HStack{
                                VStack(/*alignment: .topLeading*/){/*Strikezone w/ Pitch Overlays*/
                                    GeometryReader{ geo in
                                        Image("PLO_Background")
                                            .resizable()
                                            .scaledToFit()
                                            //.aspectRatio(contentMode: .fit)
    //                                            .containerRelativeFrame(.vertical) { size, axis in
    //                                                size * 0.3
    //                                            }
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                            .clipped()
                                            .frame(alignment: .top)
                                            .overlay{
    //                                            ForEach(game_report.x_coordinate_list.indices, id: \.self){ index in
                                                ForEach(atbat.x_coor_list.indices, id: \.self) { index in
                                                    let x_coor = atbat.x_coor_list[index] / 4 + 37/*(geometry.size.width / 5) * (202/screenSize.width) + 75*/
                                                    let y_coor = atbat.y_coor_list[index] / 4 + 18/*(geometry.size.width / 5) * (415/screenSize.height) + 39*/
                                                    let point = CGPoint(x: x_coor, y: y_coor)
                                                    let pitch_color = atbat.pitch_color_list[index]
    //                                                let outline = game_report.pl_outline_list[index]
    //
                                                    Circle()
                                                        .fill(pitch_color)
//                                                        .fill(.yellow)
                                                        .stroke(.white, lineWidth: 2)
                                                        .frame(width: 15, height: 15, alignment: .center)
                                                        .overlay {
                                                            Text("\(index + 1)")
                                                                .font(.system(size: 8))
                                                                .bold()
                                                        }
                                                        .position(point)

                                                }
                                            }
                                            //.padding(.horizontal, 6)
                                            //.padding(.bottom, 6)
                                    }
                                    
                                }
                                //.border(.yellow)
                                //.frame(height: geometry.size.height / 3)
                                
                                Spacer()
                                
                                ScrollView{
                                    VStack(alignment: .leading){
                                        /*Pitch Descriptions*/
                                        let pitch_list = atbat.pitch_list
                                        //Text("\(pitch_list.count())")
            //                          ForEach(1...7, id: \.self) {_ in
                                            Grid(alignment: .leading){
                                                ForEach(Array(pitch_list.enumerated()), id: \.offset) {pitch in
                                                    if pitch.offset > 0 {
                                                        Divider()
                                                    }
                                                    GridRow{
                                                        VStack(alignment: .leading){
                                                            Circle()
                                                                .fill(pitch.element.result_color)
                                                                .stroke(.white, lineWidth: 2)
                                                                .frame(width: 20, height: 20, alignment: .center)
                                                                .overlay {
                                                                    Text("\(pitch.offset + 1)")
                                                                        .font(.system(size: 12))
                                                                        .bold()
                                                                }
                                                        }
                                                        .gridColumnAlignment(.center)
                                                        
                                                        VStack(alignment: .leading){
                                                            Text("\(pitch.element.result)")
                                                                .font(.system(size: 14))
                                                            HStack(spacing: 2){
                                                                if pitch.element.velocity != 0 {
                                                                    Text("\(pitch.element.velocity, specifier: "%.1f") mph")
                                                                }
                                                                
                                                                Text("\(pitch.element.pitch_type)")
                                                            }
                                                            .font(.system(size: 10))
                                                        }
                                                        VStack{
                                                            Text("\(pitch.element.balls)-\(pitch.element.strikes)")
                                                                .font(.system(size: 14))
                                                        }
                                                        .gridColumnAlignment(.center)
                                                    }
                                                    //.padding(.bottom, 2)

                                                }
                                            }
                                        
                                        Spacer()
                                    }
                                }
                                .frame(height: 200) 
                                
                            }
                        }
                        .padding(view_padding)
                        .frame(maxWidth: .infinity)
                        .background(Color("DarkGrey"))
                        .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                        
                        Spacer()
                    }
                    //.fixedSize(horizontal: false, vertical: false)
                    //.frame(height: 260)
                    .foregroundStyle(.white)
                    .padding(.horizontal, view_padding)
                    .padding(.bottom, view_padding/2)
                }
            }

            
        }
    }
}

#Preview {
    AtBatReportView()
}
