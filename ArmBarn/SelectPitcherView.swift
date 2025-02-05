//
//  SelectPitcherView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 1/23/24.
//

import SwiftUI
import SwiftData
import TipKit

struct SelectPitcherView: View {
    
    @Environment(currentPitcher.self) var current_pitcher
    @Environment(GameReport.self) var game_report
    @Environment(Scoreboard.self) var scoreboard
    @Environment(Event_String.self) var event
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    @Query(sort: \Event.event_number) var events: [Event]
    
    @State private var edit_pitcher: Pitcher?
    
    @State private var searchText = ""
    
    @State private var showAddPitcher = false
    @State private var showEditPitcher = false
    @State private var newAtBat = false
    
    private let editpitchertip = EditPitcherTip()
    
    @State private var text_color = Color.white
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    @State var font_size: CGFloat = 20.0
    
    var filteredPitchers: [Pitcher] {
        guard !searchText.isEmpty else {return pitchers}
        return pitchers.filter {$0.lastName.localizedCaseInsensitiveContains(searchText)}
    }

    var body: some View {
            
            ZStack{
                NavigationStack{
                    List {
                        Section() {
                            TipView(editpitchertip)
                        }
                        
                        ForEach(filteredPitchers, id:\.id) { p_er in
                            Button(p_er.firstName + " " + p_er.lastName) {
                                if p_er.id != current_pitcher.idcode {
                                    store_pitcher_appearance()
                                    clear_game_report()
                                    current_pitcher.pitch_num = 0
                                    current_pitcher.firstName = p_er.firstName
                                    current_pitcher.lastName = p_er.lastName
                                    current_pitcher.pitch1 = p_er.pitch1
                                    current_pitcher.idcode = p_er.id
                                    if current_pitcher.pitch1 != "None" {
                                        current_pitcher.pitch_num += 1
                                        current_pitcher.arsenal[0] = p_er.pitch1
                                    }
                                    current_pitcher.pitch2 = p_er.pitch2
                                    
                                    if current_pitcher.pitch2 != "None" {
                                        current_pitcher.pitch_num += 1
                                        current_pitcher.arsenal[1] = p_er.pitch2
                                    }
                                    current_pitcher.pitch3 = p_er.pitch3
                                    
                                    if current_pitcher.pitch3 != "None" {
                                        current_pitcher.pitch_num += 1
                                        current_pitcher.arsenal[2] = p_er.pitch3
                                    }
                                    current_pitcher.pitch4 = p_er.pitch4
                                    
                                    if current_pitcher.pitch4 != "None" {
                                        current_pitcher.pitch_num += 1
                                        current_pitcher.arsenal[3] = p_er.pitch4
                                    }
                                    
                                    fetch_pitches_and_abs(pitcher_id: current_pitcher.idcode)
                                }
                                dismiss()
                            }
                            .foregroundColor(text_color)
                            .swipeActions(edge: .leading) {
                                Button(action: {
                                    showEditPitcher = true
                                    edit_pitcher = p_er
                                }, label: {
                                    Text("Edit")
                                })
                            }
                        }
                        .onDelete(perform: removePitcher)
                        
                    }
                    .sheet(item: $edit_pitcher) { edit in
                        EditPitcherView(edit_pitcher: edit)
                            .preferredColorScheme(.dark)
                    }
                    .font(.system(size: 17))
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by Last Name")
                    .toolbar{
                        
                        ToolbarItemGroup(placement: .topBarLeading) {
                            
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
                        }
                        
                        ToolbarItemGroup(placement: .principal) {
                            Text("Select Pitcher")
                                .foregroundColor(text_color)
                                .font(.system(size: 17))
                        }
                        
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            
                            Button(action: {
                                showAddPitcher = true
                            }, label: {
                                Image(systemName: "plus")
                                    .imageScale(.medium)
                                    .font(.system(size: 17))
                                    .foregroundColor(text_color)
                                    .bold()
                            })
                            .popover(isPresented: $showAddPitcher) {
                                AddPitcherView()
                                    .preferredColorScheme(.dark)
                            }
                        }
                    }
                }
            }
            .onAppear(){
                if pitchers.count == 0 {
                    showAddPitcher = true
                }
            }
    }
    
    func removePitcher(at indexSet: IndexSet) {
        for index in indexSet {
            context.delete(pitchers[index])
        }
    }
    
    func fetch_pitches_and_abs(pitcher_id: UUID) {
        
        //Redo to match pitcher ids
        //Reset pitch number and batters faced
        var appeared = false
        
        //print(scoreboard.pitchers_appearance_list)
        
        for pitchers in scoreboard.pitchers_appearance_list {
            //print(pitcher_id)
            if pitchers.pitcher_id == pitcher_id{
                //print("Entered Fetch Pitches and BFs")
                appeared = true
                scoreboard.pitches = pitchers.pitches
                scoreboard.atbats = pitchers.batters_faced
                break
            }
        }
        
        if appeared == false {
            scoreboard.pitches = 0
            scoreboard.atbats = 1
        }
        print(appeared)
        
//        scoreboard.pitches = 0
//        scoreboard.atbats = 1
//        
//        for evnt in events {
//            if pitcher_id == evnt.pitcher_id  {
//                if evnt.result_detail != "R" && evnt.result_detail != "RE" && evnt.pitch_result != "VZ" && evnt.pitch_result != "VA" && evnt.pitch_result != "IW"{
//                    scoreboard.pitches += 1
//                }
//                if event.end_ab_rd.contains(evnt.result_detail) {
//                    scoreboard.atbats += 1
//                }
//            }
//        }
    }
    
    func store_pitcher_appearance() {
        //Store appearance on change
        //Removes old data if reselected
        
        for pitcher in scoreboard.pitchers_appearance_list {
            if pitcher.pitcher_id == current_pitcher.idcode {
                
                scoreboard.pitchers_appearance_list = scoreboard.pitchers_appearance_list.filter(){ $0.pitcher_id != current_pitcher.idcode}
                //break
                
            }
        }
        
        scoreboard.pitchers_appearance_list.append(PitchersAppeared(pitcher_id: current_pitcher.idcode, pitches: scoreboard.pitches, batters_faced: scoreboard.atbats))
    }
    
    func clear_game_report() {
        
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
        game_report.pitches = 0
        
        game_report.singles = 0
        game_report.doubles = 0
        game_report.triples = 0
        game_report.homeruns = 0
        game_report.errors = 0
        game_report.p1_hits = 0
        game_report.p2_hits = 0
        game_report.p3_hits = 0
        game_report.p4_hits = 0
        game_report.most_hit_pit = ""
        game_report.mhp_pitches = 0
        game_report.mhp_hits = 0
        
        game_report.swings = 0
        game_report.swing_per = 0
        game_report.whiffs = 0
        game_report.whiff_per = 0
        
        game_report.p1_velo_list = []
        game_report.p2_velo_list = []
        game_report.p3_velo_list = []
        game_report.p4_velo_list = []
        
        game_report.velo_set_list = []
        
        game_report.rh_batters_faced = 0
        game_report.lh_batters_faced = 0
        game_report.bs_faced_factor = 0
        game_report.rh_hits = 0
        game_report.lh_hits = 0
        game_report.bs_hits_factor = 0
        game_report.rh_xbhs = 0
        game_report.lh_xbhs = 0
        game_report.bs_xbhs_factor = 0
        game_report.rh_strikeouts = 0
        game_report.lh_strikeouts = 0
        game_report.bs_strikeouts_factor = 0
        game_report.rh_walks = 0
        game_report.lh_walks = 0
        game_report.bs_walks_factor = 0
        
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
    SelectPitcherView()
}


