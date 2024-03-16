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
    
    @State var prev_inn: Int = 0
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    let gradient = Gradient(colors: [.yellow, .orange, .red])
    
    var view_padding: CGFloat = 10
    var view_crnr_radius: CGFloat = 12
    
    let columns = [
        GridItem(.flexible())
    ]
    
    let rows = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        LazyVGrid(columns: columns){
            ForEach(Array(game_report.inn_hitlog.enumerated()), id: \.offset) { index, value in
                
                let hit_type = game_report.result_hitlog[index] //Thread 1: Fatal error: Index out of range
                let balls = game_report.cnt_hitlog[index].balls
                let strikes = game_report.cnt_hitlog[index].strikes
                let pitch_type = game_report.pitchtype_hitlog[index]
                let hl_outs = game_report.outs_hitlog[index]
            
                if index == 0 {
                    LazyVGrid(columns: columns, alignment: .leading){
                        Text("INN \(value)")
                            .padding(.leading, view_padding)
                        Divider()
                    }
                    .padding(.horizontal, view_padding)
                }
                
                LazyHGrid(rows: columns){
                    Text(hit_type)
                    Text("\(balls) - \(strikes)")
                    Text(pitch_type)
                    Text("\(hl_outs) Out(s)")
                }
                .padding(.leading, view_padding * 3)
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
        .environment(GameReport())
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
