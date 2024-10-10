//
//  BullpenReportView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 10/5/24.
//

import SwiftUI

struct BullpenReportView: View {
    
    @Environment(BullpenReport.self) var bpr
    @Environment(currentPitcher.self) var current_pitcher
    @Environment(\.dismiss) var dismiss
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    @State var title_size: CGFloat = 28.0
    @State var subheadline_size: CGFloat = 15
    
    var view_padding: CGFloat = 10
    var text_color: Color = .white
    var view_crnr_radius: CGFloat = 12
    
    let header_gradient = Gradient(colors: [Color("ScoreboardGreen"), Color("ScoreboardGreen"), Color("ScoreboardGreen"), .black])
    let background_gradient = Gradient(colors: [Color("ScoreboardGreen"), .black, .black, .black, .black, .black])
    
    var body: some View {
        ZStack{
            VStack{
                HStack(alignment: .center){
                    
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .imageScale(.medium)
                            .font(.system(size: 17))
                            .frame(width: sbl_width, height: sbl_height)
                            .foregroundColor(text_color)
                            .bold()
                    })
                    
                    Spacer()
                }
                .padding(.top, view_padding * 2)
                .padding(.leading, view_padding * 1.5)
                .padding(.bottom, view_padding)
                
                ZStack{
                    ScrollView{
                        reportView
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
            }
            .background(LinearGradient(gradient: header_gradient, startPoint: .top, endPoint: .bottom))
        }
        
    }
    
    var reportView: some View {
        VStack{
            HStack{
                VStack (alignment: .leading){
                    Text(current_pitcher.firstName + " " + current_pitcher.lastName)
                        .font(.system(size: title_size))
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(text_color)
                    
                    Text(Date().formatted(.dateTime.day().month().year()))
                        .font(.system(size: subheadline_size))
                        .foregroundStyle(text_color)
                }
            }
            .padding(.horizontal, view_padding)
            .padding(.top, view_padding)
            
            HStack{
                
                VStack{
                    
//                    HStack{
//                        Text("")
//                            .font(.system(size: subheadline_size))
//                            .foregroundStyle(text_color)
//                        Spacer()
//                    }
                    
                    HStack{
                        Spacer()
                        VStack{
                            Text("Pitches")
                            Text("\(bpr.pitches)")
                        }
                        Spacer()
                        Divider()
                        Spacer()
                        VStack{
                            Text("Spots Hit")
                            Text("\(bpr.spots_hit)")
                        }
                        Spacer()
                    }
                    
                }
                .padding(view_padding)
                .frame(maxWidth: .infinity)
                .background(Color("DarkGrey"))
                .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                
            }
            .padding(.horizontal, view_padding)
            .padding(.bottom, view_padding)
            
            HStack{
                
                VStack{
                    
//                    HStack{
//                        Text("")
//                            .font(.system(size: subheadline_size))
//                            .foregroundStyle(text_color)
//                        Spacer()
//                    }
                    
                    HStack{
                        Grid(alignment: .leading) {
                            ForEach(Array(bpr.spots_by_pitch_list.enumerated()), id: \.offset){ index, pitch in
                                GridRow{
                                    
                                    HStack{
                                        Text(pitch.pitch_type)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack{
                                        Divider()
                                    }
                                    
                                    Spacer()
                                    
                                    HStack{
                                        Text("\(pitch.pitch_num)")
                                    }
                                    
                                    Spacer()
                                    
                                    HStack{
                                        Divider()
                                    }
                                    
                                    Spacer()
                                    
                                    HStack{
                                        Text("\(pitch.spots_hit)")
                                    }
                                    
                                    Spacer()
                                    
                                }
                            }
                        }
                    }
                    .padding(.leading, 10)
                }
                .padding(view_padding)
                .frame(maxWidth: .infinity)
                .background(Color("DarkGrey"))
                .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                
            }
            .padding(.horizontal, view_padding)
            .padding(.bottom, view_padding)
            
            
        }
        .background(LinearGradient(gradient: background_gradient, startPoint: .top, endPoint: .bottom))
    }
    
}

#Preview {
    BullpenReportView()
}
