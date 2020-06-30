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
	@IBOutlet weak var deleteNoteButton: UIBarButtonItem!

	var thisProject: Project!
	var thisNote: Note!


    override func viewDidLoad() {
		super.viewDidLoad()

		K.Funcs.createKeyboardToolbar(style: .done, target: noteContentField, execute: #selector(doneEditing))
		K.Funcs.createKeyboardToolbar(style: .done, target: noteTitleField, execute: #selector(doneEditing))


		self.title = thisNote.name

		noteTitleField.text = thisNote.name
		noteContentField.text = thisNote.content

		noteTitleField.delegate = self
		noteContentField.delegate = self

		if noteTitleField.text == "" {
			noteTitleField.becomeFirstResponder()
		}

	}



	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)

	}

	@objc func doneEditing() {
		if noteTitleField.isFirstResponder {
			noteTitleField.resignFirstResponder()
		}
		if noteContentField.isFirstResponder {
			noteContentField.resignFirstResponder()
		}

	}


	@IBAction func deleteNoteButtonPress(_ sender: UIBarButtonItem) {
		if noteTitleField.isFirstResponder {
			noteTitleField.resignFirstResponder()
		}
		if noteContentField.isFirstResponder {
			noteContentField.resignFirstResponder()
		}
		
		self.navigationController?.popViewController(animated: true)
		print("Noch ausführen")
		RealmFuncs.Edit.deleteObject(thisNote)
	}



}

extension NoteDetailVC: UITextFieldDelegate, UITextViewDelegate {

	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.text == "Input content here..." {
			textView.text = ""
		}

	}

	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text == "" {
			RealmFuncs.Edit.changeNoteContent(thisNote, newContent: "No content")
		}else {
			RealmFuncs.Edit.changeNoteContent(thisNote, newContent: textView.text)
		}
		textView.resignFirstResponder()
	}


	func textFieldDidBeginEditing(_ textField: UITextField) {
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		noteContentField.becomeFirstResponder()
		return true
	}


	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField.text == "" {
			RealmFuncs.Edit.renameNote(thisNote, newName: "No Name")
			textField.text = thisNote.name
			self.title = thisNote.name
		}else {
			RealmFuncs.Edit.renameNote(thisNote, newName: textField.text!)
			self.title = thisNote.name
		}
		textField.resignFirstResponder()

	}
}
