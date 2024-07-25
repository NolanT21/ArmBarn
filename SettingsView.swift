//
//  SettingsView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 4/29/24.
//

import SwiftUI
import TipKit

struct SettingsView: View {
    
    @AppStorage("BatterStance") var ASBatterStance : Bool?
    @AppStorage("VelocityInput") var ASVeloInput : Bool?
    @AppStorage("StrikeType") var ASStrikeType : Bool?
    @AppStorage("VelocityUnits") var ASVeloUnits : String?
    
    @AppStorage("BoxScore") var ASBoxScore : Bool?
    @AppStorage("StrikePer") var ASStrikePer : Bool?
    @AppStorage("Location") var ASLocation : Bool?
    @AppStorage("HitSummary") var ASHitSummary : Bool?
    @AppStorage("GameScore") var ASGameScore : Bool?
    @AppStorage("PitByInn") var ASPitByInn : Bool?
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(Event_String.self) var event
    
    private let changeinputtip = ChangeInputTip()
    
    @State private var showInputChange = false
    @State private var showFileNameInfo = false
    
    @State private var useBatterStance = false
    @State private var useStrikeType = false
    @State private var useVelocityInput = false
    
    @State private var showBoxScore = false
    @State private var showStrikePer = false
    @State private var showLocationMap = false
    @State private var showHitSummary = false
    @State private var showGameScore = false
    @State private var showPitByInn = false
    
    @State private var selected_velo_units = "MPH"
    let velo_units = ["MPH", "KPH"]
    
