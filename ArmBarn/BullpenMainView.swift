//
//  BullpenMainView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 8/22/24.
//

import SwiftUI
import SwiftData
import TipKit

struct BullpenMainView: View {
    
    @AppStorage("BullpenMode") var ASBullpenMode : Bool?
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(BullpenConfig.self) var bullpen
    @Environment(BullpenReport.self) var bpr
    @Environment(Event_String.self) var event
    @Environment(currentPitcher.self) var current_pitcher
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    @Query var bullpen_events: [BullpenEvent]
    
    @State private var pitch_num: Int = 0
    @State private var prev_pitch: String = ""
    @State private var spot_detail: String = ""
    
    @State private var showPitcherSelect = false
    @State private var showBullpenReport: Bool = false
    @State private var endBullpen: Bool = false
    @State private var resumeBullpen: Bool = false
    
    @State private var expected_target: String = ""
    @State private var actual_target: String = ""
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
    
    private let welcomebullpentip = WelcomeBullpenTip()
    private let bullpenreporttip = BullpenReportTip()
    
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
                        
                        Button {
                            endBullpen = true
                        } label: {
                            Image(systemName: "xmark")
                                .imageScale(.medium)
                                .font(.system(size: 17))
                                .frame(width: 17, height: 17)
                                .foregroundColor(text_color)
                                .bold()
                        }
                    }
                    
                    ToolbarItemGroup(placement: .principal) {
                        HStack(alignment: .center){
                            Text("P")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(.leading, -7)
                            
                            ZStack(alignment: .leading){
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundStyle(
                                        Color("ScoreboardGreen").shadow(.inner(color: .black.opacity(0.4), radius: 2, x: 1, y: 1))
                                    )
                                    .frame(width: 160, height: 30)
                                
                                let pitcher_lname = String(current_pitcher.lastName.prefix(10))
                                
                                Button(action: {
                                    if scoreboard.enable_bottom_row == true {
                                        showPitcherSelect = true
                                    }
                                }) {
                                    Text(pitcher_lname)
                                        .textCase(.uppercase)
                                        .font(.system(size: 20))
                                        .fontWeight(.black)
                                        .foregroundColor(.white)
                                        .padding(.leading, -3)
                                }
                                .popover(isPresented: $showPitcherSelect) {
                                    SelectPitcherView()
                                        .preferredColorScheme(.dark)
                                }
                            }
                        }
                    }
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        
                        Button(action: {
                            if expected_location == false {
                                //Undo function: remove previous bullpen event
                                if bullpen_events.count > 1 {
                                    context.delete(bullpen_events[bullpen_events.count - 1])
                                    update_previous_pitch_variables()
                                }
                                else {
                                    clear_previous_pitch_variables()
                                    clear_bullpen_events()
                                }
                               // print(bullpen_events.count)

                            }
                            else if expected_location == true && actual_location == false {
                                expected_location = false
                                reset_expected_locations()
                            }
                            else if expected_location == true && actual_location == true {
                                actual_location = false
                                reset_actual_locations()
                            }
                            
                        }, label: {
                            if expected_location == false {
                                Image(systemName: "arrow.counterclockwise")
                                    .imageScale(.medium)
                                    .font(.system(size: 17))
                                    .foregroundColor(.white)
                                    .padding(.leading, -5)
                                    .bold()
                                Text("UNDO")
                                    .font(.system(size: 17))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .padding(.leading, -5)
                            }
                            else {
                                Image(systemName: "chevron.left")
                                    .imageScale(.medium)
                                    .foregroundColor(.white)
                                    .bold()
                                Text("BACK")
                                    .font(.system(size: 17))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .padding(.leading, -5)
                            }
                            
                        })
                        
                    }
                    
                }
                
                if expected_location == true && actual_location == true {
                    BPPitchTypePopUp(dismiss_action: {showPitchType = false; reset_zone(); /*bullpenreporttip.invalidate(reason: .actionPerformed)*/})
                }
                
                if bullpen_events.count > 0 && bullpen.pp_number == 0 && bullpen.pp_pitchtype == "-" {
                    PopupAlertView(isActive: $resumeBullpen, title: "Resume Bullpen", message: "A previous bullpen was being recorded. Do you want to continue?", leftButtonAction: {DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){/*new set previous pitch function*/
                        resumeBullpen = false
                        scoreboard.enable_bottom_row = true
                        set_pitcher()
                        load_cur_bullpen_event()
                        dismiss()}}, rightButtonAction: {DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                            clear_bullpen_events()
                            resumeBullpen = false
                            scoreboard.enable_bottom_row = true
                            dismiss()}})
                }
                
                if endBullpen == true{
                    PopupAlertView(isActive: $endBullpen, title: "End Bullpen", message: "This bullpen session and its data will be saved!", leftButtonAction: {DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {event.recordEvent = false
                        scoreboard.update_scoreboard = false
                        ASBullpenMode = false
                        clear_bullpen_events()
                        clear_bullpen_report()
                        clear_previous_pitch_variables()
                        scoreboard.enable_bottom_row = true
                        dismiss()}}, rightButtonAction: {DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {dismiss(); endBullpen = false; scoreboard.enable_bottom_row = true}})
                }
            }
        }
    }
    
    var prev_pitch_summary: some View {
        
        GeometryReader{ geometry in
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    ZStack{
                        HStack(){
                            HStack{
                                Spacer()
                                if bullpen.pp_number == 0 {
                                    Image(systemName: "minus")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                        .bold()
                                }
                                else {
                                    Text(String(bullpen.pp_number)) //Pitch number
                                        .font(.system(size: 20))
                                        .bold()
                                }
                                Spacer()
                                Divider()
                                Spacer()
                                if bullpen.pp_pitchtype == "-" {
                                    Image(systemName: "minus")
                                        .foregroundColor(.white)
                                        .font(.system(size: 12))
                                        .bold()
                                }
                                else {
                                    Text(bullpen.pp_pitchtype) //Pitch Type
                                        .font(.system(size: 20))
                                        .bold()
                                }
                                Spacer()
                                Divider()
                                Spacer()
                                ZStack{
                                    
                                    if bullpen.pp_spot_color != .white {
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(bullpen.pp_spot_color)
                                            .font(.system(size: 30))
                                            .bold()
                                    }
                                    
                                    bullpen.pp_spot_detail //Spot hit or missed
                                        .font(bullpen.pp_spot_color == .white ? .system(size: 12) : .system(size: 30))
                                        .bold()
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 10)
                            //Spacer()
                            HStack{
                                Button(action: {
                                    if bullpen_events.count > 0 {
                                        //show Bullpen Report
                                        showBullpenReport = true
                                        generate_bullpen_report()
                                    }
                                }, label: {
                                    Image(systemName: "chart.bar.xaxis")
                                        .imageScale(.medium)
                                        .font(.system(size: 38))
                                        .foregroundColor(.white)
                                        .bold()
                                })
                                .frame(width: 75, height: 75) //Change for screen size
                                .background(Color("ScoreboardGreen"))
                                .cornerRadius(10)
                                .popover(isPresented: $showBullpenReport) {
                                    BullpenReportView().preferredColorScheme(.dark)
                                }
                            }
                        }
                        .frame(height: 75) //Change for screen size
                        .background(Color("DarkGrey"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    Spacer()
                }
                //.frame(maxWidth: .infinity)
                Spacer()
            }
            
        }
    }
    
    var bullpenPitchArea: some View {
        GeometryReader{ geometry in
            let szs_width = geometry.size.width / 11
            let szs_height = (3 * szs_width) / 2
            VStack{
                VStack{
                    //Spacer()
                    ZStack{
                        
                        prev_pitch_summary
                        
                        TipView(welcomebullpentip)
                            .tipBackground(Color("DarkGrey"))
                            .tint(Color("ScoreboardGreen"))
                            .padding(.horizontal, 8)    
                            .preferredColorScheme(.dark)

                    }
                    Spacer()
                }
                VStack{
                    Button(action: {
                        welcomebullpentip.invalidate(reason: .actionPerformed)
                        //print("HI")
                        if expected_location == false && actual_location == false {
                            expected_target = "HI"
                            bullpen.expected_target = expected_target
                            expected_location = true
                            hi_expected = true
                        }
                        else if expected_location == true && actual_location == false {
                            actual_target = "HI"
                            bullpen.actual_target = actual_target
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
                                welcomebullpentip.invalidate(reason: .actionPerformed)
                                //print("OL")
                                if expected_location == false && actual_location == false {
                                    expected_target = "OL"
                                    bullpen.expected_target = expected_target
                                    expected_location = true
                                    ol_expected = true
                                }
                                else if expected_location == true && actual_location == false {
                                    actual_target = "OL"
                                    bullpen.actual_target = actual_target
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
                                    welcomebullpentip.invalidate(reason: .actionPerformed)
                                    //print("A1")
                                    if expected_location == false && actual_location == false {
                                        expected_target = "A1"
                                        bullpen.expected_target = expected_target
                                        expected_location = true
                                        a1_expected = true
                                    }
                                    else if expected_location == true && actual_location == false {
                                        actual_target = "A1"
                                        bullpen.actual_target = actual_target
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
                                        welcomebullpentip.invalidate(reason: .actionPerformed)
                                        //print("A" + String(number + 2))
                                        if expected_location == false && actual_location == false {
                                            expected_target = "A" + String(number + 2)
                                            bullpen.expected_target = expected_target
                                            expected_location = true
                                            a_row_expected = true
                                        }
                                        else if expected_location == true && actual_location == false {
                                            actual_target = "A" + String(number + 2)
                                            bullpen.actual_target = actual_target
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
                                    welcomebullpentip.invalidate(reason: .actionPerformed)
                                    //print("A5")
                                    if expected_location == false && actual_location == false {
                                        expected_target = "A5"
                                        bullpen.expected_target = expected_target
                                        expected_location = true
                                        a5_expected = true
                                    }
                                    else if expected_location == true && actual_location == false {
                                        actual_target = "A5"
                                        bullpen.actual_target = actual_target
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
                                        welcomebullpentip.invalidate(reason: .actionPerformed)
                                        //print(row + "1")
                                        if expected_location == false && actual_location == false {
                                            expected_target = row + "1"
                                            bullpen.expected_target = expected_target
                                            expected_location = true
                                            mid_start_expected = true
                                        }
                                        else if expected_location == true && actual_location == false {
                                            actual_target = row + "1"
                                            bullpen.actual_target = actual_target
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
                                            welcomebullpentip.invalidate(reason: .actionPerformed)
                                            //print(row + String(number + 2))
                                            if expected_location == false && actual_location == false {
                                                expected_target = row + String(number + 2)
                                                bullpen.expected_target = expected_target
                                                expected_location = true
                                                mid_mid_expected = true
                                            }
                                            else if expected_location == true && actual_location == false {
                                                actual_target = row + String(number + 2)
                                                bullpen.actual_target = actual_target
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
                                        welcomebullpentip.invalidate(reason: .actionPerformed)
                                        //print(row + "5")
                                        if expected_location == false && actual_location == false {
                                            expected_target = row + "5"
                                            bullpen.expected_target = expected_target
                                            expected_location = true
                                            mid_end_expected = true
                                        }
                                        else if expected_location == true && actual_location == false {
                                            actual_target = row + "5"
                                            bullpen.actual_target = actual_target
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
                                    welcomebullpentip.invalidate(reason: .actionPerformed)
                                    //print("E1")
                                    if expected_location == false && actual_location == false {
                                        expected_target = "E1"
                                        bullpen.expected_target = expected_target
                                        expected_location = true
                                        e1_expected = true
                                    }
                                    else if expected_location == true && actual_location == false {
                                        actual_target = "E1"
                                        bullpen.actual_target = actual_target
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
                                        welcomebullpentip.invalidate(reason: .actionPerformed)
                                        //print("E" + String(number + 2))
                                        if expected_location == false && actual_location == false {
                                            expected_target = "E" + String(number + 2)
                                            bullpen.expected_target = expected_target
                                            expected_location = true
                                            e_row_expected = true
                                        }
                                        else if expected_location == true && actual_location == false {
                                            actual_target = "E" + String(number + 2)
                                            bullpen.actual_target = actual_target
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
                                    welcomebullpentip.invalidate(reason: .actionPerformed)
                                    //print("E5")
                                    if expected_location == false && actual_location == false {
                                        expected_target = "E5"
                                        bullpen.expected_target = expected_target
                                        expected_location = true
                                        e5_expected = true
                                    }
                                    else if expected_location == true && actual_location == false {
                                        actual_target = "E5"
                                        bullpen.actual_target = actual_target
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
                                welcomebullpentip.invalidate(reason: .actionPerformed)
                                //print("OR")
                                if expected_location == false && actual_location == false {
                                    expected_target = "OR"
                                    bullpen.expected_target = expected_target
                                    expected_location = true
                                    or_expected = true
                                }
                                else if expected_location == true && actual_location == false {
                                    actual_target = "OR"
                                    bullpen.actual_target = actual_target
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
                        welcomebullpentip.invalidate(reason: .actionPerformed)
                        //print("LO")
                        if expected_location == false && actual_location == false {
                            expected_target = "LO"
                            bullpen.expected_target = expected_target
                            expected_location = true
                            lo_expected = true
                        }
                        else if expected_location == true && actual_location == false {
                            actual_target = "LO"
                            bullpen.actual_target = actual_target
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
    
    func generate_bullpen_report() {
        bpr.pitches = 0
        bpr.spots_hit = 0
        
        bpr.p1_pitches = 0
        bpr.p1_spots_hit = 0
        bpr.p2_pitches = 0
        bpr.p2_spots_hit = 0
        bpr.p3_pitches = 0
        bpr.p3_spots_hit = 0
        bpr.p4_pitches = 0
        bpr.p4_spots_hit = 0
        
        bpr.spots_by_pitch_list = []
        bpr.bp_pbp_list = []
        
        var pbp_pitch_num: Int = 0
        var pbp_pitch_type: String = ""
        var pbp_expected_target: String = ""
        var pbp_actual_target: String = ""
        
        for bpevnt in bullpen_events {
            if bpevnt.pitcher_id == current_pitcher.idcode {
                bpr.pitches += 1
                pbp_pitch_num += 1
                pbp_expected_target = bpevnt.expected_target
                pbp_actual_target = bpevnt.actual_target
                
                if bpevnt.pitch_type == "P1" {
                    bpr.p1_pitches += 1
                    pbp_pitch_type = current_pitcher.pitch1
                    if bpevnt.expected_target == bpevnt.actual_target {
                        bpr.spots_hit += 1
                        bpr.p1_spots_hit += 1
                    }
                }
                else if bpevnt.pitch_type == "P2" {
                    bpr.p2_pitches += 1
                    pbp_pitch_type = current_pitcher.pitch2
                    if bpevnt.expected_target == bpevnt.actual_target {
                        bpr.spots_hit += 1
                        bpr.p2_spots_hit += 1
                    }
                }
                else if bpevnt.pitch_type == "P3" {
                    bpr.p3_pitches += 1
                    pbp_pitch_type = current_pitcher.pitch3
                    if bpevnt.expected_target == bpevnt.actual_target {
                        bpr.spots_hit += 1
                        bpr.p3_spots_hit += 1
                    }
                }
                else if bpevnt.pitch_type == "P4" {
                    bpr.p4_pitches += 1
                    pbp_pitch_type = current_pitcher.pitch4
                    if bpevnt.expected_target == bpevnt.actual_target {
                        bpr.spots_hit += 1
                        bpr.p4_spots_hit += 1
                    }
                }
                
                bpr.bp_pbp_list.append(BP_PBPLog(pitch_num: pbp_pitch_num, pitch_type: pbp_pitch_type, expected_spot: pbp_expected_target, actual_spot: pbp_actual_target))
            }
        }
        
            
        if bpr.p1_pitches >= 1 {
            bpr.spots_by_pitch_list.append(SpotsByPitchType(pitch_type: current_pitcher.pitch1, pitch_num: bpr.p1_pitches, spots_hit: bpr.p1_spots_hit))
        }
        
        if bpr.p2_pitches >= 1 {
            bpr.spots_by_pitch_list.append(SpotsByPitchType(pitch_type: current_pitcher.pitch2, pitch_num: bpr.p2_pitches, spots_hit: bpr.p2_spots_hit))
        }
        
        if bpr.p3_pitches >= 1 {
            bpr.spots_by_pitch_list.append(SpotsByPitchType(pitch_type: current_pitcher.pitch3, pitch_num: bpr.p3_pitches, spots_hit: bpr.p3_spots_hit))
        }
        
        if bpr.p4_pitches >= 1 {
            bpr.spots_by_pitch_list.append(SpotsByPitchType(pitch_type: current_pitcher.pitch4, pitch_num: bpr.p4_pitches, spots_hit: bpr.p4_spots_hit))
        }
        
    }
    
    func clear_bullpen_report() {
        bpr.pitches = 0
        bpr.spots_hit = 0
        
        bpr.p1_pitches = 0
        bpr.p1_spots_hit = 0
        bpr.p2_pitches = 0
        bpr.p2_spots_hit = 0
        bpr.p3_pitches = 0
        bpr.p3_spots_hit = 0
        bpr.p4_pitches = 0
        bpr.p4_spots_hit = 0
        
        bpr.spots_by_pitch_list = []
        
    }
    
    func clear_bullpen_events() {
        do {
            try context.delete(model: BullpenEvent.self)
        } catch {
            print("Did not clear bullpen event data")
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
    
    func reset_actual_locations() {
        //actual_location = false

        hi_actual = false
        lo_actual = false
        
        ol_actual = false
        or_actual = false
        
        a1_actual = false
        a_row_actual = false
        a5_actual = false
        
        mid_start_actual = false
        mid_mid_actual = false
        mid_end_actual = false
        
        e1_actual = false
        e_row_actual = false
        e5_actual = false
    }
    
    func reset_expected_locations() {
        //expected_location = false
        
        hi_expected = false
        lo_expected = false
        
        ol_expected = false
        or_expected = false
        
        a1_expected = false
        a_row_expected = false
        a5_expected = false
        
        mid_start_expected = false
        mid_mid_expected = false
        mid_end_expected = false
        
        e1_expected = false
        e_row_expected = false
        e5_expected = false
    }
    func load_cur_bullpen_event() {
        let current_bullpen_event = bullpen_events[bullpen_events.count - 1]
        let current_pitch_type = current_bullpen_event.pitch_type
        let current_expected_target = current_bullpen_event.expected_target
        let current_actual_target = current_bullpen_event.actual_target
        bullpen.pp_number = bullpen_events.count
        //set current pitcher
        if current_pitch_type == "P1" {
            bullpen.pp_pitchtype = current_pitcher.pitch1
        }
        else if current_pitch_type == "P2" {
            bullpen.pp_pitchtype = current_pitcher.pitch2
        }
        else if current_pitch_type == "P3" {
            bullpen.pp_pitchtype = current_pitcher.pitch3
        }
        else if current_pitch_type == "P4" {
            bullpen.pp_pitchtype = current_pitcher.pitch4
        }
        
        if current_expected_target == current_actual_target {
            bullpen.pp_spot_detail = Image(systemName: "checkmark.circle")
            bullpen.pp_spot_color = Color("ScoreboardGreen")
        }
        else {
            bullpen.pp_spot_detail = Image(systemName: "xmark.circle")
            bullpen.pp_spot_color = .red
        }
    }
    
    func set_pitcher() {
        let pitcher_id = bullpen_events[bullpen_events.count - 1].pitcher_id
        for pitcher in pitchers {
            if pitcher.id == pitcher_id {
                current_pitcher.pitch_num = 0
                current_pitcher.firstName = pitcher.firstName
                current_pitcher.lastName = pitcher.lastName
                current_pitcher.pitch1 = pitcher.pitch1
                current_pitcher.idcode = pitcher.id
                if current_pitcher.pitch1 != "None" {
                    current_pitcher.pitch_num += 1
                    current_pitcher.arsenal[0] = pitcher.pitch1
                }
                
                current_pitcher.pitch2 = pitcher.pitch2
                if current_pitcher.pitch2 != "None" {
                    current_pitcher.pitch_num += 1
                    current_pitcher.arsenal[1] = pitcher.pitch2
                }
                
                current_pitcher.pitch3 = pitcher.pitch3
                if current_pitcher.pitch3 != "None" {
                    current_pitcher.pitch_num += 1
                    current_pitcher.arsenal[2] = pitcher.pitch3
                }
                
                current_pitcher.pitch4 = pitcher.pitch4
                if current_pitcher.pitch4 != "None" {
                    current_pitcher.pitch_num += 1
                    current_pitcher.arsenal[3] = pitcher.pitch4
                }
                break
            }
        }
    }
    
    func update_previous_pitch_variables() {
        
        let previous_bullpen_event = bullpen_events[bullpen_events.count - 2]
        
        let previous_pitchtype = previous_bullpen_event.pitch_type
        let previous_expected_target = previous_bullpen_event.expected_target
        let previous_actual_target = previous_bullpen_event.actual_target
       // print(previous_pitchtype)
        
        bullpen.pp_number -= 1
        
        if previous_pitchtype == "P1" {
            bullpen.pp_pitchtype = current_pitcher.pitch1
        }
        else if previous_pitchtype == "P2" {
            bullpen.pp_pitchtype = current_pitcher.pitch2
        }
        else if previous_pitchtype == "P3" {
            bullpen.pp_pitchtype = current_pitcher.pitch3
        }
        else if previous_pitchtype == "P4" {
            bullpen.pp_pitchtype = current_pitcher.pitch4
        }
        
        //print(bullpen.pp_pitchtype)
        
        if previous_expected_target == previous_actual_target {
            bullpen.pp_spot_detail = Image(systemName: "checkmark.circle")
            bullpen.pp_spot_color = Color("ScoreboardGreen")
        }
        else {
            bullpen.pp_spot_detail = Image(systemName: "xmark.circle")
            bullpen.pp_spot_color = .red
        }

    }
    
    func clear_previous_pitch_variables() {
        bullpen.pp_pitchtype = "-"
        bullpen.pp_spot_detail = Image(systemName: "minus")
        bullpen.pp_spot_color = .white
        bullpen.pp_number = 0
    }
    
}

struct BPPitchTypePopUp: View {
    
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(currentPitcher.self) var current_pitcher
    @Environment(Event_String.self) var event
    @Environment(BullpenConfig.self) var bullpen
    
    @Environment(\.modelContext) var context
    
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
                    ForEach(0..<current_pitcher.pitch_num,  id: \.self) { pt_num in
                        Button(action: {
                            bullpen.pitch_type = "P\(pt_num + 1)"
//                            ptconfig.ptcolor = ptconfig.arsenal_colors[pt_num]
                            add_bullpen_event()
                            previous_pitch_detail()
                            close()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {dismiss_action()}
                            }) {
                                Text("\(current_pitcher.arsenal[pt_num])")
                                    .textCase(.uppercase)
                                    .fontWeight(.bold)
                                    .font(.system(size: 15))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                            }
                            .background(ptconfig.arsenal_colors[pt_num])
                            .foregroundColor(Color.white)
                            .cornerRadius(8.0)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 30)
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
                    offset = 0
                }
            }
            
        }
        
    }
    
    func previous_pitch_detail() {
        //print("Add Summary")
        bullpen.pp_number += 1
        
        if bullpen.pitch_type == "P1" {
            bullpen.pp_pitchtype = current_pitcher.pitch1
        }
        else if bullpen.pitch_type == "P2" {
            bullpen.pp_pitchtype = current_pitcher.pitch2
        }
        else if bullpen.pitch_type == "P3" {
            bullpen.pp_pitchtype = current_pitcher.pitch3
        }
        else if bullpen.pitch_type == "P4" {
            bullpen.pp_pitchtype = current_pitcher.pitch4
        }
        
        if bullpen.expected_target == bullpen.actual_target {
            bullpen.pp_spot_detail = Image(systemName: "checkmark.circle")
            bullpen.pp_spot_color = Color("ScoreboardGreen")
        }
        else {
            bullpen.pp_spot_detail = Image(systemName: "xmark.circle")
            bullpen.pp_spot_color = .red
        }
    }
    
    func add_bullpen_event() {
        let bullpen_event = BullpenEvent(pitcher_id: current_pitcher.idcode, expected_target: bullpen.expected_target, actual_target: bullpen.actual_target, pitch_type: bullpen.pitch_type)
        context.insert(bullpen_event)
        print_bullpen_event()

    }

    func print_bullpen_event() {
        print(current_pitcher.idcode, bullpen.expected_target, bullpen.actual_target, bullpen.pitch_type)
    }
    
    func close() {
        withAnimation(.spring()) {
            offset = 1000
        }
    }
    
}

#Preview {
    BullpenMainView()
        .environment(BullpenConfig())
        .environment(Event_String())
        .environment(currentPitcher())
}
