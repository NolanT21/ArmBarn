//
//  TestView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 1/7/24.
//

import SwiftUI
import SwiftData
import Charts

//struct PieChartDT: Identifiable {
//    let id = UUID()
//    let label: String
//    let value: Double
//}

struct TestView: View {
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(currentPitcher.self) var current_pitcher
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    @Environment(Event_String.self) var event
    
    @Environment(\.dismiss) var dismiss
    
    @State private var firstpitstrike_data: [PieChartDT] = [
        .init(label: "First Pitch Strikes", value: 13),
        .init(label: "First Pitch Balls", value: 9)
    ]
    
    @State private var strikepercent_data: [PieChartDT] = [
        .init(label: "Total Strikes", value: 45),
        .init(label: "Total Balls", value: 23)
    ]
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    var body: some View {
        
        HStack {
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
            .padding(10)
            .frame(width: 175)
            .chartLegend(.hidden)
            .chartBackground { proxy in
                VStack{
                    Text("59%")
                        .font(.system(size: 40))
                        .bold()
                    Text("13/22")
                }
                .padding(.top, 20)
            }
            
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
            .padding(10)
            .frame(width: 175)
            .chartLegend(.hidden)
            .chartBackground { proxy in
                VStack{
                    Text("67%")
                        .font(.system(size: 40))
                        .bold()
                    Text("45/68")
                }
                .padding(.top, 20)
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
