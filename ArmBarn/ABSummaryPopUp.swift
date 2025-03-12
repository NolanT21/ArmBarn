//
//  ABSummaryPopUp.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 2/24/25.
//

import SwiftUI

struct ABSummaryPopUp: View {
    
    @AppStorage("VelocityUnits") var ASVeloUnits : String?
    
    @State private var offset: CGFloat = 1000
    
    @State var pitch_list_data: [popup_pitch_info]
    @State var close_action: () -> ()
    @State var inning : Int
    @State var outs : Int
    @State var ab_number: Int
    @State var pitcher_name: [String]
    @State var pitch_color: Color = .clear
    @State var batter_stance: String
    
    var body: some View {
        
        ZStack{
            
            Color.black.opacity(0.8)
            
            VStack{
                
                HStack{
                    Button {
                        close()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12){
                            close_action()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                            .imageScale(.medium)
                            .bold()
                    }
                    .padding(.bottom, 5)
                    Spacer()
                    
                }
                
                VStack{
                    HStack{
                        ForEach(Array(pitcher_name.enumerated()), id: \.offset){ index, p_er in
                            Text(p_er)
                                .font(.system(size: 14))
                                .bold()
                        }
                        
                        Spacer()
                        
                        Text("INN \(inning), \(outs) Out(s) ")
                            .font(.system(size: 14))
                            .bold()
                    }
                    
                    let screenSize = UIScreen.main.bounds.size
                    //let width_ratio = (screenSize.width * 0.001087)
                    let velo_units = ASVeloUnits ?? "mph"
                    
                    ZStack{
                        Image("PLO_Background")
//                            .resizable()
//                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .clipped()
                            .overlay(alignment: .center){
                                
                                ForEach(Array(pitch_list_data.enumerated()), id: \.offset) { index, data_row in
                                    
                                    let x_coor = data_row.x_loc * (202/screenSize.width) + 70
                                    
                                    let y_coor = data_row.y_loc * (417/screenSize.height) + 39
                                    
                                    let point = CGPoint(x: x_coor, y: y_coor)
                                    let pitch_color = data_row.result_color
                                    let pitch_num = data_row.pitch_num
                                    
                                    Circle()
                                        .fill(pitch_color)
                                        .stroke(.white, lineWidth: 2)
                                        .frame(width: 17, height: 17, alignment: .center)
                                        .overlay {
                                            Text("\(pitch_num)")
                                                .font(.system(size: 9))
                                                .bold()
                                        }
                                        .position(point)
                                    
                                }
                            }
                        
                        if batter_stance != "" {
                            
                            if batter_stance == "R" {
                                VStack{
                                    
                                    Spacer()
                                    
                                    HStack{
                                        Image(systemName: "figure.baseball")
                                            .scaleEffect(x: 1, y: 2)
                                            .rotation3DEffect(.degrees(50), axis: (x: 0, y: 1, z: 0))
                                            //.scaleEffect(x: 0.9, y: 1)
                                            //.imageScale(.large)
                                            .font(.system(size: 100))
                                            .foregroundColor(.white.opacity(0.5))
                                            //.position(batter_figure_position_right)
                                        
                                        Spacer()
                                        
                                    }
                                    //.padding(.leading, 10)
                                    .padding(.top, 20)
                                    
                                    Spacer()
                                    
                                }
                            }
                            else if batter_stance == "L" {
                                VStack{
                                    
                                    Spacer()
                                    
                                    HStack{
                                        
                                        Spacer()
                                        
                                        Image(systemName: "figure.baseball")
                                            .scaleEffect(x: -1, y: 2)
                                            .rotation3DEffect(.degrees(-50), axis: (x: 0, y: 1, z: 0))
                                            //.scaleEffect(x: 0.9, y: 1)
                                            //.imageScale(.large)
                                            .font(.system(size: 100))
                                            .foregroundColor(.white.opacity(0.5))
                                            //.position(batter_figure_position_right)
                                        
                                        
                                        
                                    }
                                    //.padding(.leading, 10)
                                    .padding(.top, 20)
                                    
                                    Spacer()
                                    
                                }
                            }
                            
                        }
                        
                        
                    }
                    
                    ScrollView{
                        Grid(alignment: .center){
                            Divider()
                            ForEach(Array(pitch_list_data.enumerated()), id: \.offset) { index, data_row in
                                
                                GridRow{
                                    
                                    Circle()
                                        .fill(data_row.result_color)
                                        .stroke(.white, lineWidth: 2)
                                        .frame(width: 20, height: 20, alignment: .center)
                                        .overlay{
                                            Text("\(data_row.pitch_num)")
                                                .font(.system(size: 12))
                                                .bold()
                                        }
                                    
                                    VStack(alignment: .leading){
                                        Text("\(data_row.result)")
                                            .font(.system(size: 14))
                                            .bold()
                                        
                                        HStack(spacing: 2){
                                            
                                            if data_row.velocity != 0 {

                                                Text("\(data_row.velocity, specifier: "%.1f")") +
                                                
                                                Text(velo_units.lowercased())
                                                
                                            }
                                            
                                            Text("\(data_row.pitch_type)")
                                        }
                                        .font(.system(size: 10))
                                        
                                    }
                                    .gridColumnAlignment(.leading)
                                    
                                    
                                    Spacer()
                                        
                                    Text("\(data_row.balls)-\(data_row.strikes)")
                                        

                                }
                                
                                Divider()
                                
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
            }
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .padding()
            .background(Color("DarkGrey"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(20)
            .offset(x: 0, y: offset)
            .onAppear{
                withAnimation(.spring()) {
                    offset = -100
                }
                //print("Data List: ", pitch_list_data)
//                for i in pitch_list_data {
//                    print(i.)
//                }
                print(pitcher_name)
            }
        }
        
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                showExportPR = false
//            }

//            showExportPR = true

        }
    }
    
}

//#Preview {
//    ABSummaryPopUp()
//}
