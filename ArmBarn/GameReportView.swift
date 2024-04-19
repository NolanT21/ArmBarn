//
//  GameReportView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 2/4/24.
//

import SwiftUI
import SwiftData
import Charts

struct GameReportView: View {
    
    @Environment(GameReport.self) var game_report
    @Environment(currentPitcher.self) var current_pitcher
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(Event_String.self) var event
    
    @Query var events: [Event]
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    
    @State private var showEndGame = false
    @State private var showGameReceipt = false
    
    var gradient = Gradient(colors: [Color("PowderBlue"), Color("Gold"), Color("Tangerine")])
    var colorset = [Color("PowderBlue"), Color("Gold"), Color("Tangerine"), Color("Grey")]
    
    var view_padding: CGFloat = 10
    var view_crnr_radius: CGFloat = 12
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    @State var font_size: CGFloat = 20.0
    
    var background: Color = .black
    var component_background: UIColor = .darkGray
    var text_color: Color = .white
    var legend_color: Color = .gray
    
    let background_gradient = Gradient(colors: [Color("ScoreboardGreen"), .black, .black, .black, .black, .black])
    let header_gradient = Gradient(colors: [Color("ScoreboardGreen"), Color("ScoreboardGreen"), Color("ScoreboardGreen"), .black])
    
