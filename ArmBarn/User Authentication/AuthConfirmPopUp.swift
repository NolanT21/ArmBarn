//
//  LoginConfirmPopUp.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 8/2/25.
//

import SwiftUI
import CoreHaptics

struct AuthConfirmPopUp: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var result: Result<Void, Error>
    
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        ZStack{
            
            Color.black.opacity(0.5)
            
            VStack{
                
                HStack{
                    
                    Text("Login Successful")
                        .font(.system(size: 17, weight: .semibold))
                    
                }
                .padding(.bottom, 5)
                
                VStack{
                    
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(.green)
                        .font(.system(size: 42, weight: .medium))
                        .imageScale(.large)
                    
                }
                .frame(width: 70, height: 70)
                
            }
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .padding(25)
            .background(Color.black.opacity(0.2))
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 20)
            .offset(x: 0, y: -120)
        }
        .ignoresSafeArea(.all)
        .onAppear{
            
            prepareHaptics()
            successHaptic()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                dismiss()
            }
        }
    }
    
    func successHaptic() {
        // Make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var hap_events = [CHHapticEvent]()

        let start_intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let start_sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let start = CHHapticEvent(eventType: .hapticTransient, parameters: [start_intensity, start_sharpness], relativeTime: 0)
        hap_events.append(start)
        
        let end_intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 2)
        let end_sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 2)
        let end = CHHapticEvent(eventType: .hapticTransient, parameters: [end_intensity, end_sharpness], relativeTime: 0.2)
        hap_events.append(end)

        do {
            let pattern = try CHHapticPattern(events: hap_events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
}

//#Preview {
//    LoginConfirmPopUp()
//}
