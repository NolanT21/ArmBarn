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
        VStack{
            
            let screenSize = UIScreen.main.bounds.size
            
            ForEach(Array(at_bat_brkdwn.at_bat_list.enumerated()), id: \.offset){ index, atbat in
                VStack{
                    
                    Spacer()
                    
                    VStack{
                        HStack{/*"Header" Description*/
                            Text("INN \(atbat.inning)")
                                .font(.system(size: 14))
                                .bold()
                            Spacer()
                            Text("\(atbat.outs) Out(s)")
                                .font(.system(size: 14))
                                .bold()
                        }
                        HStack{
                            VStack{/*Strikezone w/ Pitch Overlays*/
                                Image("PLO_Background")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                    .clipped()
                                    .frame(alignment: .top)
                                    .overlay{
                                        ForEach(atbat.x_coor_list.indices, id: \.self) { index in
                                            let x_coor = atbat.x_coor_list[index] / (screenSize.width / 100) + (screenSize.width * 0.089)
                                            let y_coor = atbat.y_coor_list[index] / (screenSize.height / 204) + (screenSize.height * 0.025)
                                            let point = CGPoint(x: x_coor, y: y_coor)
                                            
                                            let pitch_color = atbat.pitch_color_list[index]
                                            let plot = atbat.plot_pitch_list[index]
                                            let pitch_num = atbat.pitch_num_list[index]
                                            
                                            if plot != 0 {
                                                let pitch_index = pitch_num
                                                Circle()
                                                    .fill(pitch_color)
                                                    .stroke(.white, lineWidth: 2)
                                                    .frame(width: 15, height: 15, alignment: .center)
                                                    .overlay {
                                                        Text("\(pitch_index)")
                                                            .font(.system(size: 8))
                                                            .bold()
                                                    }
                                                    .position(point)
                                            }
                                        }
                                    }
                            }
                            
                            Spacer()
                            
                            ScrollView{
                                VStack(alignment: .leading){
                                    /*Pitch Descriptions*/
                                    let pitch_list = atbat.pitch_list
                                    let pitch_num_list = atbat.pitch_num_list
                                    let color_list = atbat.pitch_color_list
                                        Grid(alignment: .leading){
                                            ForEach(Array(pitch_list.enumerated()), id: \.offset) {pitch in
                                                if pitch.offset > 1 {
                                                    Divider()
                                                }
                                                if pitch.element.pitch_type == "NPE" {
                                                    GridRow{
                                                        VStack{
                                                            HStack{
                                                                
                                                                Spacer()
                                                                
                                                                Text(pitch.element.result)
                                                                    .foregroundStyle(color_list[pitch.offset].opacity(2))
                                                                    .font(.system(size: 14))
                                                                    .bold()
                                                                    .padding(.vertical, 7)
                                                                
                                                                Spacer()
                                                                
                                                            }
                                                            .background(color_list[pitch.offset].opacity(0.07))
                                                        }
                                                        .gridCellColumns(3)
                                                    }
                                                }
                                                else {
                                                    GridRow{
                                                        VStack(alignment: .leading){
                                                            Circle()
                                                                .fill(pitch.element.result_color)
                                                                .stroke(.white, lineWidth: 2)
                                                                .frame(width: 20, height: 20, alignment: .center)
                                                                .overlay {
                                                                    Text("\(pitch_num_list[pitch.offset])")
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
                                                }
                                                if pitch.offset == 0 {
                                                    Divider()
                                                }
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

#Preview {
    AtBatReportView()
}
