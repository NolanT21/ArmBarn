//
//  report_variables.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 2/13/24.
//

import SwiftUI
import SwiftData
import Observation

//Pie Chart Data Type
struct PieChartDT: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}


//Pitch Type Amount by Inning Line Chart Data Structure
struct Inning: Identifiable {
    let id = UUID()
    let inn_number: Int
    let amount: Int
}

struct PitchType: Identifiable {
    let id = UUID()
    let name: String
    let pitchtype_data: [Inning]
}

@Observable class ApplicationData {
    var pitchtypes_inn_data: [PitchType]
    
    init() {
        let pitch1_inning_data = [
            Inning(inn_number: 1, amount: 10),
            Inning(inn_number: 2, amount: 12),
            Inning(inn_number: 3, amount: 8),
            Inning(inn_number: 4, amount: 13),
            Inning(inn_number: 5, amount: 9),
            Inning(inn_number: 6, amount: 7),
            Inning(inn_number: 7, amount: 8)
        ]
        
        let pitch2_inning_data = [
            Inning(inn_number: 1, amount: 3),
            Inning(inn_number: 2, amount: 5),
            Inning(inn_number: 3, amount: 2),
            Inning(inn_number: 4, amount: 8),
            Inning(inn_number: 5, amount: 6),
            Inning(inn_number: 6, amount: 5),
            Inning(inn_number: 7, amount: 9)
        ]
        
        let pitch3_inning_data = [
            Inning(inn_number: 1, amount: 15),
            Inning(inn_number: 2, amount: 2),
            Inning(inn_number: 3, amount: 7),
            Inning(inn_number: 4, amount: 4),
            Inning(inn_number: 5, amount: 3),
            Inning(inn_number: 6, amount: 10),
            Inning(inn_number: 7, amount: 12)
        ]
        
        pitchtypes_inn_data = [
            PitchType(name: "Fastball", pitchtype_data: pitch1_inning_data),
            PitchType(name: "Curveball", pitchtype_data: pitch2_inning_data),
            PitchType(name: "Change-Up", pitchtype_data: pitch3_inning_data)
        ]

        
    }
    
}
