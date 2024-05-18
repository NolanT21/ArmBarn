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
    @AppStorage("VelocityUnits") var ASVeloUnits : String?
    
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
    
    var text_color: Color = .white
    
    let gradient = Gradient(colors: [.yellow, .orange, .red])
    
    var colorset = [Color("PowderBlue"), Color("Gold"), Color("Tangerine"), Color("Grey")]
    
    var view_padding: CGFloat = 10
    var view_crnr_radius: CGFloat = 12
    
    let columns = [
        GridItem(.flexible(minimum: 0, maximum: 10000))
    ]
    
    var body: some View {
        
        ScrollView{
            VStack{
                
                Spacer()
                
                HStack{
                    
                    VStack(alignment: .trailing){
                        
                        Text("ArmBarn")
                            .font(.title)
                        
                        Text("ArmBarn")
                            .font(.headline)
                        
                        Text("ArmBarn")
                        
                        Text("ArmBarn")
                            .font(.body)
                        
                        Text("ArmBarn")
                            .font(.callout)
                        
                        Text("ArmBarn")
                            .font(.subheadline)
                        
                        Text("ArmBarn")
                            .font(.caption)
                        
                        Text("ArmBarn")
                            .font(.caption2)

                    }
                    
                    VStack(alignment: .leading, spacing: 2){
                        
                        Text("ArmBarn")
                            .font(.system(size: 28))
                        
                        Text("ArmBarn")
                            .font(.system(size: 17))
                            .bold()
                        
                        Text("ArmBarn")
                            .font(.system(size: 17))
                        
                        Text("ArmBarn")
                            .font(.system(size: 17))
                        
                        Text("ArmBarn")
                            .font(.system(size: 16))
                        
                        Text("ArmBarn")
                            .font(.system(size: 15))
                        
                        Text("ArmBarn")
                            .font(.system(size: 12))
                        
                        Text("ArmBarn")
                            .font(.system(size: 11))
                        
                    }
                    
                }

                
                Spacer()
                
            }
            .background(.black)
            
        }
    }
}

#Preview {
    TestView()
}
