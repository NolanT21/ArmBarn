//
//  LocationNavigationView.swift
//  Sandbox
//
//  Created by Nolan Thompson on 4/9/25.
//

import SwiftUI

struct LocationNavigationView: View {
    
    @Binding var path: [Int]
    
    @Environment(LocationOverlay.self) var location_overlay
    @Environment(\.dismiss) private var dismiss
    
    @State private var button_color: Color = Color("ScoreboardGreen")
    
    var body: some View {
        
        VStack{
            
            ZStack{
            
                VStack(alignment: .center){
                    
                    Text("Tap in the area above to select the pitch location")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.top, 40)
                        .padding(.horizontal, 5)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    NavigationLink{
                        PitchResultMKIIView(path: $path).navigationBarBackButtonHidden(true).task{
                            withAnimation{
                                location_overlay.showinputoverlay = false
                                
                            }
                            location_overlay.showShakeAnimation = false
                        }
                    } label: {
                        Text("Enter")
                            .font(.system(size: 17, weight: .bold))
                            .frame(maxWidth: 150, maxHeight: 45)
                            .background(button_color)
                            .foregroundColor(Color.white) 
                            .cornerRadius(8.0)
                    }
                    
                    Spacer()
                    
                }
                
                VStack{
                    
                    HStack{
                        Button {
                            dismiss()
                            withAnimation{
                                location_overlay.showinputoverlay = false
                                location_overlay.showShakeAnimation = false
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
                                        .padding(5)
                                }
                        }
                        .padding(10)
                        
                        Spacer()
                        
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
