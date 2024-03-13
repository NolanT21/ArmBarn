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
    
    var x_coordinate_list: [Double] = []
    var y_coordinate_list: [Double] = []
    var pl_color: Color = .clear
    var pl_outline: Color = .clear
    var pl_color_list: [Color] = []
    var pl_outline_list: [Color] = []
    
    var hl_hittype: String = ""
    var hl_balls: Int = 0
    var hl_strikes: Int = 0
    var hl_pitchtype: String = ""
    var hl_curinn: Int = 0
    var hl_previnn: Int = 0
    
    var inn_hitlog: [Int] = []
    var result_hitlog: [String] = []
    var pitchtype_hitlog: [String] = []
    var cnt_hitlog: [(balls: Int, strikes: Int)] = []
    var outs_hitlog: [Int] = []
    
    var p1_by_inn: [Int] = []
    var p2_by_inn: [Int] = []
    var p3_by_inn: [Int] = []
    var p4_by_inn: [Int] = []
    var pitches_by_inn: [PitchTypeDataset] = []
    
}

struct PitchTypeDataset: Identifiable {
    let id = UUID()
    let name: String
    let dataset: [Int]
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

