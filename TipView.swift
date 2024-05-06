//
//  TipView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 5/3/24.
//

import SwiftUI
import TipKit

struct EditPitcherTip: Tip {
    var title: Text {
        Text("Edit Pitcher")
    }
    
    var message: Text? {
        Text("Swipe right or left to edit or delete a pitcher")
    }
}


