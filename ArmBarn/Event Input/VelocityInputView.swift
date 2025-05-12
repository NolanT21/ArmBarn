//
//  VelocityInputView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 4/28/24.
//

import SwiftUI

struct VelocityInputNavView: View {
    
    @AppStorage("VelocityUnits") var ASVeloUnits : String?
    
    @Environment(Event_String.self) var event
    @Environment(Scoreboard.self) var scoreboard
    @Environment(\.dismiss) var dismiss
    
    @Binding var isActive: Bool
    @State var close_action: () -> ()
    
    @State var veloinput: Double = 0.0
    @State var validVeloInput: Bool = false
    
    @FocusState private var fieldIsFocused: Bool
    
    @State private var font_color: Color = .white
    @State private var offset: CGFloat = 1000
    @State private var crnr_radius: CGFloat = 12
    
    @State private var showVeloInput = true
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var body: some View {
        
        if showVeloInput == true {
            ZStack{
                
                Color(.black)
                    .opacity(0.2)
                
                VStack{
                
                    Text("Enter Velocity")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(font_color)
                        .padding()
                    
                    VStack{
                        TextField(ASVeloUnits ?? "MPH", value: $veloinput, formatter: formatter)
                            .focused($fieldIsFocused)
                            .submitLabel(.done)
                            .onSubmit {
                                event.velocity = veloinput
                                close()
                                close_action()
                            }
                            .font(.system(size: 20, weight: .bold))
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .overlay{
                                HStack{
                                    
                                    Image(systemName: "gauge.with.needle")
                                        .bold()
                                        .padding(5)
                                    
                                    Spacer()
                                }
                                
                            }
                            .padding(.horizontal, 20)
                        Button {
                            //print(veloinput)
                            event.velocity = veloinput
                            fieldIsFocused = false
                            close()
                            close_action()
                        } label : {
                            ZStack{
                                RoundedRectangle(cornerRadius: crnr_radius)
                                    .foregroundColor(validVeloInput ? Color("ScoreboardGreen") : Color.gray)
                                
                                Text("ENTER")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(font_color)
                                    .padding()
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .disabled(!validVeloInput || (veloinput > 175 && veloinput < 30))
                        .onChange(of: veloinput){ _, _ in
                            validate_velocity_input()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                }
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .padding()
                .background(Color("DarkGrey"))
                .clipShape(RoundedRectangle(cornerRadius: crnr_radius))
                .shadow(radius: 20)
                .padding(30)
                .offset(x: 0, y: offset)
                .onAppear{
                    withAnimation(.spring()) {
                        offset = -150
                    }
                }
            }
            .padding(.top, 45)
            .ignoresSafeArea()
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    fieldIsFocused = true
                }
            }
        }

    }
    
    func validate_velocity_input() {
        let validate = NSPredicate(format: "SELF MATCHES %@", "^[+]?([0-9]+(?:[\\.][0-9]*)?|\\.[0-9]+)$")
        validVeloInput = validate.evaluate(with: String(veloinput))
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                showVeloInput = true
            }
        }
    }
}
