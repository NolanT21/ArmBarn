//
//  AccountView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 7/24/25.
//

import SwiftUI

struct AccountView: View {
    
    @StateObject private var supabaseVM = SupabaseViewModel()
    
    @State private var first_name: String = "No"
    @State private var last_name: String = "Account"
    
    @State private var showSignIn: Bool = false
    
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
            .padding(10)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .background(.regularMaterial)
            .cornerRadius(12)
            
            Spacer()
            
        }
        .task{
            await supabaseVM.isAuthenticated()
        }
    }
}

#Preview {
    AccountView()
}
