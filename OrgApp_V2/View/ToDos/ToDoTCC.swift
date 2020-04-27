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

	var toDosVC: ToDosVC!
	var thisToDo: ToDo!

	override func awakeFromNib() {
        super.awakeFromNib()
		toDoText.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	@IBAction func markAsDone(_ sender: UIButton) {
		if toDoText.text == "" {
			if toDoText.isFirstResponder {
				toDoText.resignFirstResponder()
			}
		}else {
			if toDoText.isFirstResponder {
				toDoText.resignFirstResponder()
			}
			toDosVC.markCellDoneUndone(cell: self)
		}


//		if toDoText.isFirstResponder {
//			if toDoText.text != "" {
//				toDoText.resignFirstResponder()
//			}
//		}
	}


}


extension ToDoTCC: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		toDosVC.textFieldDidBeginEditing(textField, toDo: thisToDo)
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		toDosVC.textFieldShouldReturn(textField, toDo: thisToDo)
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		toDosVC.textFieldDidEndEditing(textField, toDo: thisToDo, cell: self)

	}
}
