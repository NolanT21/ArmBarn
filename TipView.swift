//
//  TipView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 5/3/24.
//

import SwiftUI
import TipKit

struct SelectPitcherTip: Tip {
    
    var options: [TipOption] {
        [Tips.MaxDisplayCount(1)]
    }
    
    var title: Text {
        Text("Select Pitcher")
    }
    
    var message: Text? {
        Text("Tap on the current pitcher's last name to change pitcher.")
    }
    
    var image: Image? {
        Image(systemName: "person.crop.circle")
    }
    

    
}

struct AddPitcherTip: Tip {
    var title: Text {
        Text("Add Pitcher")
    }
    
    var message: Text {
        Text("Tap on the plus symbol to add a new pitcher")
    }
    
    var image: Image? {
        Image(systemName: "person.crop.circle.badge.plus")
    }
}

struct EditPitcherTip: Tip {
    var title: Text {
        Text("Edit Pitcher")
    }
    
    var message: Text? {
        Text("Swipe right/left to edit or delete a pitcher")
    }
}

struct ChangeInputTip: Tip {
    var title: Text {
        Text("Changing Input")
    }
    
    var message: Text? {
        Text("To change input options, start a new game")
    }
}

struct ExportPDFTip: Tip {
    var title: Text {
        Text("Export PDF")
    }
    
    var message: Text? {
        Text("Tap here to export the active report as a PDF")
    }
    
    var image: Image? {
        Image(systemName: "chart.bar.doc.horizontal")
    }
}

struct LocationInputTip: Tip {
    
    static let locationInput = Event(id: "locationInput")
    
    var title: Text {
        Text("Location Input")
    }
    
    var message: Text? {
        Text("Tap once to set location, tap again on the circle to enter that location. After the first tap, the location can be change by tapping somewhere else")
    }
    
    var image: Image? {
        Image(systemName: "hand.tap")
    }
    
    var rules: [Rule] {
        #Rule(Self.locationInput) { loc_input in
            loc_input.donations.count == 1
        }
    }
    
}


//struct ScoreboardInfoTip: Tip {
//    var title: Text {
//        Text("Scoreboard Buttons")
//    }
//
//    var message: Text {
//        Text("View stats, start a new game, or change options with this group of three buttons")
//    }
//
//    var image: Image? {
//        Image(systemName: "info.circle")
//    }
//}
