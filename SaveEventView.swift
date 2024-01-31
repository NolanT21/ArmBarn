//
//  SaveEventView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 1/21/24.
//

import SwiftUI
import SwiftData

struct SaveEventView: View {
    
    @Environment(Event_String.self) var event
    @Environment(\.modelContext) var context
    
    var body: some View {
        
        NavigationStack{
            
            MainContainerView().onAppear{
                add_event_string()
            }

        }
    }
    
    func add_event_string() {
        print("ENTERED")
            var new_event = Event(pitch_result: event.pitch_result, pitch_type: event.pitch_type, result_detail: event.result_detail, balls: event.balls, strikes: event.strikes, outs: event.outs, inning: event.inning, atbats: event.atbats)
            context.insert(new_event)
            print_Event_String()
    }
    func print_Event_String() {
        print(event.pitch_result, event.pitch_type, event.result_detail, event.balls, event.strikes, event.outs, event.inning, event.atbats)
    }
}

#Preview {
    SaveEventView()
}
