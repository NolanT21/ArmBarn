//
//  XInfoPopUp.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 3/26/25.
//

import SwiftUI

struct XInfoPopUpView: View {
    @State private var offset: CGFloat = 1000
    
    var font_color: Color = .white
    var crnr_radius: CGFloat = 12
    var background_color: Color = Color("DarkGrey")
    
    @Binding var isActive: Bool
    let show_close: Bool
    
    let title: String
    let message: String
    let buttonText: String = "OK"
    let buttonAction: () -> ()
    let XButtonAction: () -> ()
    
    var body: some View {
        ZStack {
            
            Color(.black).opacity(0.2)
            
            VStack {
                
                HStack {
                    Button {
                        close()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12){
                            XButtonAction()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(font_color)
                            .imageScale(.medium)
                            .bold()
                    }
                    //.padding(10)
                    
                    Spacer()
                }
                
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(font_color)
                    //.padding()
                
                Text(message)
                    .font(.system(size: 15))
                    .foregroundStyle(font_color)
                    .padding()
                    .multilineTextAlignment(.center)
                
                Button {
                    close()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12){
                        buttonAction()
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: crnr_radius)
                            .foregroundColor(Color("ScoreboardGreen"))
                        
                        Text(buttonText)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(font_color)
                            .padding()
                    }

                }
                .padding()
                
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
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
        }
    }
}

//#Preview {
//    XInfoPopUpView()
//}
