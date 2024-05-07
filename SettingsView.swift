//
//  SettingsView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 4/29/24.
//

import SwiftUI

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
            VStack{
                List{
                    Section(header: Text("Input Options")){
                        HStack{
                            ZStack{
                                Rectangle()
                                    .fill(Color("PowderBlue"))
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(7)
                                Image(systemName: "figure.baseball")
                            }
                            
                            Toggle("Batter Stance", isOn: $useBatterStance)
                                .onChange(of: useBatterStance){
                                    ASBatterStance = useBatterStance
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
                            }
                            Toggle("Strike Type", isOn: $useStrikeType)
                                .onChange(of: useStrikeType){
                                    ASStrikeType = useStrikeType
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
                            }
                            Toggle("Velocity Input", isOn: $useVelocityInput)
                                .onChange(of: useVelocityInput){
                                    ASVeloInput = useVelocityInput
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
                            }
                            Toggle("Pitch by Inning Chart", isOn: $showPitByInn)
                                .onChange(of: showPitByInn){
                                    ASPitByInn = showPitByInn
                                }
                        }
                        .tint(Color("ScoreboardGreen"))
                        
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
            }
        }
    }
}

#Preview {
    SettingsView()
}
