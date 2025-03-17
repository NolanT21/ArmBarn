//
//  AddPitcherView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 12/12/23.
//

import SwiftUI
import SwiftData

struct AddPitcherView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Environment(currentPitcher.self) var current_pitcher
    
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    
    let pitch_types = ["None", "Fastball", "Curveball", "Slider", "Change-Up", "Splitter", "Cutter", "Sinker", "Sweeper", "Other"]
    
    @State private var selected_pitcher_hand = "Right"
    let pitcher_hand_list = ["Right", "Left"]
    
    @State private var invalidPitcherName: Bool = false
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var pitch1 = "None"
    @State private var pitch2 = "None"
    @State private var pitch3 = "None"
    @State private var pitch4 = "None"
    
    @State private var text_color = Color.white
     
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    var body: some View {
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        
        ZStack{
            
            VStack{
                HStack{
                    
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .imageScale(.medium)
                            .font(.system(size: 17))
                            .frame(width: sbl_width, height: sbl_height)
                            .foregroundColor(text_color)
                            .bold()
                    })
                    
                    Spacer()
                    
                    Text("Add Pitcher")
                        .font(.system(size: 17))
                        .foregroundColor(text_color)
                    
                    Spacer()
                    
                    Text("")
                    
                }
                .padding(15)
                
                Form{
                    Section(header: Text("Player Info")){
                        TextField("First Name", text: $firstName)
                        
                        TextField("Last Name", text: $lastName)

                        Picker("Velocity Units", selection: $selected_pitcher_hand) {
                            ForEach(pitcher_hand_list, id: \.self) {
                                Text($0)
                                    .bold()
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: selected_pitcher_hand){
                            impact.impactOccurred()
                            //ASVeloUnits = selected_velo_units
                            //print(selected_velo_units)
                        }
                        
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
                        for p_er in pitchers {
                            if p_er.firstName == firstName && p_er.lastName == lastName {
                                invalidPitcherName = true
                                break
                            }
                        }
                        if invalidPitcherName == false{
                            save_pitcher()
                            dismiss()
                        }
                        
                    }
                    .bold()
                    .foregroundStyle(.white)
                    .listRowBackground(Color("ScoreboardGreen"))
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    
                }

            }
            
            if invalidPitcherName == true {
                XPopupAlertView(isActive: $invalidPitcherName, show_close: false, title: "Error", message: "Another pitcher has the same first and last name. Do you want to continue?", leftButtonAction: {invalidPitcherName = false; save_pitcher(); dismiss()}, rightButtonAction: {invalidPitcherName = false}, XButtonAction: {invalidPitcherName = false})
            }
            
        }

    }
    
    func save_pitcher(){
        let pitcher = Pitcher(id: UUID(), firstName: firstName, lastName: lastName, pitch1: pitch1, pitch2: pitch2, pitch3: pitch3, pitch4: pitch4, throwingHand: selected_pitcher_hand)
        context.insert(pitcher)
    }
}

#Preview {
    AddPitcherView()
        .environment(currentPitcher())
}

