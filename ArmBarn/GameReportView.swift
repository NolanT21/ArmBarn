//
//  GameReportView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 2/4/24.
//

import SwiftUI
import Charts



struct GameReportView: View {
    
    @Environment(GameReport.self) var game_report
    @Environment(currentPitcher.self) var current_pitcher
    @Environment(PitchUsageLineData.self) private var pulData
    
    @State private var firstpitstrike_data: [PieChartDT] = [
        .init(label: "First Pitch Strikes", value: 13),
        .init(label: "First Pitch Balls", value: 9)
    ]
    
    @State private var strikepercent_data: [PieChartDT] = [
        .init(label: "Total Strikes", value: 45),
        .init(label: "Total Balls", value: 23)
    ]
    
    @State var fps_chart_colors: [Color] = [.gray, .yellow]
    @State var sp_chart_colors: [Color] = [.gray, .orange]
    
    var gradient = Gradient(colors: [.yellow, .orange, .red])
    
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
                                Text("\(game_report.inn_pitched, specifier: "%.1f")")
                                Text("\(game_report.pitches)")
                                Text("\(game_report.batters_faced)")
                                Text("\(game_report.hits)")
                                Text("\(game_report.strikeouts)")
                                Text("\(game_report.walks)")
                            }
                            
                        }
                        
                    }
                    .padding(view_padding)
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemBackground))
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
                        .padding(.bottom, view_padding)
                        
                        //Spacer()
                        
                        VStack{
                            //Spacer()
                            ZStack{
                                Gauge(value: Double(game_report.first_pit_strike_per) * 0.01) {}
                                .scaleEffect(2.5)
                                .gaugeStyle(.accessoryCircularCapacity)
                                .tint(.yellow)
                                .padding(view_padding)
                                VStack{
                                    Text("\(game_report.first_pit_strike_per)%")
                                        .font(.system(size: 40))
                                        .bold()
                                    Text("\(game_report.first_pitch_strike)/\(game_report.batters_faced)")
                                        .font(.subheadline)
                                }
                                .padding(.top, view_padding)
                            }
                            .padding(view_padding)
                            
                            Spacer()
                            
                        }
                        .padding(view_padding)
                        
                        Spacer()
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.systemBackground))
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
                        .padding(.bottom, view_padding)
                       
                        VStack{
                            //Spacer()
                            ZStack{
                                Gauge(value: Double(game_report.strikes_per) * 0.01) {}
                                .scaleEffect(2.5)
                                .gaugeStyle(.accessoryCircularCapacity)
                                .tint(.orange)
                                .padding(view_padding)
                                VStack{
                                    Text("\(game_report.strikes_per)%")
                                        .font(.system(size: 40))
                                        .bold()
                                    Text("\(game_report.strikes)/\(game_report.pitches)")
                                        .font(.subheadline)
                                }
                                .padding(.top, view_padding)
                            }
                            .padding(view_padding)
                            
                            Spacer()
                            
                        }
                        .padding(view_padding)
                        
                        Spacer()
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.systemBackground))
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
                        
                        VStack{
                            HStack{
                                Text("\(game_report.game_score)")
                                    .font(.system(size: 40))
                                    .padding(.horizontal, view_padding)
                                    .padding(.bottom, -20)
                                    .bold()
                                
                                Spacer()
                            }
                            
                            //Spacer()
                            
                            VStack{
                                Gauge(value: Double(game_report.game_score) * 0.01) {
                                    Text("Game Score")
                                }
                                .gaugeStyle(.accessoryLinear)
                                .tint(gradient)
                                .frame(height: 10)
                            }
                            .padding(view_padding)
                        }

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.systemBackground))
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
                    .background(Color(UIColor.systemBackground))
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
                        
                        VStack{
                            Chart{
                                ForEach(game_report.pitches_by_inn) { pit_dataset in
                                    ForEach(Array(pit_dataset.dataset.enumerated()), id: \.offset){ index, value in
                                        LineMark(x: .value("Inning", index + 1),
                                                 y: .value("# of Pitches", value))
                                        PointMark(x: .value("Inning", index + 1),
                                                 y: .value("# of Pitches", value))
                                    }
                                    .foregroundStyle(by: .value("Pitch Type", pit_dataset.name))
                                }
                            }
                            .chartForegroundStyleScale([
                                current_pitcher.pitch1: .yellow, current_pitcher.pitch2: .orange, current_pitcher.pitch3: .red, current_pitcher.pitch4: .gray
                            ])
                           .frame(height: 200)
                           .padding(10)
                           .chartLegend(position: .bottom, alignment: .center, spacing: 10)
                           .chartXScale(domain: [0, game_report.p1_by_inn.count + 1])
                            .chartXAxis {
                                AxisMarks(values: .automatic(desiredCount: game_report.p1_by_inn.count))
                            }
                            .chartYAxis {
                                AxisMarks(position: .leading)
                            }
                            Spacer()
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    .padding(.bottom, view_padding)
                    .padding(.leading, view_padding)
                    .padding(.trailing, view_padding)
                }
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color(UIColor.secondarySystemBackground))
        .navigationTitle("Game Summary")
    }
}

#Preview {
    GameReportView()
}
