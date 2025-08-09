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
    
    @State var button_gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color("ScoreboardGreen"), Color("DarkScoreboardGreen")]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    @State var result: Result<Void, Error>?
    @State var error_message: String = ""
    
    @State var login_successful: Bool = false
    @State var login_failed: Bool = false
    
    @State var showPassword: Bool = false
    
    var body: some View {
        NavigationStack{
            
            ZStack{
                
                VStack{
                    VStack{
                        
                        Image("ElToro")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .padding(.bottom, 5)
                        
                        Text("Login")
                            .font(.system(size: 32, weight: .bold))
                            .padding(.bottom, 40)
                        
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
                            .padding(.bottom, 10)
                        
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
                        .padding(.bottom, 10)
                        
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
                        .padding(.bottom, 40)
                        .padding(.trailing, 5)
                        
                        Button{
                            
                            loginButtonPressed()
                            
                            Task{
                                await supabaseVM.isAuthenticated()
                            }
                            
                        } label: {
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(button_gradient)
                                
                                Text("Sign In")
                                    .font(.system(size: 17, weight: .semibold))
                                
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .foregroundStyle(.white)
                        .padding(.bottom, 10)
                        
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
//                        
//                        if let result {
//                            Section {
//                                switch result {
//                                case .success:
//                                    Text("Login Successful!")
//                                case .failure(let error):
//                                    Text(error.localizedDescription).foregroundStyle(.red)
//                                }
//                            }
//                        }
                        
                    }
                    
                    Spacer()
                    
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
                
                if login_successful == true {
                    
                    AuthConfirmPopUp(result: result ?? .success(()))
                }
                if login_failed == true {
                    
                    AuthDenyPopUp(error: error_message, close_action: {login_failed = false})
                    
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
                login_successful = true
                login_failed = false
                
            } catch {
                
                result = .failure(error)
                error_message = error.localizedDescription
                error_message = error_message.prefix(1).uppercased() + error_message.dropFirst()
                login_successful = false
                login_failed = true
                
            }
        }

    }
}

#Preview {
    SignInView()
}
