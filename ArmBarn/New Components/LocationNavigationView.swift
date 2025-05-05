//
//  LocationNavigationView.swift
//  Sandbox
//
//  Created by Nolan Thompson on 4/9/25.
//

import SwiftUI

struct LocationNavigationView: View {
    
    @Binding var path: [Int]
    
    @Environment(Event_String.self) var event
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(LocationOverlay.self) var location_overlay
    @Environment(\.dismiss) private var dismiss
    
    @State private var locked_button_function: Bool = true
    
    @State private var button_color: Color = Color("ScoreboardGreen")
    
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
        
        ZStack{
            
            VStack{
                
                ZStack{
                
                    VStack(alignment: .center, spacing: 5){
                        
                        HStack{
                            Button {
                                dismiss()
                                withAnimation{
                                    location_overlay.showinputoverlay = false
                                    location_overlay.showShakeAnimation = false
                                    ptconfig.ptcolor = .clear
                                    //location_overlay.zero_location = true
                                    //pop most current pitch if in the middle of input
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
                            .padding(.top, 10)
                            .padding(.horizontal, 10)
                            
                            Spacer()
                            
                        }
                        
                        Text("Tap in the area above to select the pitch location")
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: 350)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            //.padding(.horizontal, 5)
                            
                        
                        Spacer()
                        
                        NavigationLink{
                            VelocityNavPlaceholder(path: $path).navigationBarBackButtonHidden(true).task{
                                if locked_button_function == false {
                                    withAnimation{
                                        location_overlay.showinputoverlay = false
                                        location_overlay.showVeloInput = true
                                    }
                                    location_overlay.showShakeAnimation = false
                                    
                                    //Set zero location to true, pitch has been enter, reset on back for next view
                                    location_overlay.zero_location = true
                                    
                                    //current pitch flash here
                                    location_overlay.showCurPitchPulse = true
                                    
                                    ptconfig.pitch_x_loc.append(ptconfig.cur_x_location)
                                    event.x_cor = Double(ptconfig.cur_x_location)
                                    ptconfig.pitch_y_loc.append(ptconfig.cur_y_location)
                                    event.y_cor = Double(ptconfig.cur_y_location)
                                    ptconfig.ab_pitch_color.append(ptconfig.ptcolor)
                                    ptconfig.pitch_cur_ab += 1
                                }
                            }
                        } label: {
                            Text("Enter")
                                .font(.system(size: 17, weight: .bold))
                                .frame(maxWidth: 150, maxHeight: 45)
                                .background(ptconfig.cur_x_location != 0 || ptconfig.cur_y_location != 0 ? button_gradient : disabled_gradient)
                                .foregroundColor(ptconfig.cur_x_location != 0 || ptconfig.cur_y_location != 0 ? Color.white : Color.gray)
                                .cornerRadius(8.0)
                        }
                        .disabled(ptconfig.cur_x_location == 0 && ptconfig.cur_y_location == 0)
                        
                        Spacer()
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.white)
                .background(.regularMaterial)
                .background(Color.black.opacity(0.85))
                .cornerRadius(15)
                //.padding(.horizontal, 15)
                //.padding(.top, 15)
                
                Spacer()
                
            }
            
        }
        .onAppear{
            locked_button_function = false
        }
        
    }
}

//#Preview {
//    LocationNavigationView()
//}
