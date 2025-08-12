//
//  AccountView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 7/24/25.
//

import SwiftUI

struct AccountView: View {
    
    @StateObject private var supabaseVM = SupabaseViewModel()
    
    @AppStorage("SelectedVelocityUnits") var ASVelocityUnits : String?
    
    @State private var first_name: String = "No"
    @State private var last_name: String = "Account"
    
    @State private var showSignIn: Bool = false
    
    var velo_unit_list = ["MPH", "KPH"]
    @State private var selected_units = ""
    
    var body: some View {
        VStack{
            
            HStack{
                
                Spacer()
                
                if supabaseVM.isAuthenticated == true{
                    Button{
                        Task{
                            try await supabaseVM.signOut()
                        }
                    } label: {
                        Text("Sign Out")
                            .font(.system(size: 15, weight: .regular))
                    }
                    .foregroundStyle(Color("ScoreboardGreen"))
                } else {
                    Button{
                        
                        showSignIn = true
                        
                    } label: {
                        Text("Sign In")
                            .font(.system(size: 15, weight: .regular))
                    }
                    .foregroundStyle(Color("ScoreboardGreen"))
                    .popover(isPresented: $showSignIn) {
                        SignInView()
                            .onDisappear {
                                
                                Task{
                                    await supabaseVM.isAuthenticated()
                                }
                                
                            }
                    }
                }
                
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
            
            Form{
                Section{
                    VStack{
                        
                        HStack{
                            
                            Ellipse()
                                .fill(Color.gray)
                                .frame(width: 50, height: 50)
                                .overlay{
                                    Text(first_name.prefix(1).uppercased() + last_name.prefix(1).uppercased())
                                        .font(.system(size: 23, weight: .medium))
                                }
                            
                            HStack{
                                
                                Text(first_name + " " + last_name)
                                    .font(.system(size: 19, weight: .medium))
                                
                                Spacer()
                                
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 5)
                            
                            Spacer()
                            
                        }
                        
                    }
                    //.padding(10)
                    .frame(maxWidth: .infinity)
                    //.padding(.horizontal, 20)
                    //.background(.regularMaterial)
                    .cornerRadius(12)
                }
                
                Section{
                    Button{
                        print("Ticket")
                    } label: {
                        Image("ProTicket")
                            .resizable()
                            //.padding(.horizontal, 20)
                            .frame(height: 150)
                    }
                }
                .listRowBackground(Color.clear)
                
                Section{
                    
                    HStack{
                        
                        ZStack{
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 25, height: 25)
                                .cornerRadius(7)
                            Image(systemName: "gauge.with.needle")
                                .font(.system(size: 15))
                                .foregroundColor(Color.white)
                        }
                        
                        Picker("Velocity Units", selection: $selected_units){
                            ForEach(velo_unit_list, id: \.self) {
                                Text($0)
                            }
                        }
                        .onChange(of: selected_units){
                            ASVelocityUnits = selected_units
                        }
                        .padding(.leading, 5)

                    }
                    
                    
                }
                
                Section("Support Us"){
                    HStack{
                        ZStack{
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 25, height: 25)
                                .cornerRadius(7)
                            Image(systemName: "star.fill")
                                .font(.system(size: 15))
                                .foregroundColor(Color.white)
                        }
                        
                        Link("Rate ArmBarn in the App Store", destination: URL(string: "https://apps.apple.com/us/app/armbarn/id6503445937?action=write-review")!)
                            .padding(.leading, 5)
                            .foregroundStyle(Color.blue)
                        
                    }
                    
                    HStack{
                        ZStack{
                            Rectangle()
                                .fill(Color.orange)
                                .frame(width: 25, height: 25)
                                .cornerRadius(7)
                            Image(systemName: "star.bubble")
                                .font(.system(size: 15))
                                .foregroundColor(Color.white)
                        }
                        
                        ShareLink(item: URL(string: "https://getarmbarn.com/")!) {
                            Text("Recommend ArmBarn to Others")
                                .padding(.leading, 5)
                                .foregroundStyle(Color.blue)
                        }
                        
                    }
                    
                }
                
                Section{
                    HStack{
                        ZStack{
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 25, height: 25)
                                .cornerRadius(7)
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 15))
                                .foregroundColor(Color.white)
                        }
                        
                        Text("Help and Support")
                            .padding(.leading, 5)
                        
                    }
                    
                    HStack{
                        ZStack{
                            Rectangle()
                                .fill(Color.purple)
                                .frame(width: 25, height: 25)
                                .cornerRadius(7)
                            Image(systemName: "signature")
                                .font(.system(size: 15))
                                .foregroundColor(Color.white)
                        }
                        
                        Text("Terms of Service")
                            .padding(.leading, 5)
                        
                    }
                    
                    HStack{
                        ZStack{
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: 25, height: 25)
                                .cornerRadius(7)
                            Image(systemName: "hand.raised.fill")
                                .font(.system(size: 15))
                                .foregroundColor(Color.white)
                        }
                        
                        Text("ArmBarn and Your Data")
                            .padding(.leading, 5)
                    }
                    
                }
                
            }
            
            Spacer()
            
        }
        .task{
            await supabaseVM.isAuthenticated()
        }
        .onAppear{
            if ASVelocityUnits == nil {
                selected_units = "MPH"
            }
            else {
                selected_units = ASVelocityUnits ?? "MPH"
            }
        }
    }
}

#Preview {
    AccountView()
}
