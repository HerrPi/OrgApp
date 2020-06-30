import Foundation
import UIKit

struct K {
	struct CustomCells {
		static let projectCell = "ProjectCCC"
		static let projectHeader = "ProjectHeaderCHC"
		static let projectFooter = "ProjectFooterCFC"
		static let toDoCell = "ToDoTCC"
		static let toDoDetailCell = "ToDoDetailTCC"
		static let photoCell = "PhotoCCC"
		static let photoHeader = "PhotoHeaderCHC"
		static let noteCell = "NoteTCC"
		static let selectCategory = "SelectCategoryTCC"
	}

	struct Segues {
		static let showProject = "ProjectDetailSegue"
		static let addProject = "AddProjectSegue"
		static let toDoDetail = "ToDoDetailSegue"
		static let showNote = "ShowNoteSegue"
		static let importPhoto = "ImportPhotoSegue"
		static let fullSizePhoto = "FullSizePhotoSegue"
	}


	struct Funcs {
		static func createKeyboardToolbar(style: UIBarButtonItem.Style, target: UITextField, execute: Selector) {
				let toolBar = UIToolbar()
				toolBar.sizeToFit()

				if style == .done {
					print("Make DonButton")
					let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
					let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: execute)
					toolBar.setItems([flexibleSpace,doneButton], animated: true)
					target.inputAccessoryView = toolBar
				}
		}

		static func createKeyboardToolbar(style: UIBarButtonItem.Style, target: UITextView, execute: Selector) {
			let toolBar = UIToolbar()
			toolBar.sizeToFit()

			if style == .done {
				print("Make DonButton")
				let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
				let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: execute)
				toolBar.setItems([flexibleSpace,doneButton], animated: true)
				target.inputAccessoryView = toolBar
			}
		}
	}



}