    var body: some View {
        NavigationStack{
            
            ZStack{
                VStack{
                    List{
                        Section() {
                            TipView(changeinputtip)
                        }
                        
                        Section(header: Text("Input Options")){
                            HStack{
                                ZStack{
                                    Rectangle()
                                        .fill(Color("PowderBlue"))
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(7)
                                    Image(systemName: "figure.baseball")
                                        .imageScale(.large)
                                        .font(.system(size: 17))
                                        .foregroundColor(Color.white)
                                }
                                
                                Toggle("Batter Stance", isOn: $useBatterStance)
                                    .onChange(of: useBatterStance){
                                        let showpopup = allow_input_change()

                                        if showpopup == true {
                                            showInputChange = true
                                            useBatterStance = ASBatterStance ?? false
                                        }
                                        else {
                                            ASBatterStance = useBatterStance
                                            event.batter_stance = ""
                                        }

                                    }
                            }
                            .tint(Color("ScoreboardGreen"))
                            HStack{
                                ZStack{
                                    Rectangle()
                                        .fill(Color("Gold"))
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(7)
                                    Image(systemName: "bolt.fill")
                                        .imageScale(.large)
                                        .font(.system(size: 17))
                                        .foregroundColor(Color.white)
                                }
                                Toggle("Strike Type", isOn: $useStrikeType)
                                    .onChange(of: useStrikeType){
                                        let showpopup = allow_input_change()

                                        if showpopup == true {
                                            showInputChange = true
                                            useStrikeType = ASStrikeType ?? false
                                        }
                                        else {
                                            ASStrikeType = useStrikeType
                                        }
                                    }
                            }
                            .tint(Color("ScoreboardGreen"))
                            HStack{
                                ZStack{
                                    Rectangle()
                                        .fill(Color("Tangerine"))
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(7)
                                    Image(systemName: "gauge.with.needle")
                                        .imageScale(.large)
                                        .font(.system(size: 17))
                                        .foregroundColor(Color.white)
                                }
                                Toggle("Velocity Input", isOn: $useVelocityInput)
                                    .onChange(of: useVelocityInput){
                                        let showpopup = allow_input_change()
                                        
                                        if showpopup == true {
                                            showInputChange = true
                                            useVelocityInput = ASVeloInput ?? false
                                        }
                                        else {
                                            ASVeloInput = useVelocityInput
                                            event.velocity = 0.0
                                        }
                                        
                                    }
                            }
                            .tint(Color("ScoreboardGreen"))
                            Picker("Velocity Units", selection: $selected_velo_units) {
                                ForEach(velo_units, id: \.self) {
                                    Text($0)
                                        .bold()
                                }
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: selected_velo_units){
                                ASVeloUnits = selected_velo_units
                                print(selected_velo_units)
                            }
                        }
                        Section(header: Text("Output Options")){
                            HStack{
                                ZStack{
                                    Rectangle()
                                        .fill(Color("Grey"))
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(7)
                                    Image(systemName: "archivebox.fill")
                                        .imageScale(.large)
                                        .font(.system(size: 17))
                                        .foregroundColor(Color.white)
                                }
                                Toggle("Box Score", isOn: $showBoxScore)
                                    .onChange(of: showBoxScore){
                                        ASBoxScore = showBoxScore
                                    }
                            }
                            .tint(Color("ScoreboardGreen"))
                            HStack{
                                ZStack{
                                    Rectangle()
                                        .fill(Color("ScoreboardGreen"))
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(7)
                                    Image(systemName: "percent")
                                        .bold()
                                        .imageScale(.medium)
                                        .font(.system(size: 17))
                                        .foregroundColor(Color.white)
                                }
                                Toggle("Strike Percentages", isOn: $showStrikePer)
                                    .onChange(of: showStrikePer){
                                        ASStrikePer = showStrikePer
                                    }
                            }
                            .tint(Color("ScoreboardGreen"))
                            HStack{
                                ZStack{
                                    Rectangle()
                                        .fill(Color("Purple"))
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(7)
                                    Image(systemName: "location.fill")
                                        .imageScale(.medium)
                                        .font(.system(size: 17))
                                        .foregroundColor(Color.white)
                                }
                                Toggle("Pitch Location Map", isOn: $showLocationMap)
                                    .onChange(of: showLocationMap){
                                        ASLocation = showLocationMap
                                    }
                            }
                            .tint(Color("ScoreboardGreen"))
                            HStack{
                                ZStack{
                                    Rectangle()
                                        .fill(Color("Emerald"))
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(7)
                                    Image(systemName: "hammer.fill")
                                        .imageScale(.medium)
                                        .font(.system(size: 17))
                                        .foregroundColor(Color.white)
                                }
                                Toggle("Hit Summary", isOn: $showHitSummary)
                                    .onChange(of: showHitSummary){
                                        ASHitSummary = showHitSummary
                                    }
                            }
                            .tint(Color("ScoreboardGreen"))
                            HStack{
                                ZStack{
                                    Rectangle()
                                        .fill(Color("LightBrown"))
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(7)
                                    Image(systemName: "gamecontroller.fill")
                                        .imageScale(.medium)
                                        .font(.system(size: 17))
                                        .foregroundColor(Color.white)
                                }
                                Toggle("Game Score", isOn: $showGameScore)
                                    .onChange(of: showGameScore){
                                        ASGameScore = showGameScore
                                    }
                            }
                            .tint(Color("ScoreboardGreen"))
                            HStack{
                                ZStack{
                                    Rectangle()
                                        .fill(Color("Scarlet"))
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(7)
                                    Image(systemName: "chart.xyaxis.line")
                                        .imageScale(.large)
                                        .font(.system(size: 17))
                                        .foregroundColor(Color.white)
                                }
                                Toggle("Pitch by Inning Chart", isOn: $showPitByInn)
                                    .onChange(of: showPitByInn){
                                        ASPitByInn = showPitByInn
                                    }
                            }
                            .tint(Color("ScoreboardGreen"))
                            
                        }
                        Section() {
                            Button {
                                showFileNameInfo = true
                            } label: {
                                Text("Edit Game Info")
                            }
                            .bold()
                            .foregroundStyle(.white)
                            .listRowBackground(Color("ScoreboardGreen"))
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                        }
                    }
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarTitle("Settings")
                }
                .onAppear{
                    useBatterStance = ASBatterStance ?? false
                    useVelocityInput = ASVeloInput ?? false
                    useStrikeType = ASStrikeType ?? false
                    selected_velo_units = ASVeloUnits ?? "MPH"
                    
                    showBoxScore = ASBoxScore ?? true
                    showStrikePer = ASStrikePer ?? true
                    showLocationMap = ASLocation ?? true
                    showHitSummary = ASHitSummary ?? true
                    showGameScore = ASGameScore ?? true
                    showPitByInn = ASPitByInn ?? true
                    
                    ASBoxScore = showBoxScore
                    ASStrikePer = showStrikePer
                    ASLocation = showLocationMap
                    ASHitSummary = showHitSummary
                    ASGameScore = showGameScore
                    ASPitByInn = showPitByInn
                    
                    
                }
                
                if showInputChange == true {
                    InputChangePopUp()
                }
                
                if showFileNameInfo == true {
                    FileNamePopUpView(action: {showFileNameInfo = false})
                }
                
            }
            
            
        }
    }
    
    func allow_input_change() -> Bool{
        
        var showpopup = true
        
        if scoreboard.balls == 0 && scoreboard.strikes == 0 && scoreboard.pitches == 0 && scoreboard.inning == 1 && scoreboard.atbats == 1{
            showpopup = false
        }
        
        return showpopup
    }
    
}

#Preview {
    SettingsView()
}
