//
//  BatterPositionView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 4/22/24.
//

import SwiftUI

struct BatterPositionView: View {
    
    @Environment(Event_String.self) var event
    @Environment(\.dismiss) var dismiss
    
    @State private var font_color: Color = .white
    @State private var offset: CGFloat = 1000
    
    var crnr_radius: CGFloat = 12
    
    @Binding var isActive: Bool
    var close_action: () -> ()

    var body: some View {
        ZStack{
            
            Color(.black)
                .opacity(0.2)
            
            VStack{
                Text("Choose Batter Stance")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(font_color)
                    .padding()
                Grid() {
                    GridRow{
                        Image(systemName: "figure.baseball")
                            .imageScale(.large)
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                            .bold()
                        
                        Image(systemName: "figure.baseball")
                            .scaleEffect(x: -1, y: 1)
                            .imageScale(.large)
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                            .bold()
                    }
                    GridRow{
                        Button {
                            event.batter_stance = "R"
                            close()
                            close_action()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: crnr_radius)
                                    .foregroundColor(Color("ScoreboardGreen"))
                                
                                Text("RIGHT")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(font_color)
                                    .padding()
                            }
                        }
                        
                        Button {
                            event.batter_stance = "L"
                            close()
                            close_action()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: crnr_radius)
                                    .foregroundColor(Color("ScoreboardGreen"))
                                
                                Text("LEFT")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundStyle(font_color)
                                    .padding()
                            }
                        }
                    }
                }
                
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
                    offset = -100
                }
            }
            
        }
        .padding(.top, 50)
        .ignoresSafeArea()
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
        }
    }
    
}

#Preview {
    BatterPositionView(isActive: .constant(true), close_action: {})
}
