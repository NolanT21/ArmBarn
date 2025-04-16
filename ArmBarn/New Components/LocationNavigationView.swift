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
    
    @State private var button_color: Color = Color("ScoreboardGreen")
    
    var body: some View {
        
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
                        PitchResultMKIIView(path: $path).navigationBarBackButtonHidden(true).task{
                            withAnimation{
                                location_overlay.showinputoverlay = false
                                
                            }
                            location_overlay.showShakeAnimation = false
                            
                            ptconfig.pitch_x_loc.append(ptconfig.cur_x_location)
                            event.x_cor = Double(ptconfig.cur_x_location)
                            ptconfig.pitch_y_loc.append(ptconfig.cur_y_location)
                            event.y_cor = Double(ptconfig.cur_y_location)
                            ptconfig.ab_pitch_color.append(ptconfig.ptcolor)
                            ptconfig.pitch_cur_ab += 1
                            
                        }
                    } label: {
                        Text("Enter")
                            .font(.system(size: 17, weight: .bold))
                            .frame(maxWidth: 150, maxHeight: 45)
                            .background(button_color)
                            .foregroundColor(Color.white)
                        //Logic for validating Enter button
//                            .background(scoreboard.baserunners < 1 ? Color.gray.opacity(0.5) : button_color)
//                            .foregroundColor(scoreboard.baserunners < 1 ? Color.gray : Color.white)
                            .cornerRadius(8.0)
                    }
                    
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
}

//#Preview {
//    LocationNavigationView()
//}
