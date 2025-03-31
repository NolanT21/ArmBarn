//
//  TipView.swift
//  ArmBarn
//
//  Created by Nolan Thompson on 5/3/24.
//

import SwiftUI
import TipKit

struct SelectPitcherTip: Tip {
    
    static let showPitcherTip = Event(id: "showPitcherTip")
    
    var title: Text {
        Text("Select Pitcher")
    }
    
    var message: Text? {
        Text("Tap here to choose or add pitchers.")
    }
    
    var image: Image? {
        Image(systemName: "person.crop.circle")
    }
    
    var rules: [Rule] = [
        #Rule(Self.showPitcherTip) {
            $0.donations.count >= 1
        }
    ]
    
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
        Text("Swipe right on a pitcher to edit their information. Swipe left to delete")
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
        Text("Tap once to set location, tap again on the circle to enter that location. After the first tap, the location can be changed by tapping somewhere else")
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

struct ScoreboardInfoTip: Tip {
    var title: Text {
        Text("Scoreboard Buttons")
    }

    var message: Text {
        Text("View stats, start a new game, or change options with this group of three buttons")
    }

    var image: Image? {
        Image(systemName: "info.circle")
    }
}

struct WelcomeTip: Tip {
    var title: Text {
        Text("Welcome To ArmBarn!")
    }
    
    var message: Text? {
        Text("To get started, enter the opposing team's name game location and start time")
    }
    
    var image: Image? {
        Image("ElToro")
    }
    
}

struct WelcomeBullpenTip: Tip {
    var title: Text {
        Text("Bullpen Charting")
    }
    
    var message: Text? {
        Text("After choosing a pitcher, first select the spot of the pitch, then the actual pitch location. A prompt will then ask for the pitch type")
    }
    
    var image: Image? {
        Image("ElToro")
    }
    
}

struct BullpenReportTip: Tip {
    var title: Text {
        Text("View Results")
    }
    
    var message: Text? {
        Text("This area gives a description of the previous pitch. Reports can be accessed by the green button on the right")
    }
    
    var image: Image? {
        Image(systemName: "list.bullet.clipboard")
    }
    
}
