//
//  PitchTypeSelectView.swift
//  Sandbox
//
//  Created by Nolan Thompson on 4/8/25.
//

import SwiftUI

struct PitchTypeSelectView: View {
    
    @Binding var path: [Int]
    
    @Environment(Event_String.self) var event
    @Environment(LocationOverlay.self) var location_overlay
    @Environment(\.dismiss) private var dismiss
    
    @State var show_pitchtypes: Bool = true
    @State var selected_index: Int = 1
    
    @State private var button_color: Color = Color("ScoreboardGreen")
    
    var body: some View {
        VStack(spacing: 0){
            
            //Top Navigation Bar
            HStack{
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 5){
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
                .font(.system(size: 13) .weight(.medium))
                .foregroundColor(.white)
                
                Spacer()
                
                Button{
                    withAnimation{
                        selected_index = 1
                    }
                } label : {
                    Text("Pitches")
                        .font(.system(size: 13))
                        .foregroundColor(selected_index == 1 ? Color.white : Color.gray)
                        .bold(selected_index == 1)
                }
                
                Divider()
                    .frame(height: 20)
                
                Button{
                    withAnimation{
                        selected_index = 2
                    }
                } label: {
                    Text("No Pitch")
                        .font(.system(size: 13))
                        .foregroundColor(selected_index == 2 ? Color.white : Color.gray)
                        .bold(selected_index == 2)
                }

            }
            .padding(10)
            
            HStack(alignment: .top){
                TabView(selection: $selected_index){
                    PitchTypeButtons()
                        .tag(1)
                    
                    NoPitchEvents()
                        .tag(2)
                        
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                //.transition(.slide)
                
                //Spacer()
                
            }

        }
        .ignoresSafeArea()
        .background(.regularMaterial)
        .cornerRadius(15)
        
    }
    
    @ViewBuilder
    func PitchTypeButtons() -> some View {
        VStack(alignment: .center){
            
            HStack{
                NavigationLink {
                    LocationNavigationView(path: $path).navigationBarBackButtonHidden(true).task{
                        call_location_overlay()
                    }
                } label: {
                    HStack(spacing: 12){
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .fill(Color.blue)
                            .frame(width: 18, height: 18)
                            .padding(.leading, 15)
                            
                        Text("Fastball")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Color.white)
                            .padding(.trailing, 15)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 45)
                    .background(.regularMaterial)
                    .cornerRadius(30)
                }
                
                NavigationLink {
                    LocationNavigationView(path: $path).navigationBarBackButtonHidden(true).task{
                        call_location_overlay()
                    }
                } label: {
                    HStack(spacing: 12){
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .fill(Color.orange)
                            .frame(width: 18, height: 18)
                            .padding(.leading, 15)
                            
                        Text("Curveball")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 45)
                    .background(.regularMaterial)
                    .cornerRadius(30)
                }
            }
            
            HStack{
                NavigationLink {
                    LocationNavigationView(path: $path).navigationBarBackButtonHidden(true).task{
                        call_location_overlay()
                    }
                } label: {
                    HStack(spacing: 12){
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .fill(Color.red)
                            .frame(width: 18, height: 18)
                            .padding(.leading, 15)
                            
                        Text("Change-Up")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 45)
                    .background(.regularMaterial)
                    .cornerRadius(30)
                }
                
                NavigationLink {
                    LocationNavigationView(path: $path).navigationBarBackButtonHidden(true).task{
                        call_location_overlay()
                    }
                } label: {
                    HStack(spacing: 12){
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .fill(Color.green)
                            .frame(width: 18, height: 18)
                            .padding(.leading, 15)
                            
                        Text("Other")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(Color.white)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 45)
                    .background(.regularMaterial)
                    .cornerRadius(30)
                }
            }
            
            Spacer()
            
        }
        //.transition(.move(edge: .leading))
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func NoPitchEvents() -> some View {
        VStack(alignment: .center){
            HStack(spacing: 12){
                Button {
                    path.removeAll()
                } label: {
                    Text("Violation - Ball")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_color)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                
                Button {
                    path.removeAll()
                } label: {
                    Text("Violation - Strike")
                        .font(.system(size: 17, weight: .bold))
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(button_color)
                        .foregroundColor(Color.white)
                        .cornerRadius(8.0)
                }
                                
            }
            
            HStack(spacing: 12){
                Button {
                    path.removeAll()
                } label: {
                    Text("Intentional Walk")
                        .font(.system(size: 17, weight: .bold))
                }
                .frame(maxWidth: .infinity, maxHeight: 45)
                .background(button_color)
                .foregroundColor(Color.white)
                .cornerRadius(8.0)
                
                Button {
                    path.removeAll()
                } label: {
                    Text("Runner Out")
                        .font(.system(size: 17, weight: .bold))
                }
                .frame(maxWidth: .infinity, maxHeight: 45)
                .background(button_color)
                .foregroundColor(Color.white)
                .cornerRadius(8.0)
                
            }
            
            Spacer()
            
        }
        .padding(.horizontal, 10)
    }
    
    func call_location_overlay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            location_overlay.shakecounter += 1
        }
        
        location_overlay.showinputoverlay = true
    }
    
}

//#Preview {
//    PitchTypeSelectView()
//}
