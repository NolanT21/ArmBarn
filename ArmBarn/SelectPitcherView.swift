//
//  SelectPitcherView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 1/23/24.
//

import SwiftUI
import SwiftData

struct SelectPitcherView: View {
    
    @Environment(currentPitcher.self) var current_pitcher
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) private var context
    
    @Query(sort: \Pitcher.lastName) var pitchers: [Pitcher]
    
    @State private var searchText = ""
    
    @State private var showAddPitcher = false
    @State private var showEditPitcher = false
    
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
                        ForEach(filteredPitchers, id:\.id) { p_er in
                            Button(p_er.firstName + " " + p_er.lastName) {
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
                                dismiss()
                            }
                            .foregroundColor(text_color)
                            .swipeActions(edge: .leading) {
                                Button(action: {
                                    showEditPitcher = true
                                }, label: {
                                    Text("Edit")
                                })
                            }
                        }
                        .onDelete(perform: removePitcher)
        //                .popover(isPresented: $showEditPitcher) {
        //                    EditPitcherView()
        //                }
                    }
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by Last Name")
                    .toolbar{
                        
                        ToolbarItemGroup(placement: .topBarLeading) {
                            
                            Button(action: {
                                dismiss()
                            }, label: {
                                Image(systemName: "chevron.left")
                                    .imageScale(.medium)
                                    .frame(width: sbl_width, height: sbl_height)
                                    .foregroundColor(text_color)
                                    .bold()
                                Text("Back")
                                    //.font(.system(size: font_size))
                                    //.fontWeight(.heavy)
                                    .foregroundColor(text_color)
                            })
                        }
                        
                        ToolbarItemGroup(placement: .principal) {
                            Text("Select Pitcher")
                                //.font(.system(size: font_size))
                                //.fontWeight(.heavy)
                                .foregroundColor(text_color)
                        }
                        
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            
                            Button(action: {
                                showAddPitcher = true
                            }, label: {
                                Image(systemName: "plus")
                                    .imageScale(.medium)
                                    .foregroundColor(text_color)
                                    .bold()
                            })
                            .popover(isPresented: $showAddPitcher) {
                                AddPitcherView()
                                    .preferredColorScheme(.dark)
                            }
                        }
                    }
                    //.navigationTitle("Pitchers")
                }
            }
    
    }
    
    func removePitcher(at indexSet: IndexSet) {
        for index in indexSet {
            context.delete(pitchers[index])
        }
    }
}

struct EditPitcherView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Binding var current_pitcher: currentPitcher
    
    let pitch_types = ["None", "Fastball", "Curveball", "Slider", "Change-Up", "Splitter", "Cutter", "Sinker", "Other"]
    
    var body: some View {
        VStack{
            Form{
                Section(header: Text("Player Name")){
                    TextField("First Name", text: $current_pitcher.firstName)
                    TextField("Last Name", text: $current_pitcher.lastName)
                }
                Section(header: Text("Pitch Arsenal")){
                    Picker("Pitch 1", selection: $current_pitcher.pitch1){
                        ForEach(pitch_types, id: \.self){
                            Text($0)
                        }
                    }
                    Picker("Pitch 2", selection: $current_pitcher.pitch2){
                        ForEach(pitch_types, id: \.self){
                            Text($0)
                        }
                    }
                    Picker("Pitch 3", selection: $current_pitcher.pitch3){
                        ForEach(pitch_types, id: \.self){
                            Text($0)
                        }
                    }
                    Picker("Pitch 4", selection: $current_pitcher.pitch4){
                        ForEach(pitch_types, id: \.self){
                            Text($0)
                        }
                    }
                }
                Button("Save") {
                    //let pitcher = Pitcher(firstName: firstName, lastName: lastName, pitch1: pitch1, pitch2: pitch2, pitch3: pitch3, pitch4: pitch4)
                    //context.insert(pitcher)
                    dismiss()
                }
            }
            .foregroundColor(.black)
            .background(.green)
            .tint(.gray)
        }
        //.frame(width: 400, height: 400)
    }
}

#Preview {
    SelectPitcherView()
}
