//
//  LoginDenyPopUp.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 8/2/25.
//

import SwiftUI
import CoreHaptics

struct AuthDenyPopUp: View {
    
    //@State var result: Result<Void, Error>
    
    @State var error: String
    
    @State var close_action: () -> ()
    
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        ZStack{
            
            Color.black.opacity(0.5)
            
            VStack{
                
                HStack{
                    
                    Text("Login Failed")
                        .font(.system(size: 17, weight: .semibold))
                    
                }
                
                HStack{
                    
                    Text(error)
                        .font(.system(size: 14, weight: .regular))
                    
                }
                .padding(.top, 3)
                
                VStack{
                    
                    Image(systemName: "xmark.circle")
                        .foregroundStyle(.red)
                        .font(.system(size: 42, weight: .medium))
                        .imageScale(.large)
                    
                }
                .frame(width: 150, height: 70)
                
            }
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .padding()
            .background(Color.black.opacity(0.2))
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 20)
            .overlay{
                VStack{
                    
                    HStack{
                        
                        Button {
                            close_action()
                        } label: {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                //.background(.ultraThinMaterial)
                                .frame(width: 20, height: 20)
                                .overlay{
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                        .font(.system(size: 11).bold())
                                        //.padding(5)
                                }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 10)
                        
                        Spacer()
                        
                    }
                    
                    Spacer()
                    
                }
            }
            .offset(x: 0, y: -120)
        }
        .ignoresSafeArea(.all)
        .onAppear{
            
            prepareHaptics()
            warningHaptic()
            
        }
    }
    
    func warningHaptic() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var hap_events = [CHHapticEvent]()

        // create one intense, sharp tap
        let start_intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 2)
        let start_sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 2)
        let start = CHHapticEvent(eventType: .hapticTransient, parameters: [start_intensity, start_sharpness], relativeTime: 0)
        hap_events.append(start)
        
        let end_intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let end_sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let end = CHHapticEvent(eventType: .hapticTransient, parameters: [end_intensity, end_sharpness], relativeTime: 0.2)
        hap_events.append(end)

        // convert those events into a pattern and play it immediately
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
//    LoginDenyPopUp()
//}