    var body: some View {
        
        ZStack{
            
            GeometryReader { proxy in
                
                let viewsize = proxy.size
                
                VStack{
                    HStack{
                        
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "chevron.left")
                                .imageScale(.medium)
                                .frame(width: sbl_width, height: sbl_height)
                                .foregroundColor(text_color)
                                .bold()
                            Text("BACK")
                                .font(.system(size: font_size))
                                .fontWeight(.heavy)
                                .foregroundColor(text_color)
                        })
                        
                        Spacer()
                        
                        HStack(alignment: .center){
                            
                            Button(action: {
                                showEndGame = true
                            }) {
                                Image(systemName: "flag.checkered")
                                    .imageScale(.large)
                                    .frame(width: sbl_width, height: sbl_height)
                                    .foregroundColor(Color.white)
                            }
                            
                            //Spacer()
                            
                            Button(action: {
                                showGameReceipt = true
                            }) {
                                Image(systemName: "tray.full.fill")
                                    .imageScale(.large)
                                    .frame(width: sbl_width, height: sbl_height)
                                    .foregroundColor(Color.white)
                            }
                            .padding(.leading, view_padding/2)
                            .popover(isPresented: $showGameReceipt) {
                                EndGameView()
                            }
                            
                            //Spacer()
                            
                            ShareLink("", item: render(viewSize: viewsize))
                                .imageScale(.large)
                                .foregroundStyle(text_color)
                                .fontWeight(.bold)
                                .padding(.leading, view_padding/2)
                        }
                        
                    }
                    .padding(.top, view_padding)
                    .padding(.horizontal, view_padding)
                    
                    ScrollView{
                        reportView
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    //.background(background)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
                //.background(Color("ScoreboardGreen"))
                .background(LinearGradient(gradient: header_gradient, startPoint: .top, endPoint: .bottom))
            }
            
            if showEndGame == true{
                PopupAlertView(isActive: $showEndGame, title: "End Game?", message: "This game and its data will not be saved!", leftButtonAction: {new_game_func(); dismiss(); MainContainerView()}, rightButtonAction: {showEndGame = false})
            }
        }
    }
    
    var reportView: some View {

            VStack{
                HStack{
                    VStack (alignment: .leading){
                        Text(current_pitcher.firstName + " " + current_pitcher.lastName)
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(text_color)
                            
                        Text(Date().formatted(.dateTime.day().month().year()))
                            .font(.subheadline)
                            .foregroundStyle(text_color)
                    }
                }
                .padding(.horizontal, view_padding)
                .padding(.top, view_padding)
                
                
                HStack{
                    
                    VStack{
                        
                        HStack{
                            Text("Box Score")
                                .font(.subheadline)
                                .foregroundStyle(text_color)
                            Spacer()
                        }
                        
                        Grid(){
                            GridRow{
                                Text("IP")
                                Text("Pit")
                                Text("BF")
                                Text("H")
                                Text("SO")
                                Text("BB")
                            }
                            .foregroundStyle(text_color)
                            .padding(.vertical, -5)
                            .bold()
                            
                            Divider()
                                //.background(Color.gray)
                            
                            GridRow{
                                Text("\(game_report.inn_pitched, specifier: "%.1f")")
                                Text("\(game_report.pitches)")
                                Text("\(game_report.batters_faced)")
                                Text("\(game_report.hits)")
                                Text("\(game_report.strikeouts)")
                                Text("\(game_report.walks)")
                            }
                            .foregroundStyle(text_color)
                            
                        }
                        
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
                            Text("1st Pitch Strike %")
                                .font(.subheadline)
                                .padding(.top, view_padding)
                                .foregroundStyle(text_color)
                            
                            Spacer()
                        }
                        .padding(.leading, view_padding)
                        .padding(.bottom, view_padding)
                        
                        //Spacer()
                        
                        VStack{
                            //Spacer()
                            ZStack{
                                Gauge(value: Double(game_report.first_pit_strike_per) * 0.01) {}
                                .scaleEffect(2.5)
                                .gaugeStyle(.accessoryCircularCapacity)
                                .tint(Color("PowderBlue"))
                                .padding(view_padding)
                                VStack{
                                    Text("\(game_report.first_pit_strike_per)%")
                                        .font(.system(size: 40))
                                        .foregroundStyle(text_color)
                                        .bold()
                                    Text("\(game_report.first_pitch_strike)/\(game_report.batters_faced)")
                                        .font(.subheadline)
                                        .foregroundStyle(text_color)
                                }
                                .padding(.top, view_padding)
                            }
                            .padding(view_padding)
                            
                            Spacer()
                            
                        }
                        .padding(view_padding)
                        
                        Spacer()
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    .padding(.bottom, view_padding)
                    .padding(.leading, view_padding)
                    .padding(.trailing, view_padding/2)
                    
                    VStack{
                        HStack{
                            Text("Strike %")
                                .font(.subheadline)
                                .foregroundStyle(text_color)
                                .padding(.top, view_padding)
                            
                            Spacer()
                        }
                        .padding(.leading, view_padding)
                        .padding(.bottom, view_padding)
                       
                        VStack{
                            //Spacer()
                            ZStack{
                                Gauge(value: Double(game_report.strikes_per) * 0.01) {}
                                .scaleEffect(2.5)
                                .gaugeStyle(.accessoryCircularCapacity)
                                .tint(Color("Gold"))
                                .padding(view_padding)
                                VStack{
                                    Text("\(game_report.strikes_per)%")
                                        .font(.system(size: 40))
                                        .foregroundStyle(text_color)
                                        .bold()
                                    Text("\(game_report.strikes)/\(game_report.pitches)")
                                        .font(.subheadline)
                                        .foregroundStyle(text_color)
                                }
                                .padding(.top, view_padding)
                            }
                            .padding(view_padding)
                            
                            Spacer()
                            
                        }
                        .padding(view_padding)
                        
                        Spacer()
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    .padding(.bottom, view_padding)
                    .padding(.leading, view_padding/2)
                    .padding(.trailing, view_padding)
                    
                }
                
//                HStack{}
//                
//                Spacer()

                HStack{
                    
                    VStack{
                        
                        HStack{
                            Text("Pitch Location Map")
                                .font(.subheadline)
                                .foregroundStyle(text_color)
                                .padding(.leading, view_padding)
                                .padding(.top, view_padding)
                            Spacer()
                        }

                        ZStack{
                            
                            let screenSize = UIScreen.main.bounds.size
                            
                            Image("PLO_Background")
                                //.resizable()
                                //.aspectRatio(contentMode: .fill)
                                //.scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .padding(.horizontal, 6)
                                .padding(.bottom, 6)
                                .overlay(alignment: .center){
                                    ForEach(game_report.x_coordinate_list.indices, id: \.self){ index in
                                        let xloc = game_report.x_coordinate_list[index] * (202/screenSize.width) + 75
                                        let yloc = game_report.y_coordinate_list[index] * (400/screenSize.height) + 42//0.52 + (screenSize.height * 0.04) //42
                                        let point = CGPoint(x: xloc, y: yloc)
                                        let pitch_color = game_report.pl_color_list[index]
                                        let outline = game_report.pl_outline_list[index]

                                        Circle()
                                            .fill(pitch_color)
                                            .stroke(outline, lineWidth: 4)
                                            .frame(width: 20, height: 20, alignment: .center)
                                            .position(point)
                                    }
                                }
                        }
                        
                        HStack(spacing: 5){
                            
                            Spacer()
                            
                            Circle()
                                .fill(Color("PowderBlue"))
                                .frame(width: 8, height: 8, alignment: .center)
                                                        
                            Text("Ball ")
                                .font(.caption)
                                .foregroundStyle(legend_color)
                        
                            Circle()
                                .fill(Color("Gold"))
                                .frame(width: 8, height: 8, alignment: .center)
                            
                            Text("Strike ")
                                .font(.caption2)
                                .foregroundStyle(legend_color)
                            
                            Circle()
                                .fill(Color("Tangerine"))
                                .frame(width: 8, height: 8, alignment: .center)
                            
                            Text("Hit ")
                                .font(.caption2)
                                .foregroundStyle(legend_color)
                        
                            Circle()
                                .fill(Color("Grey"))
                                .frame(width: 8, height: 8, alignment: .center)
                            
                            Text("Out ")
                                .font(.caption2)
                                .foregroundStyle(legend_color)
                            
                            Circle()
                                //.fill(Color("Grey"))
                                .stroke(.white, lineWidth: 2)
                                .frame(width: 8, height: 8, alignment: .center)
                            
                            Text("Strikeout ")
                                .font(.caption2)
                                .foregroundStyle(legend_color)
                            
                            Spacer()
                            
                        }
                        .padding(.bottom, view_padding)


                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    .padding(.bottom, view_padding)
                    .padding(.leading, view_padding)
                    .padding(.trailing, view_padding)
                }
                
                Spacer()
                
                VStack{
                    VStack{
                        HStack{
                            Text("Game Score")
                                .font(.subheadline)
                                .foregroundStyle(text_color)
                            
                            Spacer()
                        }
                        .padding(.leading, view_padding)
                        .padding(.top, view_padding - 3)
                        VStack{
                            HStack{
                                Text("\(game_report.game_score)")
                                    .font(.system(size: 40))
                                    .foregroundStyle(text_color)
                                    .padding(.horizontal, view_padding)
                                    .padding(.bottom, -20)
                                    .bold()
                                
                                Spacer()
                            }
                            
                            //Spacer()
                            
                            VStack{
                                Gauge(value: Double(game_report.game_score) * 0.01) {
                                    Text("Game Score")
                                        .foregroundStyle(text_color)
                                }
                                .gaugeStyle(.accessoryLinear)
                                .tint(gradient)
                                .frame(height: 10)
                            }
                            .padding(view_padding)
                        }

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    .padding(.leading, view_padding)
                    .padding(.trailing, view_padding)
                    HStack{
                        Text("*")
                            .baselineOffset(3.0)
                            .foregroundStyle(.gray)
                            .font(.system(size: 10))
                        
                        + Text("Calculated using Tango's formula without runs, with extra weight placed on XBHs")
                            .foregroundStyle(.gray)
                            .font(.system(size: 10))
                        
                        Spacer()
                        
                    }
                    .padding(.top, view_padding * -0.8)
                    .padding(.bottom, view_padding)
                    .padding(.leading, view_padding * 1.8)
                    .padding(.trailing, view_padding)
                    
                }
                
                Spacer()
                
                HStack{
                    VStack{
                        HStack{
                            Text("Pitch Usage by Inning")
                                .font(.subheadline)
                                .foregroundStyle(text_color)
                                .padding(.leading, view_padding)
                                .padding(.top, view_padding)
                            
                            Spacer()
                        }
                        
                        VStack{
                            Chart{
                                ForEach(game_report.pitches_by_inn) { pit_dataset in
                                    ForEach(Array(pit_dataset.dataset.enumerated()), id: \.offset){ index, value in
                                        LineMark(x: .value("Inning", index + 1),
                                                 y: .value("# of Pitches", value))
                                        PointMark(x: .value("Inning", index + 1),
                                                 y: .value("# of Pitches", value))
                                    }
                                    .foregroundStyle(by: .value("Pitch Type", pit_dataset.name))
                                }
                            }
                            .chartForegroundStyleScale([
//                                ForEach(Array(current_pitcher.arsenal.enumerated()), id: \.offset) { index in
//                                    if current_pitcher.arsenal[index] != "None" {
//                                        current_pitcher.arsenal[index]: colorset[index]
//                                    }
//                                }
                                current_pitcher.pitch1: Color("PowderBlue"), current_pitcher.pitch2: Color("Gold"), current_pitcher.pitch3: Color("Tangerine"), current_pitcher.pitch4: Color("Grey")
                            ])
                           .frame(height: 200)
                           .padding(.horizontal, view_padding)
                           .padding(.top, view_padding)
                           .chartLegend(.hidden)
                           //.chartLegend(position: .bottom, alignment: .center, spacing: 10)
                           .chartXScale(domain: [0, game_report.p1_by_inn.count + 1])
                            .chartXAxis {
                                AxisMarks(values: .automatic(desiredCount: game_report.p1_by_inn.count + 1)){
                                    
                                    AxisValueLabel()
                                        .foregroundStyle(legend_color)
                                    
                                    AxisGridLine()
                                        .foregroundStyle(legend_color)
                                }
                            }
                            .chartYAxis {
                                AxisMarks(position: .leading) {
                                    
                                    AxisValueLabel()
                                        .foregroundStyle(legend_color)
                                    
                                    AxisGridLine()
                                        .foregroundStyle(legend_color)
                                    
                                }
                            }
                            
                            HStack(spacing: 5){
                                
                                Spacer()
                                
                                Circle()
                                    .fill(Color("PowderBlue"))
                                    .frame(width: 8, height: 8, alignment: .center)
                                                            
                                Text(current_pitcher.pitch1 + " ")
                                    .font(.caption)
                                    .foregroundStyle(legend_color)
                            
                                if current_pitcher.pitch2 != "None" {
                                    Circle()
                                        .fill(Color("Gold"))
                                        .frame(width: 8, height: 8, alignment: .center)
                                    
                                    Text(current_pitcher.pitch2 + " ")
                                        .font(.caption2)
                                        .foregroundStyle(legend_color)
                                }
                                
                                if current_pitcher.pitch3 != "None" {
                                    Circle()
                                        .fill(Color("Tangerine"))
                                        .frame(width: 8, height: 8, alignment: .center)
                                    
                                    Text(current_pitcher.pitch3 + " ")
                                        .font(.caption2)
                                        .foregroundStyle(legend_color)
                                }
                                
                                if current_pitcher.pitch4 != "None" {
                                    Circle()
                                        .fill(Color("Grey"))
                                        .frame(width: 8, height: 8, alignment: .center)
                                    
                                    Text(current_pitcher.pitch4 + " ")
                                        .font(.caption2)
                                        .foregroundStyle(legend_color)
                                }
                            
                                Spacer()
                                
                            }
                            //.padding(.bottom, view_padding)
                            
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("DarkGrey"))
                    .clipShape(RoundedRectangle(cornerRadius: view_crnr_radius))
                    .padding(.bottom, view_padding)
                    .padding(.leading, view_padding)
                    .padding(.trailing, view_padding)
                }
                
                Spacer()
                
            }
            
            .background(LinearGradient(gradient: background_gradient, startPoint: .top, endPoint: .bottom))
    }
    
    @MainActor
    func render(viewSize: CGSize) -> URL {
        let renderer = ImageRenderer(content: reportView)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M.d.yy"

        let formattedDate = dateFormatter.string(from: Date())

        //print("Formatted date: \(formattedDate)")
        
        let path_string = current_pitcher.firstName + current_pitcher.lastName + formattedDate + ".pdf"
        
        let url = URL.documentsDirectory.appending(path: path_string)
        
        renderer.render { size, context in
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }
            
            pdf.beginPDFPage(nil)
            
            context(pdf)
            
            pdf.endPDFPage()
            pdf.closePDF()
        }
        
        return url
        
    }
    
    func new_game_func() {
        
        do {
            try context.delete(model: Event.self)
        } catch {
            print("Failed to delete all events.")
        }
        
        scoreboard.balls = 0
        scoreboard.strikes = 0
        scoreboard.outs = 0
        scoreboard.pitches = 0
        scoreboard.atbats = 1
        scoreboard.inning = 1
        scoreboard.baserunners = 0
        
        ptconfig.pitch_x_loc.removeAll()
        ptconfig.pitch_y_loc.removeAll()
        ptconfig.ab_pitch_color.removeAll()
        ptconfig.pitch_cur_ab = 0
        
        scoreboard.b1light = false
        scoreboard.b2light = false
        scoreboard.b3light = false
        
        scoreboard.s1light = false
        scoreboard.s2light = false
        
        scoreboard.o1light = false
        scoreboard.o2light = false
        
        game_report.batters_faced = 0
        game_report.strikes = 0
        game_report.balls = 0
        game_report.hits = 0
        game_report.strikeouts = 0
        game_report.walks = 0
        
        game_report.first_pitch_strike = 0
        game_report.first_pitch_ball = 0
        game_report.first_pit_strike_per = 0
        game_report.fpb_to_fps = []
        
        game_report.strikes_per = 0
        game_report.balls_to_strikes = []
        
        game_report.game_score = 40
        game_report.pitches = scoreboard.pitches
        
        game_report.p1_by_inn = [0]
        game_report.p2_by_inn = [0]
        game_report.p3_by_inn = [0]
        game_report.p4_by_inn = [0]
        
        game_report.x_coordinate_list = []
        game_report.y_coordinate_list = []
        game_report.pl_color_list = []
        game_report.pl_outline_list = []
        
    }
    
}

#Preview {
    GameReportView()
}
