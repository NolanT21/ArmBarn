//
//  SignInView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 7/15/25.
//

import SwiftUI

struct SignInView: View {
    
    @StateObject private var supabaseVM = SupabaseViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State var result: Result<Void, Error>?
    
    @State var showPassword: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                
                Text("Login")
                    .font(.system(size: 32, weight: .bold))
                
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .tint(Color("ScoreboardGreen"))
                    .padding()
                    .overlay{
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
                            .padding(.horizontal, 2)
                    }
                
                HStack{
                    Group{
                        if showPassword == false {
                            SecureField("Password", text: $password)
                        }
                        else {
                            TextField("Password", text: $password)
                        }
                    }
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .tint(Color("ScoreboardGreen"))
                    
                    
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                    }
                    
                }
                .frame(height: 20)
                .padding()
                .overlay{
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
                        .padding(.horizontal, 2)
                }
                
                HStack{
                    Spacer()
                    
                    NavigationLink{
                        //Link to Reset Password Screen
                        
                    } label: {
                        Text("Forgot Password?")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Color("ScoreboardGreen"))
                    }
                    
                }
                
                Button{
                    
                    loginButtonPressed()
                    
                    Task{
                        await supabaseVM.isAuthenticated()
                    }
                    
                } label: {
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color("ScoreboardGreen"))
                        
                        Text("Sign In")
                            .font(.system(size: 17, weight: .semibold))
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 35)
                .foregroundStyle(.white)
                
                HStack{
                    Spacer()
                    
                    Text("Don't have an account?")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(Color.white)
                    
                    NavigationLink{
                        CreateAccountView().navigationBarBackButtonHidden(true).task{}
                        
                    } label: {
                        Text("Sign Up")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Color("ScoreboardGreen"))
                    }
                    
                    Spacer()
                    
                }
                
                if let result {
                    Section {
                        switch result {
                        case .success:
                            Text("Login Successful!")
                        case .failure(let error):
                            Text(error.localizedDescription).foregroundStyle(.red)
                        }
                    }
                }
                
            }
            .padding(.horizontal, 10)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    
                    Button{
                        
                        dismiss()
                        
                    } label: {
                        
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 24, height: 24)
                            .overlay{
                                
                                Image(systemName: "xmark")
                                    .imageScale(.medium)
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .bold()
                                
                            }
                        
                    }
                    
                }
            }
        }
    }
    
    func loginButtonPressed() {
        
        Task{
            do{
                
                try await supabase.auth.signIn(
                  email: email,
                  password: password
                )
                
                result = .success(())
                
                //Call isAuthenticated Logic
                
            } catch {
                
                result = .failure(error)
                
            }
        }

    }
}

#Preview {
    SignInView()
}
