//
//  BullpenReportView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 10/5/24.
//

import SwiftUI
import SwiftData

struct BullpenReportView: View {
    
    @Environment(BullpenReport.self) var bpr
    @Environment(currentPitcher.self) var current_pitcher
    @Environment(\.dismiss) var dismiss
    
    @Query var bullpen_events: [BullpenEvent]
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    @State var title_size: CGFloat = 28.0
    @State var _default: CGFloat = 17
    @State var subheadline_size: CGFloat = 15
    @State var caption_size: CGFloat = 12
    
    var view_padding: CGFloat = 10
    var text_color: Color = .white
    var view_crnr_radius: CGFloat = 12
    
    var box_color: Color = .gray
    
    let header_gradient = Gradient(colors: [Color("ScoreboardGreen"), Color("ScoreboardGreen"), Color("ScoreboardGreen"), .black])
    let background_gradient = Gradient(colors: [Color("ScoreboardGreen"), .black, .black, .black, .black, .black])
    
    var body: some View {
        ZStack{
            
            GeometryReader { proxy in
                
                let viewsize = proxy.size
             
                VStack{
                    HStack(alignment: .center){
                        
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .imageScale(.medium)
                                .font(.system(size: 17))
                                .frame(width: sbl_width, height: sbl_height)
                                .foregroundColor(text_color)
                                .bold()
                        })
                        
                        Spacer()
                        
                        ShareLink("", item: renderBPR(viewSize: viewsize))
                            .imageScale(.large)
                            .font(.system(size: 16))
                            .foregroundStyle(text_color)
                            .fontWeight(.bold)
                        
                    }
                    .padding(.top, view_padding * 2)
                    .padding(.leading, view_padding * 1.5)
                    .padding(.bottom, view_padding)
                    
                    ZStack{
                        ScrollView{
                            reportView
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                }
                .background(LinearGradient(gradient: header_gradient, startPoint: .top, endPoint: .bottom))
                
            }
            
            
        }
//        .onAppear{
//            for pitch in bullpen_events {
//                print(pitch.pitch_type, pitch.expected_target, pitch.actual_target)
//            }
//        }
    }
        
    
    var reportView: some View {
        HStack{
            
            Spacer()
            
            VStack{
                HStack{
                    VStack (alignment: .leading){
                        Text(current_pitcher.firstName + " " + current_pitcher.lastName)
                            .font(.system(size: title_size))
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(text_color)
                        
                        Text(Date().formatted(.dateTime.day().month().year()))
                            .font(.system(size: subheadline_size))
                            .foregroundStyle(text_color)
                    }
                }
                .padding(.horizontal, view_padding)
                .padding(.top, view_padding)
                
                HStack{
                    
                    VStack{
                        
    //                    HStack{
    //                        Text("")
    //                            .font(.system(size: subheadline_size))
    //                            .foregroundStyle(text_color)
    //                        Spacer()
    //                    }
                        
                        HStack{
                            Spacer()
                            VStack{
                                Text("Pitches")
                                Text("\(bpr.pitches)")
                            }
                            Spacer()
                            Divider()
                                
                            Spacer()
                            VStack{
                                Text("Spots Hit")
                                Text("\(bpr.spots_hit)")
                            }
                            Spacer()
                        }
                        .font(.system(size: _default))
                        .foregroundStyle(text_color)
                        
                    }
                    .padding(view_padding)
                    .frame(maxWidth: .infinity)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    
                }
                .padding(.horizontal, view_padding)
                .padding(.bottom, view_padding)
                
                HStack{
                    
                    VStack{
                        
                        HStack{
                            Text("Pitch Type Summary")
                                .font(.system(size: subheadline_size))
                                .foregroundStyle(text_color)
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        
                        HStack{
                            Grid(alignment: .center) {
                                ForEach(Array(bpr.spots_by_pitch_list.enumerated()), id: \.offset){ index, pitch in
                                    if index > 0 {
                                        Divider()
                                    }
                                    else {
                                        GridRow(){
                                            
                                            //Spacer()
                                            
                                            Text("")
                                                .font(.system(size: caption_size))
                                            
                                            Spacer()
                                            
                                            HStack{
                                                Text("")
                                                    .font(.system(size: caption_size))
                                            }
                                            
                                            Spacer()
                                            
                                            Text("Pitches")
                                                .font(.system(size: caption_size))
                                            
                                            Spacer()
                                            
                                            HStack{
                                                Text("")
                                                    .font(.system(size: caption_size))
                                            }
                                            
                                            Spacer()
                                            
                                            Text("Spots Hit")
                                                .font(.system(size: caption_size))
                                            
                                            Spacer()
                                            
                                        }
                                        //.padding(.bottom, view_padding)
                                    }
                                    GridRow{
                                        
                                        //Spacer()
                                        
                                        Text(pitch.pitch_type)
                                            .font(.system(size: _default))
                                            .gridColumnAlignment(.trailing)
                                        
                                        Spacer()
                                        
                                        HStack{
                                            Divider()
                                        }
                                        
                                        Spacer()
                                        
                                        Text("\(pitch.pitch_num)")
                                            .font(.system(size: _default))
                                        
                                        Spacer()
                                        
                                        HStack{
                                            Divider()
                                        }
                                        
                                        Spacer()
                                        
                                        Text("\(pitch.spots_hit)")
                                            .font(.system(size: _default))
                                        
                                        Spacer()
                                        
                                    }
                                }
                            }
                        }
                        .padding(.leading, 10)
                    }
                    .foregroundStyle(text_color)
                    .padding(view_padding)
                    .frame(maxWidth: .infinity)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    
                }
                .padding(.horizontal, view_padding)
                .padding(.bottom, view_padding)
                
                HStack{
                    
                    VStack{
                        
                        HStack{
                            Text("Pitch Log")
                                .font(.system(size: subheadline_size))
                                .foregroundStyle(text_color)
                            Spacer()
                        }
                        
                        Grid() {
                            ForEach(Array(bpr.bp_pbp_list.enumerated()), id: \.offset){ index, bpevnt in
                                
                                let exp_y_target = convert_y_location(location: String(bpevnt.expected_spot.prefix(1)))
                                let exp_x_target = convert_x_location(location: String(bpevnt.expected_spot.suffix(1)))
                                let act_y_target = convert_y_location(location: String(bpevnt.actual_spot.prefix(1)))
                                let act_x_target = convert_x_location(location: String(bpevnt.actual_spot.suffix(1)))
                                
                                if index != 0 {
                                    Divider()
                                }
                                GridRow {
                                    
                                    //Spacer()
                                    
                                    Text("\(bpevnt.pitch_num)")
                                    
    //                                HStack{
    //                                    Divider()
    //                                }
                                    
                                    Spacer()
                                    
                                    Text(bpevnt.pitch_type)
                                    
    //                                HStack{
    //                                    Divider()
    //                                }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .center){
                                        Grid(horizontalSpacing: 1, verticalSpacing: 1){
                                            ForEach(0..<5, id: \.self) { ynumber in
                                                GridRow{
                                                    ForEach(0..<5, id: \.self) { xnumber in
                                                        if xnumber == act_x_target && ynumber == act_y_target {
                                                            Rectangle()
                                                                .fill(Color("Gold"))
                                                                .frame(width: 7, height: 10)
                                                                .border(xnumber == exp_x_target && ynumber == exp_y_target ? Color("ScoreboardGreen") : .clear, width: 1.5)
                                                        }
                                                        else if (ynumber > 0 && ynumber < 4) && (xnumber > 0 && xnumber < 4) {
                                                            Rectangle()
                                                                .fill(.white)
                                                                .frame(width: 7, height: 10)
                                                                .border(xnumber == exp_x_target && ynumber == exp_y_target ? Color("ScoreboardGreen") : .clear, width: 1.5)
                                                        }
                                                        else {
                                                            Rectangle()
                                                                .fill(.gray)
                                                                .frame(width: 7, height: 10)
                                                                .border(xnumber == exp_x_target && ynumber == exp_y_target ? Color("ScoreboardGreen") : .clear, width: 1.5)
                                                        }
                                                       
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .gridColumnAlignment(.center)
                                    
                                    //Spacer()
                                    
                                }
                            }
                        }
                        .padding(.horizontal, view_padding * 2)
                    }
                    .font(.system(size: _default))
                    .foregroundStyle(text_color)
                    .padding(view_padding)
                    .frame(maxWidth: .infinity)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    
                }
                .padding(.horizontal, view_padding)
                .padding(.bottom, view_padding)
                
                
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(LinearGradient(gradient: background_gradient, startPoint: .top, endPoint: .bottom))
    }
    
    func convert_y_location(location: String) -> Int {
        let location_list = ["A", "B", "C", "D", "E"]
        var num_location = 0
        var index = 0
        
        //print(location)
        
        for locations in location_list {
            if location == locations {
                num_location = index
            }
            index += 1
        }
        
        return num_location
    }
    
    func convert_x_location(location: String) -> Int {
        let location_list = ["1", "2", "3", "4", "5"]
        var num_location = 0
        var index = 0
        
        for locations in location_list {
            if location == locations {
                num_location = index
            }
            index += 1
        }
        
        return num_location
        
    }
    
    @MainActor
    func renderBPR(viewSize: CGSize) -> URL {
        
        let bpr_renderer = ImageRenderer(content: reportView.frame(width: viewSize.width))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M.d.yy"

        let formattedDate = dateFormatter.string(from: Date())
        
        let first_name = current_pitcher.firstName.prefix(1)
        let last_name = current_pitcher.lastName.prefix(5)
        
        let path_string = first_name + "-" + last_name + "-Bullpen-" + formattedDate + ".pdf"
        
        let url = URL.documentsDirectory.appending(path: path_string)
        
        bpr_renderer.render { size, context in
            var box = CGRect(x: 0, y: 0, width: viewSize.width, height: size.height)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                //pdf.autoScales = true
                return
            }
            
            pdf.beginPDFPage(nil)
            
            //pdf.translateBy(x: box.size.width / 2 - size.width / 2, y: box.size.height / 2 - size.height / 2)
            
            context(pdf)
            
            pdf.endPDFPage()
            pdf.closePDF()
        }
        
        return url
        
    }
    
}

#Preview {
    BullpenReportView()
}
