//
//  EndGameView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 1/20/24.
//

import SwiftUI
import SwiftData

struct EndGameView: View {
    
    @Query var events: [Event]
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(Event_String.self) var event
    @Environment(GameReport.self) var game_report
    
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        List {
            ForEach(events) {evnt in
                VStack{
                    
                    Text("\(evnt.pitcher_id)")
                    
                    HStack{
                        Text(evnt.pitch_result)
                        Text(evnt.pitch_type)
                        Text(evnt.result_detail)
                        Text("\(evnt.balls)")
                        Text("\(evnt.strikes)")
                        Text("\(evnt.outs)")
                        Text("\(evnt.inning)")
                        Text("\(evnt.atbats)")
                        Text("\(evnt.pitch_x_location)")
                        Text("\(evnt.pitch_y_location)")
                    }
                }
            }
        }
    }
}

#Preview {
    EndGameView()
}
