//
//  general_functions.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 1/21/24.
//

import Foundation
import SwiftData


func add_event_string() {
    print("ENTERED")
    //if event.recordEvent{
        var new_event = Event(pitch_result: event.pitch_result, pitch_type: event.pitch_type, result_detail: event.result_detail, balls: event.balls, strikes: event.strikes, outs: event.outs, inning: event.inning, atbats: event.atbats)
        context.insert(new_event)
        print_Event_String()
    //}
//        else {
//            event.recordEvent = true
//            do {
//                try context.delete(model: Event.self)
//            } catch {
//                print("Failed to delete all events.")
//            }
//        }
}


