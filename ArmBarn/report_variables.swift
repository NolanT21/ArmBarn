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
    var inn_pitched: Double = 0.0
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
    
    var singles: Int = 0
    var doubles: Int = 0
    var triples: Int = 0
    var homeruns: Int = 0
    var errors: Int = 0
    var p1_hits: Int = 0
    var p2_hits: Int = 0
    var p3_hits: Int = 0
    var p4_hits: Int = 0
    var most_hit_pit: String = ""
    var mhp_pitches: Int = 0
    var mhp_hits: Int = 0
    
    var swings: Int = 0
    var swing_per: Int = 0
    var whiffs: Int = 0
    var whiff_per: Int = 0
    
    var p1_velo_list: [Double] = []
    var p2_velo_list: [Double] = []
    var p3_velo_list: [Double] = []
    var p4_velo_list: [Double] = []
    
    var velo_set_list: [PitchVeloSet] = []
    
    var rh_batters_faced: Int = 0
    var lh_batters_faced: Int = 0
    var bs_faced_factor: Double = 0
    var rh_hits: Int = 0
    var lh_hits: Int = 0
    var bs_hits_factor: Double = 0
    var rh_xbhs: Int = 0
    var lh_xbhs: Int = 0
    var bs_xbhs_factor: Double = 0
    var rh_strikeouts: Int = 0
    var lh_strikeouts: Int = 0
    var bs_strikeouts_factor: Double = 0
    var rh_walks: Int = 0
    var lh_walks: Int = 0
    var bs_walks_factor: Double = 0
    
    var p1_by_inn: [Int] = []
    var p2_by_inn: [Int] = []
    var p3_by_inn: [Int] = []
    var p4_by_inn: [Int] = []
    var pitches_by_inn: [PitchTypeDataset] = []
    
    var pbp_event_list: [PBPLog] = []
    var cur_pitcher_id = UUID()
    
    var game_location: String = ""
    var opponent_name: String = ""
    
}

struct PBPLog: Identifiable {
    let id = UUID()
    var pitch_num : Int
    var pitch_type : String
    var result : String
    var balls : Int
    var strikes : Int
    var outs : Int
    var out_label : String
    var velo : Double
    var inning : Int
    
    var result_detail : String
    var pitcher : String
    
}

struct PitchVeloSet: Identifiable {
    let id = UUID()
    var pitch_type : String
    var max_velo : Double
    var avg_velo : Double
    var velo_factor: Double
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

