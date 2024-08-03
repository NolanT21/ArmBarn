//
//  FileNamePopUpView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 7/15/24.
//

import SwiftUI
import TipKit

struct FileNamePopUpView: View {
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(GameReport.self) var game_report
    @Environment(\.dismiss) var dismiss
    
    var welcometip = WelcomeTip()
    
    var game_location: [String] = ["Home", "Away"]
    @State private var selected_location = "Home"
    
    @State private var showExportPR: Bool = true
    
    @State var opponentname: String = String()
    
    @FocusState private var fieldIsFocused: Bool
    
    var font_color: Color = .white
    var crnr_radius: CGFloat = 12
    
    let title: String = "Game Information"
    let buttonTitle: String = "DONE"
    let action: () -> ()
    
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        
        if showExportPR == true {
            ZStack{
                
                Color(.black)
                    .opacity(0.2)
                
                ZStack {
                    
                    VStack{
                        
                        Text(title)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(font_color)
                            .padding()
                        
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
                            game_report.game_location = selected_location
                        }
                        
                        Button {
                            if opponentname != "" {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12){
                                    fieldIsFocused = false
                                    game_report.opponent_name = opponentname
                                    action()
                                }
                                close()
                                
                                welcometip.invalidate(reason: .actionPerformed)
                            }
                            
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: crnr_radius)
                                    .foregroundColor(Color("ScoreboardGreen"))
                                
                                Text(buttonTitle)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(font_color)
                                    .padding()
                            }
                            .padding()
                            
                        }
                        
                    }
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(30)
                    .offset(x: 0, y: offset)
                    .onAppear{
                        withAnimation(.spring()) {
                            offset = -100
                        }
                    }
                    
                    VStack{
                        
                        TipView(welcometip)
                            .tipBackground(Color("DarkGrey"))
                            .tint(Color("ScoreboardGreen"))
                            .padding(.horizontal, 20)
                            .preferredColorScheme(.dark)
                        
                        Spacer()
                        
                    }
                    
                }
                
                
                
            }
            .onAppear{
                scoreboard.enable_bottom_row = false
            }
            .padding(.top, 45)
            .ignoresSafeArea()

        }
        
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showExportPR = false
            }

//            showExportPR = true

        }
    }
    
}

#Preview {
    FileNamePopUpView(action: {})
}
