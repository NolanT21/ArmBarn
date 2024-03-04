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
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(currentPitcher.self) var current_pitcher
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    @Environment(Event_String.self) var event
    
    @Environment(GameReport.self) var game_report
    
    @Environment(\.dismiss) var dismiss
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    let gradient = Gradient(colors: [.yellow, .orange, .red])
    
    var view_padding: CGFloat = 10
    var view_crnr_radius: CGFloat = 12
    
    var body: some View {
        
        ScrollView{
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
        }
        
        
    }
}
        

#Preview {
    TestView()
        .environment(Scoreboard())
        .environment(Event_String())
        .environment(currentPitcher())
        .environment(PitchTypeConfig())
}

//Gauge(value: 0.4) {
//    Text("Game Score")
//}
//.gaugeStyle(.accessoryLinear)
//.tint(gradient)
//
//Gauge(value: currentSpeed, in: minSpeed...maxSpeed) {
//  Text("MPH")
//} currentValueLabel: {
//               VStack{
//                    Text(currentSpeed.formatted())
//                    Text("13/22")
//                }
//}
//.scaleEffect(2.5)
//.gaugeStyle(.accessoryCircularCapacity)
//.tint(.purple)

//            Chart{
//                ForEach(Array(fps_to_fpb.enumerated()), id: \.offset) { index, value in
//                    SectorMark(
//                        angle: .value(
//                            Text(verbatim: "\(index)"),
//                            value
//                        ),
//                        innerRadius: .ratio(0.7)
//                    )
//                    .foregroundStyle(
//                        by: .value(
//                            Text(verbatim: "\(index)"),
//                            value
//                        )
//                    )
//                }
//            }
            
//            Chart{
//                ForEach(appData.sales) { product in
//                    ForEach(product.sales) { sale in
//                        LineMark(x: .value("Date", sale.date, unit: .day),
//                                 y: .value("Sales", sale.amount))
//                    }.foregroundStyle(by: .value("Products", product.name))
//                }
//            }
//           .frame(height: 200)
//            .padding(10)
//            .chartXScale(domain: [0, 10])
//            .chartXAxis {
//                AxisMarks(values: .automatic(desiredCount: 9))
//            }
//            .chartYAxis {
//                AxisMarks(position: .leading)
//            }
//            Spacer()

//                                Chart{
//                                    ForEach(Array(game_report.game_score_inn_data.enumerated()), id: \.offset) { index, value in
//                                        PointMark(x: .value("Inning", index),
//                                                  y: .value("Game Score", value))
//
//                                        LineMark(x: .value("Inning", index),
//                                                 y: .value("Game Score", value))
//                                    }
//                                }
//                                .padding(.trailing, view_padding * 2)
//                                //.padding(.bottom, view_padding)
//                                .frame(width: 225, height: 35)
//                                .chartXAxis(.hidden)
//                                .chartYAxis(.hidden)
//                                .chartYScale(domain: [game_report.game_score_min, game_report.game_score_max])
