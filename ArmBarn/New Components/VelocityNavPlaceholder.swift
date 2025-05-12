//
//  VeloInputPopUp.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 4/28/25.
//

import SwiftUI

struct VelocityNavPlaceholder: View {
    
    @Binding var path: [Int]
    
    @Environment(Event_String.self) var event
    @Environment(LocationOverlay.self) var location_overlay
    @Environment(PitchTypeConfig.self) var ptconfig
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var show_velo_input: Bool = false
    @FocusState private var fieldIsFocused: Bool
    @State var veloinput: Double = 0.0
    @State var validVeloInput: Bool = false
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        return formatter
    }()
    
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
        
        VStack{
            
            VStack{
                    
                VStack(spacing: 0){
                    
                    Spacer()
                    
                    Text("Enter Pitch Velocity")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Spacer()

                    HStack(spacing: 10){
                        
                        TextField("mph   ", value: $veloinput, formatter: formatter)
                            .padding(.vertical, 5)
                            .focused($fieldIsFocused)
                            .font(.system(size: 24, weight: .medium))
                            .background(Color.gray.opacity(0.2))
                            .background(.regularMaterial)
                            .cornerRadius(8)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .overlay{
                                HStack{
                                    
                                    Image(systemName: "gauge.with.needle")
                                        .font(.system(size: 21, weight: .medium))
                                        .bold()
                                        .padding(5)
                                    
                                    Spacer()
                                }
                                
                            }
                        
                        NavigationLink{
                            PitchResultMKIIView(path: $path).navigationBarBackButtonHidden(true).task{
                                withAnimation{
                                    location_overlay.showVeloInput = false
                                    fieldIsFocused = false
                                }
                                event.velocity = veloinput
                                veloinput = 0
                            }
                        } label: {
                            Text("Enter")
                                .font(.system(size: 17, weight: .bold))
                                .frame(width: 125, height: 40)
                                .background(!validVeloInput || (veloinput > 115 || veloinput < 30) ? disabled_gradient : button_gradient)
                                .foregroundColor(!validVeloInput || (veloinput > 115 || veloinput < 30) ? Color.gray.opacity(0.5) : Color.white)
                                .cornerRadius(8.0)
                        }
                        .disabled(!validVeloInput || (veloinput > 115 || veloinput < 30))
                        .onChange(of: veloinput){ _, _ in
                            validate_velocity_input()
                        }
                        
                    }
                    .padding(.horizontal, 50)
                    
                    Spacer()
                }
            }
            .frame(maxHeight: 190)
            .background(Color.black.opacity(0.2))
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay{
                VStack{

                    HStack{
                        Button {
                            ptconfig.pitch_x_loc.removeLast()
                            ptconfig.pitch_y_loc.removeLast()
                            ptconfig.ab_pitch_color.removeLast()
                            ptconfig.pitch_cur_ab -= 1
                            location_overlay.showCurPitchPulse = false
                            location_overlay.zero_location = false
                            dismiss()
                            withAnimation{
                                location_overlay.showVeloInput = false
                            }
                        } label: {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                //.background(.ultraThinMaterial)
                                .frame(width: 24, height: 24)
                                .overlay{
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15).bold())
                                        //.padding(5)
                                }
                        }
                        .font(.system(size: 13) .weight(.medium))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .padding(.horizontal, 10)

                        Spacer()

                    }

                    Spacer()
                }
            }
            .padding(.horizontal, 10)
            .onAppear{
                withAnimation{
                    location_overlay.showVeloInput = true
                    fieldIsFocused = true
                }
                //veloinput = event.velocity
            }
            
            Spacer()
            
        }
    }
    
    //Function for validating velocity input
    func validate_velocity_input() {
        let validate = NSPredicate(format: "SELF MATCHES %@", "^[+]?([0-9]+(?:[\\.][0-9]*)?|\\.[0-9]+)$")
        validVeloInput = validate.evaluate(with: String(veloinput))
    }
    
}

//#Preview {
//    VelocityNavPlaceholder()
//}
