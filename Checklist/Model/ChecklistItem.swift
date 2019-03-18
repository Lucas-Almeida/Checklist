//
//  TodoItem.swift
//  Checklist
//
//  Created by Lucas Almeida on 13/03/19.
//  Copyright © 2019 Lucas Almeida. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    @objc var text: String = ""
    var isChecked: Bool = false
    
    func toggleChecked() {
        isChecked = !isChecked
    }
}
