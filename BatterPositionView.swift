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
    @State private var crnr_radius: CGFloat = 12
    
    @Binding var isActive: Bool
    var close_action: () -> ()
    
    //@Bindable var cur_ab_events: Event
    
//    @Binding var cur_ab_events: [Event]

    var body: some View {
        ZStack{
            
            Color(.black)
                .opacity(0.2)
            
            VStack{
                Text("Choose Batter Stance")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(font_color)
                    .padding()
                ZStack{
                    Grid() {
                        GridRow{
                            Image(systemName: "figure.baseball")
                                .rotation3DEffect(.degrees(20), axis: (x: 0, y: 1, z: 0))
                                //.scaleEffect(x: 0.9, y: 1)
                                .imageScale(.large)
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                                .bold()
                            
                            Image(systemName: "figure.baseball")
                                .scaleEffect(x: -1, y: 1)
                                .rotation3DEffect(.degrees(-20), axis: (x: 0, y: 1, z: 0))
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
                    
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            Image("HomeplateFromBehind")
                                .resizable()
                                .frame(width: 50.0, height: 25.0)
                            Spacer()
                        }
                        Spacer()
                    }
                    
                }
            }
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .padding()
            .background(Color("DarkGrey"))
            .clipShape(RoundedRectangle(cornerRadius: crnr_radius))
            .overlay{
                VStack{
                    
                    HStack{
                        
                        Spacer()
                        
                        Button{
                            close()
                            close_action()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white)
                        }
                        
                    }
                    
                    Spacer()
                }
                .padding()
            }
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

//#Preview {
//    BatterPositionView(isActive: .constant(true), close_action: {})
//}

//if events.count > 0 {
//    if (scoreboard.balls != 0 || scoreboard.strikes != 0) && events[events.count - 1].result_detail != "R"{
//        let cur_ab = events[events.count - 1]
//        var prev_ab_index = events.count - 2
//        var prev_ab = events[prev_ab_index]
//        while cur_ab.atbats == prev_ab.atbats {
//            
//            cur_ab_events.append(prev_ab)
//            
//            if prev_ab_index > 0 {
//                prev_ab_index -= 1
//            }
//            else {
//                break
//            }
//        }
//    }
//}
