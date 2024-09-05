//
//  BullpenMainView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 8/22/24.
//

import SwiftUI

struct BullpenMainView: View {
    
    @State private var expected_target: String?
    @State private var actual_target: String?
    @State private var expected_location: Bool = false
    @State private var actual_location: Bool = false
    @State private var show_pitch_type: Bool = false
    
    @State private var hi_expected = false
    @State private var hi_actual = false
    @State private var lo_expected = false
    @State private var lo_actual = false
    
    @State private var ol_expected = false
    @State private var ol_actual = false
    @State private var or_expected = false
    @State private var or_actual = false
    
    @State var a1_expected: Bool = false
    @State var a1_actual: Bool = false
    @State var a_row_expected: Bool = false
    @State var a_row_actual: Bool = false
    @State var a5_expected: Bool = false
    @State var a5_actual: Bool = false
    
    @State var mid_start_expected: Bool = false
    @State var mid_start_actual: Bool = false
    
    @State var mid_mid_expected: Bool = false
    @State var mid_mid_actual: Bool = false
    
    @State var mid_end_expected: Bool = false
    @State var mid_end_actual: Bool = false
    
    @State var e1_expected: Bool = false
    @State var e1_actual: Bool = false
    @State var e_row_expected: Bool = false
    @State var e_row_actual: Bool = false
    @State var e5_expected: Bool = false
    @State var e5_actual: Bool = false
    
    @State private var showPitchType: Bool = false
    
    var middle_y_cor: [String] = ["B", "C", "D"]
    
    var szb_width: CGFloat = 34
    var szb_height: CGFloat = 51
    
    var strikezone_color: Color = .white
    var outside_color: Color = .gray
    var wayout_color: Color = .black
    var text_color: Color = .white
    
