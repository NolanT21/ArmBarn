//
//  SyncGamesPopUp.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 7/29/25.
//

import SwiftUI

struct SyncGamesPopUp: View {
    
    @State var sync_animation: Bool = false
    @State var isRotating = 0.0
    
    var body: some View {
        ZStack{
            
            Color.black.opacity(0.5)
            
            VStack{
                
                HStack{
                    Text("Syncing Games")
                        .font(.system(size: 17, weight: .semibold))
                }
                
                VStack{
                    if sync_animation == true{
                        Circle()
                            .trim(from: 0.0, to: 0.70)
                            .stroke(style: StrokeStyle(lineWidth: 2.0, lineCap: .round, lineJoin: .round))
                            .fill(AngularGradient(gradient: Gradient(colors: [.black, .white]), center: .center, endAngle: .degrees(250)))
                            .frame(width: 50, height: 50)
                            .rotationEffect(.degrees(isRotating))
                            .onAppear {
                                withAnimation(.linear(duration: 1).speed(0.9).repeatForever(autoreverses: false)) {
                                    isRotating = 360
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                    sync_animation = true
                                }
                            }
                    }
                    else {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                            .font(.system(size: 21, weight: .bold))
                            .imageScale(.large)
                            .bold()
                            .onAppear{

                                //successHaptic()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                    sync_animation = false
                                    isRotating = 0
                                }
                            }
                    }
                }
                .frame(height: 60)
                
            }
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .padding()
            .background(Color.black.opacity(0.2))
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 20)
        }
    }
}

#Preview {
    SyncGamesPopUp()
}
