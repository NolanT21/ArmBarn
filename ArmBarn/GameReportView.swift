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
    
    var gradient = Gradient(colors: [Color("PowderBlue"), Color("Gold"), Color("Tangerine")])
    var colorset = [Color("PowderBlue"), Color("Gold"), Color("Tangerine"), Color("Grey")]
    
    var view_padding: CGFloat = 10
    var view_crnr_radius: CGFloat = 12
    
    var body: some View {
        
        GeometryReader { proxy in
            
            let viewsize = proxy.size
            
            ZStack{
                
                ScrollView{
                    reportView
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .background(Color(UIColor.secondarySystemBackground))
                
                HStack{
                    Spacer()
                    
                    VStack{
                        Button(action: {
                            
                            guard let image = ImageRenderer(content: reportView.frame(width: viewsize.width, height: viewsize.height, alignment: .center)).uiImage else {
                                print("Failed to render view as an image")
                                return
                            }
                            
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            
                        }, label: {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundStyle(Color(UIColor.label))
                        })
                        
                        Spacer()
                    }
                }
                .padding(.top, view_padding)
                .padding(.trailing, view_padding)
            }
        }
    }
    
    var reportView: some View {
            VStack{
                HStack{
                    VStack (alignment: .leading){
                        Text("Game Summary")
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack{
                            Text(" " + current_pitcher.firstName + " " + current_pitcher.lastName + ",")
                                .font(.subheadline)
                            Text(Date().formatted(.dateTime.day().month().year()))
                                .font(.subheadline)
                        }
                    }
                }
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
                                .tint(Color("PowderBlue"))
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
                                .tint(Color("Gold"))
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

                        ZStack{
                            
                            Image("PLO_Background")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .padding(.horizontal, 6)
                                .padding(.bottom, 6)
                            
                            ForEach(game_report.x_coordinate_list.indices, id: \.self){ index in
                                let xloc = game_report.x_coordinate_list[index] * 0.5 + 90
                                let yloc = game_report.y_coordinate_list[index] * 0.5 + 40
                                let point = CGPoint(x: xloc, y: yloc)
                                let pitch_color = game_report.pl_color_list[index]
                                Circle()
                                    .fill(pitch_color)
                                    .frame(width: 20, height: 20, alignment: .center)
                                    .position(point)
                            }
                            
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
//                                ForEach(Array(current_pitcher.arsenal.enumerated()), id: \.offset) { index in
//                                    if current_pitcher.arsenal[index] != "None" {
//                                        current_pitcher.arsenal[index]: colorset[index]
//                                    }
//                                }
                                current_pitcher.pitch1: Color("PowderBlue"), current_pitcher.pitch2: Color("Gold"), current_pitcher.pitch3: Color("Tangerine"), current_pitcher.pitch4: Color("Grey")
                            ])
                           .frame(height: 200)
                           .padding(10)
                           .chartLegend(position: .bottom, alignment: .center, spacing: 10)
                           .chartXScale(domain: [0, game_report.p1_by_inn.count + 1])
                            .chartXAxis {
                                AxisMarks(values: .automatic(desiredCount: game_report.p1_by_inn.count + 1))
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
}

#Preview {
    GameReportView()
}
