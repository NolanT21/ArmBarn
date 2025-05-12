//
//  ZeroInputXPopUp.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 4/30/25.
//

import SwiftUI

struct ZeroInputXPopUp: View {
    
    @State var title: String
    @State var description: String
    @State var close_action: () -> ()
    
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
                            
                            Spacer()
                                .frame(maxHeight: 30)
                            
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
//    ZeroInputXPopUp()
//}
