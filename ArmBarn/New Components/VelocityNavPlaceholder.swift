//
//  VeloInputPopUp.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 4/28/25.
//

import SwiftUI

struct VelocityNavPlaceholder: View {
    
    @Binding var path: [Int]
    
    @Environment(Event_String.self) var event
    @Environment(LocationOverlay.self) var location_overlay
    
    @State private var show_velo_input: Bool = false
    @FocusState private var fieldIsFocused: Bool
    @State var veloinput: Double = 0.0
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var body: some View {
        
        VStack{
            if location_overlay.showVeloInput == false {
                PitchResultMKIIView(path: $path)
            }
        }
        .onAppear {
            //fieldIsFocused = true
            withAnimation{
                location_overlay.showVeloInput = true
            }
        }
    }
}

//#Preview {
//    VelocityNavPlaceholder()
//}
