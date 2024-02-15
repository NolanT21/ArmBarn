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
    
    @Environment(PitchUsageLineData.self) private var appData
    @Environment(\.dismiss) var dismiss
    
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    var body: some View {
        VStack{
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
