//
//  TwoInputXPopUp.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 4/29/25.
//

import SwiftUI

struct TwoInputXPopUp: View {
    
    @Environment(LocationOverlay.self) var location_overlay
    
    @Environment(\.dismiss) var dismiss
    
    @State var title: String
    @State var description: String
    
    @State var leftButtonText: String
    @State var leftButtonAction: () -> ()
    @State var rightButtonText: String
    @State var rightButtonAction: () -> ()
    
    @State var close_action: () -> ()
    @State var flex_action: () -> ()
    
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
            Color.black.opacity(0.5)
            
            VStack{
                
                Spacer()
                    .frame(height: 150)
                    
                    VStack{
                        
                        Spacer()
                            .frame(maxHeight: 10)
                        
                        VStack(spacing: 20){
                            Text(title)
                                .font(.system(size: 17, weight: .semibold))
                            
                            Text(description)
                                .font(.system(size: 13, weight: .medium))
                                .multilineTextAlignment(.center)
                            
                            HStack{
                                Button {
                                    leftButtonAction()
                                    close_action()
                                } label: {
                                    Text(leftButtonText)
                                        .font(.system(size: 17, weight: .bold))
                                        .frame(width: 110, height: 40)
                                        .background(button_gradient)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(8.0)
                                }
                                
                                Button {
                                    rightButtonAction()
                                    close_action()
                                } label: {
                                    Text(rightButtonText)
                                        .font(.system(size: 17, weight: .bold))
                                        .frame(width: 110, height: 40)
                                        .background(button_gradient)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(8.0)
                                }
                                
                            }
                            
                        }
                        .padding(.horizontal, 20)
                        .frame(maxWidth: 275)
                        
                        Spacer()
                            .frame(maxHeight: 10)
                    
                }
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .padding()
                .background(Color.black.opacity(0.2))
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 20)
                .overlay{
                    VStack{
                        
                        HStack{
                            Button {
                                flex_action()
                                close_action()
                            } label: {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    //.background(.ultraThinMaterial)
                                    .frame(width: 20, height: 20)
                                    .overlay{
                                        Image(systemName: "xmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 11).bold())
                                            //.padding(5)
                                    }
                            }
                            .padding(.top, 10)
                            .padding(.horizontal, 10)
                            
                            Spacer()
                            
                        }
                        
                        Spacer()
                    }
                }
                .padding(30)
                
                Spacer()
                
            }
        }
    }
}

//#Preview {
//    TwoInputXPopUp()
//}
