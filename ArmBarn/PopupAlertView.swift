//
//  PopupAlertView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 4/15/24.
//

import SwiftUI

struct PopupAlertView: View {
    
    @State private var offset: CGFloat = 1000
    
    var font_color: Color = .white
    var crnr_radius: CGFloat = 12
    var background_color: Color = Color("DarkGrey")
    
    @Binding var isActive: Bool
    
    let title: String
    let message: String
    let leftButtonText: String = "YES"
    let leftButtonAction: () -> ()
    let rightButtonText: String = "NO"
    let rightButtonAction: () -> ()
    
    var body: some View {
        ZStack{
            
            Color(.black)
                .opacity(0.2)
            
            VStack{
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(font_color)
                    .padding()
                
                Text(message)
                    .font(.system(size: 15))
                    .foregroundStyle(font_color)
                    .padding()
                    .multilineTextAlignment(.center)
                
                HStack{
                    
                    //Spacer()
                    
                    Button {
                        close()
                        leftButtonAction()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: crnr_radius)
                                .foregroundColor(Color("ScoreboardGreen"))
                            
                            Text(leftButtonText)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(font_color)
                                .padding()
                        }
                        //.padding()
                    }
                    
                    Spacer()
                    Spacer()
                    
                    Button {
                        close()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12){
                            rightButtonAction()
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: crnr_radius)
                                .foregroundColor(Color("ScoreboardGreen"))
                            
                            Text(rightButtonText)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(font_color)
                                .padding()
                        }
                        //.padding()
                        
                    }
                    
                    //Spacer()
                    
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
        .padding(.top, 45)
        .ignoresSafeArea()
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
        }
    }
    
}

struct InputChangePopUp: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var offset: CGFloat = 1000
    
    @State private var showView: Bool = true
    
    var font_color: Color = .white
    var crnr_radius: CGFloat = 12
    
    var body: some View {
        
        if showView == true {
            ZStack{
                
                Color(.black)
                    .opacity(0.2)
                
                VStack{
                    
                    Text("Error")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(font_color)
                        .padding()
                    
                    Text("Please start new game to change input options")
                        .font(.system(size: 15))
                        .foregroundStyle(font_color)
                        .padding()
                        .multilineTextAlignment(.center)
                        
                    Button {
                        close()
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: crnr_radius)
                                .foregroundColor(Color("ScoreboardGreen"))
                            
                            Text("Dismiss")
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
                .offset(x: 0, y: offset)
                .onAppear{
                    withAnimation(.spring()) {
                        offset = -100
                    }
                }
                .padding(30)
                .shadow(radius: 20)
                .padding(.top, 45)
                
            }
            .ignoresSafeArea()
        }
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
            showView = false
        }
    }

}


#Preview {
    PopupAlertView(isActive: .constant(true), title: "Title", message: "Message", leftButtonAction: {}, rightButtonAction: {})
}
