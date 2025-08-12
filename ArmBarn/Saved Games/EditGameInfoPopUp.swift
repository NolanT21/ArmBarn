//
//  EditGameInfoPopUp.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 7/8/25.
//

import SwiftUI

struct EditGameInfoPopUp: View {
    
//    @AppStorage("CurrentOpponentName") var ASCurOpponentName : String?
//    @AppStorage("CurrentGameLocation") var ASGameLocation : String?
//    @AppStorage("CurrentGameStartTime") var ASStartTime : Date?
    
    @StateObject private var supabaseVM = SupabaseViewModel()
    
    @Bindable var gameInfo: SavedGames
    
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
                                //.submitLabel(.done)
                                .tint(Color("ScoreboardGreen"))
                                .font(.system(size: 17, weight: .medium))
                                .background(Color.gray.opacity(0.2))
                                .background(.regularMaterial)
                                .cornerRadius(8)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 20)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        fieldIsFocused = true
                                    }
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
                                            .onChange(of: start_date) {
                                                fieldIsFocused = false
                                            }

                           
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
                                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
                                .padding(.horizontal, 20)
                                .onChange(of: selected_location){
                                    fieldIsFocused = false
                                }
                            
                            Button {
                                
                                gameInfo.opponent_name = opponentname
                                gameInfo.location = selected_location
                                gameInfo.date = start_date

                                fieldIsFocused = false
                                withAnimation{
                                    close_action()
                                    location_overlay.game_info_entered = true
                                }
                                
                                if supabaseVM.isAuthenticated == true {
                                    
                                    print("Entered update game info section")
                                    
                                    // Create a DateFormatter for ISO 8601 format
                                    let isoDateFormatter = ISO8601DateFormatter()
                                    isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                                    isoDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                                    
                                    // Convert Date to ISO 8601 string
                                    let startDate = gameInfo.date
                                    let timestampString = isoDateFormatter.string(from: startDate)
                                    
                                    Task{
                                        try await supabaseVM.update_game_info(game_id: gameInfo.game_id, opponent: gameInfo.opponent_name, location: gameInfo.location, startTime: timestampString)
                                    }
//                                    
                                }
                                
                            } label: {
                                Text("Enter")
                                    .font(.system(size: 17, weight: .bold))
                                    .frame(width: 125, height: 40)
                                    .background(/*!validTeamName || */opponentname == ""  ? disabled_gradient : button_gradient)
                                    .foregroundColor(/*!validTeamName || */opponentname == "" ? Color.gray.opacity(0.5) : Color.white)
                                    .cornerRadius(8.0)
                            }
                            .disabled(opponentname == "")
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
            opponentname = gameInfo.opponent_name
            selected_location = gameInfo.location
            start_date = gameInfo.date
        }
        .task{
            await supabaseVM.isAuthenticated()
        }
    }
    
}

//#Preview {
//    EditGameInfoPopUp()
//}
