//
//  SavePopUpView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 2/6/25.
//

import SwiftUI
import SwiftData
import TipKit

struct SavePopUpView: View {
    
    @State private var offset: CGFloat = -100
    @State private var isRotating = 0.0
    @State private var saved: Bool = false
    
    var font_color: Color = .white
    var crnr_radius: CGFloat = 12
    var background_color: Color = Color("DarkGrey")
    
    @Binding var isActive: Bool

    
    let Action: () -> ()
    
    var body: some View {
        
        ZStack {
            
            let impact = UIImpactFeedbackGenerator(style: .medium)
            
            Color(.black).opacity(0.2)
            
            VStack {
                Spacer()
                
                HStack{
                    Spacer()
                    
                    if saved == false {
                        Circle()
                            .trim(from: 0.0, to: 0.70)
                            .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                            .fill(AngularGradient(gradient: Gradient(colors: [.black, .white]), center: .center, endAngle: .degrees(250)))
                            .frame(width: 125, height: 125)
                            .rotationEffect(.degrees(isRotating))
                            .onAppear {
                                withAnimation(.linear(duration: 1).speed(0.9).repeatForever(autoreverses: false)) {
                                    isRotating = 360
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                    saved = true
                                }
                            }

                    }
                    else {
                        VStack{
                            Image(systemName: "checkmark")
                                .foregroundStyle(.white)
                                .font(.system(size: 40))
                                .imageScale(.large)
                                .bold()
                            Text("Saved!")
                                .foregroundStyle(.white)
                                .font(.system(size: 17))
                                .bold()
                        }
                        .onAppear{
                            impact.impactOccurred()
                        }
                        
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
            }
            .frame(width: 200, height: 170)
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .padding()
            .background(Color("DarkGrey"))
            .clipShape(RoundedRectangle(cornerRadius: crnr_radius))
            .shadow(radius: 20)
            .padding(30)
            .offset(x: 0, y: offset)
            .animation(.easeInOut(duration: 0.2), value: saved)
            .onAppear{
//                withAnimation(.easeIn(duration: 1.0)) {
//                    offset = -100
//                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    close()
                    Action()
                }
            }
        }
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
        }
    }
    
}

//#Preview {
//    SavePopUpView()
//}
