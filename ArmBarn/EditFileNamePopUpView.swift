//
//  EditFileNamePopUpView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 2/27/25.
//

import SwiftUI

struct EditFileNamePopUpView: View {
    
    @Bindable var gameInfo: SavedGames
    
    @State private var opponentname: String = String()
    @State private var validTeamName: Bool = false
    
    @State private var offset: CGFloat = 1000
    @State private var showEditInfo: Bool = true
    
    @FocusState private var fieldIsFocused: Bool
    
    var font_color: Color = .white
    var crnr_radius: CGFloat = 12
    
    var game_location: [String] = ["Home", "Away"]
    let title: String = "Edit Game Information"
    let buttonTitle: String = "ENTER"
    
    let close_action: () -> ()
    
    var body: some View {
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        
        ZStack{
            
            Color(.black)
                .opacity(0.2)
            
            ZStack {
                
                VStack{
                    
                    Text(title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(font_color)
                        .padding()
                    
                    TextField("Enter Opponent Name", text: $gameInfo.opponent_name)
                        .focused($fieldIsFocused)
                        .submitLabel(.done)
                        .font(.system(size: 20, weight: .bold))
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                    
                    Picker("", selection: $gameInfo.location) {
                        ForEach(game_location, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
                    .padding()
                    .onChange(of: gameInfo.location){
                        impact.impactOccurred()
                        
//                        game_report.game_location = selected_location
//                        ASGameLocation = selected_location
                    }
                    
                    VStack{
                        
                        Text("Start Time")
                            .font(.system(size: 17))
                            .foregroundStyle(font_color)
                        
                        DatePicker("", selection: $gameInfo.date)
                            .labelsHidden()
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .accentColor(Color("ScoreboardGreen"))
                            .padding(.horizontal, 20)
                            .padding(.top, -5)
                    }
                    
                    Button {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12){
                                fieldIsFocused = false
                                close_action()
//                                game_report.opponent_name = opponentname
//                                ASCurOpponentName = opponentname
//                                game_report.start_date = start_date

                            }
                            close()
                        
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
                    .disabled(!validTeamName || gameInfo.opponent_name.isEmpty)
                    .onChange(of: gameInfo.opponent_name){ _, _ in
                        validate_opponent_name()
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
                    validate_opponent_name()
                }
            }
        }
//        .onAppear{
//            scoreboard.enable_bottom_row = false
//            game_report.game_location = "Home"
//            ASGameLocation = "Home"
//        }
        .padding(.top, 0)
        .ignoresSafeArea()
    }
    
    func validate_opponent_name() {
        let validate = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z\\s\\&\\-]*$")
        validTeamName = validate.evaluate(with: gameInfo.opponent_name)
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showEditInfo = false
            }
        }
    }
    
    
}

struct EditFileNamePopUpSettingsView: View {
    
    @AppStorage("CurrentOpponentName") var ASCurOpponentName : String?
    @AppStorage("GameLocation") var ASGameLocation : String?
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(GameReport.self) var game_report
    @Environment(\.dismiss) var dismiss
    
    @State private var opponentname: String = ""
    @State private var gamelocation: String = ""
    @State private var startdate = Date.now
    @State private var validTeamName: Bool = false
    
    @State private var offset: CGFloat = 1000
    @State private var showEditInfo: Bool = true
    
    @FocusState private var fieldIsFocused: Bool
    
    var font_color: Color = .white
    var crnr_radius: CGFloat = 12
    
    var game_location: [String] = ["Home", "Away"]
    let title: String = "Edit Game Information"
    let buttonTitle: String = "ENTER"
    
    let close_action: () -> ()
    
    var body: some View {
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        
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
                    
                    Picker("", selection: $gamelocation) {
                        ForEach(game_location, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
                    .padding()
                    .onChange(of: gamelocation){
                        impact.impactOccurred()
                        

                    }
                    
                    VStack{
                        
                        Text("Start Time")
                            .font(.system(size: 17))
                            .foregroundStyle(font_color)
                        
                        DatePicker("", selection: $startdate)
                            .labelsHidden()
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .accentColor(Color("ScoreboardGreen"))
                            .padding(.horizontal, 20)
                            .padding(.top, -5)
                    }
                    
                    Button {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12){
                                fieldIsFocused = false
                                close_action()
                                game_report.opponent_name = opponentname
                                ASCurOpponentName = opponentname
                                game_report.start_date = startdate
                                game_report.game_location = gamelocation
                                ASGameLocation = gamelocation

                            }
                            close()
                        
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
                    .disabled(!validTeamName || opponentname.isEmpty)
                    .onChange(of: opponentname){ _, _ in
                        validate_opponent_name()
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
                    opponentname = game_report.opponent_name
                    gamelocation = game_report.game_location
                    startdate = game_report.start_date
                }
            }
        }
//        .onAppear{
//            scoreboard.enable_bottom_row = false
//            game_report.game_location = "Home"
//            ASGameLocation = "Home"
//        }
        .padding(.top, 0)
        .ignoresSafeArea()
    }
    
    func validate_opponent_name() {
        let validate = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z\\s\\&\\-]*$")
        validTeamName = validate.evaluate(with: opponentname)
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showEditInfo = false
            }
        }
    }
    
    
}

//#Preview {
//    EditFileNamePopUpView()
//}
