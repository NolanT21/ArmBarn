//
//  TestView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 1/7/24.
//

import SwiftUI
import SwiftData
import Charts

struct LineChartDT: Identifiable {
    let id = UUID()
    let label: String
    let x_value: Int
    let y_value: Double
}

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
    
    @State private var pit1byinning_data: [LineChartDT] = [
        .init(label: "Inn1", x_value: 1, y_value: 20),
        .init(label: "Inn2", x_value: 2, y_value: 10),
        .init(label: "Inn3", x_value: 3, y_value: 12),
        .init(label: "Inn4", x_value: 4, y_value: 16),
        .init(label: "Inn5", x_value: 5, y_value: 13),
        .init(label: "Inn6", x_value: 6, y_value: 9),
        .init(label: "Inn7", x_value: 7, y_value: 26),
        .init(label: "Inn8", x_value: 8, y_value: 7),
        .init(label: "Inn9", x_value: 9, y_value: 22),
    ]
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    var body: some View {
        
        Chart{
            ForEach(pit1byinning_data) { fps in
                LineMark(x: .value("Inning", fps.x_value),
                        y: .value("# of Pit", fps.y_value))
            }
            
        }
        .frame(height: 200)
        .padding(10)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 10))
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
