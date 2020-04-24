import Foundation
import UIKit

struct ProjectContextMenu {

	static func createMenu(_ project: Project, projectsVC: ProjectsVC) -> UIMenu {
		let edit = UIAction(title: "Edit") { _ in
			
//
//			let addVC = AddProjectVC()
//			addVC.projectsVC = projectsVC
//			projectsVC.present(addVC, animated: true, completion: nil)

		}

		let delete = UIAction(title: "Delete", attributes: .destructive) { _ in
			// func delete
		}

		return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [edit, delete])
	}

//	func showAddProjectVC() {
//		let addVC = AddProjectVC()
//		addVC.projectsVC = self
//		present(addVC, animated: true, completion: nil)
//	}

}