    var outside_padding: CGFloat = 10
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                Image("BPA_Background")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack{
                    bullpenPitchArea
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color("ScoreboardGreen"))
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button(action: {
        //                    dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .imageScale(.medium)
                                .font(.system(size: 17))
                                .frame(width: 17, height: 17)
                                .foregroundColor(text_color)
                                .bold()
                        })
                    }
                }
                
                if expected_location == true && actual_location == true {
                    BPPitchTypePopUp(dismiss_action: {showPitchType = false; reset_zone()})
                    //reset zone
                }
                
            }
            

        }
    }
    
    var prev_pitch_summary: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color("DarkGrey"))
                        .frame(height: 50)
                        .padding(.horizontal, 20)
                }
                Spacer()
            }
            Spacer()
        }
        
    }
    
    var bullpenPitchArea: some View {
        GeometryReader{ geometry in
            let szs_width = geometry.size.width / 11
            let szs_height = (3 * szs_width) / 2
            VStack{
                VStack{
                    //Spacer()
                    prev_pitch_summary
                    Spacer()
                }
                VStack{
                    Button(action: {
                        //print("HI")
                        if expected_location == false && actual_location == false {
                            expected_target = "HI"
                            expected_location = true
                            hi_expected = true
                        }
                        else if expected_location == true && actual_location == false {
                            actual_target = "HI"
                            actual_location = true
                            hi_actual = true
                            showPitchType = true
                        }
                        else {
                            actual_location = false
                            expected_location = false
                            reset_zone()
                        }
                        
                    }) {
                        Rectangle()
                            .foregroundColor(hi_actual == true ? Color("Gold") : wayout_color.opacity(0.3))
                            .frame(width: szs_height * 4.3 , height: szs_width)
                            .border(hi_expected == true ? Color("ScoreboardGreen") : .clear, width: 4)
                    }
                    HStack{
                        Spacer()
                        VStack{
                            Button(action: {
                                //print("OL")
                                if expected_location == false && actual_location == false {
                                    expected_target = "OL"
                                    expected_location = true
                                    ol_expected = true
                                }
                                else if expected_location == true && actual_location == false {
                                    actual_target = "OL"
                                    actual_location = true
                                    ol_actual = true
                                }
                                else {
                                    actual_location = false
                                    expected_location = false
                                    reset_zone()
                                }
                            }) {
                                Rectangle()
                                    .foregroundColor(ol_actual == true ? Color("Gold") : wayout_color.opacity(0.3))
                                    .frame(width: szs_width, height: szs_height * 6)
                                    .border(ol_expected == true ? Color("ScoreboardGreen") : .clear, width: 4)
                            }
                        }
                        
                        VStack{
                            
                            HStack{
                                Button(action: {
                                    //print("A1")
                                    if expected_location == false && actual_location == false {
                                        expected_target = "A1"
                                        expected_location = true
                                        a1_expected = true
                                    }
                                    else if expected_location == true && actual_location == false {
                                        actual_target = "A1"
                                        actual_location = true
                                        a1_actual = true
                                    }
                                    else {
                                        actual_location = false
                                        expected_location = false
                                        reset_zone()
                                    }
                                    
                                }) {
                                    Rectangle()
                                        .foregroundColor(a1_actual == true ? Color("Gold") : outside_color)
                                        .frame(width: szs_width, height: szs_height)
                                        .border(a1_expected == true ? Color("ScoreboardGreen") : .clear, width: 4)
                                        .padding(outside_padding)
                                }
                                
                                ForEach(0..<3, id: \.self) { number in
                                    Button(action: {
                                        //print("A" + String(number + 2))
                                        if expected_location == false && actual_location == false {
                                            expected_target = "A" + String(number + 2)
                                            expected_location = true
                                            a_row_expected = true
                                        }
                                        else if expected_location == true && actual_location == false {
                                            actual_target = "A" + String(number + 2)
                                            actual_location = true
                                            a_row_actual = true
                                        }
                                        else {
                                            actual_location = false
                                            expected_location = false
                                            reset_zone()
                                        }
                                    }) {
                                        Rectangle()
                                            .foregroundColor(a_row_actual == true && actual_target == "A" + String(number + 2) ? Color("Gold") : outside_color)
                                            .border(a_row_expected == true && expected_target == "A" + String(number + 2) ? Color("ScoreboardGreen") : .clear, width: 4)
                                            .frame(width: szs_width, height: szs_height)
                                    }
                                }
                                
                                Button(action: {
                                    //print("A5")
                                    if expected_location == false && actual_location == false {
                                        expected_target = "A5"
                                        expected_location = true
                                        a5_expected = true
                                    }
                                    else if expected_location == true && actual_location == false {
                                        actual_target = "A5"
                                        actual_location = true
                                        a5_actual = true
                                    }
                                    else {
                                        actual_location = false
                                        expected_location = false
                                        reset_zone()
                                    }
                                }) {
                                    Rectangle()
                                        .foregroundColor(a5_actual == true ? Color("Gold") : outside_color)
                                        .frame(width: szs_width, height: szs_height)
                                        .border(a5_expected == true ? Color("ScoreboardGreen") : .clear, width: 4)
                                        .padding(outside_padding)
                                }
                            }
                                
                            ForEach(middle_y_cor, id: \.self) { row in
                                HStack{
                                    
                                    Button(action: {
                                        //print(row + "1")
                                        if expected_location == false && actual_location == false {
                                            expected_target = row + "1"
                                            expected_location = true
                                            mid_start_expected = true
                                        }
                                        else if expected_location == true && actual_location == false {
                                            actual_target = row + "1"
                                            actual_location = true
                                            mid_start_actual = true
                                        }
                                        else {
                                            actual_location = false
                                            expected_location = false
                                            reset_zone()
                                        }
                                    }) {
                                        Rectangle()
                                            .foregroundColor(mid_start_actual == true && actual_target == row + "1" ? Color("Gold") : outside_color)
                                            .border(mid_start_expected == true && expected_target == row + "1" ? Color("ScoreboardGreen") : .clear, width: 4)
                                            .frame(width: szs_width, height: szs_height)
                                            .padding(.horizontal, outside_padding)
                                    }
                                    
                                    ForEach(0..<3) { number in
                                        Button(action: {
                                            //print(row + String(number + 2))
                                            if expected_location == false && actual_location == false {
                                                expected_target = row + String(number + 2)
                                                expected_location = true
                                                mid_mid_expected = true
                                            }
                                            else if expected_location == true && actual_location == false {
                                                actual_target = row + String(number + 2)
                                                actual_location = true
                                                mid_mid_actual = true
                                            }
                                            else {
                                                actual_location = false
                                                expected_location = false
                                                reset_zone()
                                            }
                                        }) {
                                            Rectangle()
                                                .foregroundColor(mid_mid_actual == true && actual_target == row + String(number + 2) ? Color("Gold") : strikezone_color)
                                                .border(mid_mid_expected == true && expected_target == row + String(number + 2) ? Color("ScoreboardGreen") : .clear, width: 4)
                                                .frame(width: szs_width, height: szs_height)
                                        }
                                    }
                                    
                                    Button(action: {
                                        //print(row + "5")
                                        if expected_location == false && actual_location == false {
                                            expected_target = row + "5"
                                            expected_location = true
                                            mid_end_expected = true
                                        }
                                        else if expected_location == true && actual_location == false {
                                            actual_target = row + "5"
                                            actual_location = true
                                            mid_end_actual = true
                                        }
                                        else {
                                            actual_location = false
                                            expected_location = false
                                            reset_zone()
                                        }
                                    }) {
                                        Rectangle()
                                            .foregroundColor(mid_end_actual == true && actual_target == row + "5" ? Color("Gold") : outside_color)
                                            .border(mid_end_expected == true && expected_target == row + "5" ? Color("ScoreboardGreen") : .clear, width: 4)
                                            .frame(width: szs_width, height: szs_height)
                                            .padding(.horizontal, outside_padding)
                                    }
                                    
                                }

                            }
                            
                            HStack{
                                Button(action: {
                                    //print("E1")
                                    if expected_location == false && actual_location == false {
                                        expected_target = "E1"
                                        expected_location = true
                                        e1_expected = true
                                    }
                                    else if expected_location == true && actual_location == false {
                                        actual_target = "E1"
                                        actual_location = true
                                        e1_actual = true
                                    }
                                    else {
                                        actual_location = false
                                        expected_location = false
                                        reset_zone()
                                    }
                                }) {
                                    Rectangle()
                                        .foregroundColor(e1_actual == true ? Color("Gold") : outside_color)
                                        .frame(width: szs_width, height: szs_height)
                                        .border(e1_expected == true ? Color("ScoreboardGreen") : .clear, width: 4)
                                        .padding(outside_padding)
                                }
                                
                                ForEach(0..<3) { number in
                                    Button(action: {
                                        //print("E" + String(number + 2))
                                        if expected_location == false && actual_location == false {
                                            expected_target = "E" + String(number + 2)
                                            expected_location = true
                                            e_row_expected = true
                                        }
                                        else if expected_location == true && actual_location == false {
                                            actual_target = "E" + String(number + 2)
                                            actual_location = true
                                            e_row_actual = true
                                        }
                                        else {
                                            actual_location = false
                                            expected_location = false
                                            reset_zone()
                                        }
                                    }) {
                                        Rectangle()
                                            .foregroundColor(e_row_actual == true && actual_target == "E" + String(number + 2) ? Color("Gold") : outside_color)
                                            .border(e_row_expected == true && expected_target == "E" + String(number + 2) ? Color("ScoreboardGreen") : .clear, width: 4)
                                            .frame(width: szs_width, height: szs_height)
                                    }
                                }
                                
                                Button(action: {
                                    //print("E5")
                                    if expected_location == false && actual_location == false {
                                        expected_target = "E5"
                                        expected_location = true
                                        e5_expected = true
                                    }
                                    else if expected_location == true && actual_location == false {
                                        actual_target = "E5"
                                        actual_location = true
                                        e5_actual = true
                                    }
                                    else {
                                        actual_location = false
                                        expected_location = false
                                        reset_zone()
                                    }
                                }) {
                                    Rectangle()
                                        .foregroundColor(e5_actual == true ? Color("Gold") : outside_color)
                                        .frame(width: szs_width, height: szs_height)
                                        .border(e5_expected == true ? Color("ScoreboardGreen") : .clear, width: 4)
                                        .padding(outside_padding)
                                }
                            }
                        }
                        
                        VStack{
                            Button(action: {
                                //print("OR")
                                if expected_location == false && actual_location == false {
                                    expected_target = "OR"
                                    expected_location = true
                                    or_expected = true
                                }
                                else if expected_location == true && actual_location == false {
                                    actual_target = "OR"
                                    actual_location = true
                                    or_actual = true
                                }
                                else {
                                    actual_location = false
                                    expected_location = false
                                    reset_zone()
                                }
                            }) {
                                Rectangle()
                                    .foregroundColor(or_actual == true ? Color("Gold") : wayout_color.opacity(0.3))
                                    .frame(width: szs_width, height: szs_height * 6)
                                    .border(or_expected == true ? Color("ScoreboardGreen") : .clear, width: 4)
                            }
                        }
                        Spacer()
                    }
                    Button(action: {
                        //print("LO")
                        if expected_location == false && actual_location == false {
                            expected_target = "LO"
                            expected_location = true
                            lo_expected = true
                        }
                        else if expected_location == true && actual_location == false {
                            actual_target = "LO"
                            actual_location = true
                            lo_actual = true
                        }
                        else {
                            actual_location = false
                            expected_location = false
                            reset_zone()
                        }
                    }) {
                        Rectangle()
                            .foregroundColor(lo_actual == true ? Color("Gold") : wayout_color.opacity(0.3))
                            .frame(width: szs_height * 4.3 , height: szs_width)
                            .border(lo_expected == true ? Color("ScoreboardGreen") : .clear, width: 4)
                    }
                }
                .padding(.bottom, geometry.size.height / 7)
            }
        }
    }
    
    func reset_zone() {
        expected_location = false
        actual_location = false
        
        hi_expected = false
        hi_actual = false
        lo_expected = false
        lo_actual = false
        
        ol_expected = false
        ol_actual = false
        or_expected = false
        or_actual = false
        
        a1_expected = false
        a1_actual = false
        a_row_expected = false
        a_row_actual = false
        a5_expected = false
        a5_actual = false
        
        mid_start_expected = false
        mid_start_actual = false
        
        mid_mid_expected = false
        mid_mid_actual = false
        
        mid_end_expected = false
        mid_end_actual = false
        
        e1_expected = false
        e1_actual = false
        e_row_expected = false
        e_row_actual = false
        e5_expected = false
        e5_actual = false
        
    }
    
}

struct BPPitchTypePopUp: View {
    
    @State private var offset: CGFloat = 1000
    
    var crnr_radius: CGFloat = 12
    var font_color: Color = .white
    var dismiss_action: () -> ()
 
    var body: some View {
        
        ZStack{
            
            Color(.black)
                .opacity(0.2)
            
            VStack{
                Text("Select Pitch")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(font_color)
                    .padding()
                
                VStack{
                    Button(action: {
                        close()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {dismiss_action()}
                    }) {
                        Text("Fastball")
                    }
                }
                
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
                    offset = -120
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

#Preview {
    BullpenMainView()
}
