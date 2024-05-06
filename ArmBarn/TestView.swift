//
//  TestView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 1/7/24.
//

import SwiftUI
import SwiftData
import Charts
import Observation

struct TestView: View {
    
    @AppStorage("VelocityInput") var ASVeloInput : Bool?
    
    @Environment(Scoreboard.self) var scoreboard
    @Environment(PitchTypeConfig.self) var ptconfig
    @Environment(currentPitcher.self) var current_pitcher
    @Query var events: [Event]
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    @Environment(Event_String.self) var event
    
    @Environment(GameReport.self) var game_report
    
    @Environment(\.dismiss) var dismiss
    
    @State var pitch_num: Int = 0
    @State var result: String = ""
    @State var prev_inn: Int = 0
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    let gradient = Gradient(colors: [.yellow, .orange, .red])
    
    var view_padding: CGFloat = 10
    var view_crnr_radius: CGFloat = 12
    
    let columns = [
        GridItem(.flexible(minimum: 0, maximum: 10000))
    ]
    
    var body: some View {
        
        ScrollView{
            VStack{
                Grid(alignment: .leading, horizontalSpacing: 3, verticalSpacing: 10){
                    ForEach(Array(game_report.pbp_event_list.enumerated()), id: \.offset){ index, evnt in
                        
                        if index == 0 || game_report.pbp_event_list[index].inning > game_report.pbp_event_list[index - 1].inning{
                            Text("INN \(evnt.inning)")
                                .bold()
                                .padding(.top, 20)
                                .padding(.bottom, -10)
                                
                            
                            Divider()
                                .background(Color.black)
                                .frame(height: 10)
                                .padding(.bottom, -4)
                        }
                        
                        if index == 0 || game_report.pbp_event_list[index].pitcher != game_report.pbp_event_list[index - 1].pitcher{
                            HStack{
                                Spacer()
                                Text(evnt.pitcher + " Entered")
                                    .padding(.vertical, 5)
                                    .foregroundStyle(Color.green.opacity(2))
                                Spacer()
                            }
                            .background(Color.green.opacity(0.1))
                            
                            Divider()
                        }
                        
                        if evnt.result == "RUNNER OUT" {
                            HStack{
                                Spacer()
                                Text("Baserunner Out")
                                    .padding(.vertical, 5)
                                    .foregroundStyle(Color.red.opacity(2))
                                Spacer()
                            }
                            .background(Color.red.opacity(0.1))
                            
                            Divider()
                                .background((event.end_ab_rd.contains(evnt.result_detail)) ? Color.black : Color.clear)
                        }
                        else {
                            GridRow{
                                Text("\(evnt.pitch_num)")
                                Text(evnt.pitch_type)
                                
                                if ASVeloInput == true {
                                    Text("\(evnt.velo, specifier: "%.1f")")
                                }
                                
                                Text(evnt.result)
                                Text("\(evnt.balls) - \(evnt.strikes)")
                                Text("\(evnt.outs) " + evnt.out_label)
                            }
                            
                            Divider()
                                .background((event.end_ab_rd.contains(evnt.result_detail)) ? Color.black : Color.clear)
                        }
                        
                    }
                }
            }
            .padding(15)
        }
    }
}

#Preview {
    TestView()
}
