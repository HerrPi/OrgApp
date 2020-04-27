//
//  AddProjectVC.swift
//  OrgApp_V2
//
//  Created by Jan Manuel Brenner on 21.04.20.
//  Copyright © 2020 Jan Manuel Brenner. All rights reserved.
//

import UIKit
import RealmSwift

class AddProjectVC: UIViewController {
	@IBOutlet weak var categoryTableView: UITableView!
	@IBOutlet weak var projNameField: UITextField!
	@IBOutlet weak var categorySearchField: UITextField!
	@IBOutlet weak var createProjectButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!

	var searchedCategorys: Results<Category>!
	var projectsVC: ProjectsVC!
	var denyAddCategoryState: Bool = false
	

	override func viewDidLoad() {
        super.viewDidLoad()
		searchedCategorys = RealmFuncs.Load.categorys()

		categoryTableView.delegate = self
		categoryTableView.dataSource = self
		categoryTableView.register(UINib(nibName: K.CustomCells.selectCategory, bundle: nil), forCellReuseIdentifier: K.CustomCells.selectCategory)

		categorySearchField.delegate = self
		categorySearchField.addTarget(self, action: #selector(didTypeSomething), for: UITextField.Event.editingChanged)
		categorySearchField.placeholder = "Type new Name or Select"

		projNameField.delegate = self
		projNameField.addTarget(self, action: #selector(didTypeSomething), for: UITextField.Event.editingChanged)
		projNameField.becomeFirstResponder()

		hideCategoryList(true)
		hideCreateProjectButton(true)
		denyAddCategory(true)
    }


	@IBAction func buttonPressed(_ sender: UIButton) {
		switch sender {
		case createProjectButton:
			exitAddProjectVC(save: true)

		case cancelButton:
			exitAddProjectVC(save: false)

		default:
			break
		}
	}

	func exitAddProjectVC(save: Bool) {
		if save {
			let newProj = Project()
			let targetCategory = RealmFuncs.Search.category(name: categorySearchField.text!)
			newProj.name = projNameField.text!
			_ = RealmFuncs.Save.object(object: newProj)
			RealmFuncs.Edit.setParent(of: newProj, to: targetCategory) // SET CATEGORY!!!
			self.dismiss(animated: true, completion: nil)

		}else {
			self.dismiss(animated: true, completion: nil)
		}

	}

	func categoryExists(name: String) -> Bool {
		return RealmFuncs.Load.categorys().contains(where: { (cat) -> Bool in
			if cat.name == name {
				return true
			}else {
				return false
			}
		})
	}

	override func viewWillDisappear(_ animated: Bool) {
		projectsVC.projectsCollectionView.reloadData()
	}

	func hideCreateProjectButton(_ hide: Bool) {
		createProjectButton.isHidden = hide

	}

	func hideCategoryList(_ hide: Bool) {
		categoryTableView.isHidden = hide
	}

	func denyAddCategory(_ deny: Bool) {
		denyAddCategoryState = deny
	}

	func tryCheckOut() -> Bool {
		if categoryExists(name: categorySearchField.text!) && projNameField.text != "" {
			denyAddCategory(true)
			hideCategoryList(true)
			hideCreateProjectButton(false)
			return true
		}else {
			hideCategoryList(true)
			hideCreateProjectButton(true)
			return false
		}
	}



}


//MARK: -  UITableView Delegate and DataSource
extension AddProjectVC: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return denyAddCategoryState ? (searchedCategorys.count) : (searchedCategorys.count + 1)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: K.CustomCells.selectCategory, for: indexPath) as! SelectCategoryTCC
		
		if denyAddCategoryState {
			cell.thisCategory = searchedCategorys[indexPath.row]
			cell.categoryLabel.text = cell.thisCategory.name
			cell.categoryLabel.textColor = .label
			cell.addCatButton.isHidden = true
			return cell
		}else {
			if indexPath.row == 0 {
				cell.categoryLabel.text = categorySearchField.text!
				cell.categoryLabel.textColor = .systemBlue
				cell.addCatButton.isHidden = false
			}else {
				cell.thisCategory = searchedCategorys[indexPath.row - 1]
				cell.categoryLabel.textColor = .label
				cell.categoryLabel.text = cell.thisCategory.name
				cell.addCatButton.isHidden = true
			}
			return cell
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if !denyAddCategoryState {
			if indexPath.row == 0 {
				let newCat = Category()
				newCat.name = categorySearchField.text!
				_ = RealmFuncs.Save.object(object: newCat)
				categorySearchField.endEditing(true)
				denyAddCategory(true)
				hideCategoryList(true)
				categoryTableView.reloadData()
				_ = self.tryCheckOut()



			}else {
				categorySearchField.text = (categoryTableView.cellForRow(at: indexPath) as! SelectCategoryTCC).thisCategory.name
				categorySearchField.resignFirstResponder()
				hideCategoryList(true)
				_ = tryCheckOut()
			}
		}else {
			categorySearchField.text = (categoryTableView.cellForRow(at: indexPath) as! SelectCategoryTCC).thisCategory.name
			categorySearchField.resignFirstResponder()
			hideCategoryList(true)
			_ = tryCheckOut()
		}
	}


}


//MARK: -  UITextfield Delegate
extension AddProjectVC: UITextFieldDelegate {

	func textFieldDidBeginEditing(_ textField: UITextField) {
//		hideCreateProjectButton(true)
		denyAddCategory(true)

		switch textField {
		case categorySearchField:
			hideCreateProjectButton(true)
			hideCategoryList(false)
			if categorySearchField.text == "" {
				searchedCategorys = RealmFuncs.Load.categorys()
				denyAddCategory(true)
			}else {
				searchedCategorys = RealmFuncs.Search.categorys(contains: categorySearchField.text!)
				denyAddCategory(categoryExists(name: categorySearchField.text!))
			}
			categoryTableView.reloadData()

		case projNameField:
			_ = tryCheckOut()
			break
		default:
			break
		}
	}

	@objc func didTypeSomething(_ sender: UITextField) {
		switch sender {
		case categorySearchField:
			hideCategoryList(false)
			if categorySearchField.text == "" {
				searchedCategorys = RealmFuncs.Load.categorys()
				denyAddCategory(true)
			}else {
				searchedCategorys = RealmFuncs.Search.categorys(contains: categorySearchField.text!)
				denyAddCategory(categoryExists(name: categorySearchField.text!))
			}
			categoryTableView.reloadData()

		case projNameField:
			_ = tryCheckOut()

		default:
			break
		}
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == categorySearchField {
			if RealmFuncs.Search.categorys(contains: categorySearchField.text!).count == 0 {
				categorySearchField.text = ""
				_ = tryCheckOut()
			}
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		if textField == projNameField && categorySearchField.text == "" {
			categorySearchField.becomeFirstResponder()
		}else {
			_ = tryCheckOut()
		}
		return true
	}


}
















