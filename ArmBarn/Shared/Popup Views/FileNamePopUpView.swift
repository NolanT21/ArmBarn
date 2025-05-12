//
//  FileNamePopUpView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 7/15/24.
//

import SwiftUI
import TipKit

struct FileNamePopUpView: View {
    
    @AppStorage("CurrentOpponentName") var ASCurOpponentName : String?
    @AppStorage("GameLocation") var ASGameLocation : String?
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(GameReport.self) var game_report
    @Environment(\.dismiss) var dismiss
    
    var welcometip = WelcomeTip()
    
    var game_location: [String] = ["Home", "Away"]
    @State private var selected_location = "Home"
    
    @State private var start_date = Date.now
    
    @State private var showExportPR: Bool = true
    
    @State private var opponentname: String = String()
    @State private var validTeamName: Bool = false
    
    @FocusState private var fieldIsFocused: Bool
    
    var font_color: Color = .white
    var crnr_radius: CGFloat = 12
    
    let title: String = "Game Information"
    let buttonTitle: String = "ENTER"
    let action: () -> ()
    
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        
        if showExportPR == true {
            ZStack(alignment: .top){
                
                Color(.black)
                    .opacity(0.2)
                
                HStack{
                    
                    VStack{
                        
                        VStack{
                            TipView(welcometip)
                                .tipBackground(Color("DarkGrey"))
                                .tint(Color("ScoreboardGreen"))
                                .padding(.horizontal, 10)
                                .preferredColorScheme(.dark)
                        }
                        .frame(minHeight: 35)
                        
                        
                        // Spacer()
                        
                        ZStack{
                                
                            VStack(alignment: .center){
                                
                                Text(title)
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundStyle(font_color)
                                    .padding(.top, 5)
                                    .padding(.bottom, 15)
                                
                                TextField("Enter Opponent Name", text: $opponentname)
                                    .focused($fieldIsFocused)
                                    .submitLabel(.done)
                                    .font(.system(size: 20, weight: .bold))
                                    .textFieldStyle(.roundedBorder)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 20)
                                
                                Picker("", selection: $selected_location) {
                                    ForEach(game_location, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
                                .padding()
                                .onChange(of: selected_location){
                                    impact.impactOccurred()
                                    game_report.game_location = selected_location
                                    ASGameLocation = selected_location
                                }
                                
                                VStack{
                                    
                                    Text("Start Time")
                                        .font(.system(size: 17))
                                        .foregroundStyle(font_color)
                                    
                                    DatePicker("", selection: $start_date)
                                        .labelsHidden()
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                                        .accentColor(Color("ScoreboardGreen"))
                                        .padding(.horizontal, 20)
                                        .padding(.top, -5)
                                }
                                
                                
                                Button {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12){
                                        fieldIsFocused = false
                                        game_report.opponent_name = opponentname
                                        ASCurOpponentName = opponentname
                                        game_report.start_date = start_date
                                        action()
                                    }
                                    close()
                                
                                    welcometip.invalidate(reason: .actionPerformed)
                                    
                                    Task{
                                        await SelectPitcherTip.showPitcherTip.donate()
                                    }
                                    
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: crnr_radius)
                                            .foregroundColor(validTeamName ? Color("ScoreboardGreen") : Color.gray)
                                        
                                        Text(buttonTitle)
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundStyle(font_color)
                                            .padding()
                                    }
                                    .padding()
                                    
                                }
                                .disabled(!validTeamName || opponentname.isEmpty)
                                .onChange(of: opponentname){ _, _ in
                                    validate_opponent_name()
                                }
                                
                            }
                            .padding()
                            .background(Color("DarkGrey"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 30)
                            .fixedSize(horizontal: false, vertical: true)
                            .offset(x: 0, y: offset)
                            .onAppear{
                                withAnimation(.spring()) {
                                    offset = 20
                                }
                            }
                            
                        }
                        .ignoresSafeArea()
                        
                        //.border(Color.orange, width: 4)
                        
                        
                    }
//                    .border(Color.blue, width: 4)
                }
                .padding(.top, 50)

            }
            .ignoresSafeArea()
            .onAppear{
                //scoreboard.enable_bottom_row = false
                game_report.game_location = "Home"
                ASGameLocation = "Home"
            }
            //.padding(.top, 0)

        }

    }
    
    func validate_opponent_name() {
        let validate = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z\\s\\&\\-]*$")
        validTeamName = validate.evaluate(with: opponentname)
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showExportPR = false
            }
        }
    }
    
}

#Preview {
    FileNamePopUpView(action: {})
}
