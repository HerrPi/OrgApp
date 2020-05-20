//
//  ToDoDetailVC.swift
//  OrgApp_V2
//
//  Created by Jan Manuel Brenner on 30.04.20.
//  Copyright © 2020 Jan Manuel Brenner. All rights reserved.
//

import UIKit

class ToDoDetailVC: UIViewController {
	@IBOutlet weak var toDoNameTextField: UITextField!
	@IBOutlet weak var toDoDescriptionTextField: UITextField!
	@IBOutlet weak var doneButton: UIButton!

	var thisToDo: ToDo!
	var toDosVC: ToDosVC!

    override func viewDidLoad() {
        super.viewDidLoad()
		toDoNameTextField.text = thisToDo.name
		toDoDescriptionTextField.text = thisToDo.toDoDescription

    }

	@IBAction func doneButton(_ sender: UIButton) {
		if toDoNameTextField.text != "" {
			RealmFuncs.Edit.renameToDo(thisToDo, newName: toDoNameTextField.text!)
			RealmFuncs.Edit.changeToDoDescription(thisToDo, description: toDoDescriptionTextField.text!)
		}
		toDosVC.toDosTableView.reloadData()
		self.dismiss(animated: true, completion: nil)
	}

}
