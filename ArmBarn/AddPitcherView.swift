//
//  AddPitcherView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 12/12/23.
//

import SwiftUI

struct AddPitcherView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Environment(currentPitcher.self) var current_pitcher
    
    let pitch_types = ["None", "Fastball", "Curveball", "Slider", "Change-Up", "Splitter", "Cutter", "Sinker", "Other"]
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var pitch1 = "None"
    @State private var pitch2 = "None"
    @State private var pitch3 = "None"
    @State private var pitch4 = "None"
    
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Player Name")){
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }
                Section(header: Text("Pitch Arsenal")){
                    Picker("Pitch 1", selection: $pitch1){
                        ForEach(pitch_types, id: \.self){
                            Text($0)
                        }
                    }
                    Picker("Pitch 2", selection: $pitch2){
                        ForEach(pitch_types, id: \.self){
                            Text($0)
                        }
                    }
                    Picker("Pitch 3", selection: $pitch3){
                        ForEach(pitch_types, id: \.self){
                            Text($0)
                        }
                    }
                    Picker("Pitch 4", selection: $pitch4){
                        ForEach(pitch_types, id: \.self){
                            Text($0)
                        }
                    }
                }
                Button("Save") {
                    let pitcher = Pitcher(firstName: firstName, lastName: lastName, pitch1: pitch1, pitch2: pitch2, pitch3: pitch3, pitch4: pitch4)
                    context.insert(pitcher)
                    dismiss()
                }
            }
            .foregroundColor(.black)
            .background(.green)
            .tint(.gray)
        }
        //.frame(width: 400, height: 400)
    }
}

#Preview {
    AddPitcherView()
        .environment(currentPitcher())
}
