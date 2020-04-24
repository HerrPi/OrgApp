//
//  ProjectsCCC.swift
//  OrgApp_V2
//
//  Created by Jan Manuel Brenner on 20.04.20.
//  Copyright © 2020 Jan Manuel Brenner. All rights reserved.
//

import UIKit

class ProjectCCC: UICollectionViewCell {
	@IBOutlet weak var projectTitle: UITextView!
	var projectsVC: ProjectsVC!

	var thisProject: Project!

	
    override func awakeFromNib() {
        super.awakeFromNib()

		let cellContextMenu = UIContextMenuInteraction(delegate: self)
		self.addInteraction(cellContextMenu)
		projectTitle.delegate = self
		projectTitle.isUserInteractionEnabled = false

    }

}

extension ProjectCCC: UIContextMenuInteractionDelegate {

	func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
		let contextMenu = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
			let edit = UIAction(title: "Edit") { _ in
				self.projectTitle.isUserInteractionEnabled = true
				self.projectTitle.becomeFirstResponder()
			}

			let delete = UIAction(title: "Delete", attributes: .destructive) { _ in

				RealmFuncs.Edit.deleteObject(self.thisProject)
				self.projectsVC.projectsCollectionView.reloadData()
			}

			return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [edit, delete])
		}

		return contextMenu
	}


}


extension ProjectCCC: UITextViewDelegate {

	func textViewDidEndEditing(_ textView: UITextView) {
		textView.isUserInteractionEnabled = false
		if textView.text == "" {
			textView.text = thisProject.name
		}else {
			RealmFuncs.Edit.renameProject(thisProject, newName: textView.text)
			projectsVC.projectsCollectionView.reloadData()
		}
	}

	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			if textView.text != "" {
				textView.endEditing(true)
				return false
			}else {
				textView.text = thisProject.name
				textView.endEditing(true)
				return false
			}
		}else {
			return true
		}
	}

}
