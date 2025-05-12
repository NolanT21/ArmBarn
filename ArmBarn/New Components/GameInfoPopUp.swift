//
//  GameInfoPopUp.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 4/29/25.
//

import SwiftUI

struct GameInfoPopUp: View {
    
    @Environment(GameReport.self) var game_report
    @Environment(LocationOverlay.self) var location_overlay
    
    @State private var validTeamName: Bool = false
    
    @State private var opponentname: String = String()
    @FocusState private var fieldIsFocused: Bool
    
    @State var game_location: [String] = ["Home", "Away"]
    @State private var selected_location = "Home"
    
    @State private var start_date = Date.now
    
    @State var close_action: () -> ()
    
    @State var button_gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color("ScoreboardGreen"), Color("DarkScoreboardGreen")]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    @State var disabled_gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color.gray.opacity(0.5)]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.5)
            
            VStack{
                
                Spacer()
                    .frame(height: 100)
                    
                    VStack(){
                        
                        Spacer()
                            .frame(maxHeight: 10)
                        
                        VStack(spacing: 20){
                            Text("Game Information")
                                .font(.system(size: 17, weight: .semibold))
                                        
                            TextField("Enter Opponent Name", text: $opponentname)
                                .padding(.vertical, 5)
                                .padding(.leading, 10)
                                .focused($fieldIsFocused)
                                .submitLabel(.done)
                                //.onSubmit {
                                    //event.velocity = veloinput
                                    //close()
                                    //close_action()
                                //}
                                .font(.system(size: 17, weight: .medium))
                                .background(Color.gray.opacity(0.2))
                                .background(.regularMaterial)
                                .cornerRadius(8)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 20)
                                .onAppear {
                                    fieldIsFocused = true
                                }
                                
                                VStack{
                                    
                                    Text("Start Time")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundStyle(Color.white)
                                    
                                    HStack(spacing: 5){
                                        Spacer()
                                        
                                        DatePicker("", selection: $start_date, displayedComponents: [.date, .hourAndMinute])
                                            .labelsHidden()
                                            .transformEffect(.init(scaleX: 0.9, y: 0.9))
                                            .accentColor(Color("ScoreboardGreen"))
//                                            .padding(.horizontal, 20)
                                            .padding(.top, -5)
                                            .padding(.leading, 20)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)

                           
                                        Spacer()
                                    }
                                }
                                
                                Picker("", selection: $selected_location) {
                                    ForEach(game_location, id: \.self) {
                                        Text($0)
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundStyle(Color.white)
                                    }
                                }
                                .pickerStyle(.segmented)
                                //.pickerStyle(.inline)
                                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
                                .padding(.horizontal, 20)
                                //.padding(.top, -32)
                                //.frame(width: 200)
                                //.clipped()
                                .onChange(of: selected_location){
                                    //impact.impactOccurred()
                                    //game_report.game_location = selected_location
                                    //ASGameLocation = selected_location
                                }
                            
                            Button {
                                //Logic for storing game information
                                game_report.opponent_name = opponentname
                                game_report.game_location = selected_location
                                game_report.start_date = start_date
                                
                                fieldIsFocused = false
                                withAnimation{
                                    close_action()
                                    location_overlay.game_info_entered = true
                                }
                            } label: {
                                Text("Enter")
                                    .font(.system(size: 17, weight: .bold))
                                    .frame(width: 125, height: 40)
                                    .background(!validTeamName || opponentname == ""  ? disabled_gradient : button_gradient)
                                    .foregroundColor(!validTeamName || opponentname == "" ? Color.gray.opacity(0.5) : Color.white)
                                    .cornerRadius(8.0)
                            }
                            .disabled(!validTeamName || opponentname == "")
                            .onChange(of: opponentname){ _, _ in
                                validate_opponent_name()
                            }
                        }
                        .overlay{
                            VStack{
                                
                                HStack{
                                    Button {
                                        fieldIsFocused = false
                                        withAnimation{
                                            close_action()
                                        }
                                    } label: {
                                        Circle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 20, height: 20)
                                            .overlay{
                                                Image(systemName: "xmark")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 11).bold())
                                            }
                                    }
                                    .padding(.top, -10)
                                    .padding(.horizontal, -3)
                                    
                                    Spacer()
                                    
                                }
                                
                                Spacer()
                            }
                        }
                        
                        Spacer()
                            .frame(maxHeight: 10)
                    
                }
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .padding()
                .background(Color.black.opacity(0.2))
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 20)
                .padding(45)
                
                Spacer()
                
            }
        }
        .onAppear{
            if location_overlay.game_info_entered == true {
                opponentname = game_report.opponent_name
                selected_location = game_report.game_location
                start_date = game_report.start_date
            }
        }
    }
    
    func validate_opponent_name() {
        let validate = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z\\s\\&\\-]*$")
        validTeamName = validate.evaluate(with: opponentname)
    }
    
}
