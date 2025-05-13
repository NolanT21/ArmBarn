//
//  scoreboard.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 11/18/23.
//

import Foundation
import SwiftUI
import SwiftData
import Observation

@Observable class Scoreboard{
    var balls: Int = 0
    var strikes: Int = 0
    var outs: Int = 0
    var pitches: Int = 0
    var atbats: Int = 1
    var inning: Int = 1
    
    var baserunners: Int = 0
    
    var b1light: Bool = false
    var b2light: Bool = false
    var b3light: Bool = false
    
    var s1light: Bool = false
    var s2light: Bool = false
    
    var o1light: Bool = false
    var o2light: Bool = false
    
    var update_scoreboard: Bool = true
    var disable_bottom_row: Bool = false
    
    var pitchers_appearance_list: [PitchersAppeared] = []
    
}

@Observable class LocationOverlay{
    //Variables for location overlay, covers scoreboard
    var shakecounter: Int = 0
    var showinputoverlay: Bool = false
    var showShakeAnimation: Bool = false
    var zero_location: Bool = false
    var showCurPitchPulse: Bool = false
    var showTabBar: Bool = true
    var showVeloInput: Bool = false
    var game_info_entered: Bool = false
}

struct PitchersAppeared {
    var pitcher_id: UUID
    var pitches: Int
    var batters_faced: Int
}

@Observable class Event_String{
    var pitch_result: String = "NONE"
    var pitch_type: String = "NP"
    var result_detail: String = ""
    var balls: Int = 0
    var strikes: Int = 0
    var outs: Int = 0
    var inning: Int = 1
    var atbats: Int = 1
    var x_cor: Double = 0
    var y_cor: Double = 0
    var batter_stance: String = ""
    var velocity: Double = 0
    var event_number: Int = 0
    
    var end_ab_rd: [String] = ["S", "D", "T", "H", "E", "B", "F", "G", "L", "P", "Y", "W", "K", "C", "M", "RE"]
    var newAtBat: Bool = false
    
    var recordEvent: Bool = false
}

@Observable class currentPitcher{
    var idcode = UUID()
    var firstName: String = "No Pitcher Selected"
    var lastName: String = ""
    var pitch1: String = "None"
    var pitch2: String = "None"
    var pitch3: String = "None"
    var pitch4: String = "None"
    var arsenal: [String] = ["None", "None", "None", "None"]
    var pitch_num: Int = 0
}

@Observable class PitchTypeConfig{
    var cur_x_location: CGFloat = 0
    var cur_y_location: CGFloat = 0
    
    var ptcolor: Color = .pink
    var ab_pitch_color: [Color] = []
    var pitch_x_loc: [CGFloat] = []
    var pitch_y_loc: [CGFloat] = []
    var pitch_cur_ab: Int = 0
    var arsenal_colors: [Color] = [Color("PowderBlue"), Color("Gold"), Color("Tangerine"), Color("Grey")]
    var hidePitchOverlay: Bool = false
    var loadPitchOverlay: Bool = false
    var non_pitch_event = false
    var npe_EOAB = false
}

@Observable class BullpenConfig{
    var expected_target: String = ""
    var actual_target: String = ""
    var pitch_type: String = ""
    var pp_number: Int = 0
    var pp_pitchtype: String = "-"
    var pp_spot_detail: Image = Image(systemName: "minus")
    var pp_spot_color: Color = .white
    var event_number: Int = 0
}

@Model class BullpenEvent{
    var pitcher_id = UUID()
    var expected_target: String = ""
    var actual_target: String = ""
    var pitch_type: String = ""
    var event_number: Int = 0
    
    init(pitcher_id: UUID, expected_target: String, actual_target: String, pitch_type: String, event_number: Int) {
        self.pitcher_id = pitcher_id
        self.expected_target = expected_target
        self.actual_target = actual_target
        self.pitch_type = pitch_type
        self.event_number = event_number
    }
    
}

@Model class Event{
    
    var pitcher_id = UUID()
    
    var pitch_result: String
    var pitch_type: String
    var result_detail: String
    var balls: Int
    var strikes: Int
    var outs: Int
    var inning: Int
    var atbats: Int
    var pitch_x_location: Double = 0
    var pitch_y_location: Double = 0
    var batter_stance: String = ""
    var velocity: Double = 0
    var event_number: Int = 0
    
    init(pitcher_id: UUID, pitch_result: String, pitch_type: String, result_detail: String, balls: Int, strikes: Int, outs: Int, inning: Int, atbats: Int, pitch_x_location: Double, pitch_y_location: Double, batter_stance: String, velocity: Double, event_number: Int) {
        self.pitcher_id = pitcher_id
        self.pitch_result = pitch_result
        self.pitch_type = pitch_type
        self.result_detail = result_detail
        self.balls = balls
        self.strikes = strikes
        self.outs = outs
        self.inning = inning
        self.atbats = atbats
        self.pitch_x_location = pitch_x_location
        self.pitch_y_location = pitch_y_location
        self.batter_stance = batter_stance
        self.velocity = velocity
        self.event_number = event_number
    }
}

@Model class Pitcher{
    var id = UUID()
    var firstName: String = ""
    var lastName: String = ""
    var pitch1: String = ""
    var pitch2: String = ""
    var pitch3: String = ""
    var pitch4: String = ""
    var throwingHand: String = ""
    
    init(id: UUID, firstName: String, lastName: String, pitch1: String, pitch2: String, pitch3: String, pitch4: String, throwingHand: String){
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.pitch1 = pitch1
        self.pitch2 = pitch2
        self.pitch3 = pitch3
        self.pitch4 = pitch4
        self.throwingHand = throwingHand
    }
}

struct SavedPitcherInfo: Codable, Hashable{
    var pitcher_id: UUID
    var first_name: String = ""
    var last_name: String = ""
    var pitch1: String = ""
    var pitch2: String = ""
    var pitch3: String = ""
    var pitch4: String = ""
}

@Model class SavedGames{
    var opponent_name: String
    var date: Date
    var location: String
    var game_data: [SavedEvent]
    var pitcher_info: [SavedPitcherInfo]
    
    init(opponent_name: String, date: Date, location: String, game_data: [SavedEvent], pitcher_info: [SavedPitcherInfo]) {
        self.opponent_name = opponent_name
        self.date = date
        self.location = location
        self.game_data = game_data
        self.pitcher_info = pitcher_info
    }
}

struct SavedEvent: Codable, Hashable{
    var event_num: Int
    var pitcher_id: UUID
    var pitch_result: String
    var pitch_type: String
    var result_detail: String
    var balls: Int
    var strikes: Int
    var outs: Int
    var inning: Int
    var battersfaced: Int
    var pitch_x_location: CGFloat
    var pitch_y_location: CGFloat
    var batters_stance: String
    var velocity: Double
}


