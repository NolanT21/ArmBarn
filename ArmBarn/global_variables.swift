//
//  scoreboard.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 11/18/23.
//

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
    
    var b1light: Color = .black
    var b2light: Color = .black
    var b3light: Color = .black
    
    var s1light: Color = .black
    var s2light: Color = .black
    
    var o1light: Color = .black
    var o2light: Color = .black
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
    
    var recordEvent: Bool = false
}

@Observable class currentPitcher{
    //var idcode: String = ""
    var firstName: String = ""
    var lastName: String = "Choose Pitcher"
    var pitch1: String = "None"
    var pitch2: String = "None"
    var pitch3: String = "None"
    var pitch4: String = "None"
    var arsenal: [String] = ["None", "None", "None", "None"]
    var pitch_num: Int = 4
}

@Observable class PitchTypeConfig{
    var ptcolor: Color = .pink
    var ab_pitch_color: [Color] = []
    var pitch_x_loc: [CGFloat] = []
    var pitch_y_loc: [CGFloat] = []
    var pitch_cur_ab: Int = 0
    var arsenal_colors: [Color] = [.orange, .yellow, .red, .blue]
    var hidePitchOverlay: Bool = false
}

@Model class Pitcher{
    //var idcode = UUID()
    //@Attribute(.unique) var id: UUID
    var firstName: String
    var lastName: String
    var pitch1: String
    var pitch2: String
    var pitch3: String
    var pitch4: String
    
    init(/*idcode: UUID,*/ firstName: String, lastName: String, pitch1: String, pitch2: String, pitch3: String, pitch4: String){
        //self.idcode = idcode
        self.firstName = firstName
        self.lastName = lastName
        self.pitch1 = pitch1
        self.pitch2 = pitch2
        self.pitch3 = pitch3
        self.pitch4 = pitch4
    }
}

@Model class Event{
    var pitch_result: String
    var pitch_type: String
    var result_detail: String
    var balls: Int
    var strikes: Int
    var outs: Int
    var inning: Int
    var atbats: Int
    
    init(pitch_result: String, pitch_type: String, result_detail: String, balls: Int, strikes: Int, outs: Int, inning: Int, atbats: Int) {
        self.pitch_result = pitch_result
        self.pitch_type = pitch_type
        self.result_detail = result_detail
        self.balls = balls
        self.strikes = strikes
        self.outs = outs
        self.inning = inning
        self.atbats = atbats
    }
}
