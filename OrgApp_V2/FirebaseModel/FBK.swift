//
//  FBK.swift
//  OrgApp_V2
//
//  Created by Jan Manuel Brenner on 25.06.20.
//  Copyright © 2020 Jan Manuel Brenner. All rights reserved.
//

import Foundation
import Firebase


struct FBK {
	struct Functions {

		static func createNewCategory(named name: String) -> String {
			let dataBase = Database.database().reference().child(S.categorys).childByAutoId()
			dataBase.child(S.name).setValue(name)
			return dataBase.key!

		}

		static func deleteCategory(withID catID: String) {
			let dataBase = Database.database().reference().child(S.categorys)
			dataBase.child(catID).setValue(nil)
		}


		static func createNewProject(named name: String, in category: FBCategory) {
			let dataBase = Database.database().reference()
			let projectID = dataBase.child(S.projects).childByAutoId()

			dataBase.child("\(S.projects)/\(projectID.key!)/\(S.name)").setValue(name)
			dataBase.child("\(S.projects)/\(projectID.key!)/\(S.parentCategory)").setValue(category.uID)
			dataBase.child("\(S.categorys)/\(category.uID)/\(S.projects)/\(projectID.key!)").setValue(name)
		}

		static func renameProject(withID: String, to newName: String) {
			let dataBase = Database.database().reference()
			dataBase.child("\(S.projects)/\(withID)/\(S.name)").setValue(newName)
		}

		static func deleteProject(project: FBProject) {
			let dataBase = Database.database().reference()
			dataBase.child("\(S.projects)/\(project.uID)").setValue(nil)
			dataBase.child("\(S.categorys)/\(project.parentCategoryUID)/\(S.projects)/\(project.uID)").setValue(nil)

		}

		static func returnCategoryWhich(contains letters: String, of catArray: [FBCategory]) -> [FBCategory] {
			return catArray.filter { (cat) -> Bool in
				return cat.name.contains(letters)
			}

		}
	}

}
