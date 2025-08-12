//
//  AddPitcherView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 12/12/23.
//

import SwiftUI
import SwiftData

struct AddPitcherView: View {
    
    enum NameFieldFocusable: Hashable {
      case firstname
      case lastname
    }
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Environment(currentPitcher.self) var current_pitcher
    
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    
    let pitch_types = ["None", "Fastball", "Curveball", "Slider", "Change-Up", "Splitter", "Cutter", "Sinker", "Sweeper", "Other"]
    
    @State private var selected_pitcher_hand = "Right"
    let pitcher_hand_list = ["Right", "Left"]
    
    @FocusState private var fieldIsFocused: NameFieldFocusable?
    
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
    
    @State var button_gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color("ScoreboardGreen"), Color("DarkScoreboardGreen")]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    var body: some View {
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        
        ZStack{
            
            VStack(alignment: .leading, spacing: 0){
                VStack(alignment: .leading){
                    
                    Button(action: {
                        dismiss()
                    }, label: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 25, height: 25)
                            .overlay{
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .font(.system(size: 13))
                                    .bold()
                            }
                            .padding(.leading, 10)
                            .padding(.top, 10)
//                        Image(systemName: "xmark")
//                            .imageScale(.medium)
//                            .font(.system(size: 17))
//                            .frame(width: sbl_width, height: sbl_height)
//                            .foregroundColor(text_color)
//                            .bold()
                            
                    })
                    
                    Text("Add Pitcher")
                        .font(.largeTitle).bold()
                        .foregroundColor(text_color)
                        .padding(.leading, 20)
                        .padding(.top, 10)
                    
                }
                
                Form{
                    Section(header: Text("Player Info")){
                        TextField("First Name", text: $firstName)
                            .focused($fieldIsFocused, equals: .firstname)
                            .tint(Color("ScoreboardGreen"))
                        
                        TextField("Last Name", text: $lastName)
                            .focused($fieldIsFocused, equals: .lastname)
                            .tint(Color("ScoreboardGreen"))

                        Picker("Pitcher Hand", selection: $selected_pitcher_hand) {
                            ForEach(pitcher_hand_list, id: \.self) {
                                Text($0)
                                    .bold()
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: selected_pitcher_hand){
                            impact.impactOccurred()
                            fieldIsFocused = nil
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
                        .onChange(of: pitch1){
                            fieldIsFocused = nil
                        }
                        Picker("Pitch 2", selection: $pitch2){
                            ForEach(pitch_types, id: \.self){
                                Text($0)
                            }
                        }
                        .onChange(of: pitch2){
                            fieldIsFocused = nil
                        }
                        Picker("Pitch 3", selection: $pitch3){
                            ForEach(pitch_types, id: \.self){
                                Text($0)
                            }
                        }
                        .onChange(of: pitch3){
                            fieldIsFocused = nil
                        }
                        Picker("Pitch 4", selection: $pitch4){
                            ForEach(pitch_types, id: \.self){
                                Text($0)
                            }
                        }
                        .onChange(of: pitch4){
                            fieldIsFocused = nil
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
                        
                        fieldIsFocused = nil
                        
                    }
                    .bold()
                    .foregroundStyle(.white)
                    .listRowBackground(button_gradient)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    
                }
                .onAppear{
                    fieldIsFocused = .firstname
                }
                .scrollContentBackground(.hidden)

            }
            
            if invalidPitcherName == true {
                TwoInputXPopUp(title: "Warning", description: "A saved pitcher has the same first and last name. Do you want to continue?", leftButtonText: "Yes", leftButtonAction: {save_pitcher(); dismiss()}, rightButtonText: "No", rightButtonAction: {}, close_action: {withAnimation{invalidPitcherName = false}} , flex_action: {})
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

