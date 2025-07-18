//
//  CreateAccountView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 7/14/25.
//

import SwiftUI

struct CreateAccountView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var first_name: String = ""
    @State private var last_name: String = ""
    @State private var organization_name: String = ""
    @State private var team_mascot: String = ""
    
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    
    @State var result: Result<Void, Error>?
    
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack{
            NavigationStack{
                
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .imageScale(.medium)
                            .font(.system(size: 17))
                            .foregroundColor(Color.white)
                            .bold()
                    }
                    .padding(10)
                    
                    Spacer()
                    
                }
                
                List{
                
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
                        .listRowSeparator(.hidden)
                        
                    
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
                    .listRowSeparator(.hidden)
                    
//                    HStack{
//                        Group{
//                            if showConfirmPassword == false {
//                                SecureField("Confirm Password", text: $confirmPassword)
//                            }
//                            else {
//                                TextField("Confirm Password", text: $confirmPassword)
//                            }
//                        }
//                        .disableAutocorrection(true)
//                        .autocapitalization(.none)
//                        
//                        
//                        Button {
//                            showConfirmPassword.toggle()
//                        } label: {
//                            Image(systemName: showConfirmPassword ? "eye.fill" : "eye.slash.fill")
//                                .foregroundColor(.gray)
//                                .font(.system(size: 15))
//                        }
//                        
//                    }
//                    .frame(height: 20)
//                    .padding()
//                    .overlay{
//                        RoundedRectangle(cornerRadius: 8, style: .continuous)
//                            .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
//                            .padding(.horizontal, 2)
//                    }
//                    .listRowSeparator(.hidden)
                    
                    HStack{
                        
                        TextField("First Name", text: $first_name)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .padding()
                            .overlay{
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
                                    .padding(.horizontal, 2)
                            }
                            .listRowSeparator(.hidden)
                        
                        TextField("Last Name", text: $last_name)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .padding()
                            .overlay{
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
                                    .padding(.horizontal, 2)
                            }
                            .listRowSeparator(.hidden)
                        
                    }
                    
                    TextField("Organization Name", text: $organization_name)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .overlay{
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
                                .padding(.horizontal, 2)
                        }
                        .listRowSeparator(.hidden)
                    
                    TextField("Team Mascot", text: $team_mascot)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .overlay{
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
                                .padding(.horizontal, 2)
                        }
                        .listRowSeparator(.hidden)
                    
                    Spacer()
                        .frame(height: 50)
                    
                    VStack{
                        
                        Button{
                            
                            signUpButtonTapped()
                            print("Sign Up Button Clicked")
                            
                        } label: {
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color("ScoreboardGreen"))
                                
                                Text("Sign Up")
                                    .font(.system(size: 17, weight: .semibold))
                                
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.white)
                    }
                    
                    .listRowSeparator(.hidden)
                    
                    if let result {
                        Section {
                            switch result {
                            case .success:
                                Text("Account created successfully!")
                            case .failure(let error):
                                Text(error.localizedDescription).foregroundStyle(.red)
                            }
                        }
                    }

                }
                .preferredColorScheme(.dark)
                .navigationBarTitleDisplayMode(.automatic)
                .navigationTitle("Create Account")
                .tint(Color("ScoreboardGreen"))
                .listStyle(.plain)
                .padding(.top, 50)
                .onOpenURL(perform: { url in
                    Task{
                        do {
                            
                            try await supabase.auth.session(from: url)
                            
                        } catch {
                            self.result = .failure(error)
                        }
                    }
                })
                
            }
        }
        
    }
    
    func signUpButtonTapped() {
        
        Task{
            
            isLoading = true
            defer{isLoading = false}
            
            do {
                
                try await supabase.auth.signUp(
                    email: email,
                      password: password,
                      data: [
                        "email": .string(email),
                        "first_name": .string(first_name),
                        "last_name": .string(last_name),
                        "organization_name": .string(organization_name),
                        "team_mascot": .string(team_mascot)
                      ]
                )
                    
                result = .success(())
                
            } catch {
                
                result = .failure(error)
                
            }
            
            
        }
        
    }

}

#Preview {
    CreateAccountView()
}
