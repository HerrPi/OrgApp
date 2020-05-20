//
//  NoteDetailVC.swift
//  OrgApp_V2
//
//  Created by Jan Manuel Brenner on 27.04.20.
//  Copyright © 2020 Jan Manuel Brenner. All rights reserved.
//

import UIKit

class NoteDetailVC: UIViewController {

	@IBOutlet weak var noteTitleField: UITextField!
	@IBOutlet weak var noteContentField: UITextView!
	
	var thisProject: Project!
	var thisNote: Note!

	var editState: Bool = true

    override func viewDidLoad() {
		super.viewDidLoad()

		self.title = thisNote.title
		noteTitleField.text = thisNote.title
		noteContentField.text = thisNote.content

		noteTitleField.delegate = self
		noteContentField.delegate = self

		if noteTitleField.text == "" {
			noteTitleField.becomeFirstResponder()
		}

	}

}

extension NoteDetailVC: UITextFieldDelegate, UITextViewDelegate {

	func hideBackButton(_ state: Bool) {
		self.navigationItem.setHidesBackButton(state, animated: true)
	}

	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.text == "Input Content here..." {
			textView.text = ""
		}
		hideBackButton(true)

	}

	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		if textView.text == "" {
			textView.text = "Input Content here..."
		}else {
			RealmFuncs.Edit.changeNoteContent(thisNote, newContent: textView.text)
		}
		return true
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		textView.resignFirstResponder()
		hideBackButton(false)
	}


	func textFieldDidBeginEditing(_ textField: UITextField) {
		hideBackButton(true)

	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.endEditing(true)
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if textField.text == "" {
			textField.resignFirstResponder()
			let noTextAlert = UIAlertController(title: "No Text", message: "You need to provide a Title for the Note.", preferredStyle: .actionSheet)
			noTextAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in textField.becomeFirstResponder()}))

			present(noTextAlert, animated: true, completion: nil)
			return false

		}else {
			RealmFuncs.Edit.renameNote(thisNote, newName: textField.text!)
			return true
		}
	}


	func textFieldDidEndEditing(_ textField: UITextField) {
		textField.resignFirstResponder()
		hideBackButton(false)
	}
}
