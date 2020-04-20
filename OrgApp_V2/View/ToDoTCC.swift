//
//  ToDoTCC.swift
//  OrgApp_V2
//
//  Created by Jan Manuel Brenner on 20.04.20.
//  Copyright © 2020 Jan Manuel Brenner. All rights reserved.
//

import UIKit

class ToDoTCC: UITableViewCell {
	@IBOutlet weak var doneButton: UIButton!
	@IBOutlet weak var toDoText: UITextField!

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
