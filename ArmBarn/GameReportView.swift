//
//  GameReportView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 2/4/24.
//

import SwiftUI
import Charts

struct PieChartDT: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}

struct GameReportView: View {
    
    @State private var firstpitstrike_data: [PieChartDT] = [
        .init(label: "First Pitch Strikes", value: 13),
        .init(label: "First Pitch Balls", value: 9)
    ]
    
    @State private var strikepercent_data: [PieChartDT] = [
        .init(label: "Total Strikes", value: 45),
        .init(label: "Total Balls", value: 23)
    ]
    
    var view_padding: CGFloat = 10
    var view_crnr_radius: CGFloat = 12
    
    var body: some View {
        ScrollView{
            VStack{
                Text("Game Summary")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, view_padding)
                    .padding(.top, view_padding)
                
                HStack{
                    
                    VStack{
                        
                        HStack{
                            Text("Box Score")
                                .font(.subheadline)
                            Spacer()
                        }
                        
                        Grid(){
                            GridRow{
                            Text("IP")
                            Text("Pit")
                            Text("BF")
                            Text("H")
                            Text("SO")
                            Text("BB")
                            }
                            .padding(.vertical, -5)
                            .bold()
                            
                            Divider()
                            
                            GridRow{
                            Text("9.0")
                            Text("72")
                            Text("20")
                            Text("4")
                            Text("7")
                            Text("2")
                            }
                            
                        }
                        
                    }
                    .padding(view_padding)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    
                }
                .padding(.horizontal, view_padding)
                .padding(.bottom, view_padding)
                
                HStack{
                    
                    VStack{
                        HStack{
                            Text("1st Pitch Strike %")
                                .font(.subheadline)
                                .padding(.top, view_padding)
                            
                            Spacer()
                        }
                        .padding(.leading, view_padding)
                        
                        VStack(alignment: .trailing){
                            Chart(firstpitstrike_data) { fps in
                                SectorMark(
                                    angle: .value(
                                        Text(verbatim: fps.label),
                                        fps.value
                                    ),
                                    innerRadius: .ratio(0.7)
                                )
                                .foregroundStyle(
                                    by: .value(
                                        Text(verbatim: fps.label),
                                        fps.label
                                    )
                                )
                            }
                            .frame(width: 160, height: 140)
                            .chartLegend(.hidden)
                            .chartBackground { proxy in
                                VStack{
                                    Text("59%")
                                        .font(.system(size: 33))
                                        .bold()
                                    Text("13/22")
                                        .font(.system(size: 13))
                                }
                                .padding(.top, view_padding)
                            }
                            
                        }
                        .padding(.bottom, view_padding)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    .padding(.bottom, view_padding)
                    .padding(.leading, view_padding)
                    .padding(.trailing, view_padding/2)
                    
                    VStack{
                        HStack{
                            Text("Strike %")
                                .font(.subheadline)
                                .padding(.top, view_padding)
                            
                            Spacer()
                        }
                        .padding(.leading, view_padding)
                       
                        VStack(alignment: .trailing){
                            
                            Chart(strikepercent_data) { sp in
                                SectorMark(
                                    angle: .value(
                                        Text(verbatim: sp.label),
                                        sp.value
                                    ),
                                    innerRadius: .ratio(0.7)
                                )
                                .foregroundStyle(
                                    by: .value(
                                        Text(verbatim: sp.label),
                                        sp.label
                                    )
                                )
                            }
                            .frame(width: 160, height: 140)
                            .chartLegend(.hidden)
                            .chartBackground { proxy in
                                VStack{
                                    Text("67%")
                                        .font(.system(size: 33))
                                        .bold()
                                    Text("45/68")
                                        .font(.system(size: 13 ))
                                }
                                .padding(.top, view_padding)
                            }
                            
                        }
                        .padding(.bottom, view_padding)

                       
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    .padding(.bottom, view_padding)
                    .padding(.leading, view_padding/2)
                    .padding(.trailing, view_padding)
                    
                    
                }
                
                HStack{
                    VStack{
                        HStack{
                            Text("Game Score")
                                .font(.subheadline)
                                .padding(.leading, view_padding)
                                .padding(.top, view_padding)
                            
                            Spacer()
                            
                        }
                        
                        Text("")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    .padding(.bottom, view_padding)
                    .padding(.leading, view_padding)
                    .padding(.trailing, view_padding)
                    
                }
                
                Spacer()
                
                HStack{
                    VStack{
                        HStack{
                            Text("Pitch Location")
                                .font(.subheadline)
                                .padding(.leading, view_padding)
                                .padding(.top, view_padding)
                            Spacer()
                        }
                        
                        Image("PLO_Background")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .padding(.horizontal, 6)
                            .padding(.bottom, 6)
                            //.gesture(tap)
                            
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    .padding(.bottom, view_padding)
                    .padding(.leading, view_padding)
                    .padding(.trailing, view_padding)
                }
                
                Spacer()
                
                HStack{
                    VStack{
                        HStack{
                            Text("Pitch Usage by Inning")
                                .font(.subheadline)
                                .padding(.leading, view_padding)
                                .padding(.top, view_padding)
                            
                            Spacer()
                        }
                        
                        
                        
                        Text("")
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    .padding(.bottom, view_padding)
                    .padding(.leading, view_padding)
                    .padding(.trailing, view_padding)
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(.gray)
        .navigationTitle("Game Summary")
    }
}

#Preview {
    GameReportView()
}
