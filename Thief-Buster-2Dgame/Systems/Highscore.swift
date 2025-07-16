//
//  Highscore.swift
//  Thief-Buster-2Dgame
//
//  Created by Edward Suwandi on 16/07/25.
//

import Foundation
import SwiftData

@Model
class Highscore {
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
}