struct EditPitcherView: View {
    
    @Environment(currentPitcher.self) var current_pitcher
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Bindable var edit_pitcher: Pitcher
    
    let pitch_types = ["None", "Fastball", "Curveball", "Slider", "Change-Up", "Splitter", "Cutter", "Sinker", "Other"]
    
    @State private var selected_pitcher_hand = "Right"
    let pitcher_hand_list = ["Right", "Left"]
    
    var body: some View {
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        
        VStack{
            Form{
                Section(header: Text("Player Name")){
                    TextField("First Name", text: $edit_pitcher.firstName)
                    
                    TextField("Last Name", text: $edit_pitcher.lastName)
                    
                    Picker("Velocity Units", selection: $edit_pitcher.throwingHand) {
                        ForEach(pitcher_hand_list, id: \.self) {
                            Text($0)
                                .bold()
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: edit_pitcher.throwingHand){
                        impact.impactOccurred()
                        //ASVeloUnits = selected_velo_units
                        //print(selected_velo_units)
                    }
                    
                }
                Section(header: Text("Pitch Arsenal")){
                    Picker("Pitch 1", selection: $edit_pitcher.pitch1){
                        ForEach(pitch_types, id: \.self){
                            Text($0)
                        }
                    }
                    Picker("Pitch 2", selection: $edit_pitcher.pitch2){
                        ForEach(pitch_types, id: \.self){
                            Text($0)
                        }
                    }
                    Picker("Pitch 3", selection: $edit_pitcher.pitch3){
                        ForEach(pitch_types, id: \.self){
                            Text($0)
                        }
                    }
                    Picker("Pitch 4", selection: $edit_pitcher.pitch4){
                        ForEach(pitch_types, id: \.self){
                            Text($0)
                        }
                    }
                }
                Button("Save") {
                    dismiss()
                }
                .bold()
                .foregroundStyle(.white)
                .listRowBackground(Color("ScoreboardGreen"))
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            }
//            .foregroundColor(.black)
//            .background(.green)
//            .tint(.gray)
        }
        //.frame(width: 400, height: 400)
    }
}

