//
//  TestView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 1/7/24.
//

import SwiftUI
import SwiftData

struct TestView: View {
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(currentPitcher.self) var current_pitcher
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    @Environment(Event_String.self) var event
    
    @Environment(\.dismiss) var dismiss
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    var body: some View {
        NavigationStack{
            VStack {
                List {
                    Menu(content: {
                        ForEach(pitchers) { value in
                            Text(value.lastName)
    //                        Button(value.lastName) {
    //                            current_pitcher.pitch_num = 0
    //                            current_pitcher.firstName = value.firstName
    //                            current_pitcher.lastName = value.lastName
    //                            current_pitcher.pitch1 = value.pitch1
    //                            if current_pitcher.pitch1 != "None" {
    //                                current_pitcher.pitch_num += 1
    //                                current_pitcher.arsenal[0] = value.pitch1
    //                            }
    //
    //                            current_pitcher.pitch2 = value.pitch2
    //                            if current_pitcher.pitch2 != "None" {
    //                                current_pitcher.pitch_num += 1
    //                                current_pitcher.arsenal[1] = value.pitch2
    //                            }
    //
    //                            current_pitcher.pitch3 = value.pitch3
    //                            if current_pitcher.pitch3 != "None" {
    //                                current_pitcher.pitch_num += 1
    //                                current_pitcher.arsenal[2] = value.pitch3
    //                            }
    //
    //                            current_pitcher.pitch4 = value.pitch4
    //                            if current_pitcher.pitch4 != "None" {
    //                                current_pitcher.pitch_num += 1
    //                                current_pitcher.arsenal[3] = value.pitch4
    //                            }
    //                        }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    
                                } label : {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                        
                    }, label: {
                        if pitchers.count <= 0 {
                            Text("Add Pitcher")
                        }
                        else {
                            Text(current_pitcher.lastName)
                        }
                        
                    })
                    .foregroundColor(Color.black)
                    .bold()
                }
                
            }
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
