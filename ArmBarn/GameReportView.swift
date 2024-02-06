//
//  GameReportView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 2/4/24.
//

import SwiftUI

struct GameReportView: View {
    
    var group_padding: CGFloat = 12
    var group_crnr_radius: CGFloat = 12
    
    var body: some View {
        VStack{
            Text("Game Summary")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, group_padding)
            
            HStack{
                
                Spacer()
                
                VStack{
                    
                    HStack{
                        Text("Box Score")
                            .font(.subheadline)
                        Spacer()
                    }
                    
                    HStack{
                        
                        VStack{
                            Text("IP")
                            Text("9.0")
                        }
                        
                        Spacer()
                        
                        VStack{
                            Text("Pit")
                            Text("72")
                        }
                        
                        Spacer()
                        
                        VStack{
                            Text("BF")
                            Text("20")
                        }
                        
                        Spacer()
                        
                        VStack{
                            Text("H")
                            Text("4")
                        }
                        
                        Spacer()
                        
                        VStack{
                            Text("SO")
                            Text("7")
                        }
                        
                        Spacer()
                        
                        VStack{
                            Text("BB")
                            Text("2")
                        }
                        
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: group_crnr_radius))
                
                Spacer()
                
            }
            
            Spacer()
                .frame(height: group_padding)
            
            HStack{
                
                Spacer()
                    .frame(width: group_padding)
                
                VStack{
                    Text("1st Pit. Strike")
                        .font(.subheadline)
                        .padding(group_padding)
                    Text("")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: group_crnr_radius))
                VStack{
                    Text("Strike %")
                        .font(.subheadline)
                        .padding(group_padding)
                    Text("")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: group_crnr_radius))
                
                Spacer()
                    .frame(width:group_padding)
                
            }
            
            Spacer()
                .frame(height:group_padding)
            
            HStack{
                
                Spacer()
                    .frame(width:group_padding)
                
                VStack{
                    Text("Game Score")
                        .font(.subheadline)
                        .padding(group_padding)
                    Text("")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: group_crnr_radius))
                
                Spacer()
                    .frame(width:group_padding)
                
            }
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
        
    
//        List{
//            Section(header: Text("Box Score")) {

//            }
//        }
//        .navigationTitle("Game Summary")
//        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    GameReportView()
}
