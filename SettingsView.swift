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
    
    @State private var useBatterStance = false
    @State private var useStrikeType = false
    @State private var useVelocityInput = false
    
    @State private var selected_velo_units = "MPH"
    let velo_units = ["MPH", "KPH"]
    
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    Section(header: Text("Input Options")){
                        HStack{
                            Image(systemName: "figure.baseball")
                            Toggle("Batter Stance", isOn: $useBatterStance)
                                .onChange(of: useBatterStance){
                                    ASBatterStance = useBatterStance
                                }
                        }
                        .tint(Color("ScoreboardGreen"))
                        HStack{
                            Image(systemName: "bolt")
                            Toggle("Strike Type", isOn: $useStrikeType)
                                .onChange(of: useStrikeType){
                                    ASStrikeType = useStrikeType
                                }
                        }
                        .tint(Color("ScoreboardGreen"))
                        HStack{
                            Image(systemName: "gauge.with.needle")
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
                    Section{
                        Button {
                            
                        } label: {
                            Text("Show Walkthrough")
                                .foregroundStyle(Color("ScoreboardGreen"))
                        }
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
            }
        }
    }
}

#Preview {
    SettingsView()
}
