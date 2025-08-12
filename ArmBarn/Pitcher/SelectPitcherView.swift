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
    @Environment(Scoreboard.self) var scoreboard
    @Environment(Event_String.self) var event
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    @Query(sort: \Event.event_number) var events: [Event]
    
    @State private var edit_pitcher: Pitcher?
    private let editpitchertip = EditPitcherTip()
    
    @State private var searchText = ""
    
    @State private var showAddPitcher = false
    @State private var showEditPitcher = false
    @State private var selected_pitcher_id = UUID()
    @State private var newAtBat = false
    
    @State private var text_color = Color.white
    
    @State var sbl_width: Double = 17.0
    @State var sbl_height: Double = 13.0
    
    @State var font_size: CGFloat = 20.0
    
    @State var pitcher_select_haptic: Bool = false
    
    var filteredPitchers: [Pitcher] {
        guard !searchText.isEmpty else {return pitchers}
        return pitchers.filter {$0.lastName.localizedCaseInsensitiveContains(searchText) || $0.firstName.localizedCaseInsensitiveContains(searchText)}
    }
    
    @State var button_gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color("ScoreboardGreen"), Color("DarkScoreboardGreen")]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    var body: some View {
            
            ZStack{
                
                VStack(alignment: .leading, spacing: 5){
                    
                    NavigationView{ //Will be depreciated, bug with displaying title and NavigationStack
                        
                        List{
                            
                            TipView(editpitchertip)
                            
                            ForEach(filteredPitchers, id:\.id) { p_er in
                                HStack{
                                    
                                    Button{
                                        
                                        //Conditional Logic for calling pitcher re-entry popup
                                        //if !scoreboard.pitchers_appearance_list.contains(where: {$0.pitcher_id == p_er.id}) {
                                            
                                            pitcher_select_haptic.toggle()
                                            
                                            if p_er.id != current_pitcher.idcode {
                                                store_pitcher_appearance()
                                                current_pitcher.pitch_num = 0
                                                current_pitcher.firstName = p_er.firstName
                                                current_pitcher.lastName = p_er.lastName
                                                current_pitcher.idcode = p_er.id
                                                selected_pitcher_id = p_er.id
                                                
                                                current_pitcher.pitch1 = p_er.pitch1
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
                                            
                                        
                                        
//                                        else {
//                                            
//                                            showNoReEntry = true
//                                            
//                                        }
                                        
                                        
                                        
                                    } label: {
                                        HStack(spacing: 15){
                                            
                                            Circle()
                                                .fill(Color.clear)
                                                .stroke(selected_pitcher_id == p_er.id ? Color("ScoreboardGreen") : Color.white, lineWidth: selected_pitcher_id == p_er.id ? 3 : 2)
                                                .frame(width: 35, height: 35)
                                                .overlay{
                                                    HStack(spacing: 0){
                                                        if p_er.throwingHand == "Left" {
                                                            Image(systemName: "arrowtriangle.left.fill")
                                                                .scaleEffect(x: 0.6)
                                                                .bold()
                                                                .font(.system(size: 8))
                                                        }
                                                        Text(p_er.firstName.prefix(1))
                                                            .bold()
                                                            .font(.system(size: 13))
                                                        Text(p_er.lastName.prefix(1))
                                                            .bold()
                                                            .font(.system(size: 13))
                                                        if p_er.throwingHand == "Right" {
                                                            Image(systemName: "arrowtriangle.right.fill")
                                                                .scaleEffect(x: 0.6)
                                                                .bold()
                                                                .font(.system(size: 8))
                                                        }
                                                        
                                                    }
                                                }
                                            
                                            VStack(alignment: .leading, spacing: 2){
                                                Text(p_er.firstName + " " + p_er.lastName)
                                                    .bold()
                                                    .font(.system(size: 17))
                                                HStack(spacing: 0){
                                                    Text("Pitches: ")
                                                    Text(p_er.pitch1)
                                                    if p_er.pitch2 != "None" {
                                                        Text(", " + p_er.pitch2)
                                                    }
                                                    if p_er.pitch3 != "None" {
                                                        Text(", " + p_er.pitch3)
                                                    }
                                                    if p_er.pitch4 != "None" {
                                                        Text(", " + p_er.pitch4)
                                                    }
                                                }
                                                .font(.system(size: 11))
                                                .foregroundStyle(.gray)
                                            }
                                            
                                            Spacer()
                                            
                                        }
                                        .frame(height: 40)
                                    }
                                }
                                .sensoryFeedback(.selection, trigger: pitcher_select_haptic)
                                .foregroundColor(text_color)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    
                                    Button(role: .destructive) {
                                        //store.delete(message)
                                        context.delete(p_er)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(Color.red)
                                    
                                    
                                    Button {
                                        showEditPitcher = true
                                        edit_pitcher = p_er
                                    } label: {
                                        Text("Edit")
                                    }
                                    .tint(Color.orange)
                                    
                                }
                            }
                            //.onDelete(perform: removePitcher)
                            
                        }
                        .navigationBarTitleDisplayMode(.automatic)
                        .navigationTitle("Select Pitcher")
                        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode:.always), prompt: "Search Pitchers")
                        .toolbar{
                            
                            ToolbarItemGroup(placement: .topBarTrailing) {
                                
                                Button(action: {
                                    showAddPitcher = true
                                }, label: {
                                    
                                    Image(systemName: "person.fill.badge.plus")
                                        .foregroundStyle(Color("ScoreboardGreen"), .white)
                                        .font(.system(size: 21))
                                                
                                })
                            }
                        }
                        .sheet(item: $edit_pitcher) { edit in
                            EditPitcherView(edit_pitcher: edit)
                                .preferredColorScheme(.dark)
//                                .background(Color.black.opacity(0.5))
                                .ignoresSafeArea()
                        }
                        .sheet(isPresented: $showAddPitcher) {
                            AddPitcherView()
                                .preferredColorScheme(.dark)
//                                .background(Color.black.opacity(0.5))
                                .ignoresSafeArea()
                        }
                    }
                    
                }
                
            }
            .onAppear(){
                if pitchers.count == 0 {
                    showAddPitcher = true
                }
                
                //Set selected id to current pitcher id, allows for selection of same pitcher upon new game
                selected_pitcher_id = current_pitcher.idcode
                
                UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
                //print("Select Pitchers View")
                //print("Appearance List: ", scoreboard.pitchers_appearance_list)
                //print("Current Pitcher: ", current_pitcher.firstName, current_pitcher.idcode)
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
        //print(appeared)
    }
    
    func store_pitcher_appearance() {
        //Store appearance on change
        //Removes old data if reselected
        
        if !scoreboard.pitchers_appearance_list.contains(where: { $0.pitcher_id == current_pitcher.idcode }) && scoreboard.pitches > 0{
            
            scoreboard.pitchers_appearance_list.append(PitchersAppeared(pitcher_id: current_pitcher.idcode, pitches: scoreboard.pitches, batters_faced: scoreboard.atbats))
            
        }
        
//        for pitcher in scoreboard.pitchers_appearance_list {
//            if pitcher.pitcher_id == current_pitcher.idcode {
//
//                scoreboard.pitchers_appearance_list = scoreboard.pitchers_appearance_list.filter(){ $0.pitcher_id != current_pitcher.idcode}
//
//            }
//        }
        
//        if scoreboard.pitches > 0 {
//            //print("Adding Selected Pitcher")
//
//        }
        
//        print("Appearance List:", scoreboard.pitchers_appearance_list)
        
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
    
    @FocusState private var fieldIsFocused: Bool
    
    let pitch_types = ["None", "Fastball", "Curveball", "Slider", "Change-Up", "Splitter", "Cutter", "Sinker", "Other"]
    
    @State private var selected_pitcher_hand = "Right"
    let pitcher_hand_list = ["Right", "Left"]
    
    @State var button_gradient: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color("ScoreboardGreen"), Color("DarkScoreboardGreen")]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    var body: some View {
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        
        VStack(alignment: .leading, spacing: 0){
            
            VStack(alignment: .leading){
                
                Button(action: {
                    dismiss()
                }, label: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 25, height: 25)
                        .overlay{
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 13))
                                .bold()
                        }
                        .padding(.leading, 10)
                        .padding(.top, 10)
                })
                
                Text("Edit Pitcher")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                    .padding(.top, 10)
                
            }
            
            Form{
                Section(header: Text("Player Name")){
                    TextField("First Name", text: $edit_pitcher.firstName)
                        .focused($fieldIsFocused)
                        .tint(Color("ScoreboardGreen"))
                    
                    TextField("Last Name", text: $edit_pitcher.lastName)
                        .focused($fieldIsFocused)
                        .tint(Color("ScoreboardGreen"))
                    
                    Picker("Velocity Units", selection: $edit_pitcher.throwingHand) {
                        ForEach(pitcher_hand_list, id: \.self) {
                            Text($0)
                                .bold()
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: edit_pitcher.throwingHand){
                        impact.impactOccurred()
                        fieldIsFocused = false
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
                    .onChange(of: edit_pitcher.pitch1){
                        fieldIsFocused = false
                    }
                    Picker("Pitch 2", selection: $edit_pitcher.pitch2){
                        ForEach(pitch_types, id: \.self){
                            Text($0)
                        }
                    }
                    .onChange(of: edit_pitcher.pitch1){
                        fieldIsFocused = false
                    }
                    Picker("Pitch 3", selection: $edit_pitcher.pitch3){
                        ForEach(pitch_types, id: \.self){
                            Text($0)
                        }
                    }
                    .onChange(of: edit_pitcher.pitch1){
                        fieldIsFocused = false
                    }
                    Picker("Pitch 4", selection: $edit_pitcher.pitch4){
                        ForEach(pitch_types, id: \.self){
                            Text($0)
                        }
                    }
                    .onChange(of: edit_pitcher.pitch1){
                        fieldIsFocused = false
                    }
                }
                Button("Save") {
                    dismiss()
                }
                .bold()
                .foregroundStyle(.white)
                .listRowBackground(button_gradient)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            }
            .scrollContentBackground(.hidden)
            
        }
        //.frame(width: 400, height: 400)
    }
}

