//
//  report_variables.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 2/13/24.
//

import SwiftUI
import SwiftData
import Observation


@Observable class GameReport{
    var inn_pitched: Double = 0
    var pitches: Int = 0
    var batters_faced: Int = 0
    var hits: Int = 0
    var strikeouts: Int = 0
    var walks: Int = 0
    
    var first_pitch_strike: Int = 0
    var first_pitch_ball: Int = 0
    var first_pit_strike_per: Int = 0
    var fpb_to_fps: [Int] = [0, 0]

    var strikes: Int = 0
    var balls: Int = 0
    var strikes_per: Int = 0
    var balls_to_strikes: [Int] = [0, 0]
    
    var game_score: Int = 40
    var game_score_min: Int = 0
    var game_score_max: Int = 0
    var game_score_inn_data: [Int] = [47, 39, 42, 45, 49, 52, 50]
    
    var p1_by_inn: [Int] = []
    var p2_by_inn: [Int] = []
    var p3_by_inn: [Int] = []
    var p4_by_inn: [Int] = []
    var pitches_by_inn: [PitchTypeDataset] = []
    
}

struct PitchTypeDataset: Identifiable {
    let id = UUID()
    let name: String
    let color: String
    let dataset: [Int]
}

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

@Observable class PitchUsageLineData {
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
