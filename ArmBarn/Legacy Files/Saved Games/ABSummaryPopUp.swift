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
                            .font(.system(size: 17))
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
                    let velo_units = ASVeloUnits ?? "mph"
                    
                    ZStack{
                        Image("PLO_Background")
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .clipped()
                            .overlay(alignment: .center){
                                
                                ForEach(Array(pitch_list_data.enumerated()), id: \.offset) { index, data_row in
                                    
                                    let x_coor = data_row.x_loc * (202/screenSize.width) + 70
                                    
                                    let y_coor = data_row.y_loc * (417/screenSize.height) + 39
                                    
                                    let point = CGPoint(x: x_coor, y: y_coor)
                                    let pitch_color = data_row.result_color
                                    let pitch_num = data_row.pitch_num
                                    
                                    if data_row.pitch_type != "ROE" && data_row.pitch_type != "RO"{
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
                            }
                        
                        if batter_stance != "" {
                            
                            if batter_stance == "R" {
                                VStack{
                                    
                                    Spacer()
                                    
                                    HStack{
                                        Image(systemName: "figure.baseball")
                                            .scaleEffect(x: 1, y: 2)
                                            .rotation3DEffect(.degrees(50), axis: (x: 0, y: 1, z: 0))
                                            .font(.system(size: 100))
                                            .foregroundColor(.white.opacity(0.5))
                                        
                                        Spacer()
                                        
                                    }
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
                                            .font(.system(size: 100))
                                            .foregroundColor(.white.opacity(0.5))
                                        
                                    }
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
                                
                                if index > 0 && pitch_list_data[index].pitcher_id != pitch_list_data[index-1].pitcher_id {
                                    GridRow{
                                        HStack{
                                            
                                            Spacer()
                                            
                                            Text(data_row.pitcher_first_name + " " + data_row.pitcher_last_name + " Entered")
                                                .foregroundStyle(Color.green.opacity(2))
                                                .font(.system(size: 14))
                                                .bold()
                                                .padding(.vertical, 7)
                                            
                                            Spacer()
                                            
                                        }
                                        .background(Color.green.opacity(0.07))
                                        .gridCellColumns(4)
                                    }
                                    
                                    Divider()
                                }
                                
                                if data_row.pitch_type == "NPE" {
                                    GridRow{
                                        HStack{
                                            
                                            Spacer()
                                            
                                            Text(data_row.result)
                                                .foregroundStyle(Color.yellow.opacity(2))
                                                .font(.system(size: 14))
                                                .bold()
                                                .padding(.vertical, 7)
                                            
                                            Spacer()
                                            
                                        }
                                        .background(Color.yellow.opacity(0.07))
                                        .gridCellColumns(4)
                                    }
                                    
                                    Divider()
                                    
                                }
                                else if data_row.pitch_type == "RO" && index != 0{
                                    GridRow{
                                        HStack{
                                            
                                            Spacer()
                                            
                                            Text(data_row.result)
                                                .foregroundStyle(Color.red.opacity(2))
                                                .font(.system(size: 14))
                                                .bold()
                                                .padding(.vertical, 7)
                                            
                                            Spacer()
                                            
                                        }
                                        .background(Color.red.opacity(0.07))
                                        .gridCellColumns(4)
                                    }
                                }
                                
                                if data_row.pitch_type != "ROE" && data_row.pitch_type != "RO"{
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
                                            .font(.system(size: 14))

                                    }
                                    
                                    Divider()
                                }
                                
                                
                                
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
//    ABSummaryPopUp()
//}
